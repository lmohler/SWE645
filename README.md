# SWE 645 – Assignment 2: Containerized Web App with Kubernetes & CI/CD Pipeline

**Author:** Lucas Mohler  
**Course:** SWE 645 – Component-Based Software Development  
**Institution:** George Mason University  
**Live URL:** <http://ec2-100-52-109-4.compute-1.amazonaws.com:30007>

---

## What Was Built

A personal portfolio web application from Assignment 1 (Part 2), containerized with Docker
and deployed to a Kubernetes cluster on AWS EC2 via a fully automated Jenkins CI/CD pipeline.

The application consists of three HTML pages served by nginx:

- **index.html** – Portfolio landing page with experience, education, and technical skills
- **survey.html** – Student survey form with client-side validation
- **error.html** – Error/fallback page

---

## How It Works

Every `git push` to the `main` branch triggers an automated pipeline:

```text
git push → Jenkins (Poll SCM) → docker build → docker push → kubectl apply → Live on K8s
```

1. Jenkins detects the commit via Poll SCM (checks every minute)
2. Builds a new Docker image tagged `lmohler/my-webapp:latest`
3. Pushes the image to Docker Hub
4. Deploys to Kubernetes using `kubectl apply` with a rolling restart
5. The app is immediately live at the NodePort URL

---

## Repository Structure

```text
SWE645/
├── index.html              # Main portfolio page
├── survey.html             # Student survey form
├── error.html              # Error/fallback page
├── Dockerfile              # Docker image build instructions
├── Jenkinsfile             # CI/CD pipeline definition
├── images/
│   ├── me.jpg              # Profile photo
│   └── favicon.ico         # Site favicon
└── k8s/
    ├── deployment.yaml     # Kubernetes Deployment (3 replicas)
    └── service.yaml        # Kubernetes NodePort Service
```

---

## Infrastructure

| Component      | Technology                     |
| -------------- | ------------------------------ |
| Cloud Provider | AWS Academy (EC2 t3.large)     |
| OS             | Ubuntu Server 24.04 LTS        |
| Containers     | Docker                         |
| K8s Management | Rancher                        |
| Kubernetes     | K3s via Rancher (single-node)  |
| CI/CD Server   | Jenkins                        |
| Image Registry | Docker Hub (lmohler/my-webapp) |
| Source Control | GitHub                         |

---

## Kubernetes Deployment

**deployment.yaml** runs 3 replicas of the nginx container at all times. If a pod is
deleted, Kubernetes automatically creates a replacement to maintain the desired count of 3.

**service.yaml** exposes the app as a NodePort service:

- External port: `30007`
- Routes to container port: `80` (nginx)

To deploy manually:

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl get pods      # verify 3 pods are Running
kubectl get service   # verify NodePort 30007
```

---

## CI/CD Pipeline

The Jenkinsfile defines three stages:

| Stage                | What Happens                                          |
| -------------------- | ----------------------------------------------------- |
| Build Docker Image   | Builds Docker image tagged `lmohler/my-webapp:latest` |
| Push to Docker Hub   | Pushes image to Docker Hub via `docker-pass`          |
| Deploy to Kubernetes | Applies manifests and rolling-restarts deployment     |

**Jenkins credentials required:**

| ID            | Type                   | Purpose                   |
| ------------- | ---------------------- | ------------------------- |
| `docker-pass` | Username with password | Docker Hub login          |
| `kubeconfig`  | Secret file            | Kubernetes cluster access |

---

## Setup and Installation

See the full step-by-step setup guide: **SWE645 Complete Setup Guide.pdf**

Quick summary:

1. Launch EC2 (t3.large, Ubuntu 24.04, 30 GB) with security group ports: 22, 80, 443, 8080, 30007
2. Install Docker, then deploy Rancher: `sudo docker run -d -p 80:80 -p 443:443 --privileged rancher/rancher:latest`
3. Create K8s cluster in Rancher UI, download kubeconfig, install kubectl
4. Clone this repo: `git clone git@github.com:lmohler/SWE645.git`
5. Install Jenkins, add Docker Pipeline plugin, configure credentials
6. Create Pipeline job pointing to this repo's Jenkinsfile
7. Click **Build Now** — pipeline builds, pushes, and deploys automatically

---

## Accessing the Application

| Service    | URL                                                     |
| ---------- | ------------------------------------------------------- |
| Live App   | <http://ec2-100-52-109-4.compute-1.amazonaws.com:30007> |
| Jenkins    | <http://ec2-100-52-109-4.compute-1.amazonaws.com:8080>  |
| Rancher    | <https://ec2-100-52-109-4.compute-1.amazonaws.com>      |
| Docker Hub | <https://hub.docker.com/r/lmohler/my-webapp>            |
