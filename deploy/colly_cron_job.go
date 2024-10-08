package deploy

import (
	"context"

	"gopkg.in/yaml.v2"
	v1 "k8s.io/api/batch/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"syyx.com/crawler/pkg/k8sutil"
	"syyx.com/crawler/pkg/logging"
)

type CollyCronJobHandler struct {
}

func (h CollyCronJobHandler) Deploy(conf *DeployJobConf) (ret bool, err error) {
	var cronJob *v1.CronJob
	if cronJob, err = loadCronTemplate(); err != nil {
		logging.Error("loadCronBetaTemplate error id %d name %s", conf.ExecuteID, conf.JobName)
		return
	}
	appendCronJobValues(cronJob, conf)
	var yamlData []byte
	if yamlData, err = yaml.Marshal(*cronJob); err != nil {
		logging.Error("marshal yamlData error id %d name %s %v", conf.ExecuteID, conf.JobName, err)
		return
	}
	jobClient := k8sutil.K8sClient.BatchV1().CronJobs(conf.Namespace)
	if cronJob, err = jobClient.Create(context.TODO(), cronJob, metav1.CreateOptions{}); err != nil {
		return
	}
	logging.Info("success jobName %s yamlData %s", cronJob.GetName(), string(yamlData))
	return true, nil
}
