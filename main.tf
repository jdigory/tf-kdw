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

  force_destroy = true

  vcl {
    name    = "main"
    main    = "true"
    content = "${file("synth.vcl")}"
  }
}
