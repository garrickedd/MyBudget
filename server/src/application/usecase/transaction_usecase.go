package usecase

import (
	"fmt"
	"mybudget/domain/model"
	"mybudget/domain/repository"
	"time"

	"github.com/google/uuid"
)

type TransactionUsecase interface {
	CreateIncome(userID uuid.UUID, amount float64, description string) error
	CreateExpense(userID uuid.UUID, jarID int, amount float64, description string) error
	GetUserTransactions(userID uuid.UUID) ([]*model.Transaction, error)
}

type TransactionUsecaseImpl struct {
	transactionRepo repository.TransactionRepository
	jarRepo         repository.JarRepository
}

func NewTransactionUsecase(transactionRepo repository.TransactionRepository, jarRepo repository.JarRepository) *TransactionUsecaseImpl {
	return &TransactionUsecaseImpl{transactionRepo: transactionRepo, jarRepo: jarRepo}
}

func (u *TransactionUsecaseImpl) CreateIncome(userID uuid.UUID, amount float64, description string) error {
	if amount <= 0 {
		return fmt.Errorf("amount must be positive")
	}
	if description == "" {
		description = "Income"
	}

	jars, err := u.jarRepo.FindByUserID(userID)
	if err != nil {
		return err
	}
	if len(jars) == 0 {
		return fmt.Errorf("no jars found for user")
	}

	now := time.Now()
	for _, jar := range jars {
		allocation := amount * (jar.Percentage / 100)
		if allocation <= 0 {
			continue
		}
		transaction := &model.Transaction{
			UserID:          userID,
			JarID:           jar.ID,
			Type:            model.Income,
			Amount:          allocation,
			Description:     description,
			TransactionDate: now,
			CreatedAt:       now,
		}
		if err := u.transactionRepo.Create(transaction); err != nil {
			return err
		}
		newBalance := jar.Balance + allocation
		if err := u.jarRepo.UpdateBalance(jar.ID, newBalance); err != nil {
			return err
		}
	}
	return nil
}

func (u *TransactionUsecaseImpl) CreateExpense(userID uuid.UUID, jarID int, amount float64, description string) error {
	if amount <= 0 {
		return fmt.Errorf("amount must be positive")
	}
	if description == "" {
		description = "Expense"
	}

	jar, err := u.jarRepo.FindByID(jarID)
	if err != nil {
		return err
	}
	if jar == nil {
		return fmt.Errorf("jar not found")
	}
	if jar.UserID != userID {
		return fmt.Errorf("jar does not belong to user")
	}
	if jar.Balance < amount {
		return fmt.Errorf("insufficient balance in jar")
	}

	transaction := &model.Transaction{
		UserID:          userID,
		JarID:           jarID,
		Type:            model.Expense,
		Amount:          amount,
		Description:     description,
		TransactionDate: time.Now(),
		CreatedAt:       time.Now(),
	}
	if err := u.transactionRepo.Create(transaction); err != nil {
		return err
	}

	newBalance := jar.Balance - amount
	return u.jarRepo.UpdateBalance(jarID, newBalance)
}

func (u *TransactionUsecaseImpl) GetUserTransactions(userID uuid.UUID) ([]*model.Transaction, error) {
	if userID == uuid.Nil {
		return nil, fmt.Errorf("invalid user ID")
	}
	return u.transactionRepo.FindByUserID(userID)
}
