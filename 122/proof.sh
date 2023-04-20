#!/bin/bash

cat << EOF > ~/easy-proof.yaml
kind: Pod
apiVersion: v1
metadata:
  name: easy-proof
spec:
  containers:
  - name: foo-app
    image: hashicorp/http-echo:0.2.3
    args:
    - "-text='It is working!'"
EOF

kubectl apply -f ~/easy-proof.yaml
kubectl get pods
kubectl logs easy-proof

### -----------

cat << EOF > ~/day-2.yaml
kind: Pod
apiVersion: v1
metadata:
  name: foo-app
  labels:
    app: http-echo
spec:
  containers:
  - name: foo-app
    image: hashicorp/http-echo:0.2.3
    args:
    - "-text=foo"
---
kind: Pod
apiVersion: v1
metadata:
  name: bar-app
  labels:
    app: http-echo
spec:
  containers:
  - name: bar-app
    image: hashicorp/http-echo:0.2.3
    args:
    - "-text=bar"
---
kind: Service
apiVersion: v1
metadata:
  name: echo-service
spec:
  type: NodePort
  selector:
    app: http-echo
  ports:
  - name: http
    protocol: TCP
    port: 8081
    targetPort: 5678
EOF
kubectl apply -f ~/day-2.yaml
kubectl get svc
