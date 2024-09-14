package models

import (
	"fmt"
	"log"
	"time"

	// "github.com/jinzhu/gorm"
	// _ "github.com/jinzhu/gorm/dialects/mysql"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	"syyx.com/crawler/pkg/setting"
	// "time"
)

var db *gorm.DB

type Model struct {
	ID         int `gorm:"primary_key" json:"id"`
	CreatedOn  int `json:"created_on"`
	ModifiedOn int `json:"modified_on"`
	DeletedOn  int `json:"deleted_on"`
}

// Setup initializes the database instance
func Setup() {
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
	db, err = gorm.Open(postgres.Open(dbURL))
	if err != nil {
		log.Fatalf("models.Setup err: %v", err)
	}

	// db, err = gorm.Open(setting.DatabaseSetting.Type, fmt.Sprintf("%s:%s@tcp(%s)/%s?charset=utf8&parseTime=True&loc=Local",
	// 	setting.DatabaseSetting.User,
	// 	setting.DatabaseSetting.Password,
	// 	setting.DatabaseSetting.Host,
	// 	setting.DatabaseSetting.Name))

	// if err != nil {
	// 	log.Fatalf("models.Setup err: %v", err)
	// }

	// gorm.DefaultTableNameHandler = func(db *gorm.DB, defaultTableName string) string {
	// 	return setting.DatabaseSetting.TablePrefix + defaultTableName
	// }

	// db.SingularTable(true)
	// db.Callback().Create().Replace("gorm:update_time_stamp", updateTimeStampForCreateCallback)
	// db.Callback().Update().Replace("gorm:update_time_stamp", updateTimeStampForUpdateCallback)
	// db.Callback().Delete().Replace("gorm:delete", deleteCallback)
	// db.DB().SetMaxIdleConns(10)
	// db.DB().SetMaxOpenConns(100)
}

// CloseDB closes database connection (unnecessary)
func CloseDB() {
	defer func() {
		sqlDB, err := db.DB()
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

// updateTimeStampForCreateCallback will set `CreatedOn`, `ModifiedOn` when creating
// func updateTimeStampForCreateCallback(scope *gorm.Scope) {
// 	if !scope.HasError() {
// 		nowTime := time.Now().Unix()
// 		if createTimeField, ok := scope.FieldByName("CreatedOn"); ok {
// 			if createTimeField.IsBlank {
// 				createTimeField.Set(nowTime)
// 			}
// 		}

// 		if modifyTimeField, ok := scope.FieldByName("ModifiedOn"); ok {
// 			if modifyTimeField.IsBlank {
// 				modifyTimeField.Set(nowTime)
// 			}
// 		}
// 	}
// }

// // updateTimeStampForUpdateCallback will set `ModifiedOn` when updating
// func updateTimeStampForUpdateCallback(scope *gorm.Scope) {
// 	if _, ok := scope.Get("gorm:update_column"); !ok {
// 		scope.SetColumn("ModifiedOn", time.Now().Unix())
// 	}
// }

// // deleteCallback will set `DeletedOn` where deleting
// func deleteCallback(scope *gorm.Scope) {
// 	if !scope.HasError() {
// 		var extraOption string
// 		if str, ok := scope.Get("gorm:delete_option"); ok {
// 			extraOption = fmt.Sprint(str)
// 		}

// 		deletedOnField, hasDeletedOnField := scope.FieldByName("DeletedOn")

// 		if !scope.Search.Unscoped && hasDeletedOnField {
// 			scope.Raw(fmt.Sprintf(
// 				"UPDATE %v SET %v=%v%v%v",
// 				scope.QuotedTableName(),
// 				scope.Quote(deletedOnField.DBName),
// 				scope.AddToVars(time.Now().Unix()),
// 				addExtraSpaceIfExist(scope.CombinedConditionSql()),
// 				addExtraSpaceIfExist(extraOption),
// 			)).Exec()
// 		} else {
// 			scope.Raw(fmt.Sprintf(
// 				"DELETE FROM %v%v%v",
// 				scope.QuotedTableName(),
// 				addExtraSpaceIfExist(scope.CombinedConditionSql()),
// 				addExtraSpaceIfExist(extraOption),
// 			)).Exec()
// 		}
// 	}
// }

// // addExtraSpaceIfExist adds a separator
// func addExtraSpaceIfExist(str string) string {
// 	if str != "" {
// 		return " " + str
// 	}
// 	return ""
// }
