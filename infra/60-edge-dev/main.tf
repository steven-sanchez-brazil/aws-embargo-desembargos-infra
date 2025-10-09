# API Gateway
resource "aws_api_gateway_vpc_link" "this" {
  name        = "${var.project}-${var.environment}-vpc-link"
  target_arns = [data.terraform_remote_state.eks.outputs.nlb_arn]

  tags = {
    Environment  = var.environment
    Environment2 = var.environment
    Terraform    = "true"
  }
}

resource "aws_api_gateway_rest_api" "this" {
  name = "${var.project}-${var.environment}-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

# Example API Gateway resource and method
resource "aws_api_gateway_resource" "example" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "example"
}

resource "aws_api_gateway_method" "example" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.example.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "example" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.example.id
  http_method = aws_api_gateway_method.example.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.this.id
  uri                     = "http://internal-nlb-url:8080/{proxy}"
}
