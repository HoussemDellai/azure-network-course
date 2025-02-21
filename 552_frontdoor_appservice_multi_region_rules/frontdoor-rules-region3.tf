resource "azurerm_cdn_frontdoor_rule" "rule-region3" {
  name                      = "ruleregion3${var.location3}"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.ruleset-regions.id
  order                     = 3
  behavior_on_match         = "Continue"

  actions {
    url_redirect_action {
      redirect_type        = "PermanentRedirect" # "Moved"
      redirect_protocol    = "Https"
      query_string         = ""
      destination_path     = ""
      destination_hostname = azurerm_linux_web_app.region3.default_hostname
      destination_fragment = ""
    }
    # route_configuration_override_action {
    #   cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin-group.id
    #   forwarding_protocol           = "HttpsOnly"
    #   query_string_caching_behavior = "IncludeSpecifiedQueryStrings"
    #   query_string_parameters       = ["foo", "clientIp={client_ip}"]
    #   compression_enabled           = true
    #   cache_behavior                = "OverrideIfOriginMissing"
    #   cache_duration                = "365.23:59:59"
    # }

    # url_redirect_action {
    #   redirect_type        = "PermanentRedirect"
    #   redirect_protocol    = "MatchRequest"
    #   query_string         = "clientIp={client_ip}"
    #   destination_path     = "/exampleredirection"
    #   destination_hostname = "contoso.com"
    #   destination_fragment = "UrlRedirect"
    # }
  }

  conditions {

    remote_address_condition {
      operator         = "GeoMatch"
      match_values     = ["FR"]
      negate_condition = false
    }

    # host_name_condition {
    #   operator         = "Equal"
    #   negate_condition = false
    #   match_values     = ["www.contoso.com", "images.contoso.com", "video.contoso.com"]
    #   transforms       = ["Lowercase", "Trim"]
    # }

    # is_device_condition {
    #   operator         = "Equal"
    #   negate_condition = false
    #   match_values     = ["Mobile"]
    # }

    # post_args_condition {
    #   post_args_name = "customerName"
    #   operator       = "BeginsWith"
    #   match_values   = ["J", "K"]
    #   transforms     = ["Uppercase"]
    # }

    # request_method_condition {
    #   operator         = "Equal"
    #   negate_condition = false
    #   match_values     = ["DELETE"]
    # }

    # url_filename_condition {
    #   operator         = "Equal"
    #   negate_condition = false
    #   match_values     = ["media.mp4"]
    #   transforms       = ["Lowercase", "RemoveNulls", "Trim"]
    # }
  }

  depends_on = [
    azurerm_cdn_frontdoor_origin_group.origin-group,
    azurerm_cdn_frontdoor_origin.origin-region3
  ]
}
