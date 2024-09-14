package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"

	"syyx.com/crawler/infrast"
	"syyx.com/crawler/pkg/dockerutil"
	"syyx.com/crawler/pkg/gormdb"
	"syyx.com/crawler/pkg/gredis"
	"syyx.com/crawler/pkg/k8sutil"
	"syyx.com/crawler/pkg/logging"
	"syyx.com/crawler/pkg/setting"
	"syyx.com/crawler/pkg/util"
)

func init() {
	setting.Setup()
	gormdb.Setup()
	logging.Setup()
	gredis.Setup()
	util.Setup()
	dockerutil.Setup()
	k8sutil.Setup()
	infrast.SetUp()
}

// @title Golang Gin API
// @version 1.0
// @description An example of gin
// @termsOfService https://syyx.com/crawler
// @license.name MIT
// @license.url https://syyx.com/crawler/blob/master/LICENSE
func main() {
	gin.SetMode(setting.ServerSetting.RunMode)
	// routersInit := routers.InitRouter()
	routersInit := infrast.Router
	readTimeout := setting.ServerSetting.ReadTimeout
	writeTimeout := setting.ServerSetting.WriteTimeout
	endPoint := fmt.Sprintf(":%d", setting.ServerSetting.HttpPort)
	maxHeaderBytes := 1 << 20

	server := &http.Server{
		Addr:           endPoint,
		Handler:        routersInit,
		ReadTimeout:    readTimeout,
		WriteTimeout:   writeTimeout,
		MaxHeaderBytes: maxHeaderBytes,
	}

	log.Printf("[info] start http server listening %s", endPoint)

	server.ListenAndServe()

	// If you want Graceful Restart, you need a Unix system and download github.com/fvbock/endless
	//endless.DefaultReadTimeOut = readTimeout
	//endless.DefaultWriteTimeOut = writeTimeout
	//endless.DefaultMaxHeaderBytes = maxHeaderBytes
	//server := endless.NewServer(endPoint, routersInit)
	//server.BeforeBegin = func(add string) {
	//	log.Printf("Actual pid is %d", syscall.Getpid())
	//}
	//
	//err := server.ListenAndServe()
	//if err != nil {
	//	log.Printf("Server err: %v", err)
	//}
}
