# Assignment 7 — AI-Assisted Azure Security Posture Audit

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build a read-only Bash script that audits the Azure resources you deployed earlier this week — a virtual machine, a three-tier network with a Load Balancer, a Storage Account, and an Azure Database for MySQL server — for common security misconfigurations. You will connect that script to Claude Code as a reusable `/azure-audit` skill that explains findings and recommends a fix without ever running it, then fix one real finding yourself and prove the fix with a second audit run. This is the same read-only-evidence-then-human-fixes discipline from Week 3, now applied to Azure with the `az` CLI instead of Linux commands — and the cloud-agnostic counterpart to the AWS audit you built in Week 6.

---

# Task 1 — Confirm Your Resources and Create the Workspace

## Goal

Confirm your Azure CLI is authenticated and can see the VM, network, storage account, and MySQL server you built this week, then set up a workspace folder for the audit.

### Evidence

#### Screenshot 1 — `az account show` and `az vm list -d -o table` confirming your subscription and running VM (subscription ID partially blurred)

![az account show](screenshots/ai-health-scrn1-wk7.png)

---

# Task 2 — Create Project Context and Safety Rules in CLAUDE.md

## Goal

Create a `CLAUDE.md` for this workspace that tells Claude what the audit covers and the safety rules it must follow: never run a mutating `az` command, never claim a finding without report evidence, and always let the human review and run any remediation.

### Evidence

#### Screenshot 2 — `CLAUDE.md` open in your editor showing the project overview, audit workflow, and safety rules

![claudemd editor](screenshots/claudemd-ineditor-1.png)

---

# Task 3 — Use Agentic AI to Plan the Audit Before Writing the Script

## Goal

Ask Claude Code to read `CLAUDE.md` and propose a read-only, four-check audit plan (NSG rules open to `0.0.0.0/0` on port 22 or 3389, storage account public blob access, VM disk encryption status, and Azure Database for MySQL public network access) — without creating or editing any file yet.

### Evidence

#### Screenshot 3 — Claude Code showing the four-check plan, with no files created or modified

![Four check plan](screenshots/claude-4check-a-1.png)
![check contd](screenshots/check-contd-1.png)

---

# Task 4 — Build the Azure Audit Bash Script

## Goal

Write a Bash script that runs the four checks from Task 3 using read-only `az` commands, writes a PASS/WARN/FAIL report with your Full Name, and exits with a different code for a healthy, warning, or failing result. Validate it with `bash -n` and make it executable.

### Evidence

#### Screenshot 4 — Your script open in your editor, showing the check functions and the `az` commands they call

![az command 1](screenshots/az-commandp1-1.png)
![az command](screenshots/az-command2-1.png)

---

#### Screenshot 5 — Output of `bash -n` (no syntax errors) and `ls -l` showing the script is executable

![output](screenshots/output-bash-n-ls-l-1.png)

---

# Task 5 — Run the Script and Review the Baseline Report

## Goal

Run the script against your live resources and read the report honestly, even if it shows a real finding — do not fix anything yet.

### Evidence

#### Screenshot 6 — Script output showing your Full Name and all four checks with a PASS, WARN, or FAIL result

![script output](screenshots/scrn-6-wk7-ass7-1.png)

---

# Task 6 — Create and Run the /azure-audit Skill

## Goal

Create a Claude Code skill restricted to read-only tools (no `Write`) that runs your script, reads the report, and explains every finding with the risk of leaving it unresolved — without ever running a remediation command itself.

### Evidence

#### Screenshot 7 — Your skill file's frontmatter showing `allowed-tools` without `Write`

![allowed tools](screenshots/allowed-tools-1.png)

---

#### Screenshot 8 — `/azure-audit` output showing the baseline findings and Claude's explanation

![/azure-audit](screenshots/azure-audit1-1.png)
![/azure-audit](screenshots/azure-audit2-1.png)
---

# Task 7 — Fix a Real Finding and Re-Verify

## Goal

Pick one WARN or FAIL finding (or deliberately open an NSG rule to port 22 from `0.0.0.0/0` if your baseline was already clean), save that failing report, run the remediation command yourself — scoped to your own IP, not left open — and confirm the second audit run shows it resolved.

### Evidence

#### Screenshot 9 — Saved report showing the original finding before the fix

![original findings](screenshots/original-findings-1.png)

---

#### Screenshot 10 — Terminal output of the remediation command you ran yourself

![remediation](screenshots/remediation-1.png)

---

#### Screenshot 11 — Second `/azure-audit` run (or report) showing the finding resolved

**Finding Category Mappings Between AWS and Azure**

| AWS Finding Category (Week 6) | Azure Finding Category (Week 7) | Core Security Concern |
| :--- | :--- | :--- |
| **Security Group Inbound Rules** (`ec2 describe-sg`) | **Network Security Group Rules** (`az network nsg list`) | Unrestricted inbound access (0.0.0.0/0) on management ports (SSH/22, RDP/3389). |
| **S3 Block Public Access** (`s3control get-pab`) | **Storage Account Blob Public Access** (`allowBlobPublicAccess`) | Unauthenticated, anonymous public reads of sensitive cloud object storage. |
| **EBS Volume Encryption** (`ec2 describe-volumes`) | **VM OS Disk Encryption** (`storageProfile.osDisk...`) | Verification of data-at-rest encryption using platform or customer-managed keys. |
| **RDS Public Accessibility** (`rds describe-db`) | **Azure MySQL Public Access** (`network.publicNetworkAccess`) | Direct exposure of database ports to the public internet vs private subnets. |

---

**What Stayed Exactly the Same About the Workflow**

* **The Four-Phase Agentic Loop:** The sequence remained strictly **Gather $\rightarrow$ Analyze $\rightarrow$ Human Act $\rightarrow$ Verify**.
* **Deterministic Fact Gathering via Bash:** In both environments, a shell script executed read-only CLI commands and formatted raw findings into a standardized text report (`reports/azure-security-report.txt` vs `reports/aws-security-report.txt`) before AI engagement.
* **Separation of Concerns:** The CLI handled raw data collection, while Claude Code was restricted to analytical reasoning, risk calculation, and remediation recommendation.
* **Read-Only Safety Rails:** The Claude skills (`allowed-tools: Bash, Read, Grep`) strictly omitted `Write` access and explicitly prohibited executing destructive or mutating cloud CLI commands (`--yes`, `delete`, `terminate`).
* **Human-in-the-Loop Governance:** Remediation commands were proposed by the AI but required manual review and execution by the human engineer to ensure production safety and change control.
* **Closed-Loop Verification:** Both workflows concluded by re-running the deterministic audit script to generate a clean `after-fix-report.txt` proving that `FAIL: 0` was achieved.

---

### Notes

Compare this assignment to the AWS audit you built in Week 6: which finding categories map to each other across the two clouds, and what stayed exactly the same about the workflow even though the `az`/`aws` commands are completely different?

Add your answer here

---

# Submission Instructions

Complete all tasks in sequence.

Your submission must include:
- All 11 required screenshots
- Do not expose your Azure subscription ID, tenant ID, client secrets, or connection strings

---

# Completion Checklist

- [✅] Task 1: Azure resources confirmed and workspace created (Screenshot 1)
- [✅] Task 2: `CLAUDE.md` created with project context and safety rules (Screenshot 2)
- [✅] Task 3: Claude produced a read-only four-check plan before any script existed (Screenshot 3)
- [✅] Task 4: Audit script built, syntax-checked, and executable (Screenshots 4–5)
- [✅] Task 5: Baseline audit run and reviewed honestly (Screenshot 6)
- [✅] Task 6: `/azure-audit` skill created with no `Write` permission and run successfully (Screenshots 7–8)
- [✅] Task 7: A real finding fixed by you (not Claude) and re-verified as resolved (Screenshots 9–11)
- [✅] Notes comparing this to the Week 6 AWS audit completed
- [✅] No subscription IDs, tenant IDs, or credentials exposed

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
