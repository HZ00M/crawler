package service

import (
	"context"
	"strconv"
	"sync"

	"syyx.com/crawler/pkg/k8sutil"

	batchv1 "k8s.io/api/batch/v1" // 这是 Kubernetes API 的 batchv1 包
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
	logging.Info(" start watching namespace %s", namespace)
	// 设置 ListOptions 来过滤只监听指定的 Job
	options := metav1.ListOptions{
		LabelSelector: "app=crawler",
	}
	// 通过 clientset 的 BatchV1() 客户端获取 Job 的 Watcher
	jobWatcher, err := clientset.BatchV1().Jobs(namespace).Watch(context.TODO(), options)
	if err != nil {
		logging.Error("do Jobs Watch error namespace %s err %v", namespace, err)
		return
	}
	var cronJobWatcher watch.Interface
	// 通过 clientset 的 BatchV1() 客户端获取 CronJob 的 Watcher
	if k8sutil.VersionGreaterThan("1.20") {
		cronJobWatcher, err = clientset.BatchV1().CronJobs(namespace).Watch(context.TODO(), options)
	} else {
		cronJobWatcher, err = clientset.BatchV1beta1().CronJobs(namespace).Watch(context.TODO(), options)
	}

	if err != nil {
		logging.Error("do CronJobs Watch error namespace %s err %v", namespace, err)
		return
	}
	defer func() {
		jobWatcher.Stop()
	}()
	defer func() {
		cronJobWatcher.Stop()
	}()
	var wg sync.WaitGroup
	wg.Add(2) // 添加一个协程计数器
	go func() {
		defer wg.Done()
		handlerJobEvens(jobWatcher.ResultChan())
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
				onWatchModifyJob(event.Object)
			}()
		case watch.Deleted:
			go func() {
				onWatchDeleteJob(event.Object)
			}()
		case watch.Error:
			go func() {
				onWatcherErrorJob(event.Object)
			}()
		default:
			logging.Info("unknown event type")
		}
		// 打印 Job 的状态
		if job, ok := event.Object.(*batchv1.Job); ok {
			logging.Debug("eventInfo jobName %v status %v", job.Name, job.Status)
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
				onWatchModifyCronJob(event.Object)
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
			logging.Info(" unknown event type")
		}

	}
}

func onWatchAddJob(obj interface{}) {
	// 确保传入的对象类型正确
	job, ok := obj.(*batchv1.Job)
	if !ok {
		logging.Warn(": unexpected object type %T\n", obj)
		return
	}
	// 通过指定标签获取任务的execute_id
	if executeId, exists := job.GetLabels()["execute-id"]; exists {
		if executeId, err := strconv.Atoi(executeId); err == nil {
			if executeRecord, err := repo.GetJobExecute(executeId); err == nil && executeRecord != nil {
				// 获取并行数,更新t_job_execute记录的执行次数
				if job.Spec.Parallelism != nil {
					parallelism := *job.Spec.Parallelism
					executeRecord.ExecuteCount += int(parallelism)
					logging.Info("Job '%s' has parallelism %d executeId %d", job.Name, parallelism, executeId)
				} else {
					executeRecord.ExecuteCount++
					logging.Info("Job '%s' has no parallelism set (default is 1) executeId %d", job.Name, executeId)
				}
				if executeRecord.JobStatus == int(entity.JobStatusInit) {
					//更新t_job_execute记录执行状态
					executeRecord.UpdateStatus(entity.JobStatusRunning)
					//定时检查数据更新,更新t_job_execute记录的data_size
					scheduledExecuteDataCheck(executeId)
				}
				repo.EditJobExecute(executeRecord)
			} else {
				logging.Info("executeRecord not found executeId %d", executeId)
			}
		}
	} else {
		logging.Info(" label 'execute-id' not found %v", obj)
	}
}
func scheduledExecuteDataCheck(executeId int) {
	logging.Info("start watch timer executeId %d", executeId)
	tickerManager.StartTicker(executeId, 60, func() {
		UpdataRecordDataCount(executeId)
	})
}

func onWatchModifyJob(obj interface{}) {
	// 确保传入的对象类型正确
	job, ok := obj.(*batchv1.Job)
	if !ok {
		logging.Warn(": unexpected object type %T\n", obj)
		return
	}
	succeeded := int(job.Status.Succeeded)
	failed := int(job.Status.Failed)
	completed := job.Status.CompletionTime != nil
	// 获取指定标签的值
	if executeId, exists := job.GetLabels()["execute-id"]; exists {
		if executeId, err := strconv.Atoi(executeId); err == nil {
			if executeRecord, err := repo.GetJobExecute(executeId); err == nil && executeRecord != nil {
				// 如果任务状态不是RUNNING，直接返回)
				if executeRecord.JobStatus != int(entity.JobStatusRunning) {
					logging.Info("not running executeId %d status %s", executeId, entity.JobStatus(executeRecord.JobStatus))
					return
				}

				if executeRecord.JobType == int(deploy.OnceJob) {
					var finishCount = executeRecord.FinishCount
					var failCount = executeRecord.FailCount
					// 更新成功数和失败数
					if succeeded > executeRecord.FinishCount {
						executeRecord.FinishCount = succeeded
					}
					if failed > executeRecord.FailCount {
						executeRecord.FailCount = failed
					}
					//如果是单次任务且执行完成次数等于并行数，则本次任务执行完成
					if completed {
						executeRecord.UpdateStatus(entity.JobStatusFinish)
						tickerManager.StopTicker(executeId, func() {
							UpdataRecordDataCount(executeId)
						})
					}
					logging.Info("updated OnceJob completed info id %v FinishCount %d FailCount %d NewFinishCount %d NewFailCount %d",
						executeId, finishCount, failCount, executeRecord.FinishCount, executeRecord.FailCount)
				} else if executeRecord.JobType == int(deploy.CycleJob) {
					//如果是单次任务且执行完成次数等于并行数，则本次任务执行完成
					if completed {
						var finishCount = executeRecord.FinishCount
						var failCount = executeRecord.FailCount
						// 更新成功数和失败数
						executeRecord.FinishCount += succeeded
						executeRecord.FailCount += failed
						logging.Info("updated CycleJob completed info id %v FinishCount %d FailCount %d NewFinishCount %d NewFailCount %d",
							executeId, finishCount, failCount, executeRecord.FinishCount, executeRecord.FailCount)
					}
				}
				repo.EditJobExecute(executeRecord)
			} else {
				logging.Info("executeRecord not found %d", executeId)
			}
		}
	} else {
		logging.Info(" Label 'execute-id' not found")
	}
}
func UpdataRecordDataCount(executeId int) {
	// 每个时间间隔到来时执行的操作
	if executeRecord, err := repo.GetJobExecute(executeId); err == nil && executeRecord != nil {
		//查询更新数据量信息
		if executeRecord.JobStatus == int(entity.JobStatusRunning) {
			var oldDataSize = executeRecord.DataSize
			var queryDataSize = int(repo.GetJobRecordCountByExecuteId(executeId))
			executeRecord.DataSize = queryDataSize
			repo.EditJobExecute(executeRecord)
			logging.Info("execute update DataSize id %v oldDataSize %d queryDataSize %d", executeId, oldDataSize, queryDataSize)
		}
	}
}
func onWatchDeleteJob(obj interface{}) {
	// 确保传入的对象类型正确
	job, ok := obj.(*batchv1.Job)
	if !ok {
		logging.Warn(": unexpected object type %T\n", obj)
		return
	}
	// 获取指定标签的值
	if executeId, exists := job.GetLabels()["execute-id"]; exists {
		if executeId, err := strconv.Atoi(executeId); err == nil {
			if executeRecord, err := repo.GetJobExecute(executeId); err == nil && executeRecord != nil {
				if executeRecord.JobType == int(deploy.OnceJob) {
					executeRecord.UpdateStatus(entity.JobStatusCancel)
				} else if executeRecord.JobType == int(deploy.CycleJob) {
					tickerManager.StopTicker(executeId, func() {
						UpdataRecordDataCount(executeId)
					})
				}
				repo.EditJobExecute(executeRecord)
			} else {
				logging.Info("executeRecord not found %d", executeId)
			}
		}
	} else {
		logging.Info("Label 'execute-id' not found")
	}
}

func onWatcherErrorJob(obj interface{}) {
	// 确保传入的对象类型正确
	if job, ok := obj.(*batchv1.Job); ok {
		// 获取指定标签的值
		if executeId, exists := job.GetLabels()["execute-id"]; exists {
			if executeId, err := strconv.Atoi(executeId); err == nil {
				if executeRecord, err := repo.GetJobExecute(executeId); err == nil {
					executeRecord.UpdateStatus(entity.JobStatusError)
					repo.EditJobExecute(executeRecord)
					logging.Info("onWatcherErrorJob update status JobStatusError id %d ", executeId)
				}
			}
		} else {
			logging.Info("Label 'execute-id' not found")
		}
	} else {
		logging.Error("is no metav1.Object type %T ", obj)
		return
	}
	if status, ok := obj.(*metav1.Status); ok {
		logging.Info(" error %v", status)
	}
}

func onWatchAddCronJob(obj interface{}) {
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
					scheduledExecuteDataCheck(executeId)
				}
			}
		}
	} else {
		logging.Info(" Label 'execute-id' not found")
	}
}

func onWatchDeleteCronJob(obj interface{}) {
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
				executeRecord.UpdateStatus(entity.JobStatusCancel)
				repo.EditJobExecute(executeRecord)
				tickerManager.StopTicker(executeId, func() {
					UpdataRecordDataCount(executeId)
				})
			}
		}
	} else {
		logging.Info(" Label 'execute-id' not found")
	}

}

func onWatchModifyCronJob(obj interface{}) {
	logging.Info("Type of obj: %T\n", obj)
}

func onWatcheErrorCronJob(obj interface{}) {
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
				executeRecord.UpdateStatus(entity.JobStatusError)
				repo.EditJobExecute(executeRecord)
				tickerManager.StopTicker(executeId, func() {
					UpdataRecordDataCount(executeId)
				})
			}
		}
	} else {
		logging.Info(" Label 'execute-id' not found")
	}
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
