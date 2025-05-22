package model

import (
	"time"

	"github.com/google/uuid"
)

type Budget struct {
	ID        int       `json:"id"`
	UserID    uuid.UUID `json:"user_id"`
	JarID     int       `json:"jar_id"`
	Amount    float64   `json:"amount"`
	Month     time.Time `json:"month"`
	CreatedAt time.Time `json:"created_at"`
}
