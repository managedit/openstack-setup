#!/bin/bash

# Import Settings
. settings
glance -A $SERVICE_TOKEN show 2
(glance -A $SERVICE_TOKEN index && echo "Success" ) || echo "Failed"
