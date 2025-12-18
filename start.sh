#!/bin/bash

# Deploy script for Render
echo "🚀 Starting deployment..."

# Deploy database
echo "📦 Deploying database..."
cds deploy --to sqlite:db.sqlite

# Start the server
echo "🌟 Starting CAP server..."
cds-serve