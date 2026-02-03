# Kubernetes Deployment for Ansvue

This directory contains Kubernetes manifests for deploying the Ansvue Vue.js application.

## Prerequisites

- A running Kubernetes cluster
- `kubectl` configured to communicate with your cluster
- Docker image built and available (or pushed to a registry)

## Files

- `deployment.yaml` - Defines the Deployment resource with 2 replicas
- `service.yaml` - Defines a ClusterIP Service to expose the application
- `kustomization.yaml` - Kustomize configuration for managing the resources

## Deployment Configuration

The deployment includes:
- **Replicas**: 2 pods for high availability
- **Image**: `ansvue:latest` (can be customized via kustomization)
- **Port**: 80 (nginx serves the Vue.js app)
- **Resources**: 
  - Requests: 64Mi memory, 50m CPU
  - Limits: 128Mi memory, 100m CPU
- **Health Checks**:
  - Liveness probe: HTTP GET on `/` every 10 seconds
  - Readiness probe: HTTP GET on `/` every 5 seconds

## Deployment Methods

### Method 1: Using kubectl directly

```bash
# Apply the deployment and service
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Or apply all at once
kubectl apply -f deployment/
```

### Method 2: Using Kustomize (Recommended)

```bash
# Apply using kustomize
kubectl apply -k deployment/

# To customize the image tag, edit kustomization.yaml or use:
kubectl apply -k deployment/ --image=ansvue:v1.0.0
```

## Accessing the Application

### Port Forwarding

```bash
# Forward local port 8080 to the service
kubectl port-forward service/ansvue 8080:80

# Access at http://localhost:8080
```

### Using Ingress (if configured)

If you have an Ingress controller configured, you can create an Ingress resource to expose the service externally.

## Scaling the Deployment

```bash
# Scale to 3 replicas
kubectl scale deployment ansvue --replicas=3
```

## Checking Status

```bash
# Check deployment status
kubectl get deployment ansvue

# Check pods
kubectl get pods -l app=ansvue

# Check service
kubectl get service ansvue

# View logs
kubectl logs -l app=ansvue --tail=50 -f
```

## Cleanup

```bash
# Delete all resources
kubectl delete -k deployment/

# Or individually
kubectl delete deployment ansvue
kubectl delete service ansvue
```

## Building the Docker Image

Before deploying, ensure the Docker image is built:

```bash
# From the ansvue directory
docker build -t ansvue:latest .

# Or if using a registry
docker build -t your-registry.com/ansvue:latest .
docker push your-registry.com/ansvue:latest
```

Then update the image reference in `kustomization.yaml` or use:
```bash
kubectl set image deployment/ansvue ansvue=your-registry.com/ansvue:latest
```
