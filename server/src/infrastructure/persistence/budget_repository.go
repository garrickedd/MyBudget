package persistence

import (
	"database/sql"
	"mybudget/domain/model"
	"time"

	"github.com/google/uuid"
)

type BudgetRepositoryImpl struct {
	db *sql.DB
}

func NewBudgetRepository(db *sql.DB) *BudgetRepositoryImpl {
	return &BudgetRepositoryImpl{db: db}
}

func (r *BudgetRepositoryImpl) Create(budget *model.Budget) error {
	query := `
        INSERT INTO budgets (user_id, jar_id, amount, month, created_at)
        VALUES ($1, $2, $3, $4, $5)
        RETURNING id
    `
	err := r.db.QueryRow(query, budget.UserID, budget.JarID, budget.Amount, budget.Month, budget.CreatedAt).Scan(&budget.ID)
	return err
}

func (r *BudgetRepositoryImpl) FindByUserIDAndMonth(userID uuid.UUID, month time.Time) ([]*model.Budget, error) {
	query := `
        SELECT id, user_id, jar_id, amount, month, created_at
        FROM budgets
        WHERE user_id = $1 AND month = $2
    `
	rows, err := r.db.Query(query, userID, month)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var budgets []*model.Budget
	for rows.Next() {
		budget := &model.Budget{}
		err := rows.Scan(&budget.ID, &budget.UserID, &budget.JarID, &budget.Amount, &budget.Month, &budget.CreatedAt)
		if err != nil {
			return nil, err
		}
		budgets = append(budgets, budget)
	}
	return budgets, nil
}

func (r *BudgetRepositoryImpl) Update(budget *model.Budget) error {
	query := `
        UPDATE budgets
        SET amount = $1, created_at = $2
        WHERE id = $3
    `
	_, err := r.db.Exec(query, budget.Amount, budget.CreatedAt, budget.ID)
	return err
}
