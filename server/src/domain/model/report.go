package model

import "github.com/google/uuid"

type JarReport struct {
	JarID      int     `json:"jar_id"`
	JarName    string  `json:"jar_name"`
	Balance    float64 `json:"balance"`
	Spent      float64 `json:"spent"`
	Budget     float64 `json:"budget"`
	Percentage float64 `json:"percentage"`
}

type Report struct {
	UserID       uuid.UUID   `json:"user_id"`
	Month        string      `json:"month"` // Format: YYYY-MM
	TotalIncome  float64     `json:"total_income"`
	TotalExpense float64     `json:"total_expense"`
	Jars         []JarReport `json:"jars"`
}
