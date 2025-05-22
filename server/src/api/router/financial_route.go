package router

import (
	"mybudget/api/handler"

	"github.com/gin-gonic/gin"
)

func FinancialRoutes(api *gin.RouterGroup, financialHandler *handler.FinancialHandler) {
	api.GET("/financials", financialHandler.GetFinancialSummary)
}
