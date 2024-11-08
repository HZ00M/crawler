package entity

import (
	"time"

	"syyx.com/crawler/pkg/logging"
)

const (
	ExecuteTableName = "t_job_execute"
)

// 定义一个枚举类型
type JobStatus int

// 使用 iota 定义枚举常量
const (
	JobStatusInit JobStatus = iota // 0
	JobStatusRunning
	JobStatusPending
	JobStatusCancel
	JobStatusFinish
	JobStatusError
)

// String 方法返回 JobStatus 的字符串表示
func (status JobStatus) String() string {
	switch status {
	case JobStatusInit:
		return "JobStatusInit"
	case JobStatusRunning:
		return "JobStatusRunning"
	case JobStatusPending:
		return "JobStatusPending"
	case JobStatusCancel:
		return "JobStatusCancel"
	case JobStatusFinish:
		return "JobStatusFinish"
	case JobStatusError:
		return "JobStatusError"
	default:
		return "Unknown"
	}
}

type JobType int

const (
	JobTypeOnce JobType = iota // 0
	JobTypeCron                // 1
)

type JobExecute struct {
	ID              int64 `gorm:"primaryKey;autoIncrement"`
	MetaId          int
	MetaName        string `gorm:"type:varchar(255)"`
	KeyWord         string `gorm:"type:varchar(255)"`
	IgnoreWord      string `gorm:"type:varchar(255)"`
	BeginTime       time.Time
	EndTime         time.Time
	ExecuteName     string `gorm:"type:varchar(255)" json:"execute_name"`
	AppLabelName    string `gorm:"type:varchar(255)"`
	JobLabelName    string `gorm:"type:varchar(255)"`
	Namespace       string `gorm:"type:varchar(255)"`
	Image           string `gorm:"type:varchar(255)"`
	Command         string `gorm:"type:varchar(255)"`
	ExeArgs         string `gorm:"type:text"`
	EnvArgs         string `gorm:"type:text"`
	Cron            string `gorm:"type:varchar(255)"`
	ResultTableName string `gorm:"type:varchar(255);default:'t_job_record'"  json:"result_table_name"`
	DataSize        int    `json:"data_size"`
	ExecuteCount    int
	FinishCount     int
	FailCount       int
	JobStatus       int    `gorm:"type:int;default:0" json:"job_status"`
	JobType         int    `gorm:"type:int;default:0" json:"job_type"`
	JobGroup        string `gorm:"type:varchar(255)"`
	ParallelNum     int
	CreatedAt       time.Time `gorm:"type:timestamp with time zone" `
	CreatedById     int64     `gorm:"column:createdById" json:"createdById"`
}

func (JobExecute) TableName() string {
	return ExecuteTableName
}

func (execute *JobExecute) AppendArg(key, value string) {
	execute.ExeArgs = execute.ExeArgs + "	--" + key + "=" + value
}

func (execute *JobExecute) AppendExtraArg(key, value string) {
	execute.ExeArgs = execute.ExeArgs + "	" + key + "=" + value
}

func (execute *JobExecute) UpdateStatus(status JobStatus) {
	currentStatus := JobStatus(execute.JobStatus)
	execute.JobStatus = int(status)
	logging.Info("update executeId %d status %s -> %s",
		execute.ID, currentStatus, status)
}
