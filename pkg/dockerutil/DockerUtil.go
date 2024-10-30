package dockerutil

import (
	"archive/tar"
	"bytes"
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"io/fs"
	"os"
	"path/filepath"
	"strings"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/image"
	"github.com/docker/docker/api/types/registry"
	"github.com/docker/docker/client"
	"github.com/docker/docker/pkg/archive"
	"syyx.com/crawler/pkg/logging"
	"syyx.com/crawler/pkg/setting"
)

var (
	localClient *client.Client
	auth_string string
)

func Setup() {
	defer func() {
		if r := recover(); r != nil {
			logging.Info("Panic in init: %v", r)
			// 进行适当的处理，比如日志记录或其他恢复操作
		}
	}()
	var err error
	localClient, auth_string, err = NewDockerClient()
	if err != nil {
		logging.Error("failed to initialize Docker client: %v", err)
		panic(err)
	}

}

func NewDockerClient() (*client.Client, string, error) {
	var dockerHost string
	if isOsWindows() {
		dockerHost = "tcp://localhost:2375"
	} else {
		dockerHost = "unix:///var/run/docker.sock"
	}
	cli, err := client.NewClientWithOpts(
		client.WithHost(dockerHost),
		client.WithAPIVersionNegotiation(),
	)
	if err != nil {
		return nil, "nil", fmt.Errorf("failed to create Docker client: %w", err)
	}
	authConfig := registry.AuthConfig{
		Username:      setting.DockerSetting.RegistryUsername,
		Password:      setting.DockerSetting.RegistryPassword,
		ServerAddress: setting.DockerSetting.ServerAddress,
	}

	//var str = fmt.Sprintf(`{"username":"%s","password":"%s"}`,
	//	authConfig.Username, authConfig.Password)
	// // 编码认证信息
	var str = fmt.Sprintf(`{"username":"%s","password":"%s","serveraddress":"%s"}`,
		authConfig.Username, authConfig.Password, authConfig.ServerAddress)
	logging.Info("NewDockerClient authstr %v", str)
	authString := base64.URLEncoding.EncodeToString([]byte(str))
	return cli, authString, nil
}

func isOsWindows() bool {
	return strings.Contains(os.Getenv("OS"), "Windows")
}

func GetFullImageName(imageNameWithTag string) string {
	return fmt.Sprintf("%s/%s/%s", setting.DockerSetting.RegistryAddr, setting.DockerSetting.RegistryDir, imageNameWithTag)
}

// 构建docker镜像
func BuildDockerImage(language, pluginRootDir, imageNameWithTag string) (bool, error) {
	workDir, err := os.Getwd()
	if err != nil {
		logging.Error("Error getting current directory: %s", err)
		return false, err
	}
	pluginRootDir = filepath.Join(workDir, "plugins", language, pluginRootDir)
	buildContext, err := archive.TarWithOptions(pluginRootDir, &archive.TarOptions{})
	if err != nil {
		logging.Error("Error creating build context: %s", err)
		return false, err
	}
	fullImageName := GetFullImageName(imageNameWithTag)
	option := types.ImageBuildOptions{
		Tags:        []string{fullImageName},
		Dockerfile:  "Dockerfile", // 如果 Dockerfile.back 名称或路径不同，需要指定
		Remove:      false,        // 删除中间层镜像
		NetworkMode: "host",
	}
	pwd, err := os.Getwd()
	execPath, err := os.Executable()
	if err != nil {
		logging.Error("failed to build image: %s", err)
		return false, err
	}
	execDir := filepath.Dir(execPath)
	// 打印调试信息（可选）
	logging.Info(" build image Getwd: %s directory %s image: %s", pwd, execDir, fullImageName)
	// 打印当前目录下的所有文件和子目录
	// err = filepath.Walk(execDir, func(path string, info os.FileInfo, err error) error {
	// 	if err != nil {
	// 		return err
	// 	}
	// 	fmt.Println(path)
	// 	return nil
	// })
	buildResponse, err := localClient.ImageBuild(context.Background(), buildContext, option)
	if err != nil {
		logging.Error("Failed to build image: %s", err)
		return false, err
	}
	defer func() {
		buildResponse.Body.Close()
	}()
	// 打印构建过程中的输出
	success, err := processBuildOutput(buildResponse.Body)

	if !success {
		logging.Error("Failed to process build output: %s", err)
		return false, err
	}
	logging.Info("Successfully built Docker image: %s", fullImageName)
	return success, nil
	// pushResp, err := localClient.ImagePush(context.Background(), fullImageName, image.PushOptions{
	// 	RegistryAuth: auth_string,
	// })
	// if err != nil {
	// 	logging.Error("ImagePush failed err %s", err)
	// 	return false, err
	// }
	// defer pushResp.Close()
	// pushSuccess, err := processBuildOutput(pushResp)
	// logging.Info("ImagePush success %v pluginRootDir %v imageName %v tag %v ", pushSuccess, pluginRootDir, imageName, fullImageName)
	// _, err = localClient.ImageRemove(context.Background(), fullImageName, image.RemoveOptions{
	// 	Force: true,
	// })
	// logging.Info("ImageRemove success %v pluginRootDir %v imageName %v tag %v ", pushSuccess, pluginRootDir, imageName, fullImageName)
	// return pushSuccess, err
}

// processBuildOutput 实时解析并输出构建日志，同时判断构建结果
func processBuildOutput(reader io.Reader) (bool, error) {
	decoder := json.NewDecoder(reader)
	var success = true
	var err error = nil
	for {
		var message struct {
			Stream string `json:"stream"`
			Error  string `json:"error"`
		}

		if err = decoder.Decode(&message); err == io.EOF {
			break
		} else if err != nil {
			logging.Info("Error parsing build output: %v", err)
			success = false
			continue
		}

		if message.Stream != "" {
			logging.Info(message.Stream)
		}
		if message.Error != "" {
			logging.Info("Build failed: %s", message.Error)
			success = false
		}
	}

	return success, err
}

// 推送 Docker 镜像到远程仓库
func PushDockerImage(imageNameWithTag string) error {
	// 生成完整的镜像标签
	fullImageName := GetFullImageName(imageNameWithTag)
	// 为镜像打标签
	localClient.ImageTag(context.Background(), imageNameWithTag, fullImageName)
	// 推送镜像
	pushResp, err := localClient.ImagePush(context.Background(), fullImageName, image.PushOptions{
		RegistryAuth: auth_string,
	})
	if err != nil {
		logging.Error("Failed to push image: %v", err)
		return err
	}
	defer pushResp.Close()
	// 处理推送过程中的输出
	if _, err := io.Copy(os.Stdout, pushResp); err != nil {
		logging.Error("Failed to read push response: %v", err)
		return err
	}
	_, err = localClient.ImageRemove(context.Background(), fullImageName, image.RemoveOptions{
		Force: true,
	})
	if err != nil {
		logging.Error("Failed to remove image after push: %v", err)
	} else {
		logging.Info("Successfully removed image: %s", fullImageName)
	}
	logging.Info("PushDockerImage success with tag: %s", fullImageName)
	return nil
}

func createTarFromDir(dir string) (io.Reader, error) {
	buf := new(bytes.Buffer)
	tw := tar.NewWriter(buf)
	defer tw.Close()
	err := filepath.Walk(dir, func(file string, info fs.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.Mode().IsRegular() {
			data, err := os.ReadFile(file)
			if err != nil {
				return err
			}

			header := &tar.Header{
				Name: strings.TrimPrefix(file, dir),
				Mode: int64(info.Mode()),
				Size: info.Size(),
			}
			if err := tw.WriteHeader(header); err != nil {
				return err
			}
			if _, err := tw.Write(data); err != nil {
				return nil
			}
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return buf, nil
}
