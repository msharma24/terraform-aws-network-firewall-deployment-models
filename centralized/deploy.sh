#!/usr/bin/env sh

terraform apply -target=module.spoke_vpc_a -auto-approve && \
terraform apply -target=module.spoke_vpc_b -auto-approve && \
terraform apply  -auto-approve
