package repository

import "mybudget/domain/model"

type UserRepoIF interface {
	CreateUser(user *model.User) error
	Update(user *model.User) error
	Delete(id string) error
	GetByEmail(email string) (*model.User, error)
	ExistsByEmail(email string) (bool, error)
}
