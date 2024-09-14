package persistence

import (
	"context"
	"sync"

	"gorm.io/gorm"
	"syyx.com/crawler/domain/entity"
	"syyx.com/crawler/domain/repository"
	"syyx.com/crawler/pkg/di"
)

var (
	dataRecordRepo *DataRecordPostsqlRepository
	dataRecordOnce sync.Once
)

func init() {
	err := di.GetContianer().Provide(func(g *gorm.DB, base repository.BaseRepository) repository.DataRecordRepository {
		return GetDataRecordPostsqlRepository(g, base)
	})
	if err != nil {
		panic(err)
	}
}

type DataRecordPostsqlRepository struct {
	gorm *gorm.DB
	base repository.BaseRepository
}

func GetDataRecordPostsqlRepository(gormDB *gorm.DB, base repository.BaseRepository) *DataRecordPostsqlRepository {
	dataRecordOnce.Do(func() {
		dataRecordRepo = &DataRecordPostsqlRepository{
			gorm: gormDB,
			base: base,
		}
		gormDB.AutoMigrate(entity.DataRecord{})
	})
	return dataRecordRepo
}

func (repo *DataRecordPostsqlRepository) GetRecords(ctx context.Context, offset int, pageSize int, maps interface{}) ([]*entity.DataRecord, error) {
	var DataRecords []*entity.DataRecord
	err := repo.gorm.Model(&entity.DataRecord{}).Where(maps).Offset(offset).Limit(pageSize).Find(&DataRecords).Error
	if err != nil && err != gorm.ErrRecordNotFound {
		return nil, err
	}
	return DataRecords, nil
}

func (repo *DataRecordPostsqlRepository) GetRecord(ctx context.Context, id int) (*entity.DataRecord, error) {
	var DataRecord entity.DataRecord
	err := repo.gorm.Where("id = ? and deleted_on = ? ", id, 0).First(&DataRecord).Error
	if err != nil && err != gorm.ErrRecordNotFound {
		return nil, err
	}
	return &DataRecord, nil
}

func (repo *DataRecordPostsqlRepository) EditRecord(ctx context.Context, entity *entity.DataRecord) error {
	if err := repo.gorm.Model(entity).Where("id = ? and deleted_on = ?", entity.ID, 0).Updates(entity).Error; err != nil {
		return err
	}
	return nil
}

func (repo *DataRecordPostsqlRepository) AddRecord(ctx context.Context, entity *entity.DataRecord) error {
	if err := repo.gorm.Create(&entity).Error; err != nil {
		return err
	}
	return nil
}

func (repo *DataRecordPostsqlRepository) DeleteRecord(ctx context.Context, id int) error {
	if err := repo.gorm.Where(" id = ?", id).Delete(&entity.DataRecord{}).Error; err != nil {
		return err
	}
	return nil
}
