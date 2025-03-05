package test

import (
	"fmt"
	"math/rand"
	"sort"
	"testing"
)

func TestDemo(t *testing.T) {
	var nums = []int{1, 2, 3, 4, 5, 6, 7, 8, 9}
	var result = 10
	for n := range nums {
		result = result + n
	}
	fmt.Println("testDemo success", result)
}

func BenchmarkDemo(b *testing.B) {
	slice := make([]int, 1000)
	for i := 0; i < b.N; i++ {
		for j := range slice {
			slice[j] = rand.Int()
		}
		sort.Ints(slice)
	}
}

func BenchmarkSortWithArray(b *testing.B) {
	var arr [1000]int
	for i := 0; i < b.N; i++ {
		for j := range arr {
			arr[j] = rand.Int()
		}
		sort.Ints(arr[:])
	}
}
