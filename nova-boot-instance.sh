#!/bin/bash

# Import Settings
. settings

nova boot --flavor 1 --image 3 "Test Server"
