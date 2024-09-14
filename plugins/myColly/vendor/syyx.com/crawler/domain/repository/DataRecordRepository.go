package repository

import (
	"context"

	"syyx.com/crawler/domain/entity"
)

type DataRecordRepository interface {
	GetRecords(ctx context.Context, offset int, pageSize int, conditions interface{}) ([]*entity.DataRecord, error)

	GetRecord(ctx context.Context, id int) (*entity.DataRecord, error)

	EditRecord(ctx context.Context, entity *entity.DataRecord) error

	AddRecord(ctx context.Context, entity *entity.DataRecord) error

	DeleteRecord(ctx context.Context, id int) error
}
