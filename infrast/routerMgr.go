package infrast

import (
	"net/http"
	"sync"

	"github.com/gin-gonic/gin"
	"go.uber.org/dig"

	_ "syyx.com/crawler/docs"

	ginSwagger "github.com/swaggo/gin-swagger"
	"github.com/swaggo/gin-swagger/swaggerFiles"

	"syyx.com/crawler/pkg/di"

	"syyx.com/crawler/pkg/export"
	"syyx.com/crawler/pkg/qrcode"
	"syyx.com/crawler/pkg/upload"
	"syyx.com/crawler/routers/api"

	_ "syyx.com/crawler/domain/service"
	_ "syyx.com/crawler/infrast/persistence"
	"syyx.com/crawler/infrast/web"
)

var (
	Router *gin.Engine
	once   sync.Once
	routes map[string]web.GinRoute
	group  *RouteGroup
)

type RouteGroup struct {
	dig.In
	Group []web.GinRoute `group:"route"`
}

func init() {
	di.GetContianer().Provide(func() *gin.Engine {
		return createEngin()
	})
	di.GetContianer().Provide(func() *RouteGroup {
		return createRouteGroup()
	})

}

// RegisterRoute 注册路由
func RegisterRoute(name string, route web.GinRoute) {
	if routes == nil {
		routes = make(map[string]web.GinRoute)
	}
	routes[name] = route
}
func createRouteGroup() *RouteGroup {
	once.Do(func() {
		group = &RouteGroup{}
	})
	return group
}
func createEngin() *gin.Engine {
	once.Do(func() {
		Router = gin.New()
		Router.Use(gin.Logger())
		Router.Use(gin.Recovery())

		Router.StaticFS("/export", http.Dir(export.GetExcelFullPath()))
		Router.StaticFS("/upload/images", http.Dir(upload.GetImageFullPath()))
		Router.StaticFS("/qrcode", http.Dir(qrcode.GetQrCodeFullPath()))

		// Router.POST("/auth", api.GetAuth)
		Router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
		Router.POST("/upload", api.UploadImage)
		// err := di.GetContianer().Invoke(func(routes []web.GinRoute) {
		// 	for _, route := range routes {
		// 		route.RegisterRoutes(router)
		// 	}
		// })

	})
	return Router
}

// InitRouter initialize routing information
func SetUp() {
	// err := di.GetContianer().Invoke(func(jobRecordHandler web.GinRoute) {
	// 	jobRecordHandler.RegisterRoutes(Router)
	// })
	err := di.GetContianer().Invoke(func(engine *gin.Engine, group RouteGroup) {
		for _, route := range group.Group {
			route.RegisterRoutes(engine)
		}
	})
	// 确保检查错误
	if err != nil {
		panic(err)
	}
}
