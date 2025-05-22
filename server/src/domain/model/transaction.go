package model

import (
	"time"

	"github.com/google/uuid"
)

type TransactionType string

const (
	Income  TransactionType = "income"
	Expense TransactionType = "expense"
)

type Transaction struct {
	ID              int             `json:"id"`
	UserID          uuid.UUID       `json:"user_id"`
	JarID           int             `json:"jar_id"`
	Type            TransactionType `json:"type"`
	Amount          float64         `json:"amount"`
	Description     string          `json:"description"`
	TransactionDate time.Time       `json:"transaction_date"`
	CreatedAt       time.Time       `json:"created_at"`
}
