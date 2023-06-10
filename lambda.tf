data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
    //resources = [ aws_dynamodb_table.tf_authors_table.arn ]
  }
}

resource "aws_iam_role" "get-all-authors-lambda-role" {
  name               = "get-all-authors-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:Scan"]
    resources = [aws_dynamodb_table.tf_authors_table.arn]
  }
}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.get-all-authors-lambda-role.name
  policy_arn = aws_iam_policy.policy.arn
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/functions/get_all_authors.js"
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "get-all-authors" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = data.archive_file.lambda.output_path
  function_name = "lambda_function_name"
  role          = aws_iam_role.get-all-authors-lambda-role.arn
  handler       = "get_all_authors.handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs16.x"
}