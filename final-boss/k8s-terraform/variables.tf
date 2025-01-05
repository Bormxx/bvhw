variable "token" {
  description = "Какое-то описание токена."
  type        = string
  default     = "" # <-- Вставить значение IAM-токена, которое мы получили с помощью команды "yc iam create-token"
}

variable "cloud_id" {
  description = "Какое-то описание облака."
  type        = string
  default     = "" # <-- Вставить значение cloud_id, которое мы получили с помощью команды "yc config list"
}

variable "folder_id" {
  description = "Какое-то описание каталога."
  type        = string
  default     = "" # <-- Вставить значение cloud_id, которое мы получили с помощью команды "yc config list"
}

variable "service_account_id" {
  default = "Какое-то описание сервисного аккаунта."
  type    = string
  default = "" # <-- Подставить id созданного аккаунта.
}

variable "node_service_account_id" {
  default = "Какое-то описание сервисного аккаунта."
  type    = string
  default = "" # <-- Подставить id созданного аккаунта.
}

variable "zone" {
  description = "Какое-то описание зоны облачного сервиса."
  type        = string
  default     = "ru-central1-a" # <-- Уже настроено, можно не менять."
}