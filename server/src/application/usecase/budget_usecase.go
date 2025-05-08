package usecase

import (
	"fmt"
	"mybudget/domain/model"
	"mybudget/domain/repository"
	"time"

	"github.com/google/uuid"
)

type BudgetUsecase interface {
	CreateBudget(userID uuid.UUID, jarID int, amount float64, month time.Time) error
	GetBudgets(userID uuid.UUID, month time.Time) ([]*model.Budget, error)
	UpdateBudget(budgetID int, amount float64) error
}

type BudgetUsecaseImpl struct {
	budgetRepo repository.BudgetRepository
	jarRepo    repository.JarRepository
}

func NewBudgetUsecase(budgetRepo repository.BudgetRepository, jarRepo repository.JarRepository) *BudgetUsecaseImpl {
	return &BudgetUsecaseImpl{budgetRepo: budgetRepo, jarRepo: jarRepo}
}

func (u *BudgetUsecaseImpl) CreateBudget(userID uuid.UUID, jarID int, amount float64, month time.Time) error {
	if amount < 0 {
		return fmt.Errorf("budget amount cannot be negative")
	}
	if userID == uuid.Nil || jarID <= 0 {
		return fmt.Errorf("invalid user ID or jar ID")
	}

	// Validate jar exists and belongs to user
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

	// Check for existing budget
	existingBudgets, err := u.budgetRepo.FindByUserIDAndMonth(userID, month)
	if err != nil {
		return err
	}
	for _, budget := range existingBudgets {
		if budget.JarID == jarID {
			return fmt.Errorf("budget already exists for this jar and month")
		}
	}

	budget := &model.Budget{
		UserID:    userID,
		JarID:     jarID,
		Amount:    amount,
		Month:     time.Date(month.Year(), month.Month(), 1, 0, 0, 0, 0, time.UTC),
		CreatedAt: time.Now(),
	}
	return u.budgetRepo.Create(budget)
}

func (u *BudgetUsecaseImpl) GetBudgets(userID uuid.UUID, month time.Time) ([]*model.Budget, error) {
	if userID == uuid.Nil {
		return nil, fmt.Errorf("invalid user ID")
	}
	month = time.Date(month.Year(), month.Month(), 1, 0, 0, 0, 0, time.UTC)
	return u.budgetRepo.FindByUserIDAndMonth(userID, month)
}

func (u *BudgetUsecaseImpl) UpdateBudget(budgetID int, amount float64) error {
	if amount < 0 {
		return fmt.Errorf("budget amount cannot be negative")
	}
	if budgetID <= 0 {
		return fmt.Errorf("invalid budget ID")
	}
	budget := &model.Budget{
		ID:        budgetID,
		Amount:    amount,
		CreatedAt: time.Now(),
	}
	return u.budgetRepo.Update(budget)
}
