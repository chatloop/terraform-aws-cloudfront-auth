# AWS CloudFront Auth Terraform module

This module provisions a Lambda@Edge function that can be associated to a
CloudFront distribution to provide OpenID Connect authentication at edge functionality.

Currently, the only supported provider is Microsoft AzureAD.

## Usage

<!-- markdownlint-disable -->
```hcl
module "cloudfront_authorizer" {
  source = "github.com/chatloop/terraform-aws-cloudfront-auth?ref=v0.1.0"

  providers = {
    aws = aws.us-east-1 # Ensure you're deploying this module into us-east-1
  }

  function_name = "lambda-edge-azure-auth" # This must be unique
  tenant        = "2765a7ba-9519-4636-9669-35f6558266fe" # Azure Tenant ID
  client_id     = "2d30fa5c-bdbc-4adc-a3fb-86566348159c" # Azure App Client ID
  client_secret = var.client_secret # Azure App Client Secret - keep this secret
  redirect_uri  = "https://${var.domain_name}/_callback" # CloudFront domain name with /_callback suffix

  # The duration in hours before re-authenticating
  session_duration = 24 # optional: default = 168 (7 days)

  # Enables 301 redirects for directory paths not ending in a forward slash. e.g. www.example.com/about -> www.example.com/about/
  trailing_slash_redirects_enabled = true # optional: default = false

  # Appends index.html on to directory paths (e.g. www.example.com/about/ retrieves www.example.com/about/index.html from a backend s3 origin.)
  simple_urls_enabled = true # optional: default = true

  # Set to true if you do not wish the function to be deleted at destroy time, and instead just remove the function from the Terraform state.
  skip_destroy = true # optional: default = false
}
```
<!-- markdownlint-restore -->

<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.4 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.5 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | github.com/terraform-aws-modules/terraform-aws-lambda | 1d122404c2a3834ce39a7c5a319a3e754d5b0c29 |

## Resources

| Name | Type |
|------|------|
| [local_sensitive_file.config](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [tls_private_key.key_pair](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [external_external.create_config](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | Microsoft Azure AD Application ID | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | Microsoft Azure AD Client Secret | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name for the lambda function | `string` | `"lambda-edge-azure-auth"` | no |
| <a name="input_redirect_uri"></a> [redirect\_uri](#input\_redirect\_uri) | Registered Microsoft Azure AD Application Redirect URI | `string` | n/a | yes |
| <a name="input_session_duration"></a> [session\_duration](#input\_session\_duration) | Authenticated session duration, in hours | `number` | `168` | no |
| <a name="input_simple_urls_enabled"></a> [simple\_urls\_enabled](#input\_simple\_urls\_enabled) | Appends index.html on to directory paths (e.g. www.example.com/about/ retrieves www.example.com/about/index.html from a backend s3 origin.) | `bool` | `true` | no |
| <a name="input_skip_destroy"></a> [skip\_destroy](#input\_skip\_destroy) | Set to true if you do not wish the function to be deleted at destroy time, and instead just remove the function from the Terraform state. | `bool` | `false` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Microsoft Azure AD Tenant ID | `string` | n/a | yes |
| <a name="input_trailing_slash_redirects_enabled"></a> [trailing\_slash\_redirects\_enabled](#input\_trailing\_slash\_redirects\_enabled) | Enables 301 redirects for directory paths not ending in a forward slash. e.g. www.example.com/about -> www.example.com/about/ | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_qualified_arn"></a> [lambda\_qualified\_arn](#output\_lambda\_qualified\_arn) | n/a |
<!-- END_TF_DOCS -->
<!-- markdownlint-restore -->
