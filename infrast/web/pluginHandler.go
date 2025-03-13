package web

import (
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strconv"

	"github.com/gin-gonic/gin"
	"go.uber.org/dig"
	"syyx.com/crawler/domain/entity"
	"syyx.com/crawler/domain/service"
	"syyx.com/crawler/pkg/di"
	"syyx.com/crawler/pkg/dockerutil"
	"syyx.com/crawler/pkg/gitlabUtil"
)

func init() {
	err := di.GetContianer().Provide(func(service service.IJobRecordService) GinRoute {
		return NewPluginHandler(service)
	}, dig.Group("route"))
	if err != nil {
		panic(err)
	}

}

type PluginHandler struct {
	dig.Out
	service  service.IJobRecordService
	GinRoute GinRoute `group:"route"`
}

func NewPluginHandler(service service.IJobRecordService) GinRoute {
	return &PluginHandler{
		service: service,
	}
}

func (handler *PluginHandler) RegisterRoutes(gin *gin.Engine) {
	apiv1 := gin.Group("/api/v1")
	apiv1.POST("/docker/build", handler.BuildImage)
	apiv1.POST("/docker/push", handler.PushImage)
	apiv1.POST("/docker/sync", handler.Sync)
}

func (handler *PluginHandler) Sync(ctx *gin.Context) {
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
	workDir, err := os.Getwd()
	if err != nil {
		// 将 log.Error 替换为 log.Printf 以正确输出错误信息
		log.Printf("Error getting current directory: %s", err)
	}
	language := metaRecord.Language
	pluginRootDir := filepath.Join(workDir, "plugins", language, metaRecord.PluginPath)
	err = gitlabUtil.Sync(metaRecord.RepoUrl, pluginRootDir, metaRecord.RepoToken)
	if err != nil {
		log.Printf("Error syncing repository: %s", err)
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}
	ctx.JSON(http.StatusOK, "")
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
	if _, err = dockerutil.BuildDockerImage(metaRecord.Language, metaRecord.PluginPath, metaRecord.ImageName); err != nil {
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
		log.Printf("GetJobMetaById failed metaId %s err %v", metaId, err)
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if _, err = dockerutil.BuildDockerImage(metaRecord.Language, metaRecord.PluginPath, metaRecord.ImageName); err != nil {
		log.Printf("BuildImage failed metaId %s metaRecord %v err %v", metaId, metaRecord, err)
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err = dockerutil.PushDockerImage(metaRecord.ImageName); err != nil {
		log.Printf("PushImage failed metaId %s metaRecord %v err %v", metaId, metaRecord, err)
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	log.Printf("PushImage succeeded metaId %s metaRecord %v", metaId, metaRecord)
	ctx.JSON(http.StatusOK, "")
}
