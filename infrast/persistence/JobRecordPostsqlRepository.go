package persistence

import (
	"sync"

	"gorm.io/gorm"
	"syyx.com/crawler/domain/entity"
	"syyx.com/crawler/domain/repository"
	"syyx.com/crawler/pkg/di"
)

var (
	jobRecordRepo *JobRecordPostsqlRepository
	jobRecordOnce sync.Once
)

func init() {
	err := di.GetContianer().Provide(func(g *gorm.DB, base repository.BaseRepository) repository.JobRecordRepository {
		return GetJobRecordPostsqlRepository(g, base)
	})
	if err != nil {
		panic(err)
	}
}

type JobRecordPostsqlRepository struct {
	gorm *gorm.DB
	base repository.BaseRepository
}

func GetJobRecordPostsqlRepository(gormDB *gorm.DB, base repository.BaseRepository) *JobRecordPostsqlRepository {
	jobRecordOnce.Do(func() {
		jobRecordRepo = &JobRecordPostsqlRepository{
			gorm: gormDB,
			base: base,
		}
		gormDB.AutoMigrate(entity.JobMeta{})
		gormDB.AutoMigrate(entity.JobExecute{})
		gormDB.AutoMigrate(entity.JobRecord{})
	})
	return jobRecordRepo
}

func (repo *JobRecordPostsqlRepository) GetJobMeta(id int) (*entity.JobMeta, error) {
	var jobMeta entity.JobMeta
	err := repo.gorm.Where("id = ?", id).First(&jobMeta).Error
	if err != nil && err != gorm.ErrRecordNotFound {
		return nil, err
	}
	return &jobMeta, nil
}

func (repo *JobRecordPostsqlRepository) GetJobExecutes(offset int, pageSize int, conditions interface{}) ([]*entity.JobExecute, error) {
	var jobExecutes []*entity.JobExecute
	err := repo.gorm.Model(&entity.JobRecord{}).Where(conditions).Offset(offset).Limit(pageSize).Find(&jobExecutes).Error
	if err != nil && err != gorm.ErrRecordNotFound {
		return nil, err
	}
	return jobExecutes, nil
}

func (repo *JobRecordPostsqlRepository) GetJobExecute(id int) (*entity.JobExecute, error) {
	var jobExecute entity.JobExecute
	err := repo.gorm.Where("id = ?", id).First(&jobExecute).Error
	if err == gorm.ErrRecordNotFound {
		return nil, nil
	}
	if err != nil && err != gorm.ErrRecordNotFound {
		return nil, err
	}
	return &jobExecute, nil
}
func (repo *JobRecordPostsqlRepository) GetJobExecuteByCron(id int) (*entity.JobExecute, error) {
	var jobExecute entity.JobExecute
	err := repo.gorm.Where("id = ?", id).First(&jobExecute).Error
	if err != nil && err != gorm.ErrRecordNotFound {
		return nil, err
	}
	return &jobExecute, nil
}

func (repo *JobRecordPostsqlRepository) EditJobExecute(entity *entity.JobExecute) error {
	if err := repo.gorm.Model(entity).Where("id = ?", entity.ID).Updates(entity).Error; err != nil {
		return err
	}
	return nil
}

func (repo *JobRecordPostsqlRepository) AddJobExecute(entity *entity.JobExecute) error {
	if err := repo.gorm.Create(&entity).Error; err != nil {
		return err
	}
	return nil
}

func (repo *JobRecordPostsqlRepository) DeleteJobExecute(id int) error {
	if err := repo.gorm.Where(" id = ?", id).Delete(&entity.JobExecute{}).Error; err != nil {
		return err
	}
	return nil
}

func (repo *JobRecordPostsqlRepository) GetJobRecords(offset int, pageSize int, maps interface{}) ([]*entity.JobRecord, error) {
	var jobrecords []*entity.JobRecord
	err := repo.gorm.Model(&entity.JobRecord{}).Where(maps).Offset(offset).Limit(pageSize).Find(&jobrecords).Error
	if err != nil && err != gorm.ErrRecordNotFound {
		return nil, err
	}
	return jobrecords, nil
}

func (repo *JobRecordPostsqlRepository) GetJobRecord(id int) (*entity.JobRecord, error) {
	var jobrecord entity.JobRecord
	err := repo.gorm.Where("id = ?", id).First(&jobrecord).Error
	if err != nil && err != gorm.ErrRecordNotFound {
		return nil, err
	}
	return &jobrecord, nil
}

func (repo *JobRecordPostsqlRepository) EditJobRecord(entity *entity.JobRecord) error {
	if err := repo.gorm.Model(entity).Where("id = ?", entity.ID).Updates(entity).Error; err != nil {
		return err
	}
	return nil
}

func (repo *JobRecordPostsqlRepository) AddJobRecord(entity *entity.JobRecord) error {
	if err := repo.gorm.Create(&entity).Error; err != nil {
		return err
	}
	return nil
}

func (repo *JobRecordPostsqlRepository) DeleteJobRecord(id int) error {
	if err := repo.gorm.Where(" id = ?", id).Delete(&entity.JobRecord{}).Error; err != nil {
		return err
	}
	return nil
}

func (repo *JobRecordPostsqlRepository) DeleteJobRecordByExecuteId(executeId int) error {
	if err := repo.gorm.Where(" execute_id = ?", executeId).Delete(&entity.JobRecord{}).Error; err != nil {
		return err
	}
	return nil
}
func (repo *JobRecordPostsqlRepository) GetJobRecordCountByExecuteId(executeId int) int64 {
	// 定义计数变量
	var count int64 = 0
	repo.gorm.Model(&entity.JobRecord{}).Where(" execute_id = ?", executeId).Count(&count)
	return count
}
