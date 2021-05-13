#! /bin/bash -e

CFN_METADATA_FILE=$1

SCYLLA_NODES=$(jq -r '.SCYLLA_BENCH.nodes|map(gsub("\""; ""))|join(",")' $CFN_METADATA_FILE)
SCYLLA_PASSWORD=$(jq -r '.SCYLLA_BENCH.password' $CFN_METADATA_FILE)
SCYLLA_BENCH_PARAMS=$(jq -r '.SCYLLA_BENCH.params' $CFN_METADATA_FILE)

scylla-bench -nodes "$SCYLLA_NODES" -username scylla -password "$SCYLLA_PASSWORD" $SCYLLA_BENCH_PARAMS