package persistence

import (
	"database/sql"
	"mybudget/domain/model"

	"github.com/google/uuid"
)

type JarRepositoryImpl struct {
	db *sql.DB
}

func NewJarRepository(db *sql.DB) *JarRepositoryImpl {
	return &JarRepositoryImpl{db: db}
}

func (r *JarRepositoryImpl) Create(jar *model.Jar) error {
	query := `
        INSERT INTO jars (user_id, name, percentage, balance, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $5, $6)
        RETURNING id
    `
	err := r.db.QueryRow(query, jar.UserID, jar.Name, jar.Percentage, jar.Balance, jar.CreatedAt, jar.UpdatedAt).Scan(&jar.ID)
	return err
}

func (r *JarRepositoryImpl) FindByUserID(userID uuid.UUID) ([]*model.Jar, error) {
	query := `
        SELECT id, user_id, name, percentage, balance, created_at, updated_at
        FROM jars
        WHERE user_id = $1
    `
	rows, err := r.db.Query(query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var jars []*model.Jar
	for rows.Next() {
		jar := &model.Jar{}
		var updatedAt sql.NullTime
		err := rows.Scan(&jar.ID, &jar.UserID, &jar.Name, &jar.Percentage, &jar.Balance, &jar.CreatedAt, &updatedAt)
		if err != nil {
			return nil, err
		}
		if updatedAt.Valid {
			jar.UpdatedAt = updatedAt.Time
		}
		jars = append(jars, jar)
	}
	return jars, nil
}

func (r *JarRepositoryImpl) FindByID(jarID int) (*model.Jar, error) {
	query := `
        SELECT id, user_id, name, percentage, balance, created_at, updated_at
        FROM jars
        WHERE id = $1
    `
	jar := &model.Jar{}
	var updatedAt sql.NullTime
	err := r.db.QueryRow(query, jarID).Scan(
		&jar.ID, &jar.UserID, &jar.Name, &jar.Percentage, &jar.Balance, &jar.CreatedAt, &updatedAt,
	)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	if updatedAt.Valid {
		jar.UpdatedAt = updatedAt.Time
	}
	return jar, nil
}

func (r *JarRepositoryImpl) UpdateBalance(jarID int, balance float64) error {
	query := `
        UPDATE jars
        SET balance = $1, updated_at = CURRENT_TIMESTAMP
        WHERE id = $2
    `
	_, err := r.db.Exec(query, balance, jarID)
	return err
}
