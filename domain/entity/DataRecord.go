package entity

import (
	"syyx.com/crawler/pkg/gormdb"
)

type DataRecord struct {
	gormdb.Model
	JobName string
	Text    string
}
