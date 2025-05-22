package handler

import (
	"mybudget/application/usecase"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type BudgetHandler struct {
	budgetUsecase usecase.BudgetUsecase
}

func NewBudgetHandler(budgetUsecase usecase.BudgetUsecase) *BudgetHandler {
	return &BudgetHandler{budgetUsecase: budgetUsecase}
}

func (h *BudgetHandler) CreateBudget(c *gin.Context) {
	var input struct {
		UserID string  `json:"user_id"`
		JarID  int     `json:"jar_id"`
		Amount float64 `json:"amount"`
		Month  string  `json:"month"` // Format: YYYY-MM-DD
	}
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	userID, err := uuid.Parse(input.UserID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	month, err := time.Parse("2006-01-02", input.Month)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid month format"})
		return
	}

	if err := h.budgetUsecase.CreateBudget(userID, input.JarID, input.Amount, month); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"message": "Budget created"})
}

func (h *BudgetHandler) GetBudgets(c *gin.Context) {
	userIDStr := c.Query("user_id")
	monthStr := c.Query("month") // Format: YYYY-MM-DD
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	month, err := time.Parse("2006-01-02", monthStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid month format"})
		return
	}

	budgets, err := h.budgetUsecase.GetBudgets(userID, month)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, budgets)
}
