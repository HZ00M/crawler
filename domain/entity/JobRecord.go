package entity

import (
	"time"
)

const (
	RecordTableName = "t_job_record"
)

type JobRecord struct {
	ID                int       `gorm:"primaryKey;autoIncrement;column:id"`
	DataType          string    `gorm:"column:data_type"`
	FlagMain          int       `gorm:"column:flag_main"`
	TargetObjID       string    `gorm:"type:varchar(255);column:target_obj_id"`
	KeyWord           string    `gorm:"type:varchar(255);column:key_word"`
	ExecuteID         int       `gorm:"column:execute_id"`
	WebSite           string    `gorm:"type:varchar(255);column:web_site"`
	Content           string    `gorm:"type:text;column:content"`
	Label             string    `gorm:"type:varchar(255);column:label"`
	Subject           string    `gorm:"type:varchar(255);column:subject"`
	Author            string    `gorm:"type:varchar(255);column:author"`
	RecordURL         string    `gorm:"type:text;column:record_url"`
	MsgTime           string    `gorm:"type:varchar(255);column:msg_time"`
	TakeTime          string    `gorm:"type:varchar(255);column:take_time"`
	FansCount         int       `gorm:"column:fans_count"`
	InterestCount     int       `gorm:"column:interest_count"`
	UserID            string    `gorm:"type:varchar(255);column:user_id"`
	UserHomepage      string    `gorm:"type:text;column:user_homepage"`
	UserLevel         int       `gorm:"column:user_level"`
	ExecuteName       string    `gorm:"type:varchar(255);column:execute_name"`
	CreatedAt         time.Time `gorm:"type:timestamp with time zone;column:createdAt"`
	RecordUr          string    `gorm:"type:varchar(255);column:record_ur"`
	ActiveCount       int64     `gorm:"column:active_count"`
	ReadCount         int       `gorm:"column:read_count"`
	LikeCount         int       `gorm:"column:like_count"`
	CoinCount         int       `gorm:"column:coin_count"`
	MarkCount         int       `gorm:"column:mark_count"`
	ShareCount        int       `gorm:"column:share_count"`
	CommentsCount     int       `gorm:"column:comments_count"`
	BarrageCount      int       `gorm:"column:barrage_count"`
	Tag               string
	Comment           string
	CommenterName     string
	CommentTime       string
	UserMember        string
	UserLikes         string
	UserDescribe      string
	DeveloperWord     string
	AndroidLastUpdate string
	IosLastUpdate     string
	mark              string
	downloads         string
	BookNum           int
	DownCount         int
	ProjectName       string `gorm:"type:varchar(255)"`
	StorageFlag       int
}

func (JobRecord) TableName() string {
	return RecordTableName
}
