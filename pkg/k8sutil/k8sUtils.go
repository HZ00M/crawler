package k8sutil

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/Masterminds/semver/v3"

	"k8s.io/apimachinery/pkg/version"

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
var K8sVersion *version.Info

// var K8SJobClient batchv1.JobInterface

func Setup() {
	kubeCnf := setting.K8sSetting.KubeConfig
	restConf, err := clientcmd.BuildConfigFromFlags("", kubeCnf)
	logging.Debug("Starting kubeCnf \n%s \n restConf \n%v", kubeCnf, restConf)
	if err != nil {
		panic(err.Error())
		//return fmt.Errorf("failed to create Kubernetes client: %w", err)
	}
	K8sClient, err = kubernetes.NewForConfig(restConf)
	if err != nil {
		panic(err.Error())
		//return fmt.Errorf("failed to create Kubernetes client: %w", err)
	}
	K8sVersion, err = K8sClient.Discovery().ServerVersion()
	if err != nil {
		logging.Error("failed to Discovery K8sVersion %v", err)
	}
	logging.Info("k8sutil Setup finish %v", K8sVersion)

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

func VersionLessThan(version string) bool {
	currentVersion, err := semver.NewVersion(K8sVersion.GitVersion[1:]) // 去掉前面的 "v"
	if err != nil {
		logging.Error("Error parsing server version: %s", err.Error())
	}
	versionParsed, err := semver.NewVersion(version)
	if err != nil {
		logging.Error("Error parsing minimum version: %s", err.Error())
	}
	return currentVersion.LessThan(versionParsed) // 返回是否小于指定版本
}

func VersionGreaterThan(varsion string) bool {
	currentVersion, err := semver.NewVersion(K8sVersion.GitVersion[1:]) // 去掉前面的 "v"
	if err != nil {
		logging.Error("Error parsing server version: %s", err.Error())
	}
	versionParsed, err := semver.NewVersion(varsion)
	if err != nil {
		logging.Error("Error parsing minimum version: %s", err.Error())
	}
	return currentVersion.GreaterThan(versionParsed) // 返回是否大于指定版本
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
