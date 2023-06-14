//method
resource "aws_api_gateway_method" "get" {
  rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
  resource_id   = aws_api_gateway_resource.coursesid.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}
//reponse not proxy
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
// integration not proxy with mapping to id
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
// permissions
resource "aws_lambda_permission" "apigw5" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.get_course.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}