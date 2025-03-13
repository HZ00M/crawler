package web

import (
	"log"
	"net/http"
	"net/http/httptest"
	"strconv"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/golang/mock/gomock"
	"github.com/stretchr/testify/assert"
	"syyx.com/crawler/domain/entity"
	"syyx.com/crawler/domain/service"
)

func init() {
}

func TestSync(t *testing.T) {
	//创建gin服务器
	gin.SetMode(gin.TestMode)

	//创建gin引擎并注册路由
	router := gin.Default()
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()
	mockService := service.NewMockIJobRecordService(ctrl)
	//设置模拟返回值
	// 定义模拟的返回值
	expectedMetaRecord := &entity.JobMeta{
		ID:         1,
		Command:    "python3.10	main.py",
		Namespace:  "crawler-platform-ehijoy",
		MetaName:   "GIT_TEST_META",
		ImageName:  "python_scrapy:1.5.24",
		LabelName:  "GIT_TEST",
		ExeArgs:    "type=bilibili",
		PluginPath: "python_scrapy",
		Language:   "python",
		RepoBranch: "master",
		RepoToken:  "9zZujsME3nV_svWPh4pB",
		RepoUrl:    "http://192.168.10.7/yushen/crawler",
	}
	expectedError := error(nil)
	mockService.EXPECT().GetJobMetaById(gomock.Eq(1)).Return(expectedMetaRecord, expectedError)
	handler := &PluginHandler{
		service: mockService,
	}
	router.POST("/api/v1/docker/sync", handler.Sync)
	// 定义要传递的 id 参数
	id := 1
	// 构造请求 URL
	url := "/api/v1/docker/sync?id=" + strconv.Itoa(id)
	req, _ := http.NewRequest("POST", url, nil)
	// requestBody, _ := json.Marshal(map[string]string{"id": "1"})
	// req, _ := http.NewRequest("POST", "/api/v1/docker/build", bytes.NewBuffer(requestBody))
	req.Header.Set("Content-Type", "application/json")

	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)
	assert.Equal(t, http.StatusOK, w.Code)
	log.Println(w.Body.String())
}
