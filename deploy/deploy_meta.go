package deploy

import (
	"embed"
	"fmt"

	"syyx.com/crawler/pkg/k8sutil"

	v1 "k8s.io/api/batch/v1"
	"k8s.io/api/batch/v1beta1"
	"sigs.k8s.io/yaml"
	"syyx.com/crawler/pkg/logging"
)

//go:embed colly_job.yaml
var colly_job embed.FS

//go:embed colly_cron_job_beta1.yaml
var colly_cron_job_beta1 embed.FS

//go:embed colly_cron_job.yaml
var colly_cron_job embed.FS

type DeployJobConf struct {
	ExecuteID int64
	JobType   JobType
	Namespace string
	AppName   string
	ImageName string
	Command   string
	Args      string
	Envs      string
	Cron      string
	JobName   string
	Parallel  int
}

type JobType int
type JobHanler int

const (
	OnceJob JobType = iota
	CycleJob
)
const (
	OnceJobHandler JobHanler = iota
	CycleJobHandler
	CycleJobBetaHandler
)

type DeployJobHandler interface {
	Deploy(conf *DeployJobConf) (bool, error)
}

var deployServices map[JobHanler]DeployJobHandler

func init() {
	// 创建服务映射
	deployServices = map[JobHanler]DeployJobHandler{
		OnceJobHandler:      CollyJobHandler{},
		CycleJobHandler:     CollyCronJobHandler{},
		CycleJobBetaHandler: CollyCronJobBetaHandler{},
	}
}

func Deploy(conf *DeployJobConf) bool {
	var handler DeployJobHandler
	if conf.JobType == OnceJob {
		handler = deployServices[OnceJobHandler]
	} else if conf.JobType == CycleJob {
		//1.18以上支持使用 fieldRef 来引用 Pod 的注解和其他字段
		if k8sutil.VersionGreaterThan("1.20") {
			handler = deployServices[CycleJobHandler]
		} else {
			handler = deployServices[CycleJobBetaHandler]
		}
	}
	ret, err := handler.Deploy(conf)
	if err != nil {
		logging.Error("Deploy error %v %v", conf, err)
		return false
	}
	logging.Info("Deploy success %v %v", conf, ret)
	return true
}

func loadJobTemplate() (*v1.Job, error) {
	data, err := colly_job.ReadFile("colly_job.yaml")
	if err != nil {
		return nil, fmt.Errorf("error reading file: %w", err)
	}
	logging.Info("Raw YAML Data:\n%s\n", string(data))
	var job v1.Job
	if err := yaml.Unmarshal(data, &job); err != nil {
		return nil, fmt.Errorf("error unmarshaling YAML: %w", err)
	}
	return &job, nil
}

// UpdateJob updates the Job object with the specified image, namespace
func loadCronBetaTemplate() (*v1beta1.CronJob, error) {
	data, err := colly_cron_job_beta1.ReadFile("colly_cron_job_beta1.yaml")
	if err != nil {
		return nil, fmt.Errorf("error reading file: %w", err)
	}
	var cronJob v1beta1.CronJob
	if err := yaml.Unmarshal(data, &cronJob); err != nil {
		return nil, fmt.Errorf("error unmarshaling YAML: %w", err)
	}

	return &cronJob, nil
}

func loadCronTemplate() (*v1.CronJob, error) {
	data, err := colly_cron_job.ReadFile("colly_cron_job.yaml")
	if err != nil {
		return nil, fmt.Errorf("error reading file: %w", err)
	}
	var cronJob v1.CronJob
	if err := yaml.Unmarshal(data, &cronJob); err != nil {
		return nil, fmt.Errorf("error unmarshaling YAML: %w", err)
	}

	return &cronJob, nil
}
