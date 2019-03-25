variable "fastly_api_key" {
  type = "string"
}

variable "domain" {
  type = "string"
}

provider "fastly" {
  api_key = "${var.fastly_api_key}"
}

resource "fastly_service_v1" "kdw" {
  name = "${var.domain}"

  domain {
    name = "${var.domain}"
  }

  domain {
    name = "www.${var.domain}"
  }

  request_setting {
    name      = "${var.domain}"
    force_ssl = true
  }

  response_object {
    name              = "redirect www"
    status            = 301
    response          = "Moved Permanently"
    request_condition = "Host is www"
  }

  condition {
    name      = "Host is www"
    statement = "req.http.host == \"www.kdw.us\""
    type      = "REQUEST"
  }

  header {
    name               = "Location for www redirect"
    action             = "set"
    type               = "response"
    destination        = "http.Location"
    source             = "\"https://kdw.us/\""
    response_condition = "Set location for www redirect"
  }

  condition {
    name      = "Set location for www redirect"
    statement = "req.http.host == \"www.kdw.us\" && resp.status == 301"
    type      = "RESPONSE"
  }

  vcl {
    name    = "main"
    main    = "true"
    content = "${file("synth.vcl")}"
  }
}
