package fileserver

import (
	"ImageServer/errors"
	"ImageServer/logger"
	"encoding/json"
	"fmt"
	"github.com/pierrre/imageserver"
	imageserver_http "github.com/pierrre/imageserver/http"
	"io/ioutil"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

type UploadServer interface {
	Upload(img *imageserver.Image, params imageserver.Params) (interface{}, error)
	Delete(params imageserver.Params) (interface{}, error)
}

type Handler struct {
	Parser imageserver_http.Parser

	Server UploadServer

	ErrorFunc func(err error, req *http.Request)
}

func (handler *Handler) ServeHTTP(rw http.ResponseWriter, req *http.Request) {
	err := handler.serveHTTP(rw, req)
	if err != nil {
		handler.sendError(rw, req, err)
	}
}

func getFormatFromHeaders(req *http.Request) string {
	format :=  req.Header.Get("Content-Type")
	trimed := strings.TrimPrefix(format, "image/")
	return trimed
}

func getImageBufferFromRequest(w http.ResponseWriter, r *http.Request) (buff []byte, format string, err error) {
	defer func() {
		if err != nil {
			logger.GetLogger().Error(err.Error())
		}
	}()

	if strings.HasPrefix(r.Header.Get("Content-Type"), "multipart") {
		err = r.ParseMultipartForm(32 << 20)
		if err != nil {
			return
		}

		file, handler, err := r.FormFile("file")
		if err != nil {
			return buff, format, err
		}
		defer func() {
			err := file.Close()
			if err != nil {
				logger.GetLogger().Error(err.Error())
			}
		}()

		format = strings.TrimPrefix(filepath.Ext(handler.Filename),".")
		if format == "jpg" {
			format = "jpeg"
		}

		buff, err = ioutil.ReadAll(file)
		return buff, format, err
	} else if strings.HasPrefix(r.Header.Get("Content-Type"), "image") {
		const MAX_SIZE = 5 * (1 << (10 * 2))
		r.Body = http.MaxBytesReader(w, r.Body, MAX_SIZE)
		defer func() {
			err := r.Body.Close()
			if err != nil {
				logger.GetLogger().Error(err.Error())
			}
		}()

		format = getFormatFromHeaders(r)
		buff, err = ioutil.ReadAll(r.Body)

		return buff, format, err
	} else {
		err = &errors.MSError{Status: http.StatusBadRequest, Message: "invalid 'Content-Type', expected either 'image' or 'multipart'"}
		return
	}

}

func (handler *Handler) serveHTTP(rw http.ResponseWriter, req *http.Request) error {
	if req.Method != http.MethodPost && req.Method != http.MethodHead && req.Method != http.MethodDelete {
		return imageserver_http.NewErrorDefaultText(http.StatusMethodNotAllowed)
	}
	params := imageserver.Params{}
	err := handler.Parser.Parse(req, params)
	if err != nil {
		return err
	}

	if req.Method == http.MethodDelete {
		msg, err := handler.Server.Delete(params)
		if err != nil {
			if os.IsNotExist(err) {
				return &errors.MSError{Status: http.StatusNotFound, Message: "image has not been found"}
			}
			return err
		}
		_ = json.NewEncoder(rw).Encode(msg)
		return nil
	}

	buff, format, err := getImageBufferFromRequest(rw, req)

	if err != nil {
		return err
	}

	if format != "" {
		im := &imageserver.Image{Format: format, Data: buff}
		msg, err := handler.Server.Upload(im, params)
		if err != nil {
			return err
		}
		logger.GetLogger().Infof("Image %s has been uploaded", params["source"])
		_ = json.NewEncoder(rw).Encode(msg)
		return nil

	} else {
		return &imageserver_http.Error{Code: 400, Text: "image format must be specified either by 'Content-Type' header or 'format' query param"}
	}
}

func (handler *Handler) sendError(w http.ResponseWriter, req *http.Request, err error) {
	mserror := handler.convertToMSError(err, req)
	logger.GetLogger().Error(mserror.Error())
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Header().Set("X-Content-Type-Options", "nosniff")
	w.WriteHeader(mserror.Status)
	_ =  json.NewEncoder(w).Encode(mserror)
}

func (handler *Handler) convertToMSError(err error, req *http.Request) *errors.MSError {
	switch err := err.(type) {
	case *errors.MSError:
		return err
	case *imageserver_http.Error:
		return &errors.MSError{Status: err.Code, Message: err.Text}
	case *imageserver.ParamError:
		httpParam := handler.Parser.Resolve(err.Param)
		if httpParam == "" {
			httpParam = err.Param
		}
		text := fmt.Sprintf("invalid param \"%s\": %s", httpParam, err.Message)
		return &errors.MSError{Status: http.StatusBadRequest, Message: text}
	case *imageserver.ImageError:
		text := fmt.Sprintf("image error: %s", err.Message)
		return &errors.MSError{Status: http.StatusBadRequest, Message: text}
	default:
		if handler.ErrorFunc != nil {
			handler.ErrorFunc(err, req)
		}
		return &errors.MSError{Status: http.StatusInternalServerError, Message: err.Error()}
	}
}
