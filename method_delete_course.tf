//method with path id
resource "aws_api_gateway_method" "delete" {
  rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
  resource_id   = "${aws_api_gateway_resource.coursesid.id}"
  http_method   = "DELETE"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}
// reponse
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
// integration with id in a path and custom mapping
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
// permissions
resource "aws_lambda_permission" "apigw4" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.delete_course.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}