package repository

import (
	"syyx.com/crawler/domain/entity"
)

type JobRecordRepository interface {
	GetJobMeta(id int) (*entity.JobMeta, error)

	GetJobExecutes(offset int, pageSize int, conditions interface{}) ([]*entity.JobExecute, error)

	GetJobExecute(id int) (*entity.JobExecute, error)

	EditJobExecute(entity *entity.JobExecute) error

	AddJobExecute(entity *entity.JobExecute) error

	DeleteJobExecute(id int) error

	GetJobRecords(offset int, pageSize int, conditions interface{}) ([]*entity.JobRecord, error)

	GetJobRecord(id int) (*entity.JobRecord, error)

	EditJobRecord(entity *entity.JobRecord) error

	AddJobRecord(entity *entity.JobRecord) error

	DeleteJobRecord(id int) error

	DeleteJobRecordByExecuteId(executeId int) error

	GetJobRecordCountByExecuteId(executeId int) int64
}
