package entity

import (
	"time"
)

const (
	ExecuteTableName = "t_job_execute"
)

// 定义一个枚举类型
type JobStatus int

// 使用 iota 定义枚举常量
const (
	JobStatusInit JobStatus = iota // 0
	// JobStatusPrepare
	JobStatusRunning
	JobStatusPending
	JobStatusCancel
	JobStatusFinish
	JovStatusError
)

type JobType int

const (
	JobTypeOnce JobType = iota // 0
	JobTypeCron                // 1
)

type JobExecute struct {
	ID              int64 `gorm:"primaryKey;autoIncrement"`
	MetaId          int
	MetaName        string
	KeyWord         string
	IgnoreWord      string
	BeginTime       time.Time
	EndTime         time.Time
	ExecuteName     string `gorm:"type:varchar(255)" json:"execute_name"`
	AppLabelName    string
	JobLabelName    string
	Namespace       string `gorm:"type:varchar(255)"`
	Image           string `gorm:"type:varchar(255)"`
	Command         string `gorm:"type:varchar(255)"`
	ExeArgs         string `gorm:"type:varchar(255)"`
	EnvArgs         string `gorm:"type:varchar(255)"`
	Cron            string `gorm:"type:varchar(255)"`
	ResultTableName string `gorm:"type:varchar(255);default:'t_job_record'"  json:"result_table_name"`
	DataSize        int    `json:"data_size"`
	ExecuteCount    int
	JobStatus       int `gorm:"type:int;default:0" json:"job_status"`
	JobType         int `gorm:"type:int;default:0" json:"job_type"`
	JobGroup        string
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
	execute.JobStatus = int(status)
}
