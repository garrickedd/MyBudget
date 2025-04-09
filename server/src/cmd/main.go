package main

import (
	"log"
	"mybudget/api/handler"
	"mybudget/api/router"
	"mybudget/application/usecase"
	"mybudget/infrastructure/database"
	"mybudget/infrastructure/persistence"
)

func main() {
	db, err := database.Postgres()
	if err != nil {
		log.Fatal("Database connection failed:", err)
	}

	userRepo := &persistence.UserRepository{DB: db}
	userUsecase := usecase.NewUserUsecase(userRepo)
	userHandler := handler.NewUserHandler(userUsecase)

	r := router.SetupRouter(userHandler)
	if err := r.Run(":8080"); err != nil {
		log.Fatal("Server failed:", err)
	}
}
