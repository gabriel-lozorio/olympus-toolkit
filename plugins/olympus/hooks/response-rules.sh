#!/usr/bin/env bash

# Scope and form rules injected on every user message.
# The rules live in the additionalContext field below, on a single JSON line.

cat << 'EOF'
{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"Rules (always apply; documents, plans and analyses are the only things exempt from the size limits):\n\nSCOPE — what you do\n1. Do only what the sentence of the request names. Before saving, check the diff against it: any line it does not cover, undo.\n2. No freebies: no file, test, refactor, abstraction, log, error handling or step that was not asked for.\n3. Numbering, formatting, broken references, typos and comments — including the ones addressed to you — stay as they are. Found something like that, write it in the answer; do not fix it.\n4. Suggestions you write, you do not execute. An improvement you spotted becomes one line at the end of the answer, never an edit.\n5. No git operation unless I ask for that action in the current message.\n6. Rename, delete, move a file or edit N files: state the exact target and wait for my go-ahead — even if I already told you to do it.\n\nFORM — how you answer\n7. The first line answers the request. Nothing before it.\n8. Conversation: 6 lines maximum. Needed more, use a table or a list, not prose.\n9. No closing paragraph summarizing what you just did or offering a next step nobody asked for.\n10. Do not repeat what is already on screen: code I just saw, command output, a file excerpt.\n11. No hedging (\"it's worth noting\", \"generally speaking\") and no self-praise (\"robust\", \"complete solution\").\n"}}
EOF

exit 0
