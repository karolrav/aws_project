//method
resource "aws_api_gateway_method" "get_c" {
  rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
  resource_id   = "${aws_api_gateway_resource.courses.id}"
  http_method   = "GET"
  authorization = "NONE"
}
//response
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
// integration Proxy one
resource "aws_api_gateway_integration" "lambda5" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = "${aws_api_gateway_method.get_c.resource_id}"
  http_method = "${aws_api_gateway_method.get_c.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.get-all-courses.invoke_arn}"
}
//permissions
resource "aws_lambda_permission" "apigw6" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.get-all-courses.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}