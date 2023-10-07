provider "aws" {
    region = "ap-northeast-2"
}

# 역할 생성
resource "aws_iam_role" "this" {
    # name = "test_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },
        ]
    })
    inline_policy { # 인라인 정책 연결 (삭제되는게 아닌 그대로 업데이트됨)
      name = "my_inline_policy"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = ["ec2:Describe*"]
                Effect = "Allow"
                Resource = "*"
            },
        ]
      })
    }
    # aws 관리 정책 연결
    managed_policy_arns = [aws_iam_policy.policy.arn, "arn:aws:iam::aws:policy/ReadOnlyAccess"]
}

# 정책 만들기 (만들어 졌으니까 저 위로 추가)
resource "aws_iam_policy" "policy" {
    name        = "test_policy"
    path          = "/"
    description =  "My test policy"
    # policy = jsonencode({
    #     Version = "2012-10-17"
    #     Statement = [
    #         {
    #             Action = ["ec2:Describe*"]
    #             Effect = "Allow"
    #             Resource = "*"
    #         }
    #     ]
    # })
    policy = data.aws_iam_policy_document.this.json # 정책 내용 변경
}

# 오타를 검출하기 쉬움 (이곳에서만 만든것 뿐이다.)
# 위에 올려줘야 적용이 가능하다. 
data "aws_iam_policy_document" "this" {
    statement {
      sid = "1"
      effect = "Allow"
    #   principals {
    #     type = "Service"
    #     identifiers = ["ec2.amazonaws.com"]
    #   }
      actions = ["sts:AssumeRole"]
      resources = ["arn:aws:s3:::*"]
    }
}

