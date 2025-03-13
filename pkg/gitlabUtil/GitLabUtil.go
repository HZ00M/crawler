package gitlabUtil

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// Clone 拉取代码到指定的工作目录
func Clone(gitlabURL, repoPath, token string) error {
	var authURL = ""
	// 在 URL 中添加 Token 进行认证
	// 先将 http 替换为 https
	if strings.HasPrefix(gitlabURL, "http://") {
		// gitlabURL = strings.Replace(gitlabURL, "http://", "https://", 1)
		authURL = strings.Replace(gitlabURL, "http://", "http://oauth2:"+token+"@", 1)
	}
	if strings.HasPrefix(gitlabURL, "https://") {
		authURL = strings.Replace(gitlabURL, "https://", "https://oauth2:"+token+"@", 1)
	}

	log.Printf("Clone gitlabURL %v repoPath %v authURL %v", gitlabURL, repoPath, authURL)
	// 检查 repoPath 是否存在，如果不存在则创建
	if _, err := os.Stat(repoPath); os.IsNotExist(err) {
		err := os.MkdirAll(repoPath, 0755)
		if err != nil {
			return err
		}
	}
	cmd := exec.Command("git", "clone", authURL, repoPath)
	// 检查命令对象是否创建成功
	if cmd == nil {
		log.Printf("Failed to create git clone command for %s", gitlabURL)
		return fmt.Errorf("failed to create git clone command for %s", gitlabURL)
	}
	log.Printf("Executing git clone command: %v", cmd.Args)
	// 执行命令
	if err := cmd.Run(); err != nil {
		log.Printf("Clone repository fail repoPath %s err %v", repoPath, err)
		return err
	} else {
		log.Printf("Clone repository success repoPath %s", repoPath)
	}
	return nil
}

// Pull 更新指定工作目录的代码
func Pull(repoPath, token string) error {
	absPath, err := filepath.Abs(repoPath)
	if err != nil {
		return err
	}
	// 在执行 pull 命令前，设置 Git 的认证信息
	setAuthCmd := exec.Command("git", "config", "http.extraHeader", "PRIVATE-TOKEN: "+token)
	setAuthCmd.Dir = absPath
	if err := setAuthCmd.Run(); err != nil {
		return err
	}
	cmd := exec.Command("git", "pull")
	cmd.Dir = absPath
	log.Printf("Executing git Pull command: %v", cmd.Args)
	// 执行命令
	if err := cmd.Run(); err != nil {
		log.Printf("Pull repository fail repoPath %s err %v", repoPath, err)
		return err
	} else {
		log.Printf("Pull repository success repoPath %s", repoPath)
	}
	return nil
}

// IsGitRepo 检查指定路径是否为 Git 仓库
func IsGitRepo(repoPath string) bool {
	cmd := exec.Command("git", "rev-parse", "--is-inside-work-tree")
	cmd.Dir = repoPath
	output, err := cmd.Output()
	if err != nil {
		return false
	}
	return strings.TrimSpace(string(output)) == "true"
}

// Sync 同步代码，如果目录不存在则拉取，如果存在则更新
func Sync(gitlabURL, repoPath, token string) error {
	if IsGitRepo(repoPath) {
		return Pull(repoPath, token)
	}
	return Clone(gitlabURL, repoPath, token)
}
