resource "aws_bedrock_guardrail" "main" {
  name                      = "${var.project_prefix}-ai-guardrail"
  description               = "ReLoop 2: lọc ảnh / chữ không phù hợp khi AI phân tích ảnh thiết bị"
  blocked_input_messaging   = "Ảnh không phù hợp."
  blocked_outputs_messaging = "Kết quả không phù hợp."
  tags                      = var.common_tags

  cross_region_config {
    guardrail_profile_identifier = "arn:aws:bedrock:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:guardrail-profile/apac.guardrail.v1:0"
  }

  content_policy_config {
    tier_config = [{
      tier_name = "STANDARD"
    }]

    filters_config {
      type              = "VIOLENCE"
      input_strength    = "HIGH"
      output_strength   = "HIGH"
      input_modalities  = ["TEXT", "IMAGE"]
      output_modalities = ["TEXT"]
      input_action      = "BLOCK"
      output_action     = "BLOCK"
    }

    filters_config {
      type            = "PROMPT_ATTACK"
      input_strength  = "HIGH"
      output_strength = "NONE"
      input_action    = "BLOCK"
    }

    filters_config {
      type              = "MISCONDUCT"
      input_strength    = "HIGH"
      output_strength   = "HIGH"
      input_modalities  = ["TEXT"]
      output_modalities = ["TEXT"]
      input_action      = "BLOCK"
      output_action     = "BLOCK"
    }

    filters_config {
      type              = "HATE"
      input_strength    = "HIGH"
      output_strength   = "HIGH"
      input_modalities  = ["TEXT", "IMAGE"]
      output_modalities = ["TEXT"]
      input_action      = "BLOCK"
      output_action     = "BLOCK"
    }

    filters_config {
      type              = "SEXUAL"
      input_strength    = "HIGH"
      output_strength   = "HIGH"
      input_modalities  = ["TEXT", "IMAGE"]
      output_modalities = ["TEXT"]
      input_action      = "BLOCK"
      output_action     = "BLOCK"
    }

    filters_config {
      type              = "INSULTS"
      input_strength    = "HIGH"
      output_strength   = "HIGH"
      input_modalities  = ["TEXT", "IMAGE"]
      output_modalities = ["TEXT"]
      input_action      = "BLOCK"
      output_action     = "BLOCK"
    }
  }
}

resource "aws_bedrock_guardrail_version" "v1" {
  guardrail_arn = aws_bedrock_guardrail.main.guardrail_arn
  description   = "v1 cho ${var.project_prefix}-api (ReLoop 2 workshop)"
}
