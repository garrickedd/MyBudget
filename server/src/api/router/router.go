package router

import (
	"database/sql"
	"mybudget/api/handler"
	"mybudget/application/usecase"
	"mybudget/infrastructure/persistence"
	"mybudget/infrastructure/service"

	"github.com/gin-gonic/gin"
)

func SetupRouter(db *sql.DB) *gin.Engine {
	router := gin.Default()

	// Dependencies
	userRepo := persistence.NewUserRepository(db)
	jarRepo := persistence.NewJarRepository(db)
	transactionRepo := persistence.NewTransactionRepository(db)
	budgetRepo := persistence.NewBudgetRepository(db)
	reportRepo := persistence.NewReportRepository(db)
	financialRepo := persistence.NewFinancialRepository(db) // Thêm FinancialRepository
	passwordService := service.NewBcryptService()
	userUsecase := usecase.NewUserUsecase(userRepo, passwordService)
	jarUsecase := usecase.NewJarUsecase(jarRepo)
	transactionUsecase := usecase.NewTransactionUsecase(transactionRepo, jarRepo)
	budgetUsecase := usecase.NewBudgetUsecase(budgetRepo, jarRepo)
	reportUsecase := usecase.NewReportUsecase(reportRepo)
	financialUsecase := usecase.NewFinancialUsecase(financialRepo) // Thêm FinancialUsecase

	userHandler := handler.NewUserHandler(userUsecase)
	jarHandler := handler.NewJarHandler(jarUsecase)
	transactionHandler := handler.NewTransactionHandler(transactionUsecase)
	budgetHandler := handler.NewBudgetHandler(budgetUsecase)
	reportHandler := handler.NewReportHandler(reportUsecase)
	financialHandler := handler.NewFinancialHandler(financialUsecase) // Thêm FinancialHandler

	// Routes
	api := router.Group("/api/v1")
	{
		UserRoutes(api, userHandler)
		JarRoutes(api, jarHandler)
		TransactionRoutes(api, transactionHandler)
		BudgetRoutes(api, budgetHandler)
		ReportRoutes(api, reportHandler)
		FinancialRoutes(api, financialHandler) // Thêm FinancialRoutes
	}

	return router
}
