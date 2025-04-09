package router

import (
	"mybudget/api/handler"

	"github.com/gin-gonic/gin"
)

func SetupRouter(userHandler *handler.UserHandler) *gin.Engine {
	router := gin.Default()

	api := router.Group("/api/v1")
	{
		UserRoutes(api, userHandler)
	}

	return router
}
