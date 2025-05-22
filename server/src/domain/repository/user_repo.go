package repository

import (
	"mybudget/domain/model"

	"github.com/google/uuid"
)

type UserRepository interface {
	Create(user *model.User) error
	FindByEmail(email string) (*model.User, error)
	FindByID(id uuid.UUID) (*model.User, error)
	CreateDefaultJars(userID uuid.UUID) error
}
