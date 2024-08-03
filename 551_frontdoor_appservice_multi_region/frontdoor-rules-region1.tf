resource "azurerm_cdn_frontdoor_rule_set" "ruleset-regions" {
  name                     = "rulesetmultiregions"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor.id
}

resource "azurerm_cdn_frontdoor_rule" "rule-region1" {
  name                      = "ruleregion1${var.location1}"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.ruleset-regions.id
  order                     = 1
  behavior_on_match         = "Continue"

  actions {
    url_redirect_action {
      redirect_type        = "Moved"
      redirect_protocol    = "Https"
      query_string         = ""
      destination_path     = ""
      destination_hostname = azurerm_linux_web_app.region1.default_hostname
      destination_fragment = ""
    }
  }

  conditions {

    remote_address_condition {
      operator         = "GeoMatch"
      match_values     = ["SE"]
      negate_condition = false
    }
  }

  depends_on = [
    azurerm_cdn_frontdoor_origin_group.origin-group,
    azurerm_cdn_frontdoor_origin.origin-region1
  ]
}