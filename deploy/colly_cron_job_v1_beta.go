package deploy

import (
	"context"
	"fmt"
	"strings"

	corev1 "k8s.io/api/core/v1"

	"gopkg.in/yaml.v2"
	v1Beta "k8s.io/api/batch/v1beta1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"syyx.com/crawler/pkg/k8sutil"
	"syyx.com/crawler/pkg/logging"
)

type CollyCronJobBetaHandler struct {
}

func (h CollyCronJobBetaHandler) Deploy(conf *DeployJobConf) (ret bool, err error) {
	var cronJob *v1Beta.CronJob
	if cronJob, err = loadCronBetaTemplate(); err != nil {
		logging.Error("loadCronBetaTemplate error id %d name %s", conf.ExecuteID, conf.JobName)
		return
	}
	h.appendCronJobValuesBeta(cronJob, conf)
	var yamlData []byte
	if yamlData, err = yaml.Marshal(*cronJob); err != nil {
		logging.Error("marshal yamlData error id %d name %s %v", conf.ExecuteID, conf.JobName, err)
		return
	}
	jobClient := k8sutil.K8sClient.BatchV1beta1().CronJobs(conf.Namespace)
	if cronJob, err = jobClient.Create(context.TODO(), cronJob, metav1.CreateOptions{}); err != nil {
		return
	}
	logging.Info("success jobName %s yamlData %s", cronJob.GetName(), string(yamlData))
	return true, nil
}

// 动态设置模板值
func (h CollyCronJobBetaHandler) appendCronJobValuesBeta(job *v1Beta.CronJob, conf *DeployJobConf) {
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
		command := strings.Fields(conf.Command) //[]string{"/bin/sh", "-c"}
		job.Spec.JobTemplate.Spec.Template.Spec.Containers[0].Command = command
	}
	args := strings.Fields(conf.Args) //[]string{args}
	job.Spec.JobTemplate.Spec.Template.Spec.Containers[0].Args = args
	envPairs := strings.Fields(conf.Envs)
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
