# Assignment 7 — Capstone: Deploy a Production-Grade Stack for The EpicBook

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will deploy the EpicBook application as a production-oriented Docker Compose stack on a cloud VM. You will use optimized container images, isolated networks, health checks, persistent MySQL storage, a selected reverse proxy, logging, backup and restore testing, and reliability procedures.

---

# Task 0 — App Discovery and Architecture

## Goal

Review the EpicBook repository and design the intended application architecture.

### Evidence

#### Screenshot 1 — EpicBook Project Structure

Add a terminal screenshot showing the EpicBook project structure after cloning the repository.

![Project Structure](screenshots/ls-la-doc.png)

---

#### Screenshot 2 — Architecture Diagram

Add a screenshot of your architecture diagram showing:

- Public user
- Reverse proxy
- Frontend
- Backend
- Database
- Docker networks
- Public and private ports
- Persistent database storage

Add your full name inside the diagram or as a clear caption below it.

![Architecture Diagram](screenshots/Arch-doc.png)

---

#### Screenshot 3 — Environment Variables and Ports Document

Add a screenshot showing the contents of:

```text
docs/02-env-and-ports.md
```

It must document environment-variable names, internal ports, persistent-data details, and the health-check method. Do not expose real credentials or values.

![doc/02](screenshots/docs-02.png)

---

# Task 1 — Create Production Docker Images

## Goal

Create optimized production images for the EpicBook backend and frontend.

### Evidence

#### Screenshot 4 — Backend Dockerfile

Add a screenshot showing `backend/Dockerfile`, including:

- Dependency stage
- Minimal runtime stage
- Production startup command
- Internal backend port
- Non-root user configuration

![BE Dockerfile](screenshots/image-1.png)

---

#### Screenshot 5 — Frontend Dockerfile

Add a screenshot showing `frontend/Dockerfile`, including:

- Nginx runtime image
- Static frontend files copied to the Nginx web root

![FE Dockerfile](screenshots/doc-file.png)

---

#### Screenshot 6 — Docker Ignore Files

Add a screenshot showing both:

```text
backend/.dockerignore
frontend/.dockerignore
```

![Git ignore](screenshots/doc-ignf.png)

---

#### Screenshot 7 — Docker Image Builds and Size Comparison

Add a terminal screenshot showing successful builds of:

- Baseline backend image
- Optimized backend image
- Frontend image

The screenshot must also show the baseline and optimized backend image-size comparison.

![Baseline](screenshots/doc-img-gre.png)

---

#### Screenshot 8 — Backend Running as Non-Root User

Add a terminal screenshot showing the optimized backend container running as a non-root user.

![Root user](screenshots/root.png)

---

### Notes

Write a short note covering:

- Baseline and optimized backend image sizes
- The image-size reduction achieved
- One Docker layer-caching optimization used
- The security benefit of running the backend as a non-root user

Baseline Size: 1.68 GB (epicbook-backend:single)

Optimized Size: 238 MB (epicbook-backend:1.0)

Reduction: ~86% reduction in disk usage (~87% content size reduction).

Layer Caching Optimization: Using npm ci on isolated package files before copying the application source code.

Security Benefit: Running as the non-root node user mitigates container breakout and privilege-escalation risks if the application is ever compromised.

---

# Task 2 — Create the Docker Compose Stack and Networks

## Goal

Create one Docker Compose stack containing the reverse proxy, frontend, backend, and MySQL database.

### Evidence

#### Screenshot 9 — Docker Compose Services

Add a screenshot showing `docker-compose.yml` with all four services:

```text
reverse-proxy
frontend
backend
database
```

![alt text](screenshots/services-yml.png)
![alt text](screenshots/serv-yml-2.png)

---

#### Screenshot 10 — Networks and Named Volume

Add a screenshot showing:

- `front-tier` network
- `back-tier` network
- `db_data` named volume

![alt text](screenshots/ntwrk-vol.png)

---

#### Screenshot 11 — Docker Compose Validation

Add a terminal screenshot showing successful Docker Compose validation without exposing environment-variable values or secrets.

![alt text](screenshots/val-file-ok.png)

---

# Task 3 — Configure Health Checks and Startup Dependencies

## Goal

Configure health checks and ensure services start only after their dependencies are healthy.

### Evidence

#### Screenshot 12 — Backend Health Endpoint

Add a screenshot showing the backend application configuration for the `/health` endpoint.

![alt text](screenshots/health-doc.png)

---

#### Screenshot 13 — MySQL and Backend Health Checks

Add a screenshot showing `docker-compose.yml` with health checks for MySQL and the backend.

![alt text](screenshots/curl-be.png)
![alt text](screenshots/msql-be.png)
---

#### Screenshot 14 — Frontend and Reverse-Proxy Health Checks

Add a screenshot showing:

- Frontend health check
- Reverse-proxy health check
- `depends_on` conditions using `service_healthy`

![alt text](screenshots/fe-serv-h.png)

---

#### Screenshot 15 — Running Healthy Services

Add a terminal screenshot showing Docker Compose service status. The database, backend, frontend, and reverse proxy must be running successfully.

![alt text](screenshots/health-doc7.png)

---

#### Screenshot 16 — Public Health Endpoint

Add a terminal screenshot showing a successful response from the public application health endpoint through the reverse proxy.

![alt text](screenshots/pub-h-endp.png)

---

#### Screenshot 17 — Health-Check and Startup-Order Document

Add a screenshot showing the contents of:

```text
docs/03-healthchecks-and-depends-on.md
```

Explain the health-check method for each service and the startup dependency order.

![alt text](screenshots/h-chk.png)

---

# Task 4 — Configure the Reverse Proxy and Same-Origin Routing

## Goal

Use either Nginx or Traefik as the only public entry point for the EpicBook application.

### Evidence

#### Screenshot 18 — Selected Reverse-Proxy Configuration

Add a screenshot showing the configuration for your selected reverse proxy.

It must show routes for:

- Static frontend assets
- Application pages
- API requests
- Health endpoint

![alt text](screenshots/scrn-19.png)


---

#### Screenshot 19 — Only Reverse Proxy Publishes Port 80

Add a screenshot of `docker-compose.yml` showing that only the `reverse-proxy` service publishes port 80.

![alt text](screenshots/scrn-18.png)
![alt text](screenshots/scrn-18a.png)

---

#### Screenshot 20 — Reverse-Proxy Route Testing

Add a terminal screenshot showing successful requests through the selected reverse proxy to:

- Application page
- One API endpoint
- One static asset
- Health endpoint

![alt text](screenshots/succ-req.png)

---

#### Screenshot 21 — EpicBook Application Through Public IP

Add a browser screenshot showing the EpicBook application loaded through the VM public IP address.

Add your full name as a clear caption below the screenshot.

![alt text](screenshots/thw-epic-doc-b.png)

---

#### Screenshot 22 — Proxy Routing and CORS Document

Add a screenshot showing the contents of:

```text
docs/04-proxy-routing-and-cors.md
```

Explain the proxy routes and state whether CORS was required and why.

![alt text](screenshots/prox-rout.png)

---

# Task 5 — Prove Data Persistence, Backup, and Restore

## Goal

Verify MySQL persistence and perform a controlled backup and restore drill.

### Evidence

#### Screenshot 23 — MySQL Volume Configuration

Add a terminal screenshot showing the `db_data` named volume and its MySQL mount configuration.

![alt text](screenshots/scrn-23.png)

---

#### Screenshot 24 — Test Data Before Backup

Add a terminal screenshot showing the selected test data before the backup and restore drill.

![alt text](screenshots/scrn-24.png)

---

#### Screenshot 25 — Successful Backup Creation

Add a terminal screenshot showing successful backup creation and the backup file stored in the host backup directory.

![alt text](screenshots/scrn-25.png)

---

#### Screenshot 26 — Controlled Data-Loss Test

Add a terminal screenshot showing that the selected test record was removed during the controlled data-loss test.

![alt text](screenshots/scrn-26.png)

---

#### Screenshot 27 — Restore Verification

Add a terminal screenshot showing successful restore and verification that the deleted test record is available again.

![alt text](screenshots/scrn-27.png)

---

#### Screenshot 28 — Persistence After Down/Up Cycle

Add a terminal screenshot showing that database data remains available after a non-destructive Docker Compose down/up cycle.

Do not use `docker compose down -v`.

![alt text](screenshots/scrn-28.png)

---

#### Screenshot 29 — Persistence and Backup Document

Add a screenshot showing the contents of:

```text
docs/05-persistence-and-backup.md
```

Include the backup plan and restore procedure.

![alt text](screenshots/scrn-29.png)

---

# Task 6 — Configure Logging and Observability

## Goal

Configure useful reverse-proxy and backend logs without exposing sensitive information.

### Evidence

#### Screenshot 30 — Logging Configuration

Add a screenshot showing:

- Configuration for the selected reverse proxy
- Proxy log format
- Docker Compose host log-directory bind mount

![alt text](screenshots/30.png)

---

#### Screenshot 31 — Persistent Proxy Logs and Backend Logs

Add a terminal screenshot showing:

- Selected reverse-proxy logs available from the host directory after a proxy restart
- Backend logs displayed through Docker Compose

![alt text](screenshots/scrn-31.png)

---

### Notes

Write a short note covering:

- The selected reverse proxy
- Host path used for reverse-proxy logs
- How backend logs are viewed
- Whether JSON or standard text logs were used
- Why passwords, tokens, headers, and database connection strings must not appear in logs

The selected reverse proxy: Nginx (nginx:alpine), chosen for its lightweight footprint, high performance, and robust reverse proxying capabilities.

Host path used for reverse-proxy logs: ./logs on the host machine, which is bind-mounted directly to /var/log/nginx inside the reverse proxy container.

How backend logs are viewed: Centrally managed and inspected via Docker Compose using the command docker compose logs backend.

Whether JSON or standard text logs were used: Standard text log format was used for Nginx access and error tracking, paired with Node.js standard output streams.

Why passwords, tokens, headers, and database connection strings must not appear in logs: Sensitive information must be scrubbed from logs to prevent credential leakage, unauthorized access, and compliance violations in the event that log files are exposed or accessed inappropriately.

---

# Task 7 — Deploy and Verify the Stack on a Cloud VM

## Goal

Deploy the completed Docker Compose stack on an AWS or Azure VM and verify public access.

### Evidence

#### Screenshot 32 — VM Public IP and Inbound Rules

Add a cloud-console screenshot showing:

- VM public IP address
- SSH port 22 restricted to your IP address
- HTTP port 80 allowed from Anywhere

![alt text](screenshots/scrn-32.png)

---

#### Screenshot 33 — Cloud VM Stack Verification

Add a VM terminal screenshot showing:

- Docker Compose service status
- Successful public health or API response
- No published database, frontend, or backend ports

![alt text](screenshots/scrn-33.png)

---

#### Screenshot 34 — EpicBook Application on Cloud VM

Add a browser screenshot showing the EpicBook application loaded through the VM public IP address.

Add your full name as a clear caption below the screenshot.

![alt text](screenshots/thw-epic-doc-b-1.png)

---

### Notes

Write a short note covering:

- Cloud provider used
- VM operating system
- Public port exposed
- Security rules configured
- Confirmation that the application and backend API worked through the reverse proxy


- **Cloud Provider Used:** AWS (Amazon Web Services)
- **VM Operating System:** Ubuntu 22.04 LTS
- **Public Port Exposed:** Port 8081 (mapped to Nginx reverse proxy container port 80)
- **Security Rules Configured:** Inbound access configured for SSH (Port 22) and HTTP traffic (Ports 80 and 8081), restricting external exposure while keeping internal database and backend ports private.
- **Confirmation:** The EpicBook frontend application and backend API successfully communicated and rendered through the Nginx reverse proxy on the cloud VM.

---

# Task 8 — Automate Deployment with CI/CD (Optional)

## Goal

Optionally automate image build, image push, and deployment through GitHub Actions or Azure Pipelines.

### Optional Evidence

#### Optional Screenshot — Successful CI/CD Pipeline Run

Add a screenshot showing a successful pipeline run with build, image push, deployment, and verification stages.

Optional

---

### Optional Notes

Write a short note covering:

- CI/CD platform used
- Image-tagging method
- Registry used
- Deployment trigger
- Manual approval or secret-handling approach

Optional.

---

# Task 9 — Perform Reliability Tests and Create an Operations Runbook

## Goal

Test controlled service failures and document safe operating procedures.

### Evidence

#### Screenshot 35 — Backend Failure and Recovery

Add a terminal screenshot showing:

- Backend failure test
- Expected unavailable response through the reverse proxy
- Backend restart
- Successful health-check recovery

![alt text](screenshots//scr-351.png)
![alt text](screenshots//scrn-35-2.png)

---

#### Screenshot 36 — Database Failure and Recovery

Add a terminal screenshot showing:

- Database outage test
- Failed database-dependent request
- Database restart
- Successful application recovery

![alt text](screenshots//scrn-36.png)

---

### Notes

Write a short operations runbook covering:

- Safe restart procedure for reverse proxy, frontend, backend, and database
- Backup and restore procedure
- Secret-rotation approach
- Database recovery procedure
- What to check when the application returns an error
- Results of backend and database reliability tests

Write your note here.

Operations Runbook
1. Safe Restart Procedure
To restart components cleanly without data corruption or downtime spikes, follow this order:

Reverse Proxy (Nginx):
Command: docker compose restart proxy

Verification: Check logs with docker compose logs proxy --tail=10 to ensure workers active.

Frontend:
Command: docker compose restart frontend

Verification: Confirm responsiveness via curl -I http://localhost/.

Backend:
Command: docker compose restart backend

Verification: Check logs for App listening on PORT 3000 and successful DB synchronization.

Database:
Command: docker compose stop database && docker compose start database

Verification: Run docker compose logs database --tail=10 to verify MySQL is ready for connections.

2. Backup and Restore Procedure
Backup:
Command: docker exec -it epicbook-database mysqldump -u epicbook -p bookstore > backup_$(date +%F).sql

Verification: Check that the .sql file is generated and non-empty (ls -lh backup_*.sql).

Restore:
Command: docker exec -i epicbook-database mysql -u epicbook -p bookstore < backup_YYYY-MM-DD.sql

Verification: Query a table using docker exec -it epicbook-database mysql -u epicbook -p bookstore -e "SHOW TABLES;".

3. Secret-Rotation Approach
Update credentials inside your environment file or Docker secrets store (DB_PASSWORD, DB_ROOT_PASSWORD).

Update the bind-mounted db-config.json file to reflect the new password.

Recreate containers to apply changes: docker compose down && docker compose up -d --force-recreate.

Verification: Run docker compose logs backend --tail=10 to confirm successful authentication with the new credentials.

4. Database Recovery Procedure
Stop dependent services: docker compose stop backend frontend

Restart database service: docker compose restart database

Inspect container logs for recovery completion: docker compose logs database --tail=20

Restart dependent services: docker compose start backend frontend

Verification: Test query response using curl -I http://localhost/.

5. What to Check When the Application Returns an Error
502 Bad Gateway: Check if the upstream proxy targets (frontend or backend) are running using docker compose ps.

Database Connection Refused / ECONNREFUSED: Verify that NODE_ENV=development is set and that ./db-config.json is correctly mounted into /app/config/config.json.

Container Exits: Review container crash logs via docker compose logs [service_name] --tail=50.

6. Results of Backend and Database Reliability Tests
Outage Simulation: Stopping the backend correctly triggered an Nginx 502 Bad Gateway, and stopping the database caused graceful request failures.

Recovery: Restarting services restored full operations within seconds, confirmed via HTTP 200 OK responses and successful Sequelize model synchronization.

# Final Public Application URL

**EpicBook URL:** `http://172.31.35.189`

Replace the placeholder with your working public URL.

---

# GitHub Repository URL

**Your Fork or Repository URL:** `https://github.com/henriettao/theepicbook`

---

# LinkedIn Requirement

## Goal

Create a professional LinkedIn post of 6–10 lines about your EpicBook capstone deployment.

Your post must include:

- The architectural decision that most improved reliability
- Your biggest image-size reduction, with numbers
- Key production-hardening lessons
- A deployment verification image

### Evidence

**LinkedIn Post URL:** `https://lnkd.in/p/dXZBy8Dp`

#### LinkedIn Post Screenshot

Add a screenshot of the published LinkedIn post showing the text body and deployment verification image.

![Linkedin Post](epicbk-linkd-post-1.png)

---

# Submission Checklist

- [ ] EpicBook repository reviewed and architecture diagram created
- [ ] Environment variables, ports, persistence, and health-check details documented
- [ ] Backend and frontend production Dockerfiles created
- [ ] Backend runs as a non-root user
- [ ] Docker image-size comparison completed
- [ ] Docker Compose stack includes reverse proxy, frontend, backend, and database
- [ ] `front-tier` and `back-tier` networks configured
- [ ] `db_data` named volume configured
- [ ] MySQL, backend, frontend, and reverse-proxy health checks configured
- [ ] Startup dependencies use `service_healthy`
- [ ] Nginx or Traefik selected as the only public reverse proxy
- [ ] Only reverse-proxy port 80 is publicly published
- [ ] Same-origin routing configured and CORS used only when required
- [ ] Backup, restore, and persistence testing completed
- [ ] Reverse-proxy and backend logs verified
- [ ] Cloud VM deployment verified through the public IP
- [ ] Backend and database reliability tests completed
- [ ] Screenshots 1–36 included
- [ ] Required notes completed
- [ ] LinkedIn post URL and screenshot included
- [ ] Full name visible in required screenshots or captions
- [ ] No passwords, tokens, private keys, account IDs, or other sensitive information exposed

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
