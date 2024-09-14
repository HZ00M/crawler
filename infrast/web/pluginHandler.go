package web

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"go.uber.org/dig"
	"syyx.com/crawler/domain/entity"
	"syyx.com/crawler/domain/service"
	"syyx.com/crawler/pkg/di"
	"syyx.com/crawler/pkg/dockerutil"
)

func init() {
	err := di.GetContianer().Provide(func(service *service.JobRecordService) GinRoute {
		return NewPluginHandler(service)
	}, dig.Group("route"))
	if err != nil {
		panic(err)
	}

}

type PluginHandler struct {
	dig.Out
	service  *service.JobRecordService
	GinRoute GinRoute `group:"route"`
}

func NewPluginHandler(service *service.JobRecordService) GinRoute {
	return &PluginHandler{
		service: service,
	}
}

func (handler *PluginHandler) RegisterRoutes(gin *gin.Engine) {
	apiv1 := gin.Group("/api/v1")
	apiv1.POST("/docker/build", handler.BuildImage)
	apiv1.POST("/docker/push", handler.PushImage)
}

func (handler *PluginHandler) BuildImage(ctx *gin.Context) {
	var metaId int
	var err error
	var metaRecord *entity.JobMeta
	if metaId, err = strconv.Atoi(ctx.Query("id")); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if metaRecord, err = handler.service.GetJobMetaById(metaId); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if _, err = dockerutil.BuildDockerImage(metaRecord.PluginPath, metaRecord.ImageName); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, "")
}

func (handler *PluginHandler) PushImage(ctx *gin.Context) {
	var metaId int
	var err error
	var metaRecord *entity.JobMeta
	if metaId, err = strconv.Atoi(ctx.Query("id")); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if metaRecord, err = handler.service.GetJobMetaById(metaId); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	dockerutil.PushDockerImage(metaRecord.ImageName)
	ctx.JSON(http.StatusOK, "")
}
