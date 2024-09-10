resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

locals {
  config_file = {
    path = "${path.module}/package/config.json"

    contents = jsonencode({
      AUTH_REQUEST = {
        client_id     = var.client_id
        redirect_uri  = var.redirect_uri
        response_type = "code"
        response_mode = "query"
        scope         = "openid email profile"
      }

      TOKEN_REQUEST = {
        client_id     = var.client_id
        grant_type    = "authorization_code"
        redirect_uri  = var.redirect_uri
        client_secret = var.client_secret
      }

      DISTRIBUTION                     = "lambda-edge-azure-auth"
      PRIVATE_KEY                      = tls_private_key.key_pair.private_key_pem
      PUBLIC_KEY                       = tls_private_key.key_pair.public_key_pem
      TENANT                           = var.tenant
      DISCOVERY_DOCUMENT               = "https://login.microsoftonline.com/${var.tenant}/v2.0/.well-known/openid-configuration"
      SESSION_DURATION                 = var.session_duration * 60 * 60
      CALLBACK_PATH                    = regex("https?://.*(/.*$)", var.redirect_uri)[0]
      TRAILING_SLASH_REDIRECTS_ENABLED = var.trailing_slash_redirects_enabled
      SIMPLE_URLS_ENABLED              = var.simple_urls_enabled
    })
  }
}

data "external" "create_config" {
  program = ["sh", "-c", "printf '%s' '${local.config_file.contents}' > ${local.config_file.path} | sh >&2; echo {}"]
}

resource "local_sensitive_file" "config" {
  filename   = local.config_file.path
  content    = local.config_file.contents
  depends_on = [data.external.create_config]
}

module "lambda" {
  source = "github.com/terraform-aws-modules/terraform-aws-lambda?ref=1d122404c2a3834ce39a7c5a319a3e754d5b0c29" # v7.8.1

  function_name = var.function_name
  description   = "CloudFront OpenID Connect powered by Lambda@Edge"

  handler = "index.handler"
  runtime = "nodejs20.x"

  lambda_at_edge = true

  cloudwatch_logs_retention_in_days = 30
  recreate_missing_package          = false

  source_path = {
    path     = "${path.module}/package"
    patterns = ["!.gitignore"]
  }

  skip_destroy = var.skip_destroy

  depends_on = [local_sensitive_file.config]
}
