package persistence

import (
	"mybudget/domain/model"

	"github.com/jmoiron/sqlx"
)

type UserRepository struct {
	DB *sqlx.DB
}

func (r *UserRepository) CreateUser(user *model.User) error {
	query := `INSERT INTO users (first_name, last_name, email, pass) 
              VALUES (:first_name, :last_name, :email, :pass)`
	_, err := r.DB.NamedExec(query, user)
	return err
}

func (r *UserRepository) Update(user *model.User) error {
	query := `UPDATE users SET first_name=:first_name, last_name=:last_name, email=:email, pass=:pass 
              WHERE id_user=:id_user`
	_, err := r.DB.NamedExec(query, user)
	return err
}

func (r *UserRepository) Delete(id string) error {
	query := `DELETE FROM users WHERE id_user=$1`
	_, err := r.DB.Exec(query, id)
	return err
}

func (r *UserRepository) GetByEmail(email string) (*model.User, error) {
	var user model.User
	err := r.DB.Get(&user, `SELECT * FROM users WHERE email=$1`, email)
	if err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) ExistsByEmail(email string) (bool, error) {
	var count int
	err := r.DB.Get(&count, `SELECT COUNT(*) FROM users WHERE email=$1`, email)
	return count > 0, err
}
