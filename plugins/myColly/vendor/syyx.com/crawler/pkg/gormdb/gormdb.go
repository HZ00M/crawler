package gormdb

import (
	"fmt"
	"log"
	"sync"
	"time"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	"syyx.com/crawler/pkg/di"
	"syyx.com/crawler/pkg/setting"
)

var (
	Db    *gorm.DB
	once  sync.Once
	dbURL string
)

type Model struct {
	ID         int `gorm:"primary_key" json:"id"`
	CreatedOn  int `json:"created_on"`
	ModifiedOn int `json:"modified_on"`
	DeletedOn  int `json:"deleted_on"`
}

func CreateGormDB() *gorm.DB {
	once.Do(func() {
		// 构建数据库连接字符串
		dbURL := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
			setting.DatabaseSetting.Host,
			setting.DatabaseSetting.Port,
			setting.DatabaseSetting.User,
			setting.DatabaseSetting.Password,
			setting.DatabaseSetting.Dbname,
			setting.DatabaseSetting.Sslmode,
		)
		var err error
		Db, err = gorm.Open(postgres.Open(dbURL))
		if err != nil {
			log.Fatalf("models.Setup err: %v", err)
		}
	})
	return Db
}

// Setup initializes the database instance
func Setup() {
	CreateGormDB()
	err := di.GetContianer().Provide(func() *gorm.DB {
		return Db
	})
	if err != nil {
		panic(err)
	}
}

// CloseDB closes database connection (unnecessary)
func CloseDB() {
	defer func() {
		sqlDB, err := Db.DB()
		if err != nil {
			log.Fatalf("Failed to get sql.DB: %v", err)
		}
		sqlDB.Close()
	}()
}
func (m *Model) BeforeCreate(tx *gorm.DB) (err error) {
	m.CreatedOn = int(time.Now().Unix())
	m.ModifiedOn = m.CreatedOn
	return
}

// BeforeUpdate will set ModifiedOn before the record is updated in the database
func (m *Model) BeforeUpdate(tx *gorm.DB) (err error) {
	m.ModifiedOn = int(time.Now().Unix())
	return
}

// BeforeDelete will set DeletedOn before the record is deleted from the database
func (m *Model) BeforeDelete(tx *gorm.DB) (err error) {
	m.DeletedOn = int(time.Now().Unix())
	return
}
