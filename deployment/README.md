# Kubernetes Deployment for Ansvue

This directory contains Kubernetes manifests for deploying the Ansvue Vue.js application.

## Prerequisites

- A running Kubernetes cluster
- `kubectl` configured to communicate with your cluster
- Docker image built and available (or pushed to a registry)

## Files

- `deployment.yaml` - Defines the Deployment resource with 1 replica
- `service.yaml` - Defines a ClusterIP Service to expose the application
- `kustomization.yaml` - Kustomize configuration for managing the resources
- `redeploy.sh` - Script to clean up and redeploy (useful for fixing configuration issues)

## Deployment Configuration

The deployment includes:
- **Replicas**: 1 pod
- **Image**: `insignficant/ansible-vue:latest` (can be customized via kustomization)
- **Port**: 5173 (Vite dev server port)
- **Resources**: 
  - Requests: 64Mi memory, 50m CPU
  - Limits: 128Mi memory, 100m CPU
- **Health Checks**:
  - Liveness probe: HTTP GET on `/` on port 5173 every 10 seconds
  - Readiness probe: HTTP GET on `/` on port 5173 every 5 seconds

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
kubectl apply -k deployment/ --image=insignficant/ansible-vue:latest
```

### Method 3: Using the redeploy script (for fixing configuration issues)

If you encounter duplicate port name errors or other configuration conflicts, use the redeploy script:

```bash
cd deployment/
./redeploy.sh
```

This script will:
1. Delete the existing deployment and service
2. Wait for cleanup to complete
3. Apply the new configuration
4. Show the deployment status

## Accessing the Application

### Port Forwarding

```bash
# Forward local port 8080 to the service
kubectl port-forward service/ansvue 8080:5173

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

## Troubleshooting

### Duplicate Port Name Error

If you encounter an error like:
```
Service "ansvue" is invalid: spec.ports[1].name: Duplicate value: "http"
```

This typically happens when there's an existing deployment/service with a different configuration. To fix this:

**Option 1: Use the redeploy script**
```bash
cd deployment/
./redeploy.sh
```

**Option 2: Manually delete and redeploy**
```bash
# Delete existing resources
kubectl delete deployment ansvue -n default
kubectl delete service ansvue -n default

# Wait a few seconds for cleanup
sleep 2

# Apply the new configuration
kubectl apply -k deployment/
```

**Option 3: Check current configuration**
```bash
# View the current deployment configuration
kubectl get deployment ansvue -n default -o yaml

# View the current service configuration
kubectl get service ansvue -n default -o yaml
```

### Pods Not Starting

If pods are not starting or are in CrashLoopBackOff:

```bash
# Check pod status
kubectl get pods -l app=ansvue

# View pod logs
kubectl logs -l app=ansvue --tail=50

# Describe pod for detailed events
kubectl describe pod -l app=ansvue
```

### Port Mismatch Issues

If you see errors related to port mismatches between the container port and probe ports, ensure that:
- The container port in `deployment.yaml` matches the port your application listens on
- The liveness and readiness probes use the same port as the container port

For this application, the correct configuration is:
- Container port: 5173
- Probe port: 5173
