package service

import (
	"fmt"
	"sync"
	"time"
)

// 定义一个包级别的 TickerManager 实例 (静态变量)
var tickerManager *TickerManager

// 初始化 TickerManager 的包级别函数
func init() {
	tickerManager = &TickerManager{
		tickers: make(map[interface{}]*time.Ticker),
		mu:      sync.Mutex{},
	}
}

type TickerManager struct {
	tickers map[interface{}]*time.Ticker
	mu      sync.Mutex
}

// StartTicker 启动一个新的 ticker
func (tm *TickerManager) StartTicker(id interface{}, intervalSecond int, timerFun func()) {
	tm.mu.Lock()
	defer tm.mu.Unlock()

	// 如果 ticker 已经存在，则先停止它
	if existingTicker, exists := tm.tickers[id]; exists {
		existingTicker.Stop()
	}

	// 创建新的 ticker 并存入 map
	duration := time.Duration(intervalSecond) * time.Second
	tm.tickers[id] = time.NewTicker(duration)

	// 启动 goroutine 处理 ticker
	go func(ticker *time.Ticker, id interface{}) {
		for range ticker.C {
			fmt.Printf("Ticker %s ticked\n", id)
			timerFun()
		}
	}(tm.tickers[id], id)
}

// StopTicker 停止指定的 ticker
func (tm *TickerManager) StopTicker(id interface{}) {
	tm.mu.Lock()
	defer tm.mu.Unlock()

	if ticker, exists := tm.tickers[id]; exists {
		ticker.Stop()
		delete(tm.tickers, id)
	}
}
