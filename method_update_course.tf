//method
resource "aws_api_gateway_method" "update" {
  rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
  resource_id   = "${aws_api_gateway_resource.coursesid.id}"
  http_method   = "PUT"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id" = true
  }
}
//response
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
// integration with custom mapping no proxy
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
// permissions
resource "aws_lambda_permission" "apigw3" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.update_course.function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}
