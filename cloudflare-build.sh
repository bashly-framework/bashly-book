#!/usr/bin/env bash
set -euo pipefail

npm install retypeapp --global
retype build
cp _redirects docs/