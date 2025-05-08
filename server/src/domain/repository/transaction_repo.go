package repository

import (
	"mybudget/domain/model"

	"github.com/google/uuid"
)

type TransactionRepository interface {
	Create(transaction *model.Transaction) error
	FindByUserID(userID uuid.UUID) ([]*model.Transaction, error)
	FindByJarID(jarID int) ([]*model.Transaction, error)
}
