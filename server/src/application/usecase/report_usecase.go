package usecase

import (
	"mybudget/domain/model"
	"mybudget/domain/repository"
	"time"

	"github.com/google/uuid"
)

type ReportUsecase interface {
	GenerateReport(userID uuid.UUID, month time.Time) (*model.Report, error)
}

type ReportUsecaseImpl struct {
	reportRepo repository.ReportRepository
}

func NewReportUsecase(reportRepo repository.ReportRepository) *ReportUsecaseImpl {
	return &ReportUsecaseImpl{reportRepo: reportRepo}
}

func (u *ReportUsecaseImpl) GenerateReport(userID uuid.UUID, month time.Time) (*model.Report, error) {
	return u.reportRepo.GenerateReport(userID, month)
}
