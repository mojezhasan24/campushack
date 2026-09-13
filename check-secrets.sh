#!/bin/bash

# A simple pre-commit hook script to catch common secrets.
# To install this hook, run:
# cp check-secrets.sh .git/hooks/pre-commit
# chmod +x .git/hooks/pre-commit

echo "Checking for secrets in staged files..."

# List of regex patterns to look for
PATTERNS=(
  "(password|passwd|pwd)[[:space:]]*=[[:space:]]*[a-zA-Z0-9_]+"
  "(secret|token|api_key|access_key)[[:space:]]*=[[:space:]]*[a-zA-Z0-9_]{16,}"
  "eyJ[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+" # JWT token format
)

# Get a list of staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

if [ -z "$STAGED_FILES" ]; then
    exit 0
fi

FOUND_SECRETS=0

for FILE in $STAGED_FILES; do
    # Skip checking example and properties template files
    if [[ "$FILE" == *".example"* ]]; then
        continue
    fi

    for PATTERN in "${PATTERNS[@]}"; do
        # Check the staged content of the file
        MATCHES=$(git show ":$FILE" | grep -Ei -n "$PATTERN")
        if [ ! -z "$MATCHES" ]; then
            echo "🚨 WARNING: Potential secret found in $FILE"
            echo "$MATCHES"
            FOUND_SECRETS=1
        fi
    done
done

if [ $FOUND_SECRETS -eq 1 ]; then
    echo "==========================================================="
    echo "❌ Commit rejected because potential secrets were detected."
    echo "If this is a false positive, use 'git commit --no-verify' to bypass."
    echo "==========================================================="
    exit 1
fi

exit 0
