package entity

const (
	MetaTableName = "t_job_meta"
)

type JobMeta struct {
	ID         int    `gorm:"primary_key" json:"id"`
	MetaName   string `json:"meta_name"`
	Language   string
	LabelName  string
	ImageName  string `json:"image_name"`
	Command    string
	Namespace  string
	EnvArgs    string
	ExeArgs    string
	PluginPath string
}

func (JobMeta) TableName() string {
	return MetaTableName
}
