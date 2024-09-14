package models

import (
	"github.com/jinzhu/gorm"
	"syyx.com/crawler/pkg/setting"
)

type JobRecord struct {
	Model
	taskId    int    `json:"task_id" gorm:"index"`
	jobType   int    `json:"job_type"`
	namespace string `json:"namespace"`
	jobName   string `json:"job_name"`
	imageName string `json:"image_name"`
	command   string
	args      string
	cron      string

	state int //0 初始化 1 运行中 2 挂起 3 结束 4 取消
}

func (JobRecord) TableName() string {
	return "job_record"
}

func GetJobRecords(pageNum int, pageSize int, maps interface{}) ([]*JobRecord, error) {
	var jobrecords []*JobRecord
	err := db.Model(&JobRecord{}).Where(maps).Offset(pageNum).Limit(pageSize).Find(&jobrecords).Error
	if err != nil && err != gorm.ErrRecordNotFound {
		return nil, err
	}
	return jobrecords, nil
}

func GetJobRecord(id int) (*JobRecord, error) {
	var jobrecord JobRecord
	err := db.Where("id = ? and delete_on = ? ", id, 0).First(&jobrecord).Error
	if err != nil && err != gorm.ErrRecordNotFound {
		return nil, err
	}
	return &jobrecord, nil
}

func EditJobRecord(id int, data interface{}) error {
	if err := db.Model(&JobRecord{}).Where("id = ? and deleted_on = ?", id, 0).Updates(data).Error; err != nil {
		return err
	}
	return nil
}

func AddJobRecord(data map[string]interface{}) error {
	jobrecord := JobRecord{
		Model:     Model{},
		taskId:    data["task_id"].(int),
		jobType:   data["job_type"].(int),
		namespace: setting.K8sSetting.DefaultNamespace,
		jobName:   data["job_name"].(string),
		imageName: data["image_name"].(string),
		command:   data["command"].(string),
		args:      data["args"].(string),
		cron:      data["cron"].(string),
		state:     0,
	}
	if err := db.Create(&jobrecord).Error; err != nil {
		return err
	}
	return nil
}

func DeleteJobRecord(id int) error {
	if err := db.Where(" id = ?", id).Delete(&JobRecord{}).Error; err != nil {
		return err
	}
	return nil
}
