package setting

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"time"

	"github.com/go-ini/ini"
)

type App struct {
	JwtSecret string
	PageSize  int
	PrefixUrl string

	RuntimeRootPath string

	ImageSavePath  string
	ImageMaxSize   int
	ImageAllowExts []string

	ExportSavePath string
	QrCodeSavePath string
	FontSavePath   string

	LogSavePath string
	LogSaveName string
	LogFileExt  string
	TimeFormat  string
}

var AppSetting = &App{}

type Server struct {
	RunMode      string
	HttpPort     int
	ReadTimeout  time.Duration
	WriteTimeout time.Duration
}

var ServerSetting = &Server{}

type Database struct {
	User     string
	Password string
	Host     string
	Port     string
	Dbname   string
	Sslmode  string
}

// type Database struct {
// 	Type        string
// 	User        string
// 	Password    string
// 	Host        string
// 	Name        string
// 	TablePrefix string
// }

var DatabaseSetting = &Database{}

type Redis struct {
	Host        string
	Password    string
	MaxIdle     int
	MaxActive   int
	IdleTimeout time.Duration
}

var RedisSetting = &Redis{}

type K8s struct {
	KubeConfig       string
	DefaultNamespace string
}

var K8sSetting = &K8s{}

type Docker struct {
	RegistryAddr     string
	RegistryDir      string
	RegistryUsername string
	RegistryPassword string
	ForcePush        bool
	ServerAddress    string
}

var DockerSetting = &Docker{}

var cfg *ini.File

// Setup initialize the configuration instance
func Setup() {
	pwd, err := os.Getwd()
	execPath, err := os.Executable()
	if err != nil {
		fmt.Printf("failed to build image: %s", err)
	}
	execDir := filepath.Dir(execPath)
	fmt.Printf(" build image Getwd: %s directory %s", pwd, execDir)
	fmt.Println()
	// 打印当前目录下的所有文件和子目录
	err = filepath.Walk(execDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		fmt.Println(path)
		return nil
	})
	if err != nil {
		fmt.Printf("Error:", err)
	}
	cfg, err = ini.Load("conf/app.ini")
	if err != nil {
		log.Fatalf("setting.Setup, fail to parse 'conf/app.ini': %v", err)
	}

	mapTo("app", AppSetting)
	mapTo("server", ServerSetting)
	mapTo("database", DatabaseSetting)
	mapTo("redis", RedisSetting)
	mapTo("k8s", K8sSetting)
	mapTo("docker", DockerSetting)
	AppSetting.ImageMaxSize = AppSetting.ImageMaxSize * 1024 * 1024
	ServerSetting.ReadTimeout = ServerSetting.ReadTimeout * time.Second
	ServerSetting.WriteTimeout = ServerSetting.WriteTimeout * time.Second
	RedisSetting.IdleTimeout = RedisSetting.IdleTimeout * time.Second
}

// mapTo map section
func mapTo(section string, v interface{}) {
	err := cfg.Section(section).MapTo(v)
	if err != nil {
		log.Fatalf("Cfg.MapTo %s err: %v", section, err)
	}
}
