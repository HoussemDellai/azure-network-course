resource "azurerm_cdn_frontdoor_rule" "rule-region2" {
  name                      = "ruleregion2${var.location2}"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.ruleset-regions.id
  order                     = 2
  behavior_on_match         = "Continue"

  actions {
    url_redirect_action {
      redirect_type        = "Moved"
      redirect_protocol    = "Https"
      query_string         = ""
      destination_path     = ""
      destination_hostname = azurerm_linux_web_app.region2.default_hostname
      destination_fragment = ""
    }
  }

  conditions {

    remote_address_condition {
      operator         = "GeoMatch"
      match_values     = ["NL"]
      negate_condition = false
    }
  }

  depends_on = [
    azurerm_cdn_frontdoor_origin_group.origin-group,
    azurerm_cdn_frontdoor_origin.origin-region2
  ]
}