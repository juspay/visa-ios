#!/bin/bash
set -e

# Usage: ./generate-version.sh [patch|minor|major] [--auto]
# If no argument provided, just generates files from current VERSION
# --auto flag: skip prompts (for CI/CD)

AUTO_MODE=false
BUMP_TYPE=""

# Parse arguments
for arg in "$@"; do
    if [ "$arg" = "--auto" ]; then
        AUTO_MODE=true
    else
        BUMP_TYPE="$arg"
    fi
done

VERSION_FILE="VERSION"
if [ ! -f "$VERSION_FILE" ]; then
    echo "Error: VERSION file not found"
    exit 1
fi

VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')

if [ -z "$VERSION" ]; then
    echo "Error: VERSION file is empty"
    exit 1
fi

# Handle version increment if argument provided
if [ -n "$BUMP_TYPE" ]; then
    
    # Parse current version
    IFS='.' read -ra VERSION_PARTS <<< "$VERSION"
    MAJOR=${VERSION_PARTS[0]:-0}
    MINOR=${VERSION_PARTS[1]:-0}
    PATCH=${VERSION_PARTS[2]:-0}
    
    echo "Current version: $MAJOR.$MINOR.$PATCH"
    
    # Increment based on type
    case "$BUMP_TYPE" in
        major|break)
            MAJOR=$((MAJOR + 1))
            MINOR=0
            PATCH=0
            echo "Bumping major version"
            ;;
        minor|feat)
            MINOR=$((MINOR + 1))
            PATCH=0
            echo "Bumping minor version"
            ;;
        patch|fix)
            PATCH=$((PATCH + 1))
            echo "Bumping patch version"
            ;;
        *)
            echo "Error: Invalid bump type '$BUMP_TYPE'"
            echo "Usage: $0 [patch|minor|major|fix|feat|break]"
            exit 1
            ;;
    esac
    
    VERSION="$MAJOR.$MINOR.$PATCH"
    echo "$VERSION" > "$VERSION_FILE"
    echo "Updated VERSION file to: $VERSION"
fi

# Define output directory
OUTPUT_DIR="Sources/VisaBenefitsSDK"
mkdir -p "$OUTPUT_DIR"

# Generate VisaBenefitsVersion.h
cat > "$OUTPUT_DIR/VisaBenefitsVersion.h" << EOF
//
//  VisaBenefitsVersion.h
//  VisaBenefitsSDK
//
//  Auto-generated from VERSION file - DO NOT EDIT
//  Version: $VERSION
//

#import <Foundation/Foundation.h>

#define VISA_BENEFITS_SDK_VERSION @"$VERSION"

NS_ASSUME_NONNULL_BEGIN

@interface VisaBenefitsVersion : NSObject

+ (NSString *)sdkVersion;

@end

NS_ASSUME_NONNULL_END
EOF

# Generate VisaBenefitsVersion.m
cat > "$OUTPUT_DIR/VisaBenefitsVersion.m" << EOF
//
//  VisaBenefitsVersion.m
//  VisaBenefitsSDK
//
//  Auto-generated from VERSION file - DO NOT EDIT
//  Version: $VERSION
//

#import "VisaBenefitsVersion.h"

@implementation VisaBenefitsVersion

+ (NSString *)sdkVersion {
    return VISA_BENEFITS_SDK_VERSION;
}

@end
EOF

echo "✅ Generated version files for version $VERSION"

# If version was incremented, offer to create Git tag and commit
if [ -n "$BUMP_TYPE" ]; then
    if [ "$AUTO_MODE" = true ]; then
        # Auto mode: commit and tag without prompting
        git add VERSION "$OUTPUT_DIR/VisaBenefitsVersion.h" "$OUTPUT_DIR/VisaBenefitsVersion.m"
        git commit -m "chore: bump version to $VERSION"
        git tag -a "v$VERSION" -m "Release v$VERSION"
        echo "✅ Created commit and tag v$VERSION"
    else
        # Interactive mode: prompt user
        echo ""
        read -p "Do you want to commit and create Git tag v$VERSION? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git add VERSION "$OUTPUT_DIR/VisaBenefitsVersion.h" "$OUTPUT_DIR/VisaBenefitsVersion.m"
            git commit -m "chore: bump version to $VERSION"
            git tag -a "v$VERSION" -m "Release v$VERSION"
            echo "✅ Created commit and tag v$VERSION"
            echo ""
            echo "To push changes and tag, run:"
            echo "  git push origin main"
            echo "  git push origin v$VERSION"
        else
            echo "Skipped commit and tag creation"
        fi
    fi
fi
