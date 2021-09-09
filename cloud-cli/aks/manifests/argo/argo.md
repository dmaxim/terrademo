
# ArgoCD Setup

## Install the ArgoCD command line

Download the ArgoCD CLI: https://github.com/argoproj/argo-cd/releases

Save the CLI executable to your path.

Verify the CLI is functioning

````
argocd version
````

## Download


https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

## Install

````
kubectl apply -f argocd-namespace.yaml
kubectl apply -n argocd -f argocd-install.yaml

````

## Update Admin Password
Creating the ArgoCD resources in Kubernetes via the manifest results in Argo being setup with a default password.  The password can be changed via:

Port forward the ArgoCD server
````
kubectl port-forward svc/argocd-server -n argocd 8080:443
````

Get the curent default password
````
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

````

NOTE:  Mac command line appending a % to the end of the password. 


Login and change the password

````
argocd login localhost:8080
argocd account update-password
````


## Create a DNS Entry for the ArgoCD UI
The DNS entry should point to the external IP address of the nginx ingress controller service.

````
kubectl -n seti-ingress get service nginx-ingress-ingress-nginx-controller -o jsonpath="{.status.loadBalancer.ingress[0].ip}"
````

## Create the Ingress for ArgoCD UI

````
kubectl apply -f manifests/argo/argocd-ingress.yaml -n argocd
````

## Grant ArgoCD Permissions to Source Control
TODO:  Determine if it is possible to do this via script or if it requires manual steps

### Manual
* Create a private / public key pair for SSH access to source control (the private key cannot have a password)
* Add the public key to GitHub to allow accessing the POC repository
* Log into ArgoCD https://seti-argo.danmaxim.net
* Click on Manage Repositories / Repositories
* Connect to Repo using ssh - set the repository to the git SSH URL for the repository (git@github.com...), set the private key and click connect


