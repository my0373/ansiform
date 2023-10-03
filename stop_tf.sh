#!/bin/bash
/usr/bin/terraform plan --destroy 
/usr/bin/terraform apply --destroy --auto-approve
