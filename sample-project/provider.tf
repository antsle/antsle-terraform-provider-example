variable "apikey_auth" {
  default = "Token ey...>"
}

provider "antsle" {
  apikey_auth = var.apikey_auth
}
