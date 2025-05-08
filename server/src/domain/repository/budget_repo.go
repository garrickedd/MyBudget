package repository

import (
	"mybudget/domain/model"
	"time"

	"github.com/google/uuid"
)

type BudgetRepository interface {
	Create(budget *model.Budget) error
	FindByUserIDAndMonth(userID uuid.UUID, month time.Time) ([]*model.Budget, error)
	Update(budget *model.Budget) error
}
