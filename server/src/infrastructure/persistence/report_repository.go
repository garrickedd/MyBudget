package persistence

import (
	"database/sql"
	"mybudget/domain/model"
	"time"

	"github.com/google/uuid"
)

type ReportRepositoryImpl struct {
	db *sql.DB
}

func NewReportRepository(db *sql.DB) *ReportRepositoryImpl {
	return &ReportRepositoryImpl{db: db}
}

func (r *ReportRepositoryImpl) GenerateReport(userID uuid.UUID, month time.Time) (*model.Report, error) {
	query := `
        SELECT 
            j.id AS jar_id,
            j.name AS jar_name,
            j.balance,
            j.percentage,
            COALESCE(SUM(CASE WHEN t.type = 'expense' AND t.transaction_date >= $2 AND t.transaction_date < $3 THEN t.amount ELSE 0 END), 0) AS spent,
            COALESCE(b.amount, 0) AS budget,
            COALESCE(SUM(CASE WHEN t.type = 'income' AND t.transaction_date >= $2 AND t.transaction_date < $3 THEN t.amount ELSE 0 END), 0) AS total_income,
            COALESCE(SUM(CASE WHEN t.type = 'expense' AND t.transaction_date >= $2 AND t.transaction_date < $3 THEN t.amount ELSE 0 END), 0) AS total_expense
        FROM jars j
        LEFT JOIN transactions t ON j.id = t.jar_id
        LEFT JOIN budgets b ON j.id = b.jar_id AND b.month = $2
        WHERE j.user_id = $1
        GROUP BY j.id, j.name, j.balance, j.percentage, b.amount
    `
	monthStart := time.Date(month.Year(), month.Month(), 1, 0, 0, 0, 0, time.UTC)
	monthEnd := monthStart.AddDate(0, 1, 0)

	rows, err := r.db.Query(query, userID, monthStart, monthEnd)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	report := &model.Report{
		UserID: userID,
		Month:  monthStart.Format("2006-01"),
		Jars:   []model.JarReport{},
	}

	for rows.Next() {
		var jarReport model.JarReport
		var totalIncome, totalExpense float64
		err := rows.Scan(
			&jarReport.JarID,
			&jarReport.JarName,
			&jarReport.Balance,
			&jarReport.Percentage,
			&jarReport.Spent,
			&jarReport.Budget,
			&totalIncome,
			&totalExpense,
		)
		if err != nil {
			return nil, err
		}
		report.Jars = append(report.Jars, jarReport)
		report.TotalIncome = totalIncome
		report.TotalExpense = totalExpense
	}

	return report, nil
}
