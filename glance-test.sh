#!/bin/bash

# Import Settings
. settings
glance -A $SERVICE_TOKEN index || echo "Failed"
