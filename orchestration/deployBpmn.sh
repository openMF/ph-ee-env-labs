#!/bin/sh
HOST="https://zeebeops.sandbox.fynarfin.io/zeebe/upload"
deploy(){
    cmd="curl --insecure --location --request POST $HOST \
    --header 'Platform-TenantId: gorilla' \
    --form 'file=@\"$PWD/$1\"'"
        echo "print 1 $1"
    if [ "$1" = "orchestration/feel/inbound_transfer-mifos-DFSPID.bpmn" ]; then
      sed "s/account-identifier-DFSPID/account-identifier-gorilla/g; s/payee-loan-transfer-DFSPID/payee-loan-transfer-gorilla/g;s/payee-deposit-transfer-DFSPID/payee-deposit-transfer-gorilla/g;" $PWD/$1 > temp.bpmn
      cmd="curl --insecure --location --request POST $HOST \
      --header 'Platform-TenantId: gorilla' \
      --form 'file=@\"$PWD/temp.bpmn\"'"
    fi
    echo $cmd
    eval $cmd 
    #If curl response is not 200 it should fail the eval cmd
    
    cmd="curl --insecure --location --request POST $HOST \
    --header 'Platform-TenantId: rhino' \
    --form 'file=@\"$PWD/$1\"'"
    if [ "$1" = "orchestration/feel/inbound_transfer-mifos-DFSPID.bpmn" ]; then
      sed "s/account-identifier-DFSPID/account-identifier-rhino/g; s/payee-loan-transfer-DFSPID/payee-loan-transfer-rhino/g;s/payee-deposit-transfer-DFSPID/payee-deposit-transfer-rhino/g;" $PWD/$1 > temp.bpmn
      cmd="curl --insecure --location --request POST $HOST \
      --header 'Platform-TenantId: gorilla' \
      --form 'file=@\"$PWD/temp.bpmn\"'"
    fi
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
