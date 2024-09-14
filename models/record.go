package models

import (
	"fmt"
	"time"

	"github.com/jinzhu/gorm"
)

type Record struct {
	Model

	Text string `json:"text"`
}

// TableName returns the name of the table in the database for the Auth model.
func (Record) TableName() string {
	now := time.Now()
	subfix := now.Format("2006-01-02")
	return fmt.Sprintf("%s_%s", "record", subfix)
}

func AddRecord(data map[string]interface{}) error {
	record := Record{
		Text: data["text"].(string),
	}
	db.AutoMigrate(record)
	if err := db.Create(&record).Error; err != nil {
		return err
	}
	return nil
}

func getRecord(id int) (*Record, error) {
	var record Record
	err := db.Where("id = ?", id).First(&record).Error
	if err != nil && err != gorm.ErrRecordNotFound {
		return nil, err
	}
	return &record, nil
}
