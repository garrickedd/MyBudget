package main

import (
	"log"
	"mybudget/api/router"
	"mybudget/infrastructure/database"
)

func main() {
	// Connect to database
	db, err := database.Postgres()
	if err != nil {
		log.Fatal("Database connection failed:", err)
	}
	defer db.Close()

	// Initialize router with all handlers
	r := router.SetupRouter(db.DB) // Pass embedded sql.DB; update to db if repositories use sqlx.DB

	// Start server
	if err := r.Run(":8080"); err != nil {
		log.Fatal("Server failed:", err)
	}
}
