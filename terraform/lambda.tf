provider "aws" {
    region = "us-east-1"
}

resource "aws_lambda_function" "example" {
    function_name = "ServerlessExample"

    s3_bucket = "derrickcywoo-serverless"
    s3_key = "v1.0.0/example.zip"

    handler = "main.handler"
    runtime = "nodejs10.x"

    role = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
    name = "serverless_example_lambda"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
    EOF
}

resource "aws_lambda_permission" "apigw" {
    statement_id = "AllowAPIGatewayInvoke"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.example.function_name
    principal = "apigateway.amazonaws.com"

    source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}