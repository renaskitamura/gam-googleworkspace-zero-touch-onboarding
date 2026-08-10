#!/bin/bash

#!/bin/bash

# ==========================================
# USER CONFIGURATION REQUIRED
# Please update the variables below before running
# ==========================================

INPUT_FILE="new_volunteers.csv"
LOG_FILE="onboarding.log"
TEMPLATE_FILE="email_template.html"

# CHANGE THIS: Your Google Workspace domain (e.g., "company.com")
DOMAIN="yourdomain.org" 

# CHANGE THIS: The email of the admin account authorized in GAM
ADMIN_EMAIL="admin@yourdomain.org" 

# ==========================================

# Check if the CSV file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: $INPUT_FILE not found!"
    exit 1
fi

# Check if the email template exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: $TEMPLATE_FILE not found!"
    exit 1
fi

echo "Starting onboarding process..."

while IFS=',' read -r first_name last_name personal_email group_name
do
    if [ "$first_name" == "FirstName" ]; then
        continue
    fi

    new_email="${first_name,,}.${last_name,,}@${DOMAIN}"
    temp_password=$(openssl rand -base64 12) # Generates a random secure password

    echo "Processing user: $new_email..."
    temp_password=$(openssl rand -base64 12)

    # 1. Create the user and tell Google to send the password reset link
    gam create user "$new_email" firstname "$first_name" lastname "$last_name" password "$temp_password" changepassword on

    # 2. Add to Google Group
    gam update group "$group_name" add member user "$new_email"

    # 3. Replace placeholders and save to a temporary file (Using | to avoid password character conflicts)
    sed -e "s|{{FIRST_NAME}}|$first_name|g" \
        -e "s|{{EMAIL}}|$new_email|g" \
        -e "s|{{PASSWORD}}|$temp_password|g" \
        "$TEMPLATE_FILE" > temp_email.html

    # 4. Tell GAM to read the email body directly from the temporary file
    echo "Sending welcome email to $personal_email..."
    gam user "$ADMIN_EMAIL" sendemail recipient "$personal_email" subject "Welcome to Take Trips MES - Login Instructions" htmlfile temp_email.html
    
    # Clean up the temporary file so it doesn't clutter your folder
    rm temp_email.html

    # 5. Log the action
    echo "$(date '+%Y-%m-%d %H:%M:%S') - CREATED: $new_email | ADDED TO: $group_name | EMAILED: $personal_email" >> "$LOG_FILE"

done < "$INPUT_FILE"

echo "Onboarding complete. Check $LOG_FILE for details."
