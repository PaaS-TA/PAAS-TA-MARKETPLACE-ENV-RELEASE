#!/bin/bash

bosh -e micro-bosh -d paasta-marketplace-env deploy paasta-marketplace-env.yml \
    -v default_network_name=default \
    -v stemcell_os=ubuntu-xenial \
    -v vm_type_small=small \
    -v vm_type_medium=medium \
    -v db_port=3306 \
    -v db_admin_password="admin"
