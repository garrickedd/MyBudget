package usecase

import (
	"errors"
	"mybudget/domain/model"
	"mybudget/domain/repository"
)

type UserUsecaseIF interface {
	Register(user *model.User) error
	Login(email, password string) (*model.User, error)
	GetByID(id string) (*model.User, error)
}

type UserUsecase struct {
	userRepo repository.UserRepoIF
}

func NewUserUsecase(repo repository.UserRepoIF) *UserUsecase {
	return &UserUsecase{userRepo: repo}
}

func (u *UserUsecase) Register(user *model.User) error {
	exists, err := u.userRepo.ExistsByEmail(user.Email)
	if err != nil {
		return err
	}
	if exists {
		return errors.New("email already registered")
	}
	return u.userRepo.CreateUser(user)
}

func (u *UserUsecase) Login(email, password string) (*model.User, error) {
	user, err := u.userRepo.GetByEmail(email)
	if err != nil {
		return nil, errors.New("invalid credentials")
	}
	if user.Pass != password {
		return nil, errors.New("invalid password")
	}
	return user, nil
}

func (u *UserUsecase) GetByID(id string) (*model.User, error) {
	// Gợi ý: thêm method GetByID vào repo nếu bạn muốn thực hiện truy vấn theo id
	return nil, errors.New("not implemented")
}
