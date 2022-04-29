#!/usr/bin/env bash
# Copyright (c) 2022 Digital Asset (Switzerland) GmbH and/or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

if ! (bazel build //ledger-service/... && bazel test //ledger-service/...) &>/dev/null
then
    echo "Failed initial build. Not proceeding."
    exit 1
else
    echo "Successfully ran initial build."
    echo "Starting deletion process..."
fi



for f in $(git ls-files \
          | grep -v '^ledger-service/' \
          | grep -v '^.envrc$' \
          | grep -v '^dev-env/' \
          | grep -v '^nix/' \
          | grep -v '^.bazelrc$' \
          | grep -v '^.bazelignore$' \
          | grep -v '^.gitignore$' \
          | grep -v '^fmt.sh$' \
          | grep -v '^.hlint.yaml$' \
          | grep -v '^.scalafmt.conf$' \
          | grep -v '^COPY$' \
          | grep -v 'NO_AUTO_COPYRIGHT' \
          | grep -v '^security' \
          | grep -v '^.gitattributes$' \
          | grep -v '^.github' \
          | grep -v '^ci/' \
          | grep -v '^build.sh$' \
          ); do
    echo $f >> files.tmp
    rm $f
    if bazel build //ledger-service/... 1>>log.tmp 2>&1 \
       && bazel test //ledger-service/... 1>>log.tmp 2>&1
    then git rm $f
    else git checkout $f >/dev/null 2>&1
    fi
done
