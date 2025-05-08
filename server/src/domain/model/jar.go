package model

import (
	"time"

	"github.com/google/uuid"
)

type Jar struct {
	ID         int       `json:"id"`
	UserID     uuid.UUID `json:"user_id"`
	Name       string    `json:"name"`
	Percentage float64   `json:"percentage"`
	Balance    float64   `json:"balance"`
	CreatedAt  time.Time `json:"created_at"`
	UpdatedAt  time.Time `json:"updated_at"`
}
