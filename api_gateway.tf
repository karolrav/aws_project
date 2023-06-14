resource "aws_api_gateway_rest_api" "example" {
  name        = "ServerlessExample"
  description = "Terraform Serverless Application Example"
}
// resources
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  parent_id   = "${aws_api_gateway_rest_api.example.root_resource_id}"
  path_part   = "authors"
}
resource "aws_api_gateway_resource" "courses" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  parent_id   = "${aws_api_gateway_rest_api.example.root_resource_id}"
  path_part   = "courses"
}
resource "aws_api_gateway_resource" "coursesid" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  parent_id   = aws_api_gateway_resource.courses.id
  path_part   = "{id}"
}
//methods
resource "aws_api_gateway_method" "get_all" {
  rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_method" "save" {
  rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
  resource_id   = "${aws_api_gateway_resource.courses.id}"
  http_method   = "POST"
  authorization = "NONE"
  request_validator_id = aws_api_gateway_request_validator.the.id

  request_models = {
    "application/json" = aws_api_gateway_model.the.name
  }

}
resource "aws_api_gateway_method" "update" {
  rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
  resource_id   = "${aws_api_gateway_resource.coursesid.id}"
  http_method   = "PUT"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}
resource "aws_api_gateway_method" "delete" {
  rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
  resource_id   = "${aws_api_gateway_resource.coursesid.id}"
  http_method   = "DELETE"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}
resource "aws_api_gateway_method" "get" {
  rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
  resource_id   = aws_api_gateway_resource.coursesid.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}
resource "aws_api_gateway_method" "get_c" {
  rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
  resource_id   = "${aws_api_gateway_resource.courses.id}"
  http_method   = "GET"
  authorization = "NONE"
}
//response
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.get_all.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}
resource "aws_api_gateway_method_response" "response_200_save" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.save.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}
resource "aws_api_gateway_method_response" "response_200_update" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.coursesid.id
  http_method = aws_api_gateway_method.update.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
     response_models = {
    "application/json" = "Empty"
   }
}
resource "aws_api_gateway_method_response" "response_200_delete" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.coursesid.id
  http_method = aws_api_gateway_method.delete.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
       response_models = {
    "application/json" = "Empty"
   }
}
resource "aws_api_gateway_method_response" "response_200_get" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.coursesid.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
   response_models = {
    "application/json" = "Empty"
   }
}
resource "aws_api_gateway_method_response" "response_200_get_c" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.get_c.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}
// integration

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = "${aws_api_gateway_method.get_all.resource_id}"
  http_method = "${aws_api_gateway_method.get_all.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.get-all-authors.invoke_arn}"
}

resource "aws_api_gateway_integration" "lambda1" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = "${aws_api_gateway_method.save.resource_id}"
  http_method = "${aws_api_gateway_method.save.http_method}"

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "${aws_lambda_function.save_course.invoke_arn}"
}

resource "aws_api_gateway_integration_response" "IntegrationResponse_save" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = aws_api_gateway_resource.courses.id
  http_method = "${aws_api_gateway_method.save.http_method}"
  status_code = aws_api_gateway_method_response.response_200_save.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST,GET'"
  }
  depends_on = [ aws_api_gateway_integration.lambda1 ]
}


resource "aws_api_gateway_integration" "lambda2" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id =  aws_api_gateway_resource.coursesid.id
  http_method = "${aws_api_gateway_method.update.http_method}"

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "${aws_lambda_function.update_course.invoke_arn}"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = <<EOF
{
  "id": "$input.params('id')",
  "title" : $input.json('$.title'),
  "authorId" : $input.json('$.authorId'),
  "length" : $input.json('$.length'),
  "category" : $input.json('$.category'),
  "watchHref" : $input.json('$.watchHref')
}
EOF
  }
}

resource "aws_api_gateway_integration_response" "IntegrationResponse_update" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = aws_api_gateway_resource.coursesid.id
  http_method = "${aws_api_gateway_method.update.http_method}"
  status_code = aws_api_gateway_method_response.response_200_update.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST,PUT'"
  }
  depends_on = [ aws_api_gateway_integration.lambda2 ]
}

resource "aws_api_gateway_integration" "lambda3" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = aws_api_gateway_resource.coursesid.id
  http_method = "${aws_api_gateway_method.delete.http_method}"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "${aws_lambda_function.delete_course.invoke_arn}"

  request_templates = {
    "application/json" = <<EOF
{
  "id": "$input.params('id')"
}
EOF
  }
}

resource "aws_api_gateway_integration_response" "IntegrationResponse_delete" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = aws_api_gateway_resource.coursesid.id
  http_method = "${aws_api_gateway_method.delete.http_method}"
  status_code = aws_api_gateway_method_response.response_200_delete.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST,DELETE'"
  }
  depends_on = [ aws_api_gateway_integration.lambda3 ]
}

resource "aws_api_gateway_integration" "lambda4" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = aws_api_gateway_resource.coursesid.id
  http_method = "${aws_api_gateway_method.get.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "${aws_lambda_function.get_course.invoke_arn}"
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
    request_templates = {
    "application/json" = <<EOF
{
  "id": "$input.params('id')"
}
EOF
  }
}

resource "aws_api_gateway_integration_response" "IntegrationResponse_get" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = aws_api_gateway_resource.coursesid.id
  http_method = "${aws_api_gateway_method.get.http_method}"
  status_code = aws_api_gateway_method_response.response_200_get.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST,GET'"
  }
  depends_on = [ aws_api_gateway_integration.lambda4 ]
}

resource "aws_api_gateway_integration" "lambda5" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = "${aws_api_gateway_method.get_c.resource_id}"
  http_method = "${aws_api_gateway_method.get_c.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.get-all-courses.invoke_arn}"
}
// deployment

resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda1,
    aws_api_gateway_integration.lambda2,
    aws_api_gateway_integration.lambda3,
    aws_api_gateway_integration.lambda4,
    aws_api_gateway_integration.lambda5
  ]

  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  stage_name  = "test"
  triggers = { redeployment = sha1(jsonencode(aws_api_gateway_rest_api.example)) } 
  lifecycle { create_before_destroy = true } 
}
// permissions
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.get-all-authors.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
  #source_arn = "arn:aws:execute-api:${var.aws_region}:${var.accountId}:${aws_api_gateway_rest_api.example.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}
resource "aws_lambda_permission" "apigw2" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.save_course.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
  #source_arn = "arn:aws:execute-api:${var.aws_region}:${var.accountId}:${aws_api_gateway_rest_api.example.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}
resource "aws_lambda_permission" "apigw3" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.update_course.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
  #source_arn = "arn:aws:execute-api:${var.aws_region}:${var.accountId}:${aws_api_gateway_rest_api.example.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}
resource "aws_lambda_permission" "apigw4" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.delete_course.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
  #source_arn = "arn:aws:execute-api:${var.aws_region}:${var.accountId}:${aws_api_gateway_rest_api.example.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}
resource "aws_lambda_permission" "apigw5" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.get_course.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
  #source_arn = "arn:aws:execute-api:${var.aws_region}:${var.accountId}:${aws_api_gateway_rest_api.example.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}
resource "aws_lambda_permission" "apigw6" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.get-all-courses.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
  #source_arn = "arn:aws:execute-api:${var.aws_region}:${var.accountId}:${aws_api_gateway_rest_api.example.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}
// cors
module "cors" {
  source = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = "${aws_api_gateway_rest_api.example.id}"
  api_resource_id = "${aws_api_gateway_resource.proxy.id}"
}
module "cors2" {
  source = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = "${aws_api_gateway_rest_api.example.id}"
  api_resource_id = "${aws_api_gateway_resource.courses.id}"
}
module "cors3" {
  source = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = "${aws_api_gateway_rest_api.example.id}"
  api_resource_id = "${aws_api_gateway_resource.coursesid.id}"
}
// model

resource "aws_api_gateway_model" "the" {
  rest_api_id  = aws_api_gateway_rest_api.example.id
  name         = "POSTExampleRequestModelExample"
  description  = "A JSON schema"
  content_type = "application/json"
  schema       = file("${path.module}/requests_schemas/post_example.json")
}

resource "aws_api_gateway_request_validator" "the" {
  name                        = "POSTExampleRequestValidator"
  rest_api_id                 = aws_api_gateway_rest_api.example.id
  validate_request_body       = true
  validate_request_parameters = false
}