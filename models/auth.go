package models

import "github.com/jinzhu/gorm"

// Auth represents the authentication model for the application.
type Auth struct {
	ID       int    `gorm:"primary_key" json:"id"`
	Username string `json:"username"`
	Password string `json:"password"`
}

// TableName returns the name of the table in the database for the Auth model.
func (Auth) TableName() string {
	return "blog_auth"
}

// CheckAuth checks if authentication information exists
func CheckAuth(username, password string) (bool, error) {
	var auth Auth
	db.AutoMigrate(auth)
	err := db.Select("id").Where(Auth{Username: username, Password: password}).First(&auth).Error
	if err != nil && err != gorm.ErrRecordNotFound {
		return false, err
	}

	if auth.ID > 0 {
		return true, nil
	}

	return false, nil
}
