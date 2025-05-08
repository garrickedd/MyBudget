DB_DRIVER=postgres
DB_SOURCE="postgresql://postgres:admin@localhost:5432/mybudgetdb?sslmode=disable&search_path=public"
MIGRATIONS_DIR=infrastructure/migrations

migrate-reset:
	@echo "Resetting database..." -$(PSQL) -c "DROP DATABASE mybudgetdb;" $(PSQL) -c "CREATE DATABASE mybudgetdb;" $(MIGRATE) -path infrastructure/migrations -database "$(DB_URL)" -verbose up

migrate-init:
	migrate create -ext sql -dir ${MIGRATIONS_DIR} -seq $(name)

migrate-up:
	migrate -path ${MIGRATIONS_DIR} -database ${DB_SOURCE} -verbose up

migrate-down:
	migrate -path ${MIGRATIONS_DIR} -database ${DB_SOURCE} -verbose down

migrate-fix:
	migrate -path ${MIGRATIONS_DIR} -database ${DB_SOURCE} force $(version)

migrate-check:
	migrate -path ${MIGRATIONS_DIR} -database ${DB_SOURCE} version