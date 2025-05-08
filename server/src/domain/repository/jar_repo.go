package repository

import (
	"mybudget/domain/model"

	"github.com/google/uuid"
)

type JarRepository interface {
	Create(jar *model.Jar) error
	FindByUserID(userID uuid.UUID) ([]*model.Jar, error)
	FindByID(jarID int) (*model.Jar, error)
	UpdateBalance(jarID int, balance float64) error
}
