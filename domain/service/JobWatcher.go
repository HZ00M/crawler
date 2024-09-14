package service

import (
	"context"
	"strconv"
	"sync"

	batchv1 "k8s.io/api/batch/v1" // 这是 Kubernetes API 的 batchv1 包
	batchv1beta1 "k8s.io/api/batch/v1beta1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/watch"
	"k8s.io/client-go/informers"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/cache"
	"syyx.com/crawler/deploy"
	"syyx.com/crawler/domain/entity"
	"syyx.com/crawler/pkg/logging"
)

func watchEvent(clientset *kubernetes.Clientset, namespace string) {
	logging.Info(" start %s", namespace)
	// 设置 ListOptions 来过滤只监听指定的 Job
	options := metav1.ListOptions{
		LabelSelector: "app=crawler",
		// TimeoutSeconds: int64Ptr(60), // 每60秒超时，重新建立连接,
	}
	// 通过 clientset 的 BatchV1() 客户端获取 Job 的 Watcher
	watcher, err := clientset.BatchV1().Jobs(namespace).Watch(context.TODO(), options)
	if err != nil {
		logging.Warn("Error watching job: %v", err)
		return
	}
	cronJobWatcher, err := clientset.BatchV1beta1().CronJobs(namespace).Watch(context.TODO(), options)
	if err != nil {
		logging.Warn("Error watching CronJob: %v", err)
		return
	}
	defer func() {
		watcher.Stop()
	}()
	defer func() {
		cronJobWatcher.Stop()
	}()
	var wg sync.WaitGroup
	wg.Add(2) // 添加一个协程计数器
	go func() {
		defer wg.Done()
		handlerJobEvens(watcher.ResultChan())
	}()
	go func() {
		defer wg.Done()
		handlerCronJobEvens(cronJobWatcher.ResultChan())
	}()
	wg.Wait()
}

func handlerJobEvens(eventChan <-chan watch.Event) {
	// 启动协程处理 Job 事件
	for event := range eventChan {
		switch event.Type {
		case watch.Added:
			go func() {
				onWatchAddJob(event.Object)
			}()
		case watch.Modified:
			go func() {
				onWatchMotifyJob(event.Object)
			}()
		case watch.Deleted:
			go func() {
				onWatchDeleteJob(event.Object)
			}()
		case watch.Error:
			go func() {
				onWatcheErrorJob(event.Object)
			}()
		default:
			logging.Info("Unknown event type")
		}
		// 打印 Job 的状态
		if job, ok := event.Object.(*batchv1.Job); ok {
			logging.Debug("Job status: %v", job.Status.Succeeded)
			logging.Debug("Job status: %v %v", job.Name, job.Status.Succeeded)
		} else {
			logging.Info("Unexpected object type")
		}
	}
}

func handlerCronJobEvens(eventChan <-chan watch.Event) {
	// 启动协程处理 Job 事件
	for event := range eventChan {
		switch event.Type {
		case watch.Added:
			go func() {
				onWatchAddCronJob(event.Object)
			}()
		case watch.Modified:
			go func() {
				onWatchMotifyCronJob(event.Object)
			}()
		case watch.Deleted:
			go func() {
				onWatchDeleteCronJob(event.Object)
			}()
		case watch.Error:
			go func() {
				onWatcheErrorCronJob(event.Object)
			}()
		default:
			logging.Info(" Unknown event type")
		}
		//打印 Job 的状态
		if job, ok := event.Object.(*batchv1beta1.CronJob); ok {
			logging.Info(" Job status: %v", job.Name)
		} else {
			logging.Info(" Unexpected object type")
		}
	}
}

func onWatchAddJob(obj interface{}) {
	logging.Info("Type of obj: %T\n", obj)
	// 确保传入的对象类型正确
	metaObj, ok := obj.(metav1.Object)
	if !ok {
		logging.Warn(": Unexpected object type")
		return
	}
	// 获取指定标签的值
	if value, exists := metaObj.GetLabels()["execute-id"]; exists {
		logging.Info("Label 'execute-id': %s", value)
		if executeId, err := strconv.Atoi(value); err == nil {
			if executeRecord, err := repo.GetJobExecute(executeId); err == nil {
				if executeRecord.JobStatus == int(entity.JobStatusInit) {
					executeRecord.UpdateStatus(entity.JobStatusRunning)
					repo.EditJobExecute(executeRecord)
					logging.Info("update JobStatusRunning")
				}
			}
		}
	} else {
		logging.Info(" Label 'execute-id' not found")
	}
}

func onWatchDeleteJob(obj interface{}) {
	logging.Info("Type of obj: %T\n", obj)
	// 确保传入的对象类型正确
	metaObj, ok := obj.(metav1.Object)
	if !ok {
		logging.Warn("Unexpected object type")
		return
	}
	// 获取指定标签的值
	if value, exists := metaObj.GetLabels()["execute-id"]; exists {
		logging.Info(" Label 'execute-id': %s", value)
		if executeId, err := strconv.Atoi(value); err == nil {
			if executeRecord, err := repo.GetJobExecute(executeId); err == nil {
				if executeRecord.JobType == int(deploy.OnceJobType) {
					executeRecord.UpdateStatus(entity.JobStatusCancel)
				} else if executeRecord.JobType == int(deploy.CylceJobType) {

				}
				repo.EditJobExecute(executeRecord)
			}
		}
	} else {
		logging.Info("Label 'execute-id' not found")
	}
}

func onWatchMotifyJob(obj interface{}) {
	logging.Info("Type of obj: %T\n", obj)
	// 确保传入的对象类型正确
	metaObj, ok := obj.(metav1.Object)
	job, ok := obj.(*batchv1.Job)
	if !ok {
		logging.Warn("Unexpected object type")
		return
	}
	succeeded := int(job.Status.Succeeded)
	// 获取指定标签的值
	if value, exists := metaObj.GetLabels()["execute-id"]; exists {
		logging.Info("Label 'execute-id': %s", value)
		if executeId, err := strconv.Atoi(value); err == nil {
			if executeRecord, err := repo.GetJobExecute(executeId); err == nil {
				if executeRecord.JobStatus != int(entity.JobStatusRunning) {
					logging.Info("executeRecord.JobStatus != int(entity.JobStatusRunning) id %v status %v", value, executeRecord.JobStatus)
					return
				}
				if succeeded < 1 {
					logging.Info("succeeded < 1 id %d succeeded %s", value, succeeded)
					return
				}
				if executeRecord.JobType == int(deploy.OnceJobType) {
					executeRecord.ExecuteCount++
					if executeRecord.ExecuteCount >= executeRecord.ParallelNum {
						executeRecord.UpdateStatus(entity.JobStatusFinish)
					}

				} else if executeRecord.JobType == int(deploy.CylceJobType) {
					executeRecord.ExecuteCount++
				}
				repo.EditJobExecute(executeRecord)
				logging.Info("executeId %d succeeded %d executeRecord.ParallelNum %d executeRecord.ExecuteCount %d", executeId, succeeded, executeRecord.ParallelNum, executeRecord.ExecuteCount)
			}
		}
	} else {
		logging.Info(" Label 'execute-id' not found")
	}
}

func onWatcheErrorJob(obj interface{}) {
	logging.Info("Type of obj: %T\n", obj)
	// 确保传入的对象类型正确
	if metaObj, ok := obj.(metav1.Object); ok {
		// 获取指定标签的值
		if value, exists := metaObj.GetLabels()["execute-id"]; exists {
			logging.Info(" Label 'execute-id': %s", value)
			if executeId, err := strconv.Atoi(value); err == nil {
				if executeRecord, err := repo.GetJobExecute(executeId); err == nil {
					executeRecord.UpdateStatus(entity.JovStatusError)
					repo.EditJobExecute(executeRecord)
					logging.Info(" update JobStatusRunning")
				}
			}
		} else {
			logging.Info(" Label 'execute-id' not found")
		}
	}
	if status, ok := obj.(*metav1.Status); ok {
		logging.Info(" error %v", status)
	}
}

func onWatchAddCronJob(obj interface{}) {
	logging.Info("Type of obj: %T\n", obj)
	// 确保传入的对象类型正确
	metaObj, ok := obj.(metav1.Object)
	if !ok {
		logging.Warn(": Unexpected object type")
		return
	}
	// 获取指定标签的值
	if value, exists := metaObj.GetLabels()["execute-id"]; exists {
		logging.Info("Label 'execute-id': %s", value)
		if executeId, err := strconv.Atoi(value); err == nil {
			if executeRecord, err := repo.GetJobExecute(executeId); err == nil {
				if executeRecord.JobStatus == int(entity.JobStatusInit) {
					executeRecord.UpdateStatus(entity.JobStatusRunning)
					repo.EditJobExecute(executeRecord)
					logging.Info("update JobStatusRunning")
				}
			}
		}
	} else {
		logging.Info(" Label 'execute-id' not found")
	}
}

func onWatchDeleteCronJob(obj interface{}) {
	logging.Info("Type of obj: %T\n", obj)

}

func onWatchMotifyCronJob(obj interface{}) {
	logging.Info("Type of obj: %T\n", obj)
}

func onWatcheErrorCronJob(obj interface{}) {
	logging.Info("Type of obj: %T\n", obj)

}

func watchJob(clientset *kubernetes.Clientset) {
	// 创建 Informer 工厂，监听所有命名空间的 Job 资源
	informerFactory := informers.NewSharedInformerFactory(clientset, 0)
	jobInformer := informerFactory.Batch().V1().Jobs().Informer()
	// 设置事件处理函数
	jobInformer.AddEventHandler(
		cache.ResourceEventHandlerFuncs{
			AddFunc: func(obj interface{}) {
				logging.Info("AddFunc call %v", obj)
			},
			UpdateFunc: func(oldObj, newObj interface{}) {
				logging.Info("UpdateFunc call oldObj %v newObj %v", oldObj, newObj)
			},
			DeleteFunc: func(obj interface{}) {
				logging.Info("DeleteFunc call %v", obj)
			},
		},
	)
	//启动informer
	stopCh := make(chan struct{})
	defer close(stopCh)
	informerFactory.Start(stopCh)
	informerFactory.WaitForCacheSync(stopCh)
	// 等待缓存同步
	// if !cache.WaitForCacheSync(stopCh, jobInformer.HasSynced) {
	// 	fmt.Println("Error syncing cache")
	// 	return
	// }

	// // 保持主程序运行
	// select {}
}
