#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TEST_LOG=$SCRIPT_DIR/test_logs/system_test_$CLIENT_OS.log
LOG_LEVEL=logging.INFO

#echo "SCRIPT_DIR = ${SCRIPT_DIR}"
#echo "TEST_LOG = ${TEST_LOG}"
#echo "LOG_LEVEL = ${LOG_LEVEL}"

export CLIENT_HOSTNAME CLIENT_OS TPM_VERSION ENABLED_COLLECTORS TEST_LOG LOG_LEVEL

# prepare log file directory
rm -rf $SCRIPT_DIR/test_logs
mkdir -p $SCRIPT_DIR/test_logs

# Run systems tests
echo "===========Running systems tests on ${SERVER_HOSTNAME} and ${CLIENT_HOSTNAME}==========="
TEST_OUTPUT=$SCRIPT_DIR/test_logs/test_output$$.txt
python $SCRIPT_DIR/system_test.py 2>&1 | tee $TEST_OUTPUT
SYSTEM_TEST_EXIT_CODE=$PIPESTATUS

# check result
if [[ $SYSTEM_TEST_EXIT_CODE == 0 ]]
then
    echo "SUCCESS: System test passed"
    exit 0
fi

echo "ERROR: System tests failed"
exit 1
