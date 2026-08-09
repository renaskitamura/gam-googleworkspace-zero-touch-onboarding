# Google Workspace Zero-Touch Onboarding Pipeline

## Overview
This repository contains a Bash-based Identity and Access Management (IAM) automation script. It leverages the Google Workspace Admin SDK (via GAM) to fully automate the user provisioning lifecycle, transforming a manual helpdesk task into a streamlined, infrastructure-as-code pipeline.

## The Problem
Manual user onboarding in Google Workspace is time-consuming and prone to human error. IT administrators traditionally have to:
1. Manually create user accounts.
2. Use Google Workspace's native auto-generation password feature, securely triggering the official Google setup email and enforcing a mandatory reset upon first login.
3. Assign users to correct organizational groups and chat spaces.
4. Draft and send personalized e-mail with welcome instructions.

## The Solution
This script completely automates the workflow by parsing a CSV data file and executing secure API calls to handle account creation, Role-Based Access Control (RBAC), and credential delivery in seconds. 

## Key Features
* **Bulk User Provisioning:** Parses CSV files to create user accounts at scale.
* **Native Security Integration:** Leverages Google Workspace's native password auto-generation to securely deliver credentials and enforce first-time login resets without exposing passwords in plain text.
* **Dynamic RBAC & Space Syncing:** Automatically assigns users to designated Google Groups based on their department, instantly granting access to associated Google Chat Spaces and shared resources.
* **Custom Credential Delivery:** Utilizes the Gmail API to inject user details into a standardized HTML template, automatically emailing welcome instructions directly to the user's personal inbox.
* **Audit Logging:** Appends execution details (timestamps, emails, and group assignments) to a local log file for security auditing and compliance.

## Technology Stack
* **Language:** Bash Scripting
* **APIs:** Google Admin SDK, Gmail API
* **CLI Tool:** [GAM (Google Workspace Manager)](https://github.com/GAM-team/GAM)
* **Version Control:** Git

## Configuration & Setup
Before running this script, you must update the placeholder variables to match your specific Google Workspace environment.

**In `onboard_users.sh`:**
* Update `DOMAIN="yourdomain.org"` with your actual Google Workspace domain.
* Update `ADMIN_EMAIL="admin@yourdomain.org"` with the email address of the GAM administrator.

**In `email_template.html`:**
* Replace all bracketed text (e.g., `[Organization Name]`, `[HR Contact 1]`) with your organization's actual information.

## How It Works
1. IT updates `new_volunteers.csv` with the incoming user's Name, Personal Email, and designated Google Group.
2. The `onboard_users.sh` script is executed.
3. The script loops through the CSV, bypassing the header row, and constructs the standardized organizational email address.
4. GAM authenticates with the Google Cloud project to provision the account, apply group memberships, and dispatch the `email_template.html` payload.
5. The transaction is recorded in `onboarding.log`.

---
*Note: Sensitive files such as `new_volunteers.csv` was stripped form real world data and 'onboarding.log' was excluded from this repository via `.gitignore` to maintain security best practices.*
