#!/usr/bin/env bash

# Valida o plugin antes do commit: JSONs parseaveis + hook devolvendo JSON valido.
# Uso: bash test.sh

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

fail=0

for f in .claude-plugin/marketplace.json \
         plugins/olympus/.claude-plugin/plugin.json \
         plugins/olympus/hooks/hooks.json; do
  if node -e "JSON.parse(require('fs').readFileSync('$f','utf8'))" 2>/dev/null; then
    echo "ok     json   $f"
  else
    echo "FALHOU json   $f"
    fail=1
  fi
done

hook_out=$(echo '{}' | bash plugins/olympus/hooks/response-rules.sh 2>&1)
if echo "$hook_out" | node -e '
let s="";
process.stdin.on("data", d => s += d).on("end", () => {
  const o = JSON.parse(s);
  if (o.hookSpecificOutput.hookEventName !== "UserPromptSubmit") throw new Error("hookEventName errado");
  if (!o.hookSpecificOutput.additionalContext.trim()) throw new Error("additionalContext vazio");
  console.error(o.hookSpecificOutput.additionalContext.length + " chars de regras");
});
' 2>/tmp/hook-chars; then
  echo "ok     hook   response-rules.sh ($(cat /tmp/hook-chars))"
else
  echo "FALHOU hook   response-rules.sh"
  echo "$hook_out" | head -3
  fail=1
fi
rm -f /tmp/hook-chars

if [ "$fail" -eq 0 ]; then
  echo "tudo certo"
else
  echo "ha falhas acima"
fi
exit "$fail"
