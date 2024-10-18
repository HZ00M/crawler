package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	"syyx.com/crawler/domain/entity"
	"syyx.com/crawler/domain/repository"
	_ "syyx.com/crawler/infrast/persistence"
	"syyx.com/crawler/pkg/di"
	"syyx.com/crawler/pkg/gormdb"
	"syyx.com/crawler/pkg/logging"
	"syyx.com/crawler/pkg/setting"
)

func init() {
	setting.Setup()
	gormdb.Setup()
	logging.Setup()
}
func main() {

	//executeId := flag.Int("execute_id", 1, "a name to say hello to")
	//executeName := flag.String("execute_name", "默认任务名", "a name to say hello to")
	//keyword := flag.String("key_word", "默认关键字", "a name to say hello to")
	//// logging.Info("main run before , executeId: %d, executeName: %s", *executeId, *executeName)
	//flag.Parse() // 解析命令行参数
	//logging.Info("main flag.Parse() , executeId: %d, executeName: %s", *executeId, *executeName)
	//// 获取多余的参数
	//extraArgs := flag.Args()
	//// 打印额外参数
	//for i, arg := range extraArgs {
	//	logging.Info("Extra %d:Argument: %s\n", i, arg)
	//}
	//if len(extraArgs) > 0 {
	//	logging.Info("Extra arguments:")
	//	for i, arg := range extraArgs {
	//		parts := strings.Split(arg, "=")
	//		key := parts[0]
	//		value := parts[1]
	//		logging.Info("Arg %d arg: %s Key: %s  Value: %s\n", i, arg, key, value)
	//		if strings.EqualFold(key, "key_word") {
	//			keyword = &value
	//		}
	//	}
	//} else {
	//	logging.Info("No extra arguments provided")
	//}
	argsMap := map[string]string{
		"execute_id":   "0",
		"execute_name": "",
		"keyword":      "",
	}
	for _, arg := range os.Args[1:] {
		parts := strings.SplitN(arg, "=", 2)
		if len(parts) == 2 {
			argsMap[parts[0]] = parts[1]
		}
	}
	logging.Info("Parsed arguments %s", os.Args[1:])
	logging.Info("Parsed argsMap %v", argsMap)

	JOB_COMPLETION_INDEX := os.Getenv("JOB_COMPLETION_INDEX")
	logging.Info("Env JOB_COMPLETION_INDEX %s", JOB_COMPLETION_INDEX)

	done := make(chan struct{})
	go func() {
		executeId, _ := strconv.Atoi(argsMap["execute_id"])
		executeName := argsMap["execute_name"]
		keyword := argsMap["keyword"]
		for i := 0; i < 10; i++ {
			data := &entity.JobRecord{
				DataType:    "dataType",
				FlagMain:    1,
				TargetObjID: fmt.Sprintf("TargetObjID_%d", i),
				KeyWord:     keyword,
				ExecuteID:   executeId,
				ExecuteName: executeName,
				WebSite:     "b站",
				Content:     fmt.Sprintf("内容%d", i),
				TakeDate:    time.Now().Format("2006-01-02"),
				TakeTime:    time.Now().Format("15:04:05"),
			}

			err := di.GetContianer().Invoke(func(base repository.BaseRepository, repo repository.JobRecordRepository) {
				repo.AddJobRecord(data)
				logging.Info("AddJobRecord i %d  %v", i, data)
			})
			if err != nil {
				logging.Error("AddJobRecord i %s error ", i, err)
			}
			logging.Info("AddJobRecord i %d %v", i, data)
			//err = di.GetContianer().Invoke(func(base repository.BaseRepository, repo repository.JobRecordRepository) {
			//	executeRecord, err := repo.GetJobExecute(*executeId)
			//	if err != nil {
			//		logging.Info("AddJobRecord err %d %v", executeId, err)
			//	} else {
			//		executeRecord.DataSize++
			//		repo.EditJobExecute(executeRecord)
			//	}
			//})
			if err != nil {
				logging.Info("AddJobRecord Invoke err %d %v", executeId, err)
			}
			time.Sleep(10 * time.Second)
		}
		done <- struct{}{}
	}()
	<-done

	logging.Info("Execute job finish !")

}

// func main() {
// 	name := flag.String("tableName", "default_data_table", "a name to say hello to")
// 	logging.Info(" main run %s", name)
// 	// 创建一个新的 Collector
// 	c := colly.NewCollector()

// 	// 设置请求前的操作
// 	c.OnRequest(func(r *colly.Request) {
// 		fmt.Println("Visiting", r.URL)
// 	})

// 	// 设置响应后的操作
// 	c.OnResponse(func(r *colly.Response) {
// 		fmt.Println("Visited", r.Request.URL)
// 	})

// 	// 设置错误处理
// 	c.OnError(func(_ *colly.Response, err error) {
// 		log.Println("Something went wrong:", err)
// 	})

// 	// 设置 HTML 内容解析
// 	c.OnHTML("div.tap-rich-content__body", func(e *colly.HTMLElement) {
// 		link := e.Text
// 		fmt.Println("fmt Link found:", link)
// 		logging.Info("logging Link found  :", link)
// 		// 继续访问链接
// 		data := &entity.DataRecord{
// 			JobName: *name,
// 			Text:    link,
// 		}
// 		defer func() {
// 			if r := recover(); r != nil {
// 				// 捕获异常并打印日志
// 				logging.Error("AddRecord from data %s panic  %v", data, r)
// 			}
// 			logging.Info("AddRecord data %s", data)
// 		}()
// 		err := di.GetContianer().Invoke(func(base repository.BaseRepository, repo repository.DataRecordRepository) {
// 			ctx := base.WithTableName(context.Background(), data.JobName)
// 			repo.AddRecord(ctx, data)
// 		})
// 		if err != nil {
// 			logging.Error("AddRecord from data %s panic  %v", data, err)
// 		}
// 	})

// 	// 开始访问页面
// 	c.Visit("https://www.taptap.cn/moment/565592851090505752")
// }
