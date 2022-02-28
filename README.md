# Argo CD deployment on Google Kubernetes Engine GKE

This repo creates a standard GKE cluster and installs ArgoCD

## Create cluster

```bash
make create-cluster PROJECT_ID=your-project-id
```

## Install Argo CD

```bash
make install-argo
```

## Access Argo CD API Server

```bash
make get-pwd
```
will print the UI password for user `admin`

```bash
make port-forward
```
will forward argocd-server port 443 to `localhost:8080`