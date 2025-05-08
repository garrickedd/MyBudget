package router

import (
	"mybudget/api/handler"

	"github.com/gin-gonic/gin"
)

func JarRoutes(rg *gin.RouterGroup, jarHandler *handler.JarHandler) {
	jars := rg.Group("/jars")
	{
		jars.GET("", jarHandler.GetUserJars)
	}
}
