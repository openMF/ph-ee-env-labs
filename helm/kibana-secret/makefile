default: test
include examples.mk
RELEASE := helm-kibana-security

install:
	helm upgrade --wait --timeout=$(TIMEOUT) --install --values values.yaml $(RELEASE) ../../

test: secrets install goss

purge:
	kubectl delete secret kibana || true
	helm del $(RELEASE)

secrets:
	#encryptionkey=$$(docker run --rm busybox:1.31.1 /bin/sh -c "< /dev/urandom tr -dc _A-Za-z0-9 | head -c50") && \
	
	encryptionkey=MMFI5EFpJnib4MDDbRPuJ1UNIRiHuMud_r_EfBNprx7qVRlO7R && \
    kubectl create namespace $(NAMESPACE) || echo "namespace already exists"  && \
	kubectl create secret generic kibana --namespace=$(NAMESPACE) --from-literal=encryptionkey=$$encryptionkey
