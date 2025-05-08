package router

import (
	"mybudget/api/handler"

	"github.com/gin-gonic/gin"
)

func ReportRoutes(rg *gin.RouterGroup, reportHandler *handler.ReportHandler) {
	reports := rg.Group("/reports")
	{
		reports.GET("", reportHandler.GenerateReport)
	}
}
