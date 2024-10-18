package web

import (
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"go.uber.org/dig"
	"gorm.io/gorm"

	"syyx.com/crawler/domain/entity"
	"syyx.com/crawler/domain/service"

	"github.com/xuri/excelize/v2"
	"syyx.com/crawler/pkg/di"
	"syyx.com/crawler/pkg/logging"
)

func init() {
	err := di.GetContianer().Provide(func(gormDB *gorm.DB, service *service.JobRecordService) GinRoute {
		return NewJobRecordHandler(gormDB, service)
	}, dig.Group("route"))
	// err := di.GetContianer().Provide(func() GinRoute {
	// 	return &JobRecordHandler{}
	// }, dig.Group("route"))
	if err != nil {
		panic(err)
	}
}

type JobRecordHandler struct {
	dig.Out
	service  *service.JobRecordService
	gorm     *gorm.DB
	GinRoute GinRoute `group:"route"`
}

func NewJobRecordHandler(gormDB *gorm.DB, service *service.JobRecordService) GinRoute {
	return &JobRecordHandler{
		service: service,
		gorm:    gormDB,
	}
}

func (handler *JobRecordHandler) RegisterRoutes(gin *gin.Engine) {
	apiv1 := gin.Group("/api/v1")
	apiv1.POST("/jobrecord/GetJobRecords", handler.GetJobRecords)
	apiv1.GET("/jobrecord/GetJobRecordById/:id", handler.GetJobRecordById)
	apiv1.POST("/jobrecord/AddJobRecord", handler.AddJobRecord)
	apiv1.POST("/jobrecord/EditJobRecord/:id", handler.EditJobRecord)
	apiv1.POST("/jobrecord/DeleteJobRecord/:id", handler.DeleteJobRecord)
	apiv1.POST("/jobrecord/DoExecuteJob", handler.DoExecuteJob)
	apiv1.POST("/jobrecord/StopExecuteJob", handler.StopExecuteJob)
	apiv1.POST("/jobrecord/DeleteExecuteJob", handler.DeleteExecuteJob)
	apiv1.GET("/jobrecord/download", handler.DownloadJobRecord)

	apiv1.POST("/jobrecord/CreateExecuteJob", handler.CreateJobExecute)
}

type GetJobRecordsRequest struct {
	JobID   string `json:"job_id"`
	Status  string `json:"status"`
	Message string `json:"message"`
}

func (handler *JobRecordHandler) DownloadJobRecord(ctx *gin.Context) {
	tableName := entity.RecordTableName
	executeId := ctx.Query("execute_id")
	executeName := ctx.Query("execute_name")
	//创建excel文件
	f := excelize.NewFile()
	sheetName := "Sheet1"
	f.SetSheetName(f.GetSheetName(1), sheetName)
	tx := handler.gorm.Table(tableName)
	if executeId != "nil" {
		tx.Where("execute_id", executeId)
	}
	if executeName != "" {
		tx.Where("execute_name", executeName)
	}
	// 打开数据库连接
	rows, err := tx.Rows()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query database"})
		return
	}
	defer rows.Close()
	// 获取列名
	cols, err := rows.Columns()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get columns"})
		return
	}
	//写表头
	for i, colname := range cols {
		cell := fmt.Sprintf("%s%d", string(rune('A'+i)), 1)
		f.SetCellValue(sheetName, cell, colname)
	}
	// 定义一个变量存储当前行数
	rowIndex := 2
	// 流式读取和写入数据
	for rows.Next() {
		colPointers := make([]interface{}, len(cols))
		columns := make([]interface{}, len(cols))
		for i := range columns {
			//将columns每一个地址的指针赋值给colpointer
			//这样scan设置值的时候才能修改切片里具体的值
			//如果直接传递columns给scan,实际是进行值传递 无法改变切片里面的内容
			colPointers[i] = &columns[i]
		}
		//通过 columnPointers...，你将这个切片的每个元素（即指针）分别传递给 rows.Scan()，而不是将整个切片作为一个参数。
		if err := rows.Scan(colPointers...); err != nil {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to scan row"})
			return
		}
		for i, col := range columns {
			cell := fmt.Sprintf(("%s%d"), string(rune('A'+i)), rowIndex)
			f.SetCellValue(sheetName, cell, col)
		}
		// 每隔1000行写入一次
		if rowIndex%1000 == 0 {
			// 写入部分数据到响应流
			if err := f.Write(ctx.Writer); err != nil {
				ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to write Excel file"})
				return
			}
			// 重置文件对象，以便释放内存
			f = excelize.NewFile()
			f.NewSheet(sheetName)
		}
		rowIndex++
	}
	// 如果需要，可以在这里添加定期保存到磁盘或者流式传输的逻辑
	// 将 Excel 文件写入响应流
	ctx.Header("Content-Disposition", "attachment; filename=data.xlsx")
	ctx.Header("Content-Type", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
	if err := f.Write(ctx.Writer); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to write Excel file"})
	}
}

func (handler *JobRecordHandler) GetJobRecords(ctx *gin.Context) {
	pageNum, err := strconv.Atoi(ctx.DefaultQuery("pageSize", "10"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid limit"})
		return
	}
	offset, err := strconv.Atoi(ctx.DefaultQuery("offset", "0"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid offset"})
		return
	}
	var conditions []interface{}
	if name := ctx.Query("task_id"); name != "" {
		conditions = append(conditions, fmt.Sprintf("task_id = '%s'", name))
	}

	if email := ctx.Query("job_name"); email != "" {
		conditions = append(conditions, fmt.Sprintf("job_name = '%s'", email))
	}
	records, err := handler.service.GetJobRecords(offset, pageNum, conditions)
	if err != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, records)
}

func (handler *JobRecordHandler) GetJobRecordById(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id")) //ctx.Param("id") /:id
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	record, err := handler.service.GetJobRecordById(id)
	if err != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "Invalid user ID"})
		return
	}
	ctx.JSON(http.StatusOK, record)
}

func (handler *JobRecordHandler) AddJobRecord(ctx *gin.Context) {
	// var body map[string]interface{}
	// if err := ctx.BindJSON(&body); err != nil {
	// 	ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	// 	return
	// }
	// logging.Info("body %v", body)

	var record entity.JobRecord
	if err := ctx.ShouldBindWith(&record, binding.JSON); err != nil {
		logging.Error("ctx.ShouldBindWith body %v err %v", record, err)
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	_, err := handler.service.AddJobRecord(&record)
	if err != nil {
		logging.Error("handler.service.AddJobRecord record %v err %v", record, err)
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, record)
}

func (handler *JobRecordHandler) EditJobRecord(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id")) //ctx.Param("id") /:id
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// var body map[string]interface{}
	// if err := ctx.BindJSON(&body); err != nil {
	// 	ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	// 	return
	// }
	var record entity.JobRecord
	if err := ctx.ShouldBindWith(&record, binding.JSON); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := handler.service.EditJobRecord(id, &record); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, "success")
}

func (handler *JobRecordHandler) DeleteJobRecord(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id")) //ctx.Param("id") /:id
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := handler.service.DeleteJobRecord(id); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, "success")
}

func (handler *JobRecordHandler) CreateJobExecute(ctx *gin.Context) {
	var params map[string]interface{}
	if err := ctx.BindJSON(&params); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := handler.service.CreateJobExecute(params); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, "success")
}

func (handler *JobRecordHandler) DoExecuteJob(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Query("id")) //ctx.Param("id") /:id
	if err != nil {
		logging.Error("ctx.Query() id %v err %v", id, err)
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := handler.service.DoExecuteJob(id); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, "success")
}

func (handler *JobRecordHandler) StopExecuteJob(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Query("id")) //ctx.Param("id") /:id
	if err != nil {
		logging.Error("ctx.Query() id %v err %v", id, err)
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := handler.service.StopExecuteJob(id); err != nil {
		logging.Error("StopExecuteJob id %v err %v", id, err)
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, "success")
}

func (handler *JobRecordHandler) DeleteExecuteJob(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Query("id")) //ctx.Param("id") /:id
	if err != nil {
		logging.Error("ctx.Query() id %v err %v", id, err)
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := handler.service.DeleteExecuteJob(id); err != nil {
		logging.Error("DeleteExecuteJob id %v err %v", id, err)
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, "success")
}
