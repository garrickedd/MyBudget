package handler

import (
	"mybudget/application/usecase"
	"net/http"

	"github.com/gin-gonic/gin"
)

type FinancialHandler struct {
	financialUsecase *usecase.FinancialUsecase
}

func NewFinancialHandler(financialUsecase *usecase.FinancialUsecase) *FinancialHandler {
	return &FinancialHandler{financialUsecase: financialUsecase}
}

func (h *FinancialHandler) GetFinancialSummary(c *gin.Context) {
	userID := c.Query("user_id")
	if userID == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "user_id is required"})
		return
	}

	summary, err := h.financialUsecase.GetFinancialSummary(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, summary)
}
