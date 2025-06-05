#!/bin/bash

# PRISMON OS Website Deployment Script
# Prepares and deploys the website to various hosting platforms

set -e

WEBSITE_DIR="/home/hirday-veer/OS" # Updated to reflect the actual location of index.html
BUILD_DIR="/tmp/prismos-website-build"
VERSION=$(date +"%Y%m%d_%H%M%S")

# Derive remote repository info
REMOTE_URL=$(git -C "$WEBSITE_DIR" remote get-url origin)
if [[ "$REMOTE_URL" =~ github.com[:/](.+)/(.+?)(\.git)?$ ]]; then
  GITHUB_USER=${BASH_REMATCH[1]}
  GITHUB_REPO=${BASH_REMATCH[2]}
else
  echo "❌ Unable to parse GitHub remote URL: $REMOTE_URL"
  exit 1
fi

echo "🚀 PRISMON OS Website Deployment Script"
echo "📅 Version: $VERSION"
echo ""
echo "🏠 Current website directory: $WEBSITE_DIR" # Added for clarity
echo "🔨 Build directory: $BUILD_DIR" # Added for clarity
echo ""

# Function to create optimized build
create_build() {
    echo "📦 Creating optimized build..."
    
    # Clean and create build directory
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"
    
    # Check if the main HTML file exists
    if [ ! -f "$WEBSITE_DIR/index.html" ]; then
        echo "❌ Main website file not found: $WEBSITE_DIR/index.html"
        exit 1
    fi

    # Copy website files (specifically index.html and any assets if they were in a subfolder)
    cp "$WEBSITE_DIR/index.html" "$BUILD_DIR/"
    # If you have CSS, JS, or image folders, copy them too. For example:
    # cp -r "$WEBSITE_DIR/css" "$BUILD_DIR/"
    # cp -r "$WEBSITE_DIR/js" "$BUILD_DIR/"
    # cp -r "$WEBSITE_DIR/images" "$BUILD_DIR/"
    
    # Add version info to the end of the HTML file (before closing </html> tag)
    sed -i "s|</body>|<!-- PRISMON OS Website v$VERSION - Built $(date) -->\n</body>|" "$BUILD_DIR/index.html"
    
    echo "✅ Build created in: $BUILD_DIR"
}

# Function to validate build
validate_build() {
    echo "🔍 Validating build..."
    
    # Check required files
    required_files=(
        "index.html"
        # Add other critical files here if any, e.g., "css/style.css", "js/script.js"
    )
    
    for file in "${required_files[@]}"; do
        if [[ ! -f "$BUILD_DIR/$file" ]]; then
            echo "❌ Missing required file: $file"
            exit 1
        fi
    done
    
    # Check file sizes
    index_size=$(stat -f%z "$BUILD_DIR/index.html" 2>/dev/null || stat -c%s "$BUILD_DIR/index.html" 2>/dev/null)
    # Add size checks for other assets if needed
    
    echo "📊 File sizes:"
    echo "   - index.html: ${index_size} bytes"
    
    # Check if HTML is valid (basic check)
    if ! grep -q "</html>" "$BUILD_DIR/index.html"; then
        echo "⚠️  Warning: HTML file might be incomplete"
    fi
    
    echo "✅ Build validation passed"
}

# Function to deploy to GitHub Pages
deploy_github_pages() {
    echo "🐙 Deploying to GitHub Pages via temporary clone..."

    # Clone gh-pages branch into a temporary directory
    TMP_DIR=$(mktemp -d)
    # Attempt to clone gh-pages, fallback to creating orphan branch
    if git clone --branch gh-pages "$REMOTE_URL" "$TMP_DIR"; then
        echo "ℹ️  Cloned existing gh-pages branch"
    else
        git clone "$REMOTE_URL" "$TMP_DIR"
        cd "$TMP_DIR"
        git checkout --orphan gh-pages
        git rm -rf .
        echo "ℹ️  Initialized new gh-pages orphan branch"
    fi

    # Clear all files except .git
    cd "$TMP_DIR"
    find . -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +
    
    # Copy build artifacts
    cp -r "$BUILD_DIR"/* "$TMP_DIR"/
    
    # Commit and push
    cd "$TMP_DIR"
    git add .
    git config user.name "PRISMON OS Deploy Bot"
    git config user.email "deploy@prismonos.com"
    
    # Check if this is an empty repository (no commits yet)
    if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
        # First commit to empty repository
        git commit -m "Initial deploy of PRISMON OS website v$VERSION"
        git push origin gh-pages
        echo "✅ Successfully created and pushed initial gh-pages branch."
        echo "🌐 Your website is live at: https://${GITHUB_USER}.github.io/${GITHUB_REPO}/"
    elif git diff-index --quiet HEAD -- 2>/dev/null; then
        echo "ℹ️ No changes to commit. Website is up-to-date."
    else
        git commit -m "Deploy website v$VERSION"
        git push origin gh-pages
        echo "✅ Successfully pushed gh-pages branch."
        echo "🌐 Your website is live at: https://${GITHUB_USER}.github.io/${GITHUB_REPO}/"
    fi
    rm -rf "$TMP_DIR"
}

# Function to create ZIP for manual deployment
create_zip() {
    echo "📦 Creating ZIP archive for manual deployment..."
    
    ZIP_FILE="/home/hirday-veer/OS/prismos-website-v$VERSION.zip"
    
    cd "$BUILD_DIR"
    zip -r "$ZIP_FILE" . -x "*.DS_Store" "*.git*"
    
    echo "✅ ZIP archive created: $ZIP_FILE"
    echo "📤 You can upload this ZIP to any static hosting service"
}

# Function to test build locally
test_build() {
    echo "🧪 Testing build locally..."
    
    cd "$BUILD_DIR"
    echo "🌐 Starting test server at http://localhost:8080"
    echo "⏹️  Press Ctrl+C to stop"
    
    if command -v python3 &> /dev/null; then
        python3 -m http.server 8080
    elif command -v python &> /dev/null; then
        python -m SimpleHTTPServer 8080
    else
        echo "❌ Python not found. Please install Python to test locally."
        exit 1
    fi
}

# Function to show deployment options
show_menu() {
    echo "🎯 Deployment Options:"
    echo "1) Test build locally"
    echo "2) Deploy to GitHub Pages"
    echo "3) Create ZIP for manual deployment"
    echo "4) Create build only"
    echo "5) Exit"
    echo ""
    read -p "Choose an option (1-5): " choice
    
    case $choice in
        1)
            create_build
            validate_build
            test_build
            ;;
        2)
            create_build
            validate_build
            deploy_github_pages
            ;;
        3)
            create_build
            validate_build
            create_zip
            ;;
        4)
            create_build
            validate_build
            echo "✅ Build ready in: $BUILD_DIR"
            ;;
        5)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid option"
            show_menu
            ;;
    esac
}

# Function to show quick deployment tips
show_tips() {
    echo ""
    echo "💡 Quick Deployment Tips:"
    echo ""
    echo "🌐 Static Hosting Options:"
    echo "   • GitHub Pages: Free, easy integration with your repo"
    echo "   • Netlify: Drag & drop ZIP file for instant deployment"
    echo "   • Vercel: Connect GitHub repo for automatic deployments"
    echo "   • Firebase Hosting: Google's static hosting with CDN"
    echo ""
    echo "📋 Before deploying:"
    echo "   • Test locally first (option 1)"
    echo "   • Update download links to point to actual ISO files"
    echo "   • Configure analytics (Google Analytics, etc.)"
    echo "   • Set up custom domain if needed"
    echo ""
    echo "🔧 For production:"
    echo "   • Enable HTTPS (most hosts do this automatically)"
    echo "   • Configure CDN for better performance"
    echo "   • Set up monitoring and analytics"
    echo ""
}

# Main execution
echo "🏠 Current website directory: $WEBSITE_DIR"
echo "🔨 Build directory: $BUILD_DIR"
echo ""

# Check if website directory exists
if [[ ! -d "$WEBSITE_DIR" ]]; then
    echo "❌ Website directory not found: $WEBSITE_DIR"
    exit 1
fi

show_tips
show_menu
