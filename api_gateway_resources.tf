resource "aws_api_gateway_rest_api" "example" {
  name        = "ServerlessExample"
  description = "Terraform Serverless Application Example"
}

// resources
resource "aws_api_gateway_resource" "authors" {
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

// deployment test
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

// cors custom model on resources to create preflight option request to front
module "cors" {
  source = "squidfunk/api-gateway-enable-cors/aws"
  version = "0.3.3"

  api_id          = "${aws_api_gateway_rest_api.example.id}"
  api_resource_id = "${aws_api_gateway_resource.authors.id}"
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
