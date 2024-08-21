module "lambda" {
  source = "github.com/terraform-aws-modules/terraform-aws-lambda?ref=f48be17ec03a53b85b7da1f2ad8787792f2425ee" # v7.7.1

  function_name = var.function_name
  description   = "CloudFront OpenID Connect powered by Lambda@Edge"

  handler = "index.handler"
  runtime = "nodejs20.x"

  lambda_at_edge = true

  source_path = {
    //
  }
}
