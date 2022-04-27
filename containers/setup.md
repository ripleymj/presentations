$Env:KUBECONFIG = "c:\users\riple\Downloads\k8s-1-32-2-do-0-nyc3-1744550659292-kubeconfig.yaml"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.1/deploy/static/provider/cloud/deploy.yaml

kubectl config get-contexts -o name
argocd cluster add --kubeconfig <path-of-kubeconfig-file> --kube-context string <cluster-context> --name <cluster-name>