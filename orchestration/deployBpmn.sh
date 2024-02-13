#!/bin/sh
HOST="https://zeebeops.sandbox.fynarfin.io/zeebe/upload"
deploy(){
    cmd="curl --insecure --location --request POST $HOST \
    --header 'Platform-TenantId: gorilla' \
    --form 'file=@\"$PWD/$1\"'"
    echo $cmd
    eval $cmd 
    #If curl response is not 200 it should fail the eval cmd
}

LOC=orchestration/feel/*.bpmn
for f in $LOC; do
    deploy $f
done

LOC2=orchestration/feel/example/*.bpmn
for f in $LOC2; do
    deploy $f
done