# Assignment 03 — Deploy a Static Website to Multiple Servers Using a Multi-Play Ansible Playbook

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Student Details

**Full Name:** Add your full name here  
**Cloud Platform Used:** AWS / Azure  
**Server 1 URL:** `http://98.93.215.207`  
**Server 2 URL:** `http://3.84.186.75`

---

## Purpose

In this assignment, you will create a multi-play Ansible playbook to install Nginx, deploy a static website to two Ubuntu servers, and verify that the website is accessible from both servers.

You may use either AWS EC2 instances or Azure Virtual Machines as your managed servers.

---

# Task 1 — Create the Project Structure

## Goal

Create the required folders and files for the Ansible project.

## Evidence

### Screenshot 1 — Terminal or VS Code showing the complete `static-web` project structure

![static web proj structure](screenshots/staticweb-struc.png)

---

# Task 2 — Configure the Ansible Inventory

## Goal

Add both Ubuntu servers to the Ansible inventory.

## Evidence

### Screenshot 2 — Output of `ansible-inventory -i inventory.ini --graph` showing `web1` and `web2`

![web1 and web2](screenshots/web1-2-ans.png)

---

## Configuration File

Copy and paste the complete contents of your `inventory.ini` file below:

```ini
[web]
web1 ansible_host=98.93.215.207
web2 ansible_host=3.84.186.75

[web:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_ed25519
ansible_ssh_common_args=-o StrictHostKeyChecking=no
```

---

# Task 3 — Verify Ansible Connectivity

## Goal

Confirm that the Ansible controller can connect to both servers.

## Evidence

### Screenshot 3 — Ansible ping output showing `SUCCESS` and `pong` for both servers

![SUCCESS Output](screenshots/ping-web.png)

---

# Task 4 — Download and Personalize the Static Website

## Goal

Download `index.html` to the Ansible controller and personalize the website with your full name.

## Evidence

### Screenshot 4 — Edited `files/index.html` showing the footer line with your full name

![html footer fullname](html-footer.png)

---

# Task 5 — Create the Multi-Play Ansible Playbook

## Goal

Create a single Ansible playbook containing separate plays for installation, deployment, and verification.

## Configuration File

Copy and paste the complete contents of your `site.yml` file below:

```yaml
site.yml
---
- name: Install and configure Nginx
  hosts: web
  become: true
  tasks:
    - name: Update the APT package cache
      ansible.builtin.apt:
        update_cache: true
        cache_valid_time: 3600

    - name: Install Nginx
      ansible.builtin.apt:
        name: nginx
        state: present

    - name: Start and enable Nginx
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true

- name: Deploy the static website
  hosts: web
  become: true
  tasks:
    - name: Copy index.html to the web root
      ansible.builtin.copy:
        src: files/index.html
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: "0644"
      notify: Reload nginx

  handlers:
    - name: Reload nginx
      ansible.builtin.service:
        name: nginx
        state: reloaded

- name: Verify both websites from the controller
  hosts: localhost
  connection: local
  gather_facts: false
  become: false
  tasks:
    - name: Send an HTTP GET request to each web server
      ansible.builtin.uri:
        url: "http://{{ hostvars[item].ansible_host }}"
        status_code: 200
      loop: "{{ groups['web'] }}"
      register: website_checks

    - name: Confirm each server returned HTTP 200
      ansible.builtin.assert:
        that:
          - item.status == 200
        success_msg: "{{ item.item }} returned HTTP {{ item.status }}"
      loop: "{{ website_checks.results }}"
```

---

# Task 6 — Validate the Playbook Syntax

## Goal

Check the playbook for YAML or Ansible syntax errors before running it.

## Evidence

### Screenshot 5 — Successful syntax-check output showing `playbook: site.yml`

![playbook: site.yml](screenshots/site-yml.png)

---

# Task 7 — Run the Multi-Play Playbook

## Goal

Install Nginx, deploy the website, and verify both servers in one playbook run.

## Evidence

### Screenshot 6 — Play 3 verification showing HTTP `200` for both servers

![verification](screenshots/verificatn-1.png)
![verification](screenshots/verificatn-2.png)
![verification](screenshots/verificatn-3.png)


---

### Screenshot 7 — Final play recap showing `unreachable=0` and `failed=0` for `web1`, `web2`, and `localhost`

![verification](screenshots/verificatn-4.png)

---

# Task 8 — Verify Idempotency

## Goal

Run the playbook again and confirm that it does not make unnecessary changes.

## Evidence

### Screenshot 8 — Second playbook run showing the play recap with `changed=0`, `unreachable=0`, and `failed=0` for both web servers

![second playbook](screenshots/2ndveri-1.png)
![second playbook](screenshots/2ndveri-2.png)
![second playbook](screenshots/2ndveri-3.png)
![second playbook](screenshots/2ndveri-4.png)
---

# Task 9 — Test Both Websites Manually

## Goal

Confirm that the static website is accessible from both public IP addresses.

## Evidence

### Screenshot 9 — `curl -I` output showing HTTP `200 OK` from both servers

![200 ok](screenshots/output-200-ans.png)

---

### Screenshot 10 — Browser showing the website from Server 1 with the public IP and your full name visible

![browser](screenshots/ist-browser.png)

---

### Screenshot 11 — Browser showing the website from Server 2 with the public IP and your full name visible

![browser](screenshots/2nd-browser.png)

---

## Website URLs

Add both deployed website URLs below:

```text
Server 1: http://98.93.215.207
Server 2: http://3.84.186.75
```

---

# Task 10 — Complete the Project README

## Goal

Document how the project works and record what you learned.

## README Content

Copy and paste the complete contents of your `README.md` file below:

```markdown
# Multi-Play Ansible Static Website Deployment

## Project Overview
This project automates the provisioning, deployment, and health verification of a static marketing website across a multi-node Ubuntu server fleet on AWS using a multi-play Ansible playbook.

## Environment
- Cloud platform: AWS (EC2)
- Operating system: Ubuntu 22.04 LTS
- Number of managed servers: 2 (web1, web2)
- Web server: Nginx

## How to Run the Playbook
Ensure your Python virtual environment is activated and execute:
```bash
ansible-playbook -i inventory.ini site.yml                                                                                                                                                                                  Issue Faced and Solution
During repeated playbook executions, refreshing the APT package cache unnecessarily triggered change events. I configured cache_valid_time: 3600 on the ansible.builtin.apt task, ensuring the package repository index is only polled if the local cache is older than one hour, achieving true changed=0 idempotency on subsequent runs.

What I Learned
I learned how to divide an end-to-end automation workflow into logically distinct plays (infrastructure configuration, content deployment, and client verification). I also learned how to use event-driven handlers (notify) so services only reload when managed files change.

Why Installation and Deployment Are Separate
Separating installation from deployment decouples system-level dependencies from application release lifecycles. Base server configuration changes infrequently, whereas application artifacts update continuously. Dividing them into separate plays improves readability, limits the blast radius of changes, and simplifies maintenance.

Benefit of the Ansible Copy Module
The ansible.builtin.copy module allows the controller to act as the single source of truth for deployment artifacts without requiring Git credentials or deployment keys to be placed on production nodes. Additionally, it computes cryptographic checksums so that file transfers and notifications occur only when source content actually differs.

```

---

# LinkedIn Post Required

## Evidence

### LinkedIn Post URL

Paste your LinkedIn post URL here:

`Add your URL here`

---

### Screenshot — Published LinkedIn post

Add your screenshot here.

---

# Assignment Questions

Answer the following in your own words:

**1. What issue did you face while completing this assignment, and how did you fix it?**

During repeated playbook executions, refreshing the APT package cache unnecessarily triggered change events. I configured cache_valid_time: 3600 on the ansible.builtin.apt task, ensuring the package repository index is only polled if the local cache is older than one hour, achieving true changed=0 idempotency on subsequent runs.

---

**2. What did you learn from this assignment?**

I learned how to divide an end-to-end automation workflow into logically distinct plays (infrastructure configuration, content deployment, and client verification). I also learned how to use event-driven handlers (notify) so services only reload when managed files change.

---

**3. Why is it useful to split installation, deployment, and verification into separate plays?**

Separating installation from deployment decouples system-level dependencies from application release lifecycles. Base server configuration changes infrequently, whereas application artifacts update continuously. Dividing them into separate plays improves readability, limits the blast radius of changes, and simplifies maintenance.

---

**4. What is one benefit of using the Ansible `copy` module instead of cloning the website directly from Git on every managed server?**

The ansible.builtin.copy module allows the controller to act as the single source of truth for deployment artifacts without requiring Git credentials or deployment keys to be placed on production nodes. Additionally, it computes cryptographic checksums so that file transfers and notifications occur only when source content actually differs.

---

**5. What does idempotency mean in this assignment?**

Idempotency means that running the playbook multiple times results in the same desired end state without performing unnecessary operations. In this assignment, it was demonstrated when the second playbook run reported ok (not changed) for the Nginx installation, HTML file copy, and service reload. Because the actual system state already matched the declared playbook state, Ansible correctly skipped those tasks on the repeat execution.

---

**6. What does the Ansible `uri` module verify in Play 3?**

It verifies end-to-end network reachability and web server status. The uri module, running programmatically from the controller machine (localhost), sends a real HTTP GET request over port 80 to the public IP address of each managed node. This confirms that the Nginx daemon is running, the AWS security group allows HTTP ingress traffic, and the server successfully returns the expected HTTP 200 OK status code.

---

# Required Files

Confirm that the following files are included in your assignment folder:

- [ ] `inventory.ini`
- [ ] `site.yml`
- [ ] `files/index.html`
- [ ] `README.md`

---

# Submission Instructions

- Add all required screenshots in the correct order.
- Full Name must be visible in required screenshots.
- Include both deployed website URLs.
- Paste `inventory.ini`, `site.yml`, and `README.md` as editable text.
- Answer all assignment questions clearly in your own words.
- Add your LinkedIn post URL.
- Do not expose SSH private keys, passwords, cloud account IDs, or other sensitive information.

---

# Completion Checklist

- [ ] Task 1: `static-web` folder structure is complete
- [ ] Task 2: Both servers are listed under the `[web]` group in `inventory.ini`
- [ ] Task 2: Inventory graph shows `web1` and `web2`
- [ ] Task 3: Ansible ping returns `SUCCESS` and `pong` for both servers
- [ ] Task 4: `files/index.html` contains your full name
- [ ] Task 5: `site.yml` contains three separate plays
- [ ] Task 5: Play 1 installs, starts, and enables Nginx
- [ ] Task 5: Play 2 deploys `index.html` using the `copy` module
- [ ] Task 5: Nginx reload handler is included
- [ ] Task 5: Play 3 verifies both web servers from the controller
- [ ] Task 6: Playbook syntax check passes
- [ ] Task 7: First playbook run completes with `unreachable=0` and `failed=0`
- [ ] Task 7: URI verification returns HTTP `200` for both servers
- [ ] Task 8: Second playbook run demonstrates idempotency
- [ ] Task 8: Second run shows `changed=0` for both web servers
- [ ] Task 9: Both `curl -I` commands return HTTP `200 OK`
- [ ] Task 9: Website loads from Server 1
- [ ] Task 9: Website loads from Server 2
- [ ] Task 9: Full name is visible on both deployed websites
- [ ] Task 10: `README.md` contains all required explanations
- [ ] Screenshots 1–11 are included
- [ ] `inventory.ini`, `site.yml`, and `README.md` are pasted as editable text
- [ ] Both website URLs are included
- [ ] Assignment questions are answered
- [ ] LinkedIn post published
- [ ] LinkedIn post URL added
- [ ] No sensitive information is exposed

---

## About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra and The CloudAdvisory, focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## Resources

- DMI Official Website: [https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme](https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme)
- University: [https://university.pravinmishra.com?utm_source=github&utm_medium=readme](https://university.pravinmishra.com?utm_source=github&utm_medium=readme)
- Discord Community: [https://discord.pravinmishra.com?utm_source=github&utm_medium=readme](https://discord.pravinmishra.com?utm_source=github&utm_medium=readme)
- Blog: [https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme](https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme)
- YouTube Playlist: [https://www.youtube.com/playlist?list=PLFeSNDtI4Cho](https://www.youtube.com/playlist?list=PLFeSNDtI4Cho)
- Pravin Mishra LinkedIn: [https://www.linkedin.com/in/pravin-mishra-aws-trainer/](https://www.linkedin.com/in/pravin-mishra-aws-trainer/)
- CloudAdvisory LinkedIn: [https://www.linkedin.com/company/thecloudadvisory/](https://www.linkedin.com/company/thecloudadvisory/)

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*