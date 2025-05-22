package persistence

import (
	"database/sql"
	"mybudget/domain/model"

	"github.com/google/uuid"
)

type TransactionRepositoryImpl struct {
	db *sql.DB
}

func NewTransactionRepository(db *sql.DB) *TransactionRepositoryImpl {
	return &TransactionRepositoryImpl{db: db}
}

func (r *TransactionRepositoryImpl) Create(transaction *model.Transaction) error {
	query := `
        INSERT INTO transactions (user_id, jar_id, type, amount, description, transaction_date, created_at)
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        RETURNING id
    `
	err := r.db.QueryRow(query, transaction.UserID, transaction.JarID, transaction.Type, transaction.Amount, transaction.Description, transaction.TransactionDate, transaction.CreatedAt).Scan(&transaction.ID)
	return err
}

func (r *TransactionRepositoryImpl) FindByUserID(userID uuid.UUID) ([]*model.Transaction, error) {
	query := `
        SELECT id, user_id, jar_id, type, amount, description, transaction_date, created_at
        FROM transactions
        WHERE user_id = $1
    `
	rows, err := r.db.Query(query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var transactions []*model.Transaction
	for rows.Next() {
		transaction := &model.Transaction{}
		err := rows.Scan(&transaction.ID, &transaction.UserID, &transaction.JarID, &transaction.Type, &transaction.Amount, &transaction.Description, &transaction.TransactionDate, &transaction.CreatedAt)
		if err != nil {
			return nil, err
		}
		transactions = append(transactions, transaction)
	}
	return transactions, nil
}

func (r *TransactionRepositoryImpl) FindByJarID(jarID int) ([]*model.Transaction, error) {
	query := `
        SELECT id, user_id, jar_id, type, amount, description, transaction_date, created_at
        FROM transactions
        WHERE jar_id = $1
    `
	rows, err := r.db.Query(query, jarID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var transactions []*model.Transaction
	for rows.Next() {
		transaction := &model.Transaction{}
		err := rows.Scan(&transaction.ID, &transaction.UserID, &transaction.JarID, &transaction.Type, &transaction.Amount, &transaction.Description, &transaction.TransactionDate, &transaction.CreatedAt)
		if err != nil {
			return nil, err
		}
		transactions = append(transactions, transaction)
	}
	return transactions, nil
}
