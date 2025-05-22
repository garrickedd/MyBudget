package repository

import (
	"mybudget/domain/model"
	"time"

	"github.com/google/uuid"
)

type ReportRepository interface {
	GenerateReport(userID uuid.UUID, month time.Time) (*model.Report, error)
}
