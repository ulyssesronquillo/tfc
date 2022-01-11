#!/bin/bash
aws lightsail get-instances --query 'instances[*].[name]' --output text
