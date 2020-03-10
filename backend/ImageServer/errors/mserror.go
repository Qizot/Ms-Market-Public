package errors

import "fmt"

type MSError struct {
	Status  int    `json:"Status"`
	Message string `json:"Message"`
}

func New(message string, statusCode int) *MSError {
	return &MSError{Status: statusCode, Message: message}
}

func (err *MSError) Error() string {
	return fmt.Sprintf("Encountered an error: %s, http Status: %d", err.Message, err.Status)
}
