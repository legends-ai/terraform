provider "aws" {
  region  = "us-east-1"
  profile = "asuna"
}

resource "aws_ecr_repository" "alexandria" {
  name = "alexandria"
}

resource "aws_ecr_repository" "charon" {
  name = "charon"
}

resource "aws_ecr_repository" "helios" {
  name = "helios"
}

resource "aws_ecr_repository" "legends-ai" {
  name = "legends-ai"
}

resource "aws_ecr_repository" "lucinda" {
  name = "lucinda"
}

resource "aws_ecr_repository" "luna" {
  name = "luna"
}

resource "aws_ecr_repository" "nova" {
  name = "nova"
}

resource "aws_ecr_repository" "vulgate" {
  name = "vulgate"
}
