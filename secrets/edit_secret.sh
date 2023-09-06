#!/usr/bin/env bash

nix run github:yaxitech/ragenix -- -i ~/.ssh/id_ed25519 -e $1
