#!/usr/bin/env bash

# Valida o plugin antes do commit: validador oficial + name das skills + hook devolvendo JSON valido.
# Uso: bash test.sh

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

fail=0

for d in . plugins/olympus; do
  if out=$(claude plugin validate "$d" 2>&1); then
    echo "ok     valid  $d"
  else
    echo "FALHOU valid  $d"
    echo "$out" | grep -E '✘|❯' | head -5
    fail=1
  fi
done

for f in plugins/olympus/skills/*/SKILL.md; do
  dir=$(basename "$(dirname "$f")")
  front=$(sed -n '1{/^---$/!q};2,/^---$/p' "$f")
  if echo "$front" | grep -qx "name: $dir" && echo "$front" | grep -q '^description: .\+'; then
    echo "ok     skill  $dir"
  else
    echo "FALHOU skill  $f (frontmatter sem name: $dir ou sem description)"
    fail=1
  fi
done

hook_chars=$(mktemp)
hook_out=$(echo '{}' | bash plugins/olympus/hooks/response-rules.sh 2>&1)
if echo "$hook_out" | node -e '
let s="";
process.stdin.on("data", d => s += d).on("end", () => {
  const o = JSON.parse(s);
  if (o.hookSpecificOutput.hookEventName !== "UserPromptSubmit") throw new Error("hookEventName errado");
  if (!o.hookSpecificOutput.additionalContext.trim()) throw new Error("additionalContext vazio");
  console.error(o.hookSpecificOutput.additionalContext.length + " chars de regras");
});
' 2>"$hook_chars"; then
  echo "ok     hook   response-rules.sh ($(cat "$hook_chars"))"
else
  echo "FALHOU hook   response-rules.sh"
  echo "$hook_out" | head -3
  fail=1
fi
rm -f "$hook_chars"

if [ "$fail" -eq 0 ]; then
  echo "tudo certo"
else
  echo "ha falhas acima"
fi
exit "$fail"
