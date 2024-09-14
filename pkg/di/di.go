package di

import (
	"sync"

	"go.uber.org/dig"
)

var (
	contianer *dig.Container
	once      sync.Once
)

func GetContianer() *dig.Container {
	once.Do(func() {
		contianer = dig.New()
	})
	return contianer
}
