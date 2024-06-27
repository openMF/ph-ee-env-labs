#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 [-n NAMESPACE] [-p POD_NAME] [-c CONTAINER_NAME] [-f FOLLOW] [-o OUTPUT_FILE]"
    echo "  -n NAMESPACE      : The namespace of the pod (default: default)"
    echo "  -p POD_NAME       : The name of the pod"
    echo "  -c CONTAINER_NAME : The name of the container (optional)"
    echo "  -f FOLLOW         : Follow the log output (optional, default: false)"
    echo "  -o OUTPUT_FILE    : The file to write the logs to (optional)"
    exit 1
}

# Default values
NAMESPACE="default"
FOLLOW=false
OUTPUT_FILE=""

# Parse command line arguments
while getopts ":n:p:c:fo:" opt; do
    case ${opt} in
        n )
            NAMESPACE=$OPTARG
            ;;
        p )
            POD_NAME=$OPTARG
            ;;
        c )
            CONTAINER_NAME=$OPTARG
            ;;
        f )
            FOLLOW=true
            ;;
        o )
            OUTPUT_FILE=$OPTARG
            ;;
        \? )
            usage
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            usage
            ;;
    esac
done

# Validate required arguments
if [ -z "${POD_NAME}" ]; then
    echo "Error: Pod name is required"
    usage
fi

# Construct the kubectl command
KUBECTL_CMD="kubectl logs -n ${NAMESPACE} ${POD_NAME}"

# Append container name if provided
if [ ! -z "${CONTAINER_NAME}" ]; then
    KUBECTL_CMD="${KUBECTL_CMD} -c ${CONTAINER_NAME}"
fi

# Append follow flag if set
if [ "${FOLLOW}" = true ]; then
    KUBECTL_CMD="${KUBECTL_CMD} -f"
fi

# Execute the command and handle output
if [ ! -z "${OUTPUT_FILE}" ]; then
    echo "Fetching logs for pod '${POD_NAME}' in namespace '${NAMESPACE}' and writing to '${OUTPUT_FILE}'..."
    $KUBECTL_CMD > "${OUTPUT_FILE}"
else
    echo "Fetching logs for pod '${POD_NAME}' in namespace '${NAMESPACE}'..."
    $KUBECTL_CMD
fi
