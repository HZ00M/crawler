package k8sutil

import (
	"fmt"
	"os"
	"path/filepath"

	v1 "k8s.io/api/batch/v1"
	v1beta1 "k8s.io/api/batch/v1beta1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	"sigs.k8s.io/yaml"

	"syyx.com/crawler/pkg/logging"
	"syyx.com/crawler/pkg/setting"
)

// 指针类型与接口
// 接口类型：batchv1.JobInterface 只是一个接口类型，它定义了可以对 Job 资源进行的操作。
// 指针类型：*batchv1.JobInterface 是指向接口的指针，这在 Go 中并不常见，因为接口本身就是一个指针类型，它内部持有实际的实现对象的指针。
// *kubernetes.Clientset 是指向实例的指针

var K8sClient *kubernetes.Clientset

// var K8SJobClient batchv1.JobInterface

func Setup() {
	kubeCnf := setting.K8sSetting.KubeConfig
	restConf, err := clientcmd.BuildConfigFromFlags("", kubeCnf)
	if err != nil {
		panic(err.Error())
	}
	K8sClient, err = kubernetes.NewForConfig(restConf)
	if err != nil {
		panic(err.Error())
	}
	// K8SJobClient = K8sClient.BatchV1().Jobs(setting.K8sSetting.Namespace)
	logging.Info("k8sutil SETUP finish")
}

// LoadJobFromYAML reads a YAML file and converts it into a Job object
func LoadJobFromYAML(pathName, fileName string) (*v1.Job, error) {
	filePath := filepath.Join(pathName, fileName) // Assumes the template directory is in the project root

	data, err := os.ReadFile(filePath)
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

func LoadCronFromYAML(pathName, fileName string) (*v1.CronJob, error) {
	filePath := filepath.Join(pathName, fileName) // Assumes the template directory is in the project root

	yamlFile, err := os.ReadFile(filePath)
	if err != nil {
		return nil, fmt.Errorf("error reading file: %w", err)
	}

	var cronJob v1.CronJob
	if err := yaml.Unmarshal(yamlFile, &cronJob); err != nil {
		return nil, fmt.Errorf("error unmarshaling YAML: %w", err)
	}

	return &cronJob, nil
}

// UpdateJob updates the Job object with the specified image, namespace
func LoadCronFromYAMLBeta(pathName, fileName string) (*v1beta1.CronJob, error) {
	filePath := filepath.Join(pathName, fileName) // Assumes the template directory is in the project root

	yamlFile, err := os.ReadFile(filePath)
	if err != nil {
		return nil, fmt.Errorf("error reading file: %w", err)
	}

	var cronJob v1beta1.CronJob
	if err := yaml.Unmarshal(yamlFile, &cronJob); err != nil {
		return nil, fmt.Errorf("error unmarshaling YAML: %w", err)
	}

	return &cronJob, nil
}
