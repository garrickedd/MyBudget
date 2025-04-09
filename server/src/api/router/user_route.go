package router

import (
	"mybudget/api/handler"

	"github.com/gin-gonic/gin"
)

func UserRoutes(rg *gin.RouterGroup, userHandler *handler.UserHandler) {
	users := rg.Group("/users")
	{
		users.POST("/register", userHandler.Register)
		users.POST("/login", userHandler.Login)
		users.GET("/:id", userHandler.GetByID)
	}
}
