package persistence

import (
	"context"
	"sync"

	"gorm.io/gorm"
	"syyx.com/crawler/domain/repository"
	"syyx.com/crawler/pkg/di"
)

var (
	baseRepo       *BasePostsqlRepository
	baseRecordOnce sync.Once
)

func init() {
	err := di.GetContianer().Provide(func(g *gorm.DB) repository.BaseRepository {
		return GetPostsqlRepository(g)
	})
	if err != nil {
		panic(err)
	}
}

type BasePostsqlRepository struct {
	gorm *gorm.DB
}

func GetPostsqlRepository(gormDB *gorm.DB) *BasePostsqlRepository {
	baseRecordOnce.Do(func() {
		baseRepo = &BasePostsqlRepository{gorm: gormDB}
	})
	return baseRepo
}

func (r *BasePostsqlRepository) Create(ctx context.Context, data interface{}) error {
	return r.gorm.Table(TableNameFromContext(ctx)).WithContext(ctx).Create(data).Error
}

func (r *BasePostsqlRepository) Read(ctx context.Context, id string) (interface{}, error) {
	var result interface{}
	err := r.gorm.Table(TableNameFromContext(ctx)).WithContext(ctx).Where("id = ?", id).First(&result).Error
	return result, err
}

func (r *BasePostsqlRepository) Update(ctx context.Context, id string, data interface{}) error {
	return r.gorm.Table(TableNameFromContext(ctx)).WithContext(ctx).Where("id = ?", id).Updates(data).Error
}

func (r *BasePostsqlRepository) Delete(ctx context.Context, id string) error {
	return r.gorm.Table(TableNameFromContext(ctx)).WithContext(ctx).Where("id = ?", id).Delete(nil).Error
}

const tableNameKey string = "tableName"

// 设置表名到上下文中
func (r *BasePostsqlRepository) WithTableName(ctx context.Context, tableName string) context.Context {
	return context.WithValue(ctx, tableNameKey, tableName)
}

// 从上下文中获取表名
func TableNameFromContext(ctx context.Context) string {
	if tableName, ok := ctx.Value(tableNameKey).(string); ok {
		return tableName
	}
	return ""
}
