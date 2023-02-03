#!/bin/bash
#--------------------------------------------------------|
#                 KUBERNETES APPLY SCRIPT                |
#--------------------------------------------------------'
option="$1"

function banner() {
    echo -e "**** Initializing Kubernetes Apply Script ****\n"
}

function help() {
    echo -e "\nUsage:"
    echo -e "./k8s-apply.sh <option>"
    echo -e "ex: ./k8s-apply.sh apply|delete|recreate|delete_full|check\n"
}

function catch() {
    if [ "$1" != "0" ]; then
      # Error handling
      echo "Error $1 occurred on $2"
    else echo -e "Success! Good bye!\n"
    fi
}

function set_requirements() {
    [[ $1 == "" ]] && echo -e "** Please provide an option!\n" && help && exit 1
    # Set bash strict mode
    set -euo pipefail
    IFS=$'\n\t'
    # Treat Errors
    trap 'catch $? $LINENO' EXIT
    echo -e "** Done setting script requirements...\n"
}

####

function build() {
# ToDo
#    docker build . -t evmos-devnet1 --build-arg commit_hash=tags/v9.1.0
#    docker build . -t evmos-devnet2 --build-arg commit_hash=tags/v10.0.0-rc2 --build-arg extra_flags=--metrics
}

function apply() {
    kubectl apply -f 00-k8s-namespace.yaml
    kubectl apply -f 10-k8s-configmap.yaml
    kubectl apply -f 20-k8s-svc.yaml
    kubectl apply -f 30-k8s-evmos-devnet1.yaml
    kubectl apply -f 30-k8s-evmos-devnet1.yaml
    kubectl apply -f 30-k8s-grafana.yaml
    kubectl apply -f 30-k8s-prometheus.yaml
}

function delete() {
    kubectl delete -f 30-k8s-evmos-devnet1.yaml
    kubectl delete -f 30-k8s-evmos-devnet1.yaml
    kubectl delete -f 30-k8s-grafana.yaml
    kubectl delete -f 30-k8s-prometheus.yaml
}

function delete-full() {
    delete
    kubectl delete -f 20-k8s-svc.yaml
    kubectl delete -f 10-k8s-configmap.yaml
    kubectl delete -f 00-k8s-namespace.yaml
}

function recreate() {
    delete
    apply
}

function check() {
    echo -e "\nNamespaces:"
    kubectl get namespaces
    echo -e "\nServices:"
    kubectl get services -A
    echo -e "\nCheck Pods:"
    kubectl get pods -A
}

# Main
function main() {
    set_requirements $1
    banner
    if [[ "$1" == "apply" ]]; then
        build
        $1
    fi
    if [[ "$1" == "recreate" ]]; then
        build
        $1
    fi
    if [[ "$1" == "delete" ]]; then
        $1
    fi
    if [[ "$1" == "delete-full" ]]; then
        $1
    fi
    if [[ "$1" == "check" ]]; then
        $1
    fi
    echo -e "\n** exiting... **\n"
    exit
}

# Calls main with args
main "$@"