package usecase

import (
	"fmt"
	"mybudget/domain/model"
	"mybudget/domain/repository"
	"mybudget/infrastructure/service"
	"time"

	"github.com/google/uuid"
)

type UserUsecase interface {
	Register(firstName, lastName, email, password string) (*model.User, error)
	Login(email, password string) (*model.User, error)
	GetByID(id string) (*model.User, error)
}

type UserUsecaseImpl struct {
	userRepo        repository.UserRepository
	passwordService service.PasswordService
}

func NewUserUsecase(userRepo repository.UserRepository, passwordService service.PasswordService) *UserUsecaseImpl {
	return &UserUsecaseImpl{userRepo: userRepo, passwordService: passwordService}
}

func (u *UserUsecaseImpl) Register(firstName, lastName, email, password string) (*model.User, error) {
	// Check if email already exists
	existingUser, err := u.userRepo.FindByEmail(email)
	if err != nil {
		return nil, err
	}
	if existingUser != nil {
		return nil, fmt.Errorf("email already exists")
	}

	// Hash password
	hashedPassword, err := u.passwordService.HashPassword(password)
	if err != nil {
		return nil, err
	}

	// Create user
	user := &model.User{
		FirstName: firstName,
		LastName:  lastName,
		Email:     email,
		Pass:      hashedPassword,
		Name:      firstName + " " + lastName,
		CreatedAt: time.Now(),
	}

	if err := u.userRepo.Create(user); err != nil {
		return nil, err
	}

	// Create default jars
	if err := u.userRepo.CreateDefaultJars(user.ID); err != nil {
		return nil, err
	}

	return user, nil
}

func (u *UserUsecaseImpl) Login(email, password string) (*model.User, error) {
	user, err := u.userRepo.FindByEmail(email)
	if err != nil {
		return nil, err
	}
	if user == nil {
		return nil, fmt.Errorf("invalid email or password")
	}

	if err := u.passwordService.ComparePassword(user.Pass, password); err != nil {
		return nil, fmt.Errorf("invalid email or password")
	}

	return user, nil
}

func (u *UserUsecaseImpl) GetByID(id string) (*model.User, error) {
	userID, err := uuid.Parse(id)
	if err != nil {
		return nil, fmt.Errorf("invalid user ID")
	}
	user, err := u.userRepo.FindByID(userID)
	if err != nil {
		return nil, err
	}
	if user == nil {
		return nil, fmt.Errorf("user not found")
	}
	return user, nil
}
