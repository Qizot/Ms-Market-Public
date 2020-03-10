package config

import (
	"ImageServer/repository"
	"github.com/joeshaw/envdecode"
)

type Config struct {
	ImageDir   string `env:"IMAGE_DIR,required"`
	Port       string `env:"PORT,default=8080"`
	EnableAuth bool   `env:"ENABLE_AUTH,default=false"`
	DBUsername string `env:"DB_USER,required"`
	DBPassword string `env:"DB_PASS,required"`
	DBName     string `env:"DB_NAME,required"`
	DBHost     string `env:"DB_HOST,required"`
}

func LoadServerConfig() (Config, error) {
	var cfg Config
	err := envdecode.Decode(&cfg)
	return cfg, err
}

func ServerConfigToDBUri(config Config) repository.DBUri {
	return repository.DBUri{
		DBName:     config.DBName,
		DBPassword: config.DBPassword,
		DBUser:     config.DBUsername,
		DBHost:     config.DBHost,
	}
}
