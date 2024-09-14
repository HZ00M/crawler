package logging

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"runtime"

	"syyx.com/crawler/pkg/file"
)

type Level int

var (
	F                  *os.File
	DefaultCallerDepth = 2

	fileLogger    *log.Logger
	consoleLogger *log.Logger
	logPrefix     = ""
	levelFlags    = []string{"DEBUG", "INFO", "WARN", "ERROR", "FATAL"}
)

const (
	DEBUG Level = iota
	INFO
	WARNING
	ERROR
	FATAL
)

// Setup initialize the log instance
func Setup() {
	var err error
	filePath := getLogFilePath()
	fileName := getLogFileName()
	F, err = file.MustOpen(fileName, filePath)
	if err != nil {
		log.Fatalf("logging.Setup err: %v", err)
	}

	fileLogger = log.New(F, "File", log.LstdFlags)
	consoleLogger = log.New(os.Stdout, "Console", log.LstdFlags)
	// 使用 logger 打印日志
	fileLogger.Printf("fileLogger Setup() finish. filePath %s fileName %s", filePath, fileName)
	consoleLogger.Printf("consoleLogger Setup() finish. filePath %s fileName %s", filePath, fileName)
}

func getFunctionName() string {
	pc, _, _, _ := runtime.Caller(2)
	fullName := runtime.FuncForPC(pc).Name()
	return extractFunctionName(fullName)
}

func extractFunctionName(fullName string) string {
	// 使用正则表达式提取函数名
	re := regexp.MustCompile(`[^/]+\.[^/]+$`)
	match := re.FindString(fullName)
	return match + "	"
}

// Debug output logs at debug level
func Debug(v ...interface{}) {
	setPrefix(DEBUG)
	fileLogger.Printf(getFunctionName()+v[0].(string), v[1:]...)
	consoleLogger.Printf(getFunctionName()+v[0].(string), v[1:]...)
}

// Info output logs at info level
func Info(v ...interface{}) {
	setPrefix(INFO)

	fileLogger.Printf(getFunctionName()+v[0].(string), v[1:]...)
	consoleLogger.Printf(getFunctionName()+v[0].(string), v[1:]...)
}

// Warn output logs at warn level
func Warn(v ...interface{}) {
	setPrefix(WARNING)
	fileLogger.Printf(getFunctionName()+v[0].(string), v[1:]...)
	consoleLogger.Printf(getFunctionName()+v[0].(string), v[1:]...)
}

// Error output logs at error level
func Error(v ...interface{}) {
	setPrefix(ERROR)
	fileLogger.Printf(getFunctionName()+v[0].(string), v[1:]...)
	consoleLogger.Printf(getFunctionName()+v[0].(string), v[1:]...)
}

// Fatal output logs at fatal level
func Fatal(v ...interface{}) {
	setPrefix(FATAL)
	fileLogger.Fatalf(getFunctionName()+v[0].(string), v[1:]...)
	consoleLogger.Fatalf(getFunctionName()+v[0].(string), v[1:]...)
}

// setPrefix set the prefix of the log output
func setPrefix(level Level) {
	_, file, line, ok := runtime.Caller(DefaultCallerDepth)
	if ok {
		logPrefix = fmt.Sprintf("[%s][%s:%d]", levelFlags[level], filepath.Base(file), line)
	} else {
		logPrefix = fmt.Sprintf("[%s]", levelFlags[level])
	}

	fileLogger.SetPrefix(logPrefix)
	consoleLogger.SetPrefix(logPrefix)
}
