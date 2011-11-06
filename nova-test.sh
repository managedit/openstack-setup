#!/bin/bash

# Import Settings
. settings

nova image-list

nova flavor-list

(nova list && echo "Sucess") || echo "Failed"
