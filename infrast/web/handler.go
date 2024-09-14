package web

import "github.com/gin-gonic/gin"

type GinRoute interface {
	RegisterRoutes(gin *gin.Engine)
}
