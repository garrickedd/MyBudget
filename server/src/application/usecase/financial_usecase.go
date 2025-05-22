package usecase

import (
	"mybudget/domain/model"
	"mybudget/domain/repository"
)

type FinancialUsecase struct {
	financialRepo repository.FinancialRepository
}

func NewFinancialUsecase(financialRepo repository.FinancialRepository) *FinancialUsecase {
	return &FinancialUsecase{financialRepo: financialRepo}
}

func (u *FinancialUsecase) GetFinancialSummary(userID string) (model.FinancialSummary, error) {
	return u.financialRepo.GetFinancialSummary(userID)
}
