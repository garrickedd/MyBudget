package repository

import "mybudget/domain/model"

type FinancialRepository interface {
	GetFinancialSummary(userID string) (model.FinancialSummary, error)
}
