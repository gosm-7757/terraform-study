provider "aws" {
    region = "ap-northeast-2"
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

# 전체 정보를 한번에 가져오고 싶을 때
output "test" {
  value = data.aws_caller_identity.current
}