package authorization

import (
	"ImageServer/errors"
	"ImageServer/repository"
	"encoding/json"
	"github.com/gorilla/mux"
	"net/http"
)



func writeError(w http.ResponseWriter, error *errors.MSError) {
	w.WriteHeader(error.Status)
	_ = json.NewEncoder(w).Encode(&error)
}

func ImageMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost && r.Method != http.MethodDelete {
			next.ServeHTTP(w,r)
			return
		}
		token := r.Header.Get("Authorization")
		vars := mux.Vars(r)
		itemId, ok := vars["item_id"]
		if !ok {
			writeError(w, &errors.MSError{http.StatusBadRequest, "lacking item_id in url"})
			return
		}
		if authorized, err := repository.Repo.VerifyToken(itemId, token); err != nil {
			writeError(w, &errors.MSError{http.StatusInternalServerError, err.Error()})
			return
		} else {
			if !authorized {
				writeError(w, &errors.MSError{http.StatusUnauthorized, "invalid authorizaton token"})
				return
			}
			next.ServeHTTP(w, r)
			return
		}
	})
}