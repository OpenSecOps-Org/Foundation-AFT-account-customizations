data "aws_ssm_parameter" "limit_usd" {
  name = "/aft/account-request/custom-fields/limit_usd"
}

data "aws_ssm_parameter" "notification_email" {
  name = "/aft/account-request/custom-fields/notification_email"
}


resource "aws_budgets_budget" "monthly-account-budget" {
  name              = "monthly-account-budget"
  budget_type       = "COST"
  limit_amount      = data.aws_ssm_parameter.limit_usd.value
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [
        "accounts+budgets@yourcompany.com",
        data.aws_ssm_parameter.notification_email.value
    ]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [
        "accounts+budgets@yourcompany.com",
        data.aws_ssm_parameter.notification_email.value
    ]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [
        "accounts+budgets@yourcompany.com",
        data.aws_ssm_parameter.notification_email.value
    ]
  }
}
