package handler

import (
	"mybudget/application/usecase"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type JarHandler struct {
	jarUsecase usecase.JarUsecase
}

func NewJarHandler(jarUsecase usecase.JarUsecase) *JarHandler {
	return &JarHandler{jarUsecase: jarUsecase}
}

func (h *JarHandler) GetUserJars(c *gin.Context) {
	userIDStr := c.Query("user_id")
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	jars, err := h.jarUsecase.GetUserJars(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, jars)
}
