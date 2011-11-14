#!/bin/bash

# Import Settings
. settings

nova boot --flavor 1 --image 2 "Test Server"
