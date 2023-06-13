data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

// ROLES
resource "aws_iam_role" "get-all-authors-lambda-role" {
  name               = "get-all-authors-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_role" "get-all-courses-lambda-role" {
  name               = "get-all-courses-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_role" "delete_course" {
  name               = "delete_course"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_role" "get-course" {
  name               = "get-course"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_role" "save-course" {
  name               = "save-course"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_role" "update_course" {
  name               = "update_course"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
// POLICIES
data "aws_iam_policy_document" "get_all" {
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:Scan"]
    resources = [aws_dynamodb_table.tf_authors_table.arn]
  }
}
data "aws_iam_policy_document" "save" { //save/update
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:PutItem"]
    resources = [aws_dynamodb_table.tf_course_table.arn]
  }
}
data "aws_iam_policy_document" "get_one" { //save/update
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:GetItem"]
    resources = [aws_dynamodb_table.tf_course_table.arn]
  }
}
data "aws_iam_policy_document" "delete" { //delete
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:DeleteItem"]
    resources = [aws_dynamodb_table.tf_course_table.arn]
  }
}
data "aws_iam_policy_document" "get_all_c" { //delete
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:Scan"]
    resources = [aws_dynamodb_table.tf_course_table.arn]
  }
}

// POLICY
resource "aws_iam_policy" "get_all_policy" {
  name        = "get_all_policy"
  description = "A get_all_policy"
  policy      = data.aws_iam_policy_document.get_all.json
}
resource "aws_iam_policy" "save_policy" {
  name        = "save_policy"
  description = "A save_policy"
  policy      = data.aws_iam_policy_document.save.json
}
resource "aws_iam_policy" "get_one_policy" {
  name        = "get_one_policy"
  description = "A get_one_policy"
  policy      = data.aws_iam_policy_document.get_one.json
}
resource "aws_iam_policy" "delete_policy" {
  name        = "delete_policy"
  description = "A delete_policy"
  policy      = data.aws_iam_policy_document.delete.json
}
resource "aws_iam_policy" "get_all_c_policy" {
  name        = "get_all_c_policy"
  description = "A get_all_c_policy"
  policy      = data.aws_iam_policy_document.get_all_c.json
}
// ATTACH

resource "aws_iam_role_policy_attachment" "attach_1" {
  role       = aws_iam_role.get-all-authors-lambda-role.name
  policy_arn = aws_iam_policy.get_all_policy.arn
}
resource "aws_iam_role_policy_attachment" "attach_2" {
  role       = aws_iam_role.get-all-courses-lambda-role.name
  policy_arn = aws_iam_policy.get_all_c_policy.arn
}
resource "aws_iam_role_policy_attachment" "attach_3" {
  role       = aws_iam_role.delete_course.name
  policy_arn = aws_iam_policy.delete_policy.arn
}
resource "aws_iam_role_policy_attachment" "attach_4" {
  role       = aws_iam_role.get-course.name
  policy_arn = aws_iam_policy.get_one_policy.arn
}
resource "aws_iam_role_policy_attachment" "attach_5" {
  role       = aws_iam_role.save-course.name
  policy_arn = aws_iam_policy.save_policy.arn
}
resource "aws_iam_role_policy_attachment" "attach_6" {
  role       = aws_iam_role.update_course.name
  policy_arn = aws_iam_policy.save_policy.arn
}
// LAMBDA
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/functions/get_all_authors.js"
  output_path = "${path.module}/lambda_function_payload.zip"
}
data "archive_file" "lambda1" {
  type        = "zip"
  source_file = "${path.module}/functions/get_all_courses.js"
  output_path = "${path.module}/lambda_function_payload1.zip"
}
data "archive_file" "lambda2" {
  type        = "zip"
  source_file = "${path.module}/functions/delete_course.js"
  output_path = "${path.module}/lambda_function_payload2.zip"
}
data "archive_file" "lambda3" {
  type        = "zip"
  source_file = "${path.module}/functions/get_course.js"
  output_path = "${path.module}/lambda_function_payload3.zip"
}
data "archive_file" "lambda4" {
  type        = "zip"
  source_file = "${path.module}/functions/save_course.js"
  output_path = "${path.module}/lambda_function_payload4.zip"
}
data "archive_file" "lambda5" {
  type        = "zip"
  source_file = "${path.module}/functions/update_course.js"
  output_path = "${path.module}/lambda_function_payload5.zip"
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
resource "aws_lambda_function" "get-all-courses" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = data.archive_file.lambda1.output_path
  function_name = "lambda_function_name1"
  role          = aws_iam_role.get-all-courses-lambda-role.arn
  handler       = "get_all_courses.handler"

  source_code_hash = data.archive_file.lambda1.output_base64sha256

  runtime = "nodejs16.x"
}
resource "aws_lambda_function" "delete_course" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = data.archive_file.lambda2.output_path
  function_name = "lambda_function_name2"
  role          = aws_iam_role.delete_course.arn
  handler       = "delete_course.handler"

  source_code_hash = data.archive_file.lambda2.output_base64sha256

  runtime = "nodejs16.x"
}
resource "aws_lambda_function" "get_course" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = data.archive_file.lambda3.output_path
  function_name = "lambda_function_name3"
  role          = aws_iam_role.get-course.arn
  handler       = "get_course.handler"

  source_code_hash = data.archive_file.lambda3.output_base64sha256

  runtime = "nodejs16.x"
}
resource "aws_lambda_function" "save_course" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = data.archive_file.lambda4.output_path
  function_name = "lambda_function_name4"
  role          = aws_iam_role.save-course.arn
  handler       = "save_course.handler"

  source_code_hash = data.archive_file.lambda4.output_base64sha256

  runtime = "nodejs16.x"
}
resource "aws_lambda_function" "update_course" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = data.archive_file.lambda5.output_path
  function_name = "lambda_function_name5"
  role          = aws_iam_role.update_course.arn
  handler       = "update_course.handler"

  source_code_hash = data.archive_file.lambda5.output_base64sha256

  runtime = "nodejs16.x"
}