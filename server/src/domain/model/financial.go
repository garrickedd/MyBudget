package model

type FinancialSummary struct {
	TotalBalance float64 `json:"totalBalance"`
	Income       float64 `json:"income"`
	Expense      float64 `json:"expense"`
}
