.PHONY: config-gcp, create-cluster, credentials-cluster, delete-cluster, download-argo-manifests

PROJECT_ID?=hermes-freestyle
COMPUTE_ZONE?=us-east1-b
COMPUTE_REGION?=us-east1
CLUSTER_NAME?=argocd
NUM_NODES?=1
CLUSTER=gke_$(PROJECT_ID)_$(COMPUTE_ZONE)_$(CLUSTER_NAME)

# GKE cluster management
config-gcp:
	@gcloud config set project $(PROJECT_ID)
	@gcloud config set compute/zone $(COMPUTE_ZONE)
	@gcloud config set compute/region $(COMPUTE_REGION)

create-cluster: config-gcp
	@gcloud container clusters create $(CLUSTER_NAME) --num-nodes=$(NUM_NODES)

credentials-cluster:
	@gcloud container clusters get-credentials $(CLUSTER_NAME)

delete-cluster:
	@gcloud container clusters delete $(CLUSTER_NAME)

# Argo Install
download-argo-manifests:
	@wget -O argocd/install.yaml https://raw.githubusercontent.com/argoproj/argo-cd/8f981ccfcf942a9eb00bc466649f8499ba0455f5/manifests/install.yaml

install-argo: download-argo-manifests
	@kubectl apply --context $(CLUSTER) -f argocd/namespace.yaml
	@kubectl apply -n argocd --context $(CLUSTER) -f argocd/install.yaml

# Argo access
get-pwd:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

port-forward:
	kubectl port-forward svc/argocd-server -n argocd 8080:443