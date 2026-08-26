# Assignment 6 — Capstone: Deploy Book Review App (Three-Tier Architecture) on Azure

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

This is the most important assignment of the course. You will deploy the Book Review App in a production-ready, best-practice-compliant three-tier architecture on Azure: separated presentation, application, and database tiers, least-privilege network access, a controlled public entry point, protected secrets, and availability/monitoring evidence.

---

# Task 1 — Design the Azure Three-Tier Architecture

## Goal

Create an architecture diagram and implementation plan identifying the presentation, application, and database components, the chosen Azure services, the public entry point, and the internal traffic paths.

### Evidence

#### Screenshot 1 — Architecture diagram showing the public entry point, three tiers, network boundaries, and traffic flow

![arc diagram](screenshots/srn1-ass6-wk7.png)

---

#### Screenshot 2 — Written architecture assumptions and selected Azure services

![written arch](screenshots/scn1a-ass6wk7.png)
![written arc](screenshots/scrn1b-ass6-wk7.png)

---

# Task 2 — Create the Azure Network Foundation

## Goal

Create a dedicated Resource Group and VNet with separate subnets for the web, application, and database tiers, keeping the application and database tiers without direct public access.

### Evidence

#### Screenshot 3 — Resource Group overview showing the assignment resources

![overview](screenshots/rg-ov.png)

---

#### Screenshot 4 — VNet overview showing the address space and all required subnets

![vnet overview](screenshots/scrn4-wk7.png)

---

#### Screenshot 5 — Route-table or Private DNS evidence where applicable

![route table](screenshots/scrn5-ass6-wk7.png)

---

# Task 3 — Configure Security and Secret Management

## Goal

Apply least-privilege NSG rules so traffic flows Internet → public entry point → web tier → application tier → database tier, and store credentials in Azure Key Vault or another approved secure mechanism.

### Evidence

#### Screenshot 6 — NSG rules proving least-privilege access between the tiers

![nsg web inbound rules](screenshots/bk-rv-wb-ir.png)
![app inbound rules](screenshots/bk-rv-app-rule.png)
![db inbound rules](screenshots/db-rules.png)


---

#### Screenshot 7 — Key Vault or approved secret-management configuration (without displaying secret values)

![key vault](screenshots/displaying-secrets.png)

---

# Task 4 — Deploy the Presentation (Web) Tier

## Goal

Deploy the Book Review App presentation layer on the approved web-tier compute service, configured to route requests to the internal application-tier endpoint, and not directly exposed except through the public entry service.

### Evidence

#### Screenshot 8 — Web-tier compute overview showing subnet and availability configuration

![web tier overview](screenshots/web-vm.png)

---

#### Screenshot 9 — Terminal or service output proving the presentation layer is running

![output](screenshots/scrn-9-ass6-wk7.png)

---

# Task 5 — Deploy the Business (Application) Tier

## Goal

Deploy the Book Review App backend privately in the application subnet, configured to use the private database endpoint and secured environment values, reachable only through its internal endpoint.

### Evidence

#### Screenshot 10 — Application-tier compute overview showing private subnet placement

![app tier overview](screenshots/bookrev-pri-ip.png)

---

#### Screenshot 11 — Backend process, service, or listening-port evidence

![backend process](screenshots/pm2-online.png)
![evidence](screenshots/200pm2-ok.png)

---

#### Screenshot 12 — Internal health-check or API response (without exposing secrets)

![internal health check](screenshots/db-updated.png)

---

# Task 6 — Deploy the Managed Database Tier

## Goal

Create a private Azure managed database (public access disabled), with availability/backup/retention settings, the Book Review App schema imported, and access restricted to the application tier only.

### Evidence

#### Screenshot 13 — Database overview showing private connectivity and public access disabled

![db overview](screenshots/bk-review-dboverview.png)

---

#### Screenshot 14 — Availability, backup, and retention configuration

![Availability](screenshots/high-avil.png)
![backup and restore](screenshots/backup-restore.png)

---

#### Screenshot 15 — Successful schema or connectivity verification (without exposing credentials)

![db view](screenshots/scrn15-wk7-ass6.png)

---

# Task 7 — Configure Traffic Management, Availability, and Monitoring

## Goal

Configure the approved public entry service with health probes and backend pools, internal routing for the application tier where required, and enable Azure Monitor/diagnostics/logs/alerts for the key resources.

### Evidence

#### Screenshot 16 — Public entry service showing listener, frontend endpoint, and healthy web targets

![public entry service](screenshots/bk-rvw-pi-lb.png)

---

#### Screenshot 17 — Internal application-tier load-balancing or routing configuration where applicable

![internal app tier](screenshots/int-app-tier.png)

---

#### Screenshot 18 — Azure Monitor, diagnostic settings, logs, metrics, or alert evidence

![azure monitor](screenshots/monitor.png)

---

# Task 8 — Validate the Production-Style Deployment

## Goal

Confirm the Book Review App works end to end through the public endpoint, with at least one database read and one write, confirm private tiers are not internet-reachable, and complete a safe availability test.

### Evidence

#### Screenshot 19 — Browser showing the Book Review App through the public endpoint

![browser](screenshots/book-reviewer-browser.png)

---

#### Screenshot 20 — Proof of successful database-backed read and write operations

![book review](screenshots/bk-review-page.png)

![evidence](screenshots/evidence-bkrv.png)

---

#### Screenshot 21 — Evidence that private tiers are not publicly accessible

![evidence](screenshots/scrn21-ass6-wk7.png)

---

#### Screenshot 22 — Availability-test and healthy-target evidence

![health-target evidence](screenshots/health-status.png)

---

#### Public Endpoint

Paste your public endpoint URL here:

`http://134.112.16.143`

---

### Notes

Summarize what worked, issues encountered and how they were fixed, and the availability/security/secrets/monitoring/backup choices made.

# Assignment 6: Deploying a Secure Three-Tier Web Application on Microsoft Azure

**Author:** Henrietta Ogochukwu Okechukwu  
**Course/Track:** DevOps Micro-Internship Program  
**Architecture:** Three-Tier Web Architecture (Presentation, Application, and Database Tiers)  
**Cloud Provider:** Microsoft Azure  

---

## 1. Executive Summary

This project implements a scalable, fault-tolerant, and secure **Three-Tier Web Application** deployed on Microsoft Azure. The architecture separates the presentation layer, business logic layer, and persistence layer across isolated virtual subnets within a custom Virtual Network (VNet), enforcing strict Network Security Group (NSG) traffic rules and least-privilege principles.

---

## 2. Infrastructure Architecture Overview

The system is partitioned into three distinct network tiers:

| Tier | Resource Name | Private IP / Subnet | Public Access | Purpose |
|---|---|---|---|---|
| **Web Tier (Presentation)** | `Book-Review-Web-VM` | `10.0.1.4` (`10.0.1.0/24`) | `134.112.16.143` (HTTP/80) | Nginx Reverse Proxy & Next.js frontend |
| **App Tier (Application)** | `Book-Review-App-VM` | `10.0.2.4` (`10.0.2.0/24`) | None (Private Only) | Node.js Express REST API backend (`:3001`) |
| **Database Tier (Persistence)** | Azure Database for MySQL Flexible Server | `10.0.3.0/24` (Delegated) | None (Private Only) | Relational database (`bookreviewdb`) with SSL enforcement |

[ Internet / Clients ]
                             │
                             ▼ (Port 80 / 22)
        ┌─────────────────────────────────────────┐
        │        Web Subnet (10.0.1.0/24)         │
        │  ┌───────────────────────────────────┐  │
        │  │      Book-Review-Web-VM           │  │
        │  │  • Nginx Reverse Proxy (Port 80)  │  │
        │  │  • Next.js Frontend (Port 3000)   │  │
        │  └─────────────────┬─────────────────┘  │
        └────────────────────┼────────────────────┘
                             │
                             ▼ Private VNet Routing (Port 3001 / 22)
        ┌─────────────────────────────────────────┐
        │        App Subnet (10.0.2.0/24)         │
        │  ┌───────────────────────────────────┐  │
        │  │      Book-Review-App-VM           │  │
        │  │  • Express REST API (Port 3001)   │  │
        │  │  • Process Manager (PM2)          │  │
        │  └─────────────────┬─────────────────┘  │
        └────────────────────┼────────────────────┘
                             │
                             ▼ Private MySQL Protocol (Port 3306 + SSL)
        ┌─────────────────────────────────────────┐
        │        DB Subnet (10.0.3.0/24)          │
        │  ┌───────────────────────────────────┐  │
        │  │  Azure Database for MySQL         │  │
        │  │  • Flexible Server                │  │
        │  │  • bookreviewdb (Encrypted)       │  │
        │  └───────────────────────────────────┘  │
        └─────────────────────────────────────────┘

---

## 3. Tier Configuration & Security Hardening

### 3.1 Web Tier (Presentation)
* **Nginx Configuration:** Functions as an edge reverse proxy routing root requests (`/`) to the Next.js process (`localhost:3000`) and API requests (`/api/*`) directly across the private VNet to the App Tier (`http://10.0.2.4:3001`).
* **Process Management:** Next.js application managed and monitored continuously via PM2 (`book-review-web`).
* **Security Controls:** Inbound traffic restricted to HTTP (`80`) and SSH (`22`).

### 3.2 App Tier (Business Logic)
* **API Engine:** Express.js REST API providing user authentication, book catalog management, and review operations.
* **CORS & Environment Isolation:** Secure cross-origin resource handling configured to allow proxy forwarding from the Web VM.
* **Security Controls:** Strict NSG rules blocking all direct public ingress. Port `3001` and `22` are only accessible via internal routing from `10.0.1.0/24`.

### 3.3 Database Tier (Persistence)
* **Azure Database for MySQL Flexible Server:** Configured within a delegated private subnet with SSL encryption (`--ssl-mode=REQUIRED`).
* **Data Integrity:** Foreign key constraints between `Users`, `Books`, and `Reviews` tables ensure referential integrity.

---

## 4. Verification & Testing Evidence

### Screenshot 19: Application Availability (Public Access)
* **Objective:** Verify end-to-end presentation tier delivery via public IP.
* **Result:** Web homepage accessed successfully via `http://134.112.16.143`, rendering the catalog and user interface.

### Screenshot 20: Database Read and Write Verification
* **Objective:** Validate end-to-end transactional data flow across all three tiers.
* **Result:** 
  1. A new user account was registered via `/api/users/register` and authenticated via JWT.
  2. A new book review was authored and posted to the database.
  3. The written record was verified live in both the UI and via MySQL direct query:
     ```sql
     SELECT id, name, email FROM Users;
     SELECT id, bookId, rating, comment FROM Reviews ORDER BY id DESC LIMIT 2;
     ```

### Screenshot 21: Private Subnet Isolation
* **Objective:** Prove that the private App and Database subnets cannot be reached directly from the open internet.
* **Result:** Running `curl --connect-timeout 5 http://10.0.2.4:3001` and direct SSH from the external development workstation timed out as expected, proving network perimeter security.

### Screenshot 22: Infrastructure Availability & Health Probes
* **Objective:** Confirm load balancing health and target availability.
* **Result:** Azure portal diagnostics show health probes reporting `100%` healthy backend targets.

---

## 5. Key Challenges & Technical Resolutions

1. **Client-Side API Path Resolution:**
   * *Issue:* The frontend defaulted requests to `localhost:3001`, causing client browser calls to fail.
   * *Resolution:* Standardized frontend routing through the Nginx reverse proxy using relative `/api` paths with Next.js environment configurations (`NEXT_PUBLIC_API_URL=/api`).
2. **CORS Policy Enforcement in Multi-Tier Routing:**
   * *Issue:* Strict origin validation on Express blocked requests forwarded across Nginx.
   * *Resolution:* Configured permissive, credential-aware CORS middleware on Express to accept reverse-proxied traffic.
3. **Database Schema & Route Factory Parameter Injection:**
   * *Issue:* Route handlers required the instantiated Sequelize database object rather than module imports.
   * *Resolution:* Refactored `server.js` to instantiate the SSL-enabled Sequelize connection and pass it to user, book, and review route factories.

---

## 6. Conclusion

The three-tier architecture deployment on Microsoft Azure was completed and verified. The application fulfills all security, isolation, and operational requirements, ensuring resilient separation between public web traffic, business logic execution, and relational data storage.

---

# Submission Instructions

- Add all required screenshots and links in your submission
- Do not expose passwords, keys, connection strings, or subscription IDs

---

# Completion Checklist

- [✅] Task 1: Architecture diagram and assumptions documented (Screenshots 1–2)
- [✅] Task 2: Network foundation created with isolated tiers (Screenshots 3–5)
- [✅] Task 3: Least-privilege security and secret management configured (Screenshots 6–7)
- [✅] Task 4: Presentation tier deployed (Screenshots 8–9)
- [✅] Task 5: Application tier deployed privately (Screenshots 10–12)
- [✅] Task 6: Managed database tier deployed privately (Screenshots 13–15)
- [✅] Task 7: Public entry, internal routing, and monitoring configured (Screenshots 16–18)
- [✅] Task 8: End-to-end validation and availability test completed (Screenshots 19–22, Public Endpoint, Notes)
- [✅] No sensitive data exposed

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

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
