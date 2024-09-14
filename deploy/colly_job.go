package deploy

import (
	"context"
	"fmt"
	"strings"

	"gopkg.in/yaml.v2"
	v1 "k8s.io/api/batch/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"syyx.com/crawler/pkg/k8sutil"
	"syyx.com/crawler/pkg/logging"
)

type CollyJob struct {
}

func (j CollyJob) Deploy(conf *DeployJobConf) (*DeployResult, error) {
	// job, err := k8sutil.LoadJobFromYAML("deploy", "colly_job.yaml")
	job, err := LoadJobFromYAML()
	if err != nil {
		logging.Error("DeployJob error %s", job.GetName())
	}

	appendJobValues(job, conf)
	yamlData, err := yaml.Marshal(*job)
	// 将 YAML 数据写入文件
	// fileName := "job.yaml"
	// err = os.WriteFile(fileName, yamlData, 0644)
	// if err != nil {
	// 	logging.Error("error writing YAML to file: %v", err)
	// }
	logging.Info("DeployJob success %s appendJobValues %s", job.GetName(), string(yamlData))
	jobClient := k8sutil.K8sClient.BatchV1().Jobs(conf.Namespace)
	createJob, err := jobClient.Create(context.TODO(), job, metav1.CreateOptions{})
	if err != nil {
		logging.Error("Deploy error %v", err)
		result := &DeployResult{
			ok: true,
		}
		return result, err
	}

	logging.Info("Deploy success %v", createJob)
	var result = &DeployResult{
		ok: true,
	}
	return result, nil
}

// 动态设置模板值
func appendJobValues(job *v1.Job, conf *DeployJobConf) {
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
	command := strings.Split(conf.Command, "	") //[]string{"/bin/sh", "-c"}
	job.Spec.Template.Spec.Containers[0].Command = command
	args := strings.Split(conf.Args, "	") //[]string{args}
	job.Spec.Template.Spec.Containers[0].Args = args

}
