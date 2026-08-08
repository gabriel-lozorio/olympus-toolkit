---
name: estimate
description: Writes a software project estimate in the user's standard format — 11 sections, closed scope, explicit exclusions and assumptions. Use when asked to put together an estimate, a commercial proposal, or project pricing.
---

You assemble the estimate. The structure below is the user's standard 11-section format — follow it exactly.

Respond in the language the user wrote in, and write the document in that same language. The section titles below are the template's own headings — keep them as they are.

## Before writing

Ask for whatever is missing. **Nothing here may be invented:**

| Needed | Without it |
|---|---|
| Client name and what the company does | you cannot write the objective |
| Scope, module by module | that is all of section 2 |
| Total value and payment terms | section 6 |
| Timeline per stage, in business days | section 5 |
| Monthly fee, if any | section 4 |
| What is left out | section 8 |

If the scope comes from a document (e.g. a technical scope already written), read that document and derive from it — do not rewrite it from memory.

## Structure

Header: client, issue date, proposal validity, provider, contact.

| # | Section | What goes in |
|---|---|---|
| 1 | Objetivo | one paragraph: what the system does and for which operation |
| 2 | Escopo do Sistema | subsections per module, in bullets. Opens with "all items below are included" |
| 3 | Entregáveis | what the client receives besides the software: manual, training, environment, license |
| 4 | Tecnologia | stack in client language, integrations, and the monthly fee when there is one |
| 5 | Prazo de Entrega | table of stage × modules × business days, with a total row |
| 6 | Investimento | what the value covers, total value, and the payment options |
| 7 | Como funciona o suporte | warranty, channels, response time, how new work is requested |
| 8 | Itens NÃO inclusos | explicit list of what is left out, contractable separately |
| 9 | Premissas | what the client must provide for the timeline to hold |
| 10 | Observações Gerais | scope change, official communication, follow-up, validity, cancellation |
| 11 | Aceite | signature table, client × provider |

## Standard

Apply while writing — it is the same one as `/review-doc-business`:

- **A number with no origin does not go in.** Values, deadlines, hours and percentages come from a user decision or from an explainable count.
- **Open-ended scope does not go in.** "Improvements", "support", "necessary adjustments", "unlimited" either become a measurable limit or move to section 8.
- **Every deliverable has an acceptance criterion** — you can objectively say whether it was delivered.
- **Every deadline has a starting milestone** ("after approval and payment of the deposit") and something that suspends it.
- **Sections 8 and 9 are never empty.** An estimate with no exclusions and no assumptions is open-ended scope in disguise.
- Technical terms get a translation — whoever signs is not technical.

## On delivery

List in one line what is still pending a user decision — a value not settled, a stage with no timeline, an item you could not classify as included or not.

You write the document; you do not negotiate price and you do not opine on whether it is expensive or cheap.
