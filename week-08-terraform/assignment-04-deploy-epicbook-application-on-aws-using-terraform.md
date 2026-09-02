# Assignment 4 — Deploy EpicBook Application on AWS Using Terraform

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will use Terraform to provision AWS network infrastructure (VPC, public/private subnets, Security Groups), launch an Ubuntu 22.04 EC2 instance, and provision a private Amazon RDS for MySQL instance. You will then deploy EpicBook, connect it to MySQL, and validate the complete user flow.

---

# Task 1 — Create Network Infrastructure with Terraform

## Goal

Define a VPC (10.0.0.0/16) with a public subnet (10.0.1.0/24) and private subnet (10.0.2.0/24), an Internet Gateway with public routing, an EC2 Security Group (SSH 22, HTTP 80), and an RDS Security Group (MySQL 3306 only from the EC2 Security Group).

### Evidence

#### Screenshot 1 — Terraform configuration showing the VPC and both subnet CIDR ranges

![tf-config](screenshots/vpc-bothsubnts.png)

---

#### Screenshot 2 — Terraform configuration showing the Internet Gateway, public route table, and both Security Groups

![tf config](screenshots/aws-intgw-prt.png)

---

# Task 2 — Provision EC2 Virtual Machine (Ubuntu 22.04)

## Goal

Use Terraform to launch a t2.micro Ubuntu 22.04 EC2 instance in the public subnet with a public IP, then install Node.js, npm, Git, Nginx, and MySQL client.

### Evidence

#### Screenshot 3 — Terraform apply output showing successful EC2 provisioning

![tf apply](screenshots/tfapply-aws.png)

---

#### Screenshot 4 — EC2 instance running in the AWS Console with the public IP and subnet visible

![EC2 instance running](screenshots/pubicip-svis-aws.png)

---

#### Screenshot 5 — Terminal showing successful SSH access and installed software

![ssh successful](screenshots/ssh-aws-success.png)

---

# Task 3 — Deploy the EpicBook Application

## Goal

Deploy the EpicBook frontend and backend on the EC2 instance and configure Nginx to serve it, following the Installation, Configuration & Troubleshooting Guide.

### Evidence

#### Screenshot 6 — Terminal showing the EpicBook application files and dependency installation

![dependency installation](screenshots/versions-aws.png)

---

#### Screenshot 7 — Terminal showing the application and Nginx services running

![running](screenshots/nginx-aws-running.png)

---

# Task 4 — Set Up Amazon RDS for MySQL with Terraform

## Goal

Provision a private Amazon RDS MySQL instance (db.t3.micro, Publicly accessible: false) restricted to the EC2 Security Group, then initialize the database using the provided SQL dump and connect the EpicBook backend to it.

### Evidence

#### Screenshot 8 — Terraform apply output showing successful RDS provisioning

![tf apply](screenshots/tfapply-aws.png)

---

#### Screenshot 9 — RDS instance in the AWS Console showing the private network configuration and Publicly accessible: No

![rds aws console](screenshots/cee.png)

---

#### Screenshot 10 — Terminal showing successful database initialization or table verification from EC2

![table verification](screenshots/sql-bdaws.png)

---

# Task 5 — Test End-to-End Functionality

## Goal

Confirm EpicBook is accessible through the EC2 public IP and that navigation, cart, order summary, and checkout all work against the MySQL backend.

### Evidence

#### Screenshot 11 — Browser showing the EpicBook application through the EC2 public IP

![port 8080](screenshots/port-8080aws.png)
![browser showing epicbook](screenshots/epicbk-aws.png)

---

#### Screenshot 12 — Browser showing a working product, cart, order summary, or checkout flow

![check out flow](screenshots/checkoutflow-aws.png)

---

### Notes

Write a short note describing any issue you faced, how you fixed it, and what you learned.

Challenge 1: Free-Tier Instance Type Incompatibility (t2.micro vs. t3.micro)

Issue: During the execution of terraform apply, AWS returned an InvalidParameterCombination error stating that t2.micro was not eligible for Free Tier in the target region.

Resolution: Updated the EC2 module variable default in modules/ec2/variables.tf from t2.micro to t3.micro and re-applied the configuration.

Lesson Learned: AWS periodically shifts default Free Tier eligible instance families across regions and newer accounts. Decoupling instance sizing into modular variables makes adapting to account-specific constraints quick and seamless.

Challenge 2: Conflicting Pre-Existing AWS Resources & Missing Key Pair

Issue: The initial deployment halted due to an InvalidKeyPair.NotFound error from a placeholder key pair name in terraform.tfvars, along with a DBSubnetGroupAlreadyExists conflict from a lingering RDS subnet group.

Resolution: Cleaned up the orphaned RDS DB subnet group via the AWS CLI (aws rds delete-db-subnet-group), queried existing key pairs, and configured the correct key pair (react) in terraform.tfvars.

Lesson Learned: Terraform expects full ownership of declared resources. Proper state alignment and verification of account prerequisites before provisioning prevents resource naming collisions and pipeline interruptions.

Challenge 3: Cross-Platform SSH Key Resolution (PowerShell vs. POSIX Pathing)

Issue: Attempting to connect via SSH from PowerShell using Unix-style paths (/c/Users/...) resulted in a No such file or directory warning and denied authentication.

Resolution: Corrected the path formatting to standard Windows notation ("C:\Users\user\Downloads\react.pem") to successfully open the SSH tunnel.

Lesson Learned: Shell environments interpret filesystem paths differently; ensuring CLI commands respect host OS syntax prevents false connectivity troubleshooting.

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about what you achieved in this assignment, with public or "Anyone" visibility.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/henrietta-ogochukwu-onyeabor_devops-aws-terraform-activity-7500200458670657536-Xfao?utm_source=share&utm_medium=member_desktop&rcm=ACoAACLZGVcB6FzOlcovzi-lUsceaYDsGRsJUSU`

---

#### Screenshot 13 — Published LinkedIn post showing the text and at least one image or proof

![pub linkedin post](screenshots/linkd-ass5-wk8.png)

---

# Submission Instructions

- Add all required screenshots in your submission
- Include the EC2 public IP
- Do not expose database passwords, private keys, or other secrets

---

# Completion Checklist

- [✅] Task 1: VPC, subnets, IGW, and Security Groups created with Terraform (Screenshots 1–2)
- [✅] Task 2: EC2 provisioned and required software installed (Screenshots 3–5)
- [✅] Task 3: EpicBook deployed and Nginx serving the app (Screenshots 6–7)
- [✅] Task 4: Private RDS MySQL created and database initialized (Screenshots 8–10)
- [✅] Task 5: End-to-end functionality validated (Screenshots 11–12)
- [✅] Issue/fix/learning note written (Notes)
- [✅] LinkedIn post published and URL submitted (Screenshot 13)
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
