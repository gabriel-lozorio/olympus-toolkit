# claude-config

Configuração pessoal do Claude Code, empacotada como plugin: skills globais + um hook que injeta regras de escopo e forma em toda mensagem.

Este repo é **marketplace e plugin ao mesmo tempo**: a raiz tem o `marketplace.json`, e o plugin `olympus` vive em `plugins/olympus/`.

## Estrutura

```
.claude-plugin/marketplace.json     lista o plugin "olympus"
test.sh                             valida o plugin antes do commit
plugins/olympus/
  .claude-plugin/plugin.json        nome, versão, descrição, autor
  skills/<nome>/SKILL.md            uma pasta por skill
  hooks/hooks.json                  registra o hook UserPromptSubmit
  hooks/response-rules.sh          emite as regras como JSON
```

## Testar

```bash
bash test.sh
```

Confere que os três JSONs parseiam e que o hook devolve JSON válido com regras não vazias. Sai com código 1 em caso de falha, então dá pra encadear: `bash test.sh && git commit ...`.

Rode sempre depois de mexer no `response-rules.sh` — hook quebrado falha em silêncio, sem erro na tela.

## O que vem dentro

| Skill | Faz |
|---|---|
| `/code-kiss` | escreve ou altera código aplicando KISS de fato — edita os arquivos |
| `/commit-msg` | texto da mensagem de commit + nome de branch quando você está na `main` |
| `/estimate` | monta orçamento de projeto no formato padrão de 11 seções |
| `/explain` | reexplica do zero, em camadas, sem jargão nem `foo`/`bar` |
| `/judge` | julga uma decisão com agentes adversariais (defesa, acusação, custo) + juiz independente |
| `/kiss` | audita código simples e funcional (KISS, DRY, clean code, comentários, eficiência) |
| `/review-doc-business` | valida contrato, orçamento, proposta (escopo fechado, número com origem) |
| `/review-doc-tech` | valida doc técnico (fonte obrigatória, `arquivo:linha` conferido) |
| `/security` | audita a postura de segurança do sistema inteiro (cliente, API, infra, build) |
| `/shorten` | reescreve uma resposta prolixa, cortando sem perder fato |
| `/solution-kiss` | acha a solução mais simples antes de existir código — escada de 6 degraus |
| `/write-doc` | escreve doc técnico ou comercial já dentro da régua (fonte junto de cada afirmação) |

Todas podem ser chamadas por você com `/nome`, e também disparadas pelo próprio Claude quando a `description` casa com o pedido.

Nome e corpo das skills são em inglês; cada uma instrui responder no idioma em que você escreveu.

O hook `UserPromptSubmit` injeta 11 regras (escopo do que fazer + forma de responder) junto de cada mensagem que você manda.

## Instalar em outra máquina

```
/plugin marketplace add gabriel-lozorio/claude-config
/plugin install olympus
```

É assim que esta máquina está configurada. Como a fonte é o repositório remoto, `/plugin update olympus` puxa do GitHub — o que estiver só no working tree local não é visto.

Local, sem GitHub:

```
/plugin marketplace add C:/caminho/para/claude-config
/plugin install olympus
```

O equivalente por arquivo, em `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "claude-config": {
      "source": { "source": "github", "repo": "gabriel-lozorio/claude-config" }
    }
  },
  "enabledPlugins": { "olympus@claude-config": true }
}
```

Qualquer um dos dois só passa a valer **no próximo start** do Claude Code.

## Editar as regras do hook

As regras ficam numa única linha JSON dentro de `plugins/olympus/hooks/response-rules.sh`, no campo `additionalContext`. Quebra de linha é `\n`.

Ficaram no `.sh` em vez de num `.md` ao lado porque `${CLAUDE_PLUGIN_ROOT}` vira caminho Windows e o `node` não lê o caminho POSIX que o Git Bash devolveria. Script autocontido evita o problema — é o mesmo padrão do plugin oficial `explanatory-output-style`.

Depois de editar, rode `bash test.sh` — é ele que confere que o hook ainda devolve JSON válido.

## Adicionar uma skill

Crie `plugins/olympus/skills/<nome>/SKILL.md` com frontmatter:

```markdown
---
name: <nome>
description: <quando usar — é o que o Claude lê pra decidir relevância>
---
```

Acrescente `disable-model-invocation: true` se ela só puder rodar quando **você** digitar `/nome`.

Reinicie o Claude Code e ela aparece como `/<nome>`.

## Desinstalar

`/plugin uninstall olympus`, ou apague `extraKnownMarketplaces` e `enabledPlugins` do `~/.claude/settings.json`.
