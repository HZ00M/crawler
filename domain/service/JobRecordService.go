package service

import (
	"context"
	"encoding/json"
	"fmt"
	"math/rand"
	"strconv"
	"sync"
	"time"

	// 这是 Kubernetes API 的 batchv1 包

	"k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"syyx.com/crawler/deploy"
	"syyx.com/crawler/domain/entity"
	"syyx.com/crawler/domain/repository"
	"syyx.com/crawler/pkg/di"
	"syyx.com/crawler/pkg/dockerutil"
	"syyx.com/crawler/pkg/k8sutil"
	"syyx.com/crawler/pkg/logging"
	"syyx.com/crawler/pkg/setting"
)

var (
	service *JobRecordService
	once    sync.Once
)

type IJobRecordService interface {
	// 定义接口方法
	CreateJobExecute(params map[string]interface{}) error
	GetJobRecords(offset int, pageSize int, conditions interface{}) ([]*entity.JobRecord, error)
	GetJobRecordById(id int) (*entity.JobRecord, error)
	EditJobRecord(id int, jobrecord *entity.JobRecord) error
	AddJobRecord(jobrecord *entity.JobRecord) (*entity.JobRecord, error)
	DeleteJobRecord(id int) error
	GetJobMetaById(id int) (*entity.JobMeta, error)
	DoExecuteJob(id int) error
	StopExecuteJob(id int) error
	DeleteExecuteJob(id int) error
	// 其他方法...
}
type JobRecordService struct {
	repo repository.JobRecordRepository
}

var (
	repo repository.JobRecordRepository
)

func init() {
	err := di.GetContianer().Provide(func(repo repository.JobRecordRepository) IJobRecordService {
		return GetJobRecordService(repo)
	})
	if err != nil {
		panic(err)
	}

}
func GetJobRecordService(repos repository.JobRecordRepository) *JobRecordService {
	once.Do(func() {
		service = &JobRecordService{repo: repo}
		namespace := setting.K8sSetting.DefaultNamespace
		client := k8sutil.K8sClient
		repo = repos
		service.repo = repos
		go func() { watchEvent(client, namespace) }()
	})
	return service
}
func int64Ptr(i int64) *int64 {
	return &i
}

func (s *JobRecordService) CreateJobExecute(params map[string]interface{}) error {
	var req struct {
		MetaId      int    `json:"meta_id"`
		ExecuteName string `json:"execute_name"`
		JobType     string `json:"job_type"`
		Cron        string
		KeyWord     string `json:"key_word"`
		IgnoreWord  string `json:"ignore_word"`
		BeginTime   string `json:"begin_time"`
		EndTime     string `json:"end_time"`
		User        int    `json:"user_id"`
		ParallelNum int    `json:"parallel_num"`
		ProjectName string `json:"project_name"`
		StorageFlag string `json:"storage_flag"`
	}
	// 将 map 转换为 JSON 字符串
	jsonData, err := json.Marshal(params)
	if err != nil {
		return fmt.Errorf("Error marshalling map: %v", err)
	} else {
		logging.Info("CreateJobExecute jsonData: %s", jsonData)
	}

	// 将 JSON 字符串解析为结构体
	err = json.Unmarshal(jsonData, &req)
	if err != nil {
		return fmt.Errorf("Error unmarshalling json: %v", err)
	}
	var jobMeta *entity.JobMeta
	jobTypeInt, err := strconv.Atoi(req.JobType)
	if err != nil {
		fmt.Errorf("Error strconv.Atoi(req.JobType) error %v: %v", req.JobType, err)
	}
	storageFlag, err := strconv.Atoi(req.StorageFlag)
	if err != nil {
		fmt.Errorf("Error strconv.Atoi(req.StorageFlag) error %v: %v", req.JobType, err)
	}
	jobMeta, err = s.repo.GetJobMeta(req.MetaId)
	if err != nil || jobMeta == nil {
		fmt.Errorf("Error GetJobMeta error %v: %v", req.MetaId, err)
	}
	// 解析时间字符串
	begin, err := time.Parse(time.RFC3339, req.BeginTime)
	end, err := time.Parse(time.RFC3339, req.EndTime)

	fullImageName := dockerutil.GetFullImageName(jobMeta.ImageName)
	jobName := jobMeta.LabelName + "-" + generateRandomString()
	// 创建 JobExecute 实体
	newExecute := &entity.JobExecute{
		ExecuteName:     req.ExecuteName,
		Namespace:       jobMeta.Namespace, // 从 JobMeta 获取
		Image:           fullImageName,     // 从 JobMeta 获取
		Command:         jobMeta.Command,   // 从 JobMeta 获取
		Cron:            req.Cron,
		ResultTableName: entity.RecordTableName, // 根据需要设定，或者从参数中获取
		JobType:         jobTypeInt,
		ParallelNum:     req.ParallelNum,
		ProjectName:     req.ProjectName,
		StorageFlag:     storageFlag,
		CreatedAt:       time.Now(), // 设置为当前时间
		CreatedById:     int64(req.User),
		JobStatus:       int(entity.JobStatusInit),
		MetaId:          req.MetaId,
		MetaName:        jobMeta.MetaName,
		AppLabelName:    jobMeta.LabelName,
		JobLabelName:    jobName,
		JobGroup:        jobName,
		KeyWord:         req.KeyWord,
		IgnoreWord:      req.IgnoreWord,
		BeginTime:       begin,
		EndTime:         end,
	}

	if err := s.repo.AddJobExecute(newExecute); err != nil {
		fmt.Errorf("Error AddJobExecute fail id %v: %v", req.MetaId, err)
	}
	// 获取 Unix 时间戳
	beginTimestamp := begin.Unix()
	endTimestamp := end.Unix()
	var args = fmt.Sprintf("execute_id=%d\texecute_name=%s\tkey_word=%s\tignore_word=%s\tproject_name=%s\tstorage_flag=%s\tbegin_time=%d\tend_time=%d\t%s",
		newExecute.ID, req.ExecuteName, req.KeyWord, req.IgnoreWord, req.ProjectName, req.StorageFlag, beginTimestamp, endTimestamp, jobMeta.ExeArgs)
	logging.Info("args %s", args)
	newExecute.ExeArgs = args
	newExecute.EnvArgs = jobMeta.EnvArgs
	if err := s.repo.EditJobExecute(newExecute); err != nil {
		fmt.Errorf("Error EditJobExecute fail id %v: %v", req.MetaId, err)
	}
	return nil
}

func generateRandomString() string {
	// 使用当前时间纳秒作为随机数生成器的种子
	rand.Seed(time.Now().UnixNano())

	b := make([]byte, stringLength)
	for i := range b {
		b[i] = letterBytes[rand.Intn(len(letterBytes))]
	}
	return string(b)
}

const (
	letterBytes  = "abcdefghijklmnopqrstuvwxyz0123456789"
	stringLength = 6 // 生成字符串的长度
)

func (s *JobRecordService) GetJobRecords(offset int, pageSize int, conditions interface{}) ([]*entity.JobRecord, error) {
	records, err := s.repo.GetJobRecords(offset, pageSize, conditions)
	if err != nil {
		return nil, err
	}
	return records, nil
}

func (s *JobRecordService) GetJobRecordById(id int) (*entity.JobRecord, error) {
	jobrecord, err := s.repo.GetJobRecord(id)
	if err != nil {
		return nil, err
	}
	return jobrecord, nil
}

func (s *JobRecordService) EditJobRecord(id int, jobrecord *entity.JobRecord) error {
	jobrecord.ID = id
	err := s.repo.EditJobRecord(jobrecord)
	if err != nil {
		return err
	}
	return nil
}

func (s *JobRecordService) AddJobRecord(jobrecord *entity.JobRecord) (*entity.JobRecord, error) {
	// jobrecord := &entity.JobRecord{
	// 	JobName:   data["jobName"].(string),
	// 	ImageName: data["imageName"].(string),
	// }
	err := s.repo.AddJobRecord(jobrecord)
	if err != nil {
		return nil, err
	}
	return jobrecord, nil
}

func (s *JobRecordService) DeleteJobRecord(id int) error {
	err := s.repo.DeleteJobRecord(id)
	if err != nil {
		return err
	}
	return nil
}

func (s *JobRecordService) GetJobMetaById(id int) (*entity.JobMeta, error) {
	jobMeta, err := s.repo.GetJobMeta(id)
	if err != nil {
		return nil, err
	}
	return jobMeta, nil
}

func buildDeployConf(jobExecute entity.JobExecute) (*deploy.DeployJobConf, error) {
	deployConf := deploy.DeployJobConf{
		ExecuteID: jobExecute.ID,
		JobType:   deploy.JobType(jobExecute.JobType),
		Namespace: jobExecute.Namespace,
		ImageName: jobExecute.Image,
		AppName:   jobExecute.AppLabelName,
		JobName:   jobExecute.JobLabelName,
		Command:   jobExecute.Command,
		Args:      jobExecute.ExeArgs,
		Envs:      jobExecute.EnvArgs,
		Cron:      jobExecute.Cron,
		Parallel:  jobExecute.ParallelNum,
	}
	return &deployConf, nil
}

func (s *JobRecordService) DoExecuteJob(id int) (err error) {
	var execute *entity.JobExecute
	if execute, err = s.repo.GetJobExecute(id); err != nil {
		logging.Error("execute not found %d", id)
		return
	}
	if execute.JobType == int(deploy.OnceJob) {
		s.doExecuteOnceJob(execute)
	} else if execute.JobType == int(deploy.CycleJob) {
		s.doExecuteCronJob(execute)
	}
	return nil
}
func (s *JobRecordService) doExecuteOnceJob(execute *entity.JobExecute) (err error) {
	var deployJobConf *deploy.DeployJobConf
	if deployJobConf, err = buildDeployConf(*execute); err != nil {
		return
	}
	deployRet := deploy.Deploy(deployJobConf)
	if !deployRet {
		return fmt.Errorf("execute fail id %d ", execute.ID)
	}
	logging.Info("execute success id %d %v", execute.ID, execute)
	return nil
}

func (s *JobRecordService) doExecuteCronJob(execute *entity.JobExecute) (err error) {
	if execute.JobStatus == int(entity.JobStatusInit) {
		var deployJobConf *deploy.DeployJobConf
		if deployJobConf, err = buildDeployConf(*execute); err != nil {
			return
		}
		deployRet := deploy.Deploy(deployJobConf)
		if !deployRet {
			return fmt.Errorf("deploy fail id %d ret %v", execute.ID, deployRet)
		}
		logging.Info("execute success id %d %v", execute.ID, execute)
	}
	if execute.JobStatus == int(entity.JobStatusPending) {
		s.DoResumeCronJob(execute.Namespace, execute.JobGroup)
		logging.Info("resume success id %d ", execute.ID)
	}
	return nil
}

func (s *JobRecordService) StopExecuteJob(id int) error {
	record, err := s.repo.GetJobExecute(id)
	if err != nil {
		return err
	}
	if record.JobType == int(deploy.OnceJob) {
		s.DoStopJob(record.Namespace, record.JobGroup)
	} else if record.JobType == int(deploy.CycleJob) {
		s.DoSuspendCronJob(record.Namespace, record.JobGroup)
	}
	return nil
}

func (s *JobRecordService) DeleteExecuteJob(id int) error {
	record, err := s.repo.GetJobExecute(id)
	if err != nil {
		logging.Info("GetJobExecute error id %d %v", id, err)
		return err
	}
	if record.JobType == int(deploy.OnceJob) {
		err = s.DoStopJob(record.Namespace, record.JobGroup)
		if err != nil {
			logging.Info("DoStopJob error id %d %v", id, err)
			return err
		}

	} else if record.JobType == int(deploy.CycleJob) {
		err = s.DoStopCronJob(record.Namespace, record.JobGroup)
		if err != nil {
			logging.Info("DoStopCronJob error id %d %v", id, err)
			return err
		}
	}

	err = s.repo.DeleteJobRecordByExecuteId(id)
	if err != nil {
		logging.Info("DeleteJobRecordByExecuteId error id %d %v", id, err)
		return err
	}
	err = s.repo.DeleteJobExecute(id)
	if err != nil {
		logging.Info("DeleteJobExecute error id %d %v", id, err)
		return err
	}
	return err
}

func (s *JobRecordService) DoStopJob(namespace, jobName string) error {

	deletePolicy := metav1.DeletePropagationForeground
	err := k8sutil.K8sClient.BatchV1().Jobs(namespace).Delete(context.TODO(), jobName, metav1.DeleteOptions{
		PropagationPolicy: &deletePolicy,
	})
	if err != nil {
		if errors.IsNotFound(err) {
			// Job 不存在的情况下认为删除成功
			logging.Info("Job %s not found in namespace %s, considered as successfully deleted", jobName, namespace)
			return nil
		}
		return err
	}
	return nil
}

func (s *JobRecordService) DoSuspendCronJob(namespace, jobName string) error {
	var executeId int
	// Set suspend to true to stop CronJob scheduling
	trueVar := true
	if k8sutil.VersionGreaterThan("1.20") {
		cronJob, err := k8sutil.K8sClient.BatchV1().CronJobs(namespace).Get(context.TODO(), jobName, metav1.GetOptions{})
		if err != nil {
			logging.Error("DoSuspendCronJob Error getting CronJob: %v", err)
			return err
		}
		cronJob.Spec.Suspend = &trueVar
		k8sutil.K8sClient.BatchV1().CronJobs(namespace).Update(context.TODO(), cronJob, metav1.UpdateOptions{})
		executeId, err = strconv.Atoi(cronJob.Labels["execute-id"])
	} else {
		cronJob, err := k8sutil.K8sClient.BatchV1beta1().CronJobs(namespace).Get(context.TODO(), jobName, metav1.GetOptions{})
		if err != nil {
			logging.Error("DoSuspendCronJob Error getting CronJob: %v", err)
			return err
		}
		cronJob.Spec.Suspend = &trueVar
		k8sutil.K8sClient.BatchV1beta1().CronJobs(namespace).Update(context.TODO(), cronJob, metav1.UpdateOptions{})
		executeId, err = strconv.Atoi(cronJob.Labels["execute-id"])
	}
	if executeRecord, err := s.repo.GetJobExecute(executeId); err == nil {
		executeRecord.UpdateStatus(entity.JobStatusPending)
		s.repo.EditJobExecute(executeRecord)
		tickerManager.StopTicker(executeId, func() {
			UpdataRecordDataCount(executeId)
		})
	}
	return nil
}

func (s *JobRecordService) DoResumeCronJob(namespace, jobName string) error {
	var executeId int
	trueVar := false
	cronJob, err := k8sutil.K8sClient.BatchV1().CronJobs(namespace).Get(context.TODO(), jobName, metav1.GetOptions{})
	if err != nil {
		logging.Error("DoResumeCronJob Error getting CronJob: %v", err)
	}
	cronJob.Spec.Suspend = &trueVar
	k8sutil.K8sClient.BatchV1().CronJobs(namespace).Update(context.TODO(), cronJob, metav1.UpdateOptions{})
	if err != nil {
		logging.Error("DoResumeCronJob Error updating CronJob: %v", err)
		return err
	}
	executeId, err = strconv.Atoi(cronJob.Labels["execute-id"])
	if executeRecord, err := s.repo.GetJobExecute(executeId); err == nil {
		executeRecord.UpdateStatus(entity.JobStatusRunning)
		s.repo.EditJobExecute(executeRecord)
		scheduledExecuteDataCheck(executeId)
	}
	return nil
}

func (s *JobRecordService) DoStopCronJob(namespace, jobName string) error {
	// List Jobs with the specified label
	err := k8sutil.K8sClient.BatchV1().CronJobs(namespace).Delete(context.TODO(), jobName, metav1.DeleteOptions{})
	if err != nil {
		if errors.IsNotFound(err) {
			// Job 不存在的情况下认为删除成功
			logging.Info("Job %s not found in namespace %s, considered as successfully deleted", jobName, namespace)
			return nil
		}
		return err
	}
	// Define the label selector to match the Jobs
	labelSelector := "job-group=" + jobName
	// List Jobs with the specified label
	jobs, err := k8sutil.K8sClient.BatchV1().Jobs(namespace).List(context.TODO(), metav1.ListOptions{
		LabelSelector: labelSelector,
	})
	if err != nil {
		if errors.IsNotFound(err) {
			// Job 不存在的情况下认为删除成功
			logging.Info("Job %s not found in namespace %s, considered as successfully deleted", jobName, namespace)

			logging.Error("Error listing Jobs: %s", err.Error())
			return err
		}
	}
	// Delete each Job
	deletePolicy := metav1.DeletePropagationForeground
	for _, job := range jobs.Items {
		err = k8sutil.K8sClient.BatchV1().Jobs(namespace).Delete(context.TODO(), job.Name, metav1.DeleteOptions{
			PropagationPolicy: &deletePolicy,
		})
		if err != nil {
			logging.Error("Error Delete Jobs: %s", err.Error())
			return err
		}
		logging.Info("delete job jobName %s namespace %s", job.Name, job.Namespace)
	}
	return err
}
