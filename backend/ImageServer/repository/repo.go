package repository

import (
	"database/sql"
	"errors"
	"fmt"
	_ "github.com/lib/pq"
)

type repo struct {
	DB *sql.DB
}

type DBUri struct {
	DBPassword string
	DBUser string
	DBHost string
	DBName string
}

func getDBUriString(dbUri DBUri) string {
	return fmt.Sprintf("host =%s user=%s password=%s dbname=%s sslmode=disable",
		dbUri.DBHost, dbUri.DBUser, dbUri.DBPassword, dbUri.DBName)
}


var Repo *repo = &repo{DB: nil}

func (r *repo) Connect(dbUri DBUri) error {
	conn, err := sql.Open("postgres", getDBUriString(dbUri))
	if err != nil {
		return err
	}
	if err = conn.Ping(); err != nil {
		return err
	}
	r.DB = conn
	return nil
}


func (r *repo) VerifyToken(itemId string, token string) (bool, error) {
	if r.DB == nil {
		return false, errors.New("repository has not been connected to any database")
	}
	var authorized bool
	err := r.DB.QueryRow("SELECT 	EXISTS(SELECT id FROM item_image_tokens WHERE item_id = $1 and token = $2);", itemId, token).Scan(&authorized)
	if err != nil {
		return false, err
	}
	return authorized, nil
}
