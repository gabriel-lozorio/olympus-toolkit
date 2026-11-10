# olympus-toolkit

Configuração pessoal do Claude Code, empacotada como plugin: skills globais + um hook que injeta regras de escopo em toda mensagem + um output style com as regras de forma.

Este repo é **marketplace e plugin ao mesmo tempo**: a raiz tem o `marketplace.json`, e o plugin `olympus` vive em `plugins/olympus/`.

## Estrutura

```
.claude-plugin/marketplace.json     lista o plugin "olympus"
test.sh                             valida o plugin antes do commit
plugins/olympus/
  .claude-plugin/plugin.json        nome, descrição, autor
  skills/<nome>/SKILL.md            uma pasta por skill
  hooks/hooks.json                  registra o hook UserPromptSubmit
  hooks/response-rules.sh          emite as regras de escopo como JSON
  output-styles/olympus.md          regras de forma, aplicadas automaticamente
  evals/<caso>/                     casos do claude plugin eval
```

## Testar

```bash
bash test.sh
```

Precisa do `claude` e do `node` no PATH.

Roda o `claude plugin validate` no marketplace e no plugin, confere que cada `SKILL.md` tem frontmatter com `name` igual ao nome da pasta e `description` preenchida, e que o hook devolve JSON válido com regras não vazias. Sai com código 1 em caso de falha, então dá pra encadear: `bash test.sh && git commit ...`.

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
| `/rbac` | extrai a matriz papel × recurso × ação do código, com `arquivo:linha` em cada célula |
| `/review-doc-business` | valida contrato, orçamento, proposta (escopo fechado, número com origem) |
| `/review-doc-tech` | valida doc técnico (fonte obrigatória, `arquivo:linha` conferido) |
| `/security` | audita a postura de segurança do sistema inteiro (cliente, API, infra, build) |
| `/ship-pr` | cria branch, commita, dá push, abre a PR e comenta nela screenshots e vídeo capturados com o Playwright MCP, o `playwright-cli` ou o `agent-browser` — o primeiro disponível |
| `/ship-pr-lite` | cria branch, commita, dá push, abre a PR e comenta nela o que foi feito — sem screenshots nem vídeo |
| `/shorten` | reescreve uma resposta prolixa, cortando sem perder fato |
| `/solution-kiss` | acha a solução mais simples antes de existir código — escada de 6 degraus |
| `/write-doc` | escreve doc técnico ou comercial já dentro da régua (fonte junto de cada afirmação) |

Todas podem ser chamadas por você com `/nome`, e também disparadas pelo próprio Claude quando a `description` casa com o pedido.

Nome e corpo das skills são em inglês; cada uma instrui responder no idioma em que você escreveu.

O hook `UserPromptSubmit` injeta as 7 regras de escopo (o que fazer) junto de cada mensagem que você manda. As 5 regras de forma (8–12, como responder) ficam no output style `olympus`, que o plugin aplica sozinho (`force-for-plugin: true`) e sobrepõe o `outputStyle` das suas configurações.

## Navegador do `/ship-pr`

O `/ship-pr` usa o primeiro destes que estiver disponível: Playwright MCP (vem no plugin), `playwright-cli`, `agent-browser`. Para ter os três numa máquina Ubuntu/WSL:

```bash
sudo apt-get install -y libnspr4 libnss3 libasound2t64 ffmpeg   # libs do Chromium; ffmpeg para o vídeo do agent-browser
npx -y @playwright/mcp@0.0.83 install-browser chrome-for-testing
npm install -g @playwright/cli agent-browser
playwright-cli install-browser chromium
agent-browser install
```

## Evals

```bash
claude plugin eval ./plugins/olympus --allow-tools Edit Write
```

Roda cada caso em `plugins/olympus/evals/` com e sem o plugin. As chamadas de modelo contam na sua cota. O `--allow-tools` libera Edit e Write para que o grader "nunca editou" teste algo de verdade.

## Instalar em outra máquina

Em um passo (Claude Code 2.1.275+):

```
/plugin install olympus --marketplace gabriel-lozorio/olympus-toolkit
```

Ou em dois:

```
/plugin marketplace add gabriel-lozorio/olympus-toolkit
/plugin install olympus
```

É assim que esta máquina está configurada. Como a fonte é o repositório remoto, `/plugin update olympus` puxa do GitHub — o que estiver só no working tree local não é visto. O `plugin.json` não fixa `version`, então cada commit no GitHub conta como versão nova.

Local, sem GitHub:

```
/plugin marketplace add C:/caminho/para/olympus-toolkit
/plugin install olympus
```

O equivalente por arquivo, em `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "olympus-toolkit": {
      "source": { "source": "github", "repo": "gabriel-lozorio/olympus-toolkit" }
    }
  },
  "enabledPlugins": { "olympus@olympus-toolkit": true }
}
```

Qualquer um dos dois só passa a valer **no próximo start** do Claude Code.

## Atualizar

**Mesma máquina, outro repo** (marketplace instalado da pasta local, escopo `user`): o plugin é lido direto desta pasta. Salve aqui e reinicie o Claude Code no outro repo. Não precisa de commit nem de update.

**Outra máquina** (marketplace instalado do GitHub):

1. Neste repo: `bash test.sh`, commit e push para o GitHub. O que não foi pro GitHub não chega nas outras máquinas.
2. Em cada máquina:

```bash
claude plugin marketplace update olympus-toolkit
claude plugin update olympus@olympus-toolkit
```

3. Reinicie o Claude Code. A atualização só vale depois do restart.

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
