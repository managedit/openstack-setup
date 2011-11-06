#!/bin/bash

# Import Settings
. settings

(./obtain-token.sh && echo "Success") || echo "Failure"
