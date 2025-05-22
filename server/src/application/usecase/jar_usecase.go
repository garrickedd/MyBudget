package usecase

import (
	"fmt"
	"mybudget/domain/model"
	"mybudget/domain/repository"

	"github.com/google/uuid"
)

type JarUsecase interface {
	GetUserJars(userID uuid.UUID) ([]*model.Jar, error)
	UpdateJarBalance(jarID int, amount float64, isIncome bool) error
}

type JarUsecaseImpl struct {
	jarRepo repository.JarRepository
}

func NewJarUsecase(jarRepo repository.JarRepository) *JarUsecaseImpl {
	return &JarUsecaseImpl{jarRepo: jarRepo}
}

func (u *JarUsecaseImpl) GetUserJars(userID uuid.UUID) ([]*model.Jar, error) {
	return u.jarRepo.FindByUserID(userID)
}

func (u *JarUsecaseImpl) UpdateJarBalance(jarID int, amount float64, isIncome bool) error {
	jar, err := u.jarRepo.FindByID(jarID)
	if err != nil {
		return err
	}
	if jar == nil {
		return fmt.Errorf("jar not found")
	}

	newBalance := jar.Balance
	if isIncome {
		newBalance += amount
	} else {
		newBalance -= amount
		if newBalance < 0 {
			return fmt.Errorf("insufficient balance in jar")
		}
	}

	return u.jarRepo.UpdateBalance(jarID, newBalance)
}
