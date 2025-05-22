package router

import (
	"mybudget/api/handler"

	"github.com/gin-gonic/gin"
)

func BudgetRoutes(rg *gin.RouterGroup, budgetHandler *handler.BudgetHandler) {
	budgets := rg.Group("/budgets")
	{
		budgets.POST("", budgetHandler.CreateBudget)
		budgets.GET("", budgetHandler.GetBudgets)
	}
}
