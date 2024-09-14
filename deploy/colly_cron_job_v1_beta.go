package deploy

import (
	"context"

	"gopkg.in/yaml.v2"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

	"syyx.com/crawler/pkg/k8sutil"
	"syyx.com/crawler/pkg/logging"
)

type CollyCronJob struct {
}

func (j CollyCronJob) Deploy(conf *DeployJobConf) (*DeployResult, error) {
	cronJob, err := LoadCronFromYAMLBeta()
	if err != nil {
		logging.Error("DeployJob error %s", cronJob.GetName())
	}

	appendCronJobValues(cronJob, conf)
	yamlData, err := yaml.Marshal(*cronJob)
	// 将 YAML 数据写入文件
	// fileName := "cronjob.yaml"
	// err = os.WriteFile(fileName, yamlData, 0644)
	// if err != nil {
	// 	logging.Error("error writing YAML to file: %v", err)
	// }
	logging.Info("DeployJob success %s appendJobValues %s", cronJob.GetName(), string(yamlData))
	jobClient := k8sutil.K8sClient.BatchV1beta1().CronJobs(conf.Namespace)
	createJob, err := jobClient.Create(context.TODO(), cronJob, metav1.CreateOptions{})
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
