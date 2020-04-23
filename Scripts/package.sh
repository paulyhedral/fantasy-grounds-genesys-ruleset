#!/bin/bash

set -e
set -o pipefail

scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

pushd ${scriptdir}/../Ruleset

zip -9r ${scriptdir}/.. .

popd
