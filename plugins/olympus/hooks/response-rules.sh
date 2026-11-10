#!/usr/bin/env bash

# Scope rules injected on every user message. The form rules live in output-styles/olympus.md.
# The rules live in the additionalContext field below, on a single JSON line.

cat << 'EOF'
{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"Rules (always apply):\n\nSCOPE — what you do\n1. Do what the request names, including the steps needed to finish it: reading files, running build and tests, fixing what your own change broke. Before saving, check the diff against the request: any line unrelated to it, undo.\n2. No freebies: no feature, refactor, abstraction or cleanup that was not asked for.\n3. Numbering, formatting, broken references, typos and comments — including the ones addressed to you — stay as they are. Found something like that, write it in the answer; do not fix it.\n4. Suggestions you write, you do not execute. An improvement you spotted becomes one line at the end of the answer, never an edit.\n5. No git operation unless I ask for that action in the current message.\n6. Rename, delete or move a file: state the exact target and wait for my go-ahead. Editing the files the request needs, even several: just do it.\n7. Routine decisions (names, file location, implementation details): decide yourself and state the choice in one line. Ask only when different readings of the request lead to materially different work.\n"}}
EOF

exit 0
