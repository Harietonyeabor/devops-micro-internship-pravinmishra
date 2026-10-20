# Assignment 10 — Capstone: Deploy the Book Review App to Kubernetes

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

Deploy the Book Review App as a production-style three-tier application using Kubernetes manifests or Helm charts, with an accessible frontend, an internal backend, and a managed or persistent MySQL database.

---

## Submission Details

**Full Name:** Henrietta Ogochukwu Okechukwu.

**Kubernetes Platform:** Azure.

**Namespace:** book-review

**Frontend URL or IP:** http://localhost:3000 (via port-forwarding) or http://localhost:30080 (via NodePort)

**Access Method:** Documented local access via kubectl port-forward / NodePort within the Kind Kubernetes cluster.

**GitHub Manifests or Helm Chart URL:** https://github.com/Harietonyeabor/book-review-app

**Architecture Diagram:** 
![Architectural Diagram](screenshots/Archi-kubernate.jpg)

---

# Task 1 — Prepare the Kubernetes Cluster and Project

## Goal

Prepare the cluster, application source, container images, and tooling needed for the deployment.

### Evidence

#### Screenshot 1 — Active Kubernetes context and Ready nodes

![alt text](screenshots/show-ready.png)

---

#### Screenshot 2 — If using Helm: Output of `helm version`

Required only if you choose Helm. Skip this screenshot if using YAML manifests.

Add your screenshot here, or write “Not applicable — using YAML manifests.”

 “Not applicable — using YAML manifests.”

---

# Task 2 — Design the Three-Tier Kubernetes Architecture

## Goal

Document the workloads, networking, configuration, storage, and permitted communication paths before deployment.

### Evidence

#### Screenshot 3 — Completed Kubernetes architecture diagram

![Architectural Diagram](screenshots/Archi-kubernate.jpg)

---

# Task 3 — Create ConfigMaps and Secrets

## Goal

Provide application configuration and credentials without embedding sensitive values in images or committing them to Git.

### Evidence

#### Screenshot 4 — ConfigMap configuration or describe output showing non-sensitive values

![alt text](screenshots/config-4.png)

---

#### Screenshot 5 — Secret references or describe output showing names and keys without sensitive values

![alt text](screenshots/des-sec.png)

---

# Task 4 — Deploy and Configure the MySQL Data Tier

## Goal

Provide persistent MySQL storage and allow the backend to connect without exposing the database publicly.

### Evidence

#### Screenshot 6 — Managed MySQL status or MySQL StatefulSet and PVC status

![alt text](screenshots/mysql-serv.png)

---

#### Screenshot 7 — Successful database connectivity or schema verification with credentials hidden

![alt text](screenshots/msql-veri.png)

---

# Task 5 — Deploy the Backend Application Tier

## Goal

Run one or two Node.js/Express backend replicas on port 3001 and expose them through an internal ClusterIP Service.

### Evidence

#### Screenshot 8 — Backend Deployment, ready Pods, and internal Service

![alt text](screenshots/scrn-8-kub.png)

---

#### Screenshot 9 — Backend startup logs and database connectivity evidence

If the application does not log successful database connections, provide a successful database-backed request alongside the startup logs.

![alt text](screenshots/db-s.png)

---

# Task 6 — Deploy the Frontend and Configure Nginx

## Goal

Run the Next.js frontend behind Nginx on port 80 and proxy API requests to the internal backend Service.

### Evidence

#### Screenshot 10 — Frontend Deployment and Ready Pods

![alt text](screenshots/kb-ass10-s10.png)

---

#### Screenshot 11 — Nginx reverse-proxy configuration showing the internal backend Service name and port 3001

![alt text](screenshots/scrn11-dka10.png)

---

# Task 7 — Configure External and Internal Networking

## Goal

Expose the frontend and enforce the intended communication path between application tiers.

### Evidence

#### Screenshot 12 — Frontend LoadBalancer or Ingress configuration and assigned endpoint, or documented local access method

![alt text](screenshots/scrn12-ass10-doc.png)

---

#### Screenshot 13 — Internal backend Service and NetworkPolicy or equivalent restriction, with access-test evidence

![alt text](screenshots/scrn13-kb-ass10.png)

---

# Task 8 — Validate the Application End to End

## Goal

Prove that the frontend, backend, and MySQL database work together and collect operational evidence.

### Evidence

#### Screenshot 14 — `kubectl get all` output for the book-review namespace

![alt text](screenshots/kb-all.png)

---

#### Screenshot 15 — Functional Book Review App in the browser with the URL visible, including evidence of a successful user flow

![alt text](screenshots/bk-rv-brs.png)

---

#### Screenshot 16 — Frontend or Nginx container logs

![alt text](screenshots/scrn-16-dk-ass10.png)

---

#### Screenshot 17 — Backend logs and evidence of a successful database-backed operation

![alt text](screenshots/scrn17-ass10-doc.png)

---

#### Screenshot 18 — Optional: Kubernetes dashboard

 “Not attempted.”

Multiple images may be included under a screenshot number when needed to demonstrate the complete user flow.

---

# Task 9 — Optional: Implement Production Improvements

## Goal

Add selected improvements without breaking the required three-tier architecture.

### Evidence

#### Screenshot 19 — Optional: Evidence of selected Helm, HPA, probe, or TLS improvements

 “Not attempted.”

---

# Task 10 — Publish Your Book Review App Deployment on LinkedIn

## Goal

Explain your three-tier architecture, demonstrate the working application, and share what you learned.

### Evidence

#### Screenshot 20 — Published LinkedIn post about your Book Review App deployment on Kubernetes

![Linkedin Post](screenshots/ass10-wk11-kb.png)

### LinkedIn Post URL

https://lnkd.in/p/dpCGUZMf

---

# Final Summary

## What Worked

Describe the application components and user flows you successfully deployed and tested.

Successfully deployed a three-tier Book Review application inside a local Kubernetes (kind) cluster within the book-review namespace. This architecture utilized a stateful MySQL database (mysql-0 via a headless service with persistent volume claims), a Node.js & Express backend API using Sequelize for ORM, and an Nginx-backed frontend service exposed via NodePort (30080). All environment variables and sensitive credentials were securely managed using Kubernetes ConfigMaps and Secrets. Database schema synchronization and sample data seeding executed successfully upon backend startup.

## Issues and Fixes

Describe the main issues encountered, their causes, and how you resolved them.

MODULE_NOT_FOUND Error: Encountered when Node.js could not locate dependencies inside the container. Resolved by adding a proper .dockerignore file to exclude local node_modules from the Docker build context and ensuring clean dependency installation during docker build.

Image Pull Policy / Kind Caching: The cluster cached older image versions. Resolved by explicitly setting imagePullPolicy: Never in the deployment manifest and loading images directly into the kind node using kind load docker-image.

Sequelize Connection Refused (ECONNREFUSED): The backend attempted to connect before MySQL finished initializing. Resolved by allowing MySQL to complete its internal InnoDB and X Plugin bootstrap sequence (ready for connections) before restarting the backend deployment.

## Tools and Sources Used

List the documentation and tools that helped you complete the assignment.

Tools: Kubernetes (kubectl), Kind, Docker, Node.js, Express, Sequelize, MySQL 8.0, WSL2 / Linux Terminal.

Sources: Kubernetes Official Documentation, Sequelize ORM Guides, MySQL Docker Hub Documentation.
## Optional Improvements

Describe any optional improvements implemented, or write “Not attempted.”

“Not attempted.”

## Cleanup or Reuse Plan

State which resources were removed or why the environment is being retained.

The local development environment is being retained for ongoing testing and demonstration purposes. To clean up the cluster in the future, the namespace can be deleted via kubectl delete namespace book-review

---

# Submission Instructions

- Include your Kubernetes manifests or Helm chart in the linked repository.
- Submit Secret examples containing placeholders only.
- Include Screenshot 1, Screenshots 3–17, and Screenshot 20.
- Include Screenshot 2 only if using Helm.
- Screenshots 18–19 are optional.
- Keep screenshot numbering consistent with the guidelines.
- Use clear, readable screenshots showing relevant configuration, commands, and outputs.
- Make your full name visible in required screenshots.
- Complete the submission details and Final Summary.
- Include your published LinkedIn post URL.
- Capture required evidence before cleanup.
- Do not expose passwords, tokens, JWT secrets, actual Secret values, kubeconfig contents, cloud credentials, or confidential account information.

---

# Completion Checklist

- [ ] Selected and configured a supported Kubernetes platform
- [ ] Confirmed the context and Ready nodes (Screenshot 1)
- [ ] Created and selected the book-review namespace
- [ ] Inspected the application repository
- [ ] Prepared images accessible to the cluster
- [ ] Confirmed Helm if using charts (Screenshot 2, conditional)
- [ ] Created the architecture diagram (Screenshot 3)
- [ ] Created ConfigMaps and Secrets (Screenshots 4–5)
- [ ] Excluded actual Secret values from Git and screenshots
- [ ] Provisioned private managed MySQL or persistent Kubernetes MySQL (Screenshot 6)
- [ ] Initialized the required database and schema
- [ ] Verified database connectivity or schema (Screenshot 7)
- [ ] Deployed one or two backend replicas listening on port 3001
- [ ] Created the backend ClusterIP Service (Screenshot 8)
- [ ] Verified backend-to-database connectivity (Screenshot 9)
- [ ] Deployed one or two frontend replicas behind Nginx (Screenshot 10)
- [ ] Configured API proxying through the internal backend Service (Screenshot 11)
- [ ] Configured and documented frontend access (Screenshot 12)
- [ ] Enforced backend access restrictions (Screenshot 13)
- [ ] Confirmed that the backend and database are not publicly exposed
- [ ] Captured resource status for book-review (Screenshot 14)
- [ ] Tested application functionality and database writes (Screenshots 15 and 17)
- [ ] Verified saved data after application restart
- [ ] Captured frontend and backend logs (Screenshots 16–17)
- [ ] Included optional dashboard or improvement evidence if attempted (Screenshots 18–19)
- [ ] Published the LinkedIn post (Screenshot 20)
- [ ] Included the LinkedIn post URL
- [ ] Documented issues, fixes, and useful sources
- [ ] Recorded cleanup status or reuse plans
- [ ] No sensitive data exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*
