#!/bin/bash
# Building RavenOS itself happens in extensions
# This can be modified to add additional customizations

set -xeuo pipefail

RELEASE=$1
LINUXFAMILY=$2
BOARD=$3
BUILD_DESKTOP=$4
