#-_- Creating lamda function for staring and stoping ec2 instance -_-#
resource "aws_lambda_function" "ec2" {
  filename         = data.archive_file.lamda_func.output_path
  function_name    = "ec2_lambda_function"
  role             = aws_iam_role.ec2-lambda-function-role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lamda_func.output_base64sha256
  runtime          = "python3.9"
  timeout          = 20
  # environment {
  #   variables = {
  #     "" = ""
  #   }
  # }
}

#-_- IAM role for lamda func -_-#
resource "aws_iam_role" "ec2-lambda-function-role" {
  name               = "ec2_lambda_function"
  assume_role_policy = <<EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "sts:AssumeRole"
              ],
              "Principal": {
                  "Service": [
                      "lambda.amazonaws.com"
                  ]
              }
          }
      ]
  }
  EOF
}

#-_- IAM policy for lamda function -_-#
resource "aws_iam_policy" "ec2_lambda_function_policy" {
  name        = "ec2_lambda_function_policy"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid"   : "LogPermissions",
        "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
       ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
        "Sid"   : "WorkPermissions",
        "Effect": "Allow",
        "Action": [
            "ec2:DescribeInstances",
            "ec2:StopInstances",
            "ec2:StartInstances"
        ],
        "Resource": "*"
    }
  ]
}
EOF
}

#-_- Attache a Managed IAM Policy to an ec2-lambda-function-role -_-#
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.ec2-lambda-function-role.name
  policy_arn = aws_iam_policy.ec2_lambda_function_policy.arn
}

#-_- Creatin Clod Watch log group for lamda -_-#
resource "aws_cloudwatch_log_group" "ec2_lambda_function" {
  for_each          = var.cron
  name              = "/aws/lambda/lamda-func-${each.key}"
  retention_in_days = 3
}

#-_- Creating event rule for lamda -_-#
resource "aws_cloudwatch_event_rule" "lamda-func" {
  for_each            = var.cron
  name                = "lamda-func-${each.key}"
  schedule_expression = each.value
  event_pattern       = <<EOF
  {
    "action": [
      "${each.key}"
    ]
  }
  EOF
}

resource "aws_cloudwatch_event_target" "ec2-lamda-run" {
  for_each  = var.cron
  target_id = "lamda-run"
  rule      = aws_cloudwatch_event_rule.lamda-func[each.key].name
  arn       = aws_lambda_function.ec2.arn
  input_transformer {
    input_template = <<EOF
    {
      "action" : "${each.key}"
    }
    EOF
  }
}
#-_- Allow cloudwatch permissions to access the Lambda function -_-#
resource "aws_lambda_permission" "allow_cloudwatch" {
  for_each      = aws_cloudwatch_event_rule.lamda-func
  statement_id  = title("Allow${title(each.key)}FromCloudWatch")
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = each.value.arn

}
