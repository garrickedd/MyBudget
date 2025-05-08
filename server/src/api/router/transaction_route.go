package router

import (
	"mybudget/api/handler"

	"github.com/gin-gonic/gin"
)

func TransactionRoutes(rg *gin.RouterGroup, transactionHandler *handler.TransactionHandler) {
	transactions := rg.Group("/transactions")
	{
		transactions.POST("/income", transactionHandler.CreateIncome)
		transactions.POST("/expense", transactionHandler.CreateExpense)
		transactions.GET("", transactionHandler.GetUserTransactions)
	}
}
