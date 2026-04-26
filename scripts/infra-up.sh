#!/bin/bash
set -e

# ---- Config --------------------------------
REPO="believion/devops-end-to-end-pipeline"
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DEV_DIR="$ROOT_DIR/terraform/environments/dev"
#---------------------------------------------

echo "🚀 Applying dev environment..."
terraform -chdir="$DEV_DIR" apply -auto-approve

echo "📡 Fetching new EC2 IP..."
NEW_IP=$(terraform -chdir="$DEV_DIR" output -raw ec2_public_ip)

if [ -z "$NEW_IP" ]; then
  echo "❌ Failed to get EC2 IP. Check terraform output."
  exit 1
fi

echo "New IP: $NEW_IP"

echo "🔐 Updating GitHub secret EC2_HOST..."
gh secret set EC2_HOST --body "$NEW_IP" --repo $REPO

echo "⏳ Waiting 90s for EC2 to finish booting..."
sleep 90


echo "✅ Done! EC2_HOST is now $NEW_IP"