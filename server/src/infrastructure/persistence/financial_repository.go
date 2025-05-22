package persistence

import (
	"database/sql"
	"mybudget/domain/model"
)

type FinancialRepository struct {
	db *sql.DB
}

func NewFinancialRepository(db *sql.DB) *FinancialRepository {
	return &FinancialRepository{db: db}
}

func (r *FinancialRepository) GetFinancialSummary(userID string) (model.FinancialSummary, error) {
	var summary model.FinancialSummary
	err := r.db.QueryRow(`
        SELECT income, expense, total_balance
        FROM financial_summaries
        WHERE user_id = $1
    `, userID).Scan(&summary.Income, &summary.Expense, &summary.TotalBalance)
	if err != nil {
		// Nếu không tìm thấy, trả về summary rỗng
		if err == sql.ErrNoRows {
			return model.FinancialSummary{}, nil
		}
		return summary, err
	}
	return summary, nil
}
