//method with model
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
// response
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
// integration no proxy, custom model
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
// permissions
resource "aws_lambda_permission" "apigw2" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.save_course.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
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