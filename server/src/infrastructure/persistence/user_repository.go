package persistence

import (
	"database/sql"
	"mybudget/domain/model"

	"github.com/google/uuid"
)

type UserRepositoryImpl struct {
	db *sql.DB
}

func NewUserRepository(db *sql.DB) *UserRepositoryImpl {
	return &UserRepositoryImpl{db: db}
}

func (r *UserRepositoryImpl) Create(user *model.User) error {
	query := `
        INSERT INTO users (first_name, last_name, email, pass, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $5, $6)
        RETURNING id_user
    `
	err := r.db.QueryRow(query, user.FirstName, user.LastName, user.Email, user.Pass, user.CreatedAt, user.UpdatedAt).Scan(&user.ID)
	return err
}

func (r *UserRepositoryImpl) FindByEmail(email string) (*model.User, error) {
	query := `
        SELECT id_user, first_name, last_name, email, pass, created_at, updated_at
        FROM users
        WHERE email = $1
    `
	user := &model.User{}
	var updatedAt sql.NullTime
	err := r.db.QueryRow(query, email).Scan(
		&user.ID, &user.FirstName, &user.LastName, &user.Email, &user.Pass, &user.CreatedAt, &updatedAt,
	)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	user.Name = user.FirstName + " " + user.LastName
	if updatedAt.Valid {
		user.UpdatedAt = updatedAt.Time
	}
	return user, nil
}

func (r *UserRepositoryImpl) FindByID(id uuid.UUID) (*model.User, error) {
	query := `
        SELECT id_user, first_name, last_name, email, pass, created_at, updated_at
        FROM users
        WHERE id_user = $1
    `
	user := &model.User{}
	var updatedAt sql.NullTime
	err := r.db.QueryRow(query, id).Scan(
		&user.ID, &user.FirstName, &user.LastName, &user.Email, &user.Pass, &user.CreatedAt, &updatedAt,
	)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	user.Name = user.FirstName + " " + user.LastName
	if updatedAt.Valid {
		user.UpdatedAt = updatedAt.Time
	}
	return user, nil
}

func (r *UserRepositoryImpl) CreateDefaultJars(userID uuid.UUID) error {
	query := `
        INSERT INTO jars (user_id, name, percentage)
        VALUES
            ($1, 'Necessities', 55.00),
            ($1, 'Long-Term Savings', 10.00),
            ($1, 'Education', 10.00),
            ($1, 'Play', 10.00),
            ($1, 'Financial Freedom', 10.00),
            ($1, 'Give', 5.00)
    `
	_, err := r.db.Exec(query, userID)
	return err
}
