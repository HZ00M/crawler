package deploy

import (
	"embed"
	"fmt"
	"strings"

	corev1 "k8s.io/api/core/v1"

	v1 "k8s.io/api/batch/v1"
	"k8s.io/api/batch/v1beta1"
	v1Beta "k8s.io/api/batch/v1beta1"
	"sigs.k8s.io/yaml"
	"syyx.com/crawler/pkg/logging"
)

//go:embed colly_job.yaml
var colly_job embed.FS

//go:embed colly_cron_job_beta1.yaml
var colly_cron_job_beta1 embed.FS

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

const (
	OnceJobType JobType = iota
	CylceJobType
)

type DeployResult struct {
	ok bool
}
type DeployJobPlugin interface {
	Deploy(conf *DeployJobConf) (*DeployResult, error)
}

var deployServices map[JobType]DeployJobPlugin

func init() {
	// 创建服务映射
	deployServices = map[JobType]DeployJobPlugin{
		OnceJobType:  CollyJob{},
		CylceJobType: CollyCronJob{},
	}
}

func Deploy(conf *DeployJobConf) bool {
	plugin := deployServices[conf.JobType]
	ret, err := plugin.Deploy(conf)
	if err != nil {
		logging.Error("Deploy error %v %v", conf, err)
		return false
	}
	logging.Info("Deploy success %v %v", conf, ret)
	return true
}

func LoadJobFromYAML() (*v1.Job, error) {
	// 列出目录中的所有文件
	// entries, err := templateFS.ReadDir("deploy")
	// if err != nil {
	// 	logging.Debug("error reading directory: %v", err)
	// }
	// for _, entry := range entries {
	// 	logging.Debug("Embedded file: %s", entry.Name())
	// }

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

// 动态设置模板值
func appendCronJobValues(job *v1Beta.CronJob, conf *DeployJobConf) {
	parallel := int32(conf.Parallel)
	executeId := fmt.Sprintf("%d", conf.ExecuteID)
	job.ObjectMeta.Name = conf.JobName
	job.ObjectMeta.Namespace = conf.Namespace
	job.ObjectMeta.Labels["execute-id"] = executeId
	// job.ObjectMeta.Labels["app-group"] = conf.AppName
	// job.ObjectMeta.Labels["job-group"] = conf.JobName
	job.Spec.Schedule = conf.Cron
	job.Spec.JobTemplate.Spec.Parallelism = &parallel
	job.Spec.JobTemplate.Spec.Completions = &parallel
	job.Spec.JobTemplate.Spec.Template.ObjectMeta.Labels["execute-id"] = executeId
	job.Spec.JobTemplate.Spec.Template.ObjectMeta.Labels["app-group"] = conf.AppName
	job.Spec.JobTemplate.Spec.Template.ObjectMeta.Labels["job-group"] = conf.JobName
	job.Spec.JobTemplate.Spec.Template.Spec.Containers[0].Image = conf.ImageName
	job.Spec.JobTemplate.Spec.Template.Spec.Containers[0].Name = conf.AppName
	if conf.Command != "" {
		command := strings.Split(conf.Command, "\t") //[]string{"/bin/sh", "-c"}
		job.Spec.JobTemplate.Spec.Template.Spec.Containers[0].Command = command
	}
	args := strings.Split(conf.Args, "	") //[]string{args}
	job.Spec.JobTemplate.Spec.Template.Spec.Containers[0].Args = args
	envPairs := strings.Split(conf.Envs, "\t")
	var envVars []corev1.EnvVar
	// 遍历每个 KEY=VALUE 对，并转换为 v1.EnvVar 结构体
	for _, pair := range envPairs {
		parts := strings.SplitN(pair, "=", 2)
		if len(parts) == 2 {
			envVars = append(envVars, corev1.EnvVar{
				Name:  parts[0],
				Value: parts[1],
			})
		}
	}
	job.Spec.JobTemplate.Spec.Template.Spec.Containers[0].Env = envVars

}

// UpdateJob updates the Job object with the specified image, namespace
func LoadCronFromYAMLBeta() (*v1beta1.CronJob, error) {
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
