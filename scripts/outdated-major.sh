#!/bin/sh

## Intended behaviour
# Inform only when direct major version updates are available
# Only direct dependencies (yellow) are relevant
# Minor version changes (red) are irrelevant

## Logic
# Compare direct outdated dependencies with minor outdated dependencies
# if the count is different return a non-zero exit code

## Prevent from running without composer.json
if [ ! -f composer.json ]; then
    echo "The project seems to not contain a composer.json file. Script could not run"
    # Exit code 1 Generic/unknown error code (https://getcomposer.org/doc/03-cli.md#process-exit-codes)
    exit 1
fi

COMMAND="composer outdated --direct"

COUNT_DIRECT=$($COMMAND | wc -l)

if [ "$COUNT_DIRECT" -eq 0 ]; then
    echo "No outdated direct dependencies found"
    # Exit code 0 if no outdated direct dependencies
    exit 0
fi

COUNT_MINOR=$($COMMAND --minor-only | wc -l)

if [ "$COUNT_MINOR" -ne "$COUNT_DIRECT" ]; then
    DIFFERENCE=$((COUNT_DIRECT - COUNT_MINOR))
    echo "$DIFFERENCE outdated major dependencies detected"
    echo "$COUNT_DIRECT"
    # A non-zero exit code has to be used; here the count of detected relevant outdated dependencies
    exit "$DIFFERENCE"
fi

# Reaching this point means no relevant outdated dependencies
echo "No outdated major dependencies found"
exit 0
