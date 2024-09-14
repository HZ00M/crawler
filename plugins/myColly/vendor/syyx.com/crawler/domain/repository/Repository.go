package repository

import "context"

type BaseRepository interface {
	Create(ctx context.Context, data interface{}) error
	Read(ctx context.Context, id string) (interface{}, error)
	Update(ctx context.Context, id string, data interface{}) error
	Delete(ctx context.Context, id string) error
	WithTableName(ctx context.Context, tableName string) context.Context
}
