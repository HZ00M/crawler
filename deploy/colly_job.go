package deploy

import (
	"context"
	"fmt"
	"strings"

	v1 "k8s.io/api/batch/v1"

	"gopkg.in/yaml.v2"
	batchv1 "k8s.io/api/batch/v1"
	corev1 "k8s.io/api/core/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"syyx.com/crawler/pkg/k8sutil"
	"syyx.com/crawler/pkg/logging"
)

type CollyJobHandler struct {
}

func (h CollyJobHandler) Deploy(conf *DeployJobConf) (ret bool, err error) {
	var job *v1.Job
	if job, err = loadJobTemplate(); err != nil {
		logging.Error("loadJobTemplate error id %d name %s", conf.ExecuteID, conf.JobName)
		return
	}
	appendJobValues(job, conf)
	var yamlData []byte
	if yamlData, err = yaml.Marshal(*job); err != nil {
		logging.Error("marshal yamlData error id %d name %s %v", conf.ExecuteID, conf.JobName, err)
		return
	}
	jobClient := k8sutil.K8sClient.BatchV1().Jobs(conf.Namespace)
	if job, err = jobClient.Create(context.TODO(), job, metav1.CreateOptions{}); err != nil {
		return
	}
	logging.Info("success jobName %s yamlData %s", job.GetName(), string(yamlData))
	return true, nil
}

// 动态设置模板值
func appendJobValues(job *batchv1.Job, conf *DeployJobConf) {
	parallel := int32(conf.Parallel)
	job.ObjectMeta.Name = conf.JobName
	job.ObjectMeta.Namespace = conf.Namespace
	job.ObjectMeta.Labels["app"] = "crawler" //可省略  已在模板配置
	job.ObjectMeta.Labels["execute-id"] = fmt.Sprintf("%d", conf.ExecuteID)
	job.ObjectMeta.Labels["app-group"] = conf.AppName
	job.ObjectMeta.Labels["job-group"] = conf.JobName
	job.Spec.Parallelism = &parallel
	job.Spec.Completions = &parallel
	job.Spec.Template.Spec.Containers[0].Image = conf.ImageName
	job.Spec.Template.Spec.Containers[0].Name = conf.AppName
	if conf.Command != "" {
		command := strings.Split(conf.Command, "\t") //[]string{"/bin/sh", "-c"}
		job.Spec.Template.Spec.Containers[0].Command = command
	}
	args := strings.Split(conf.Args, "\t") //[]string{args}
	job.Spec.Template.Spec.Containers[0].Args = args
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
	job.Spec.Template.Spec.Containers[0].Env = envVars
}
