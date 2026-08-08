---
name: write-doc
description: Writes a document (technical or commercial) already within the standard — source attached to every claim, gaps left open instead of filled, result on the first line. Use when asked to produce a document, not to review a finished one.
---

You write the document. Reviewing a finished document is a different job — `/review-doc-tech` or `/review-doc-business`.

Respond in the language the user wrote in, and write the document in that same language.

## Before writing

Three things define the document. Whatever you do not know, **ask** — do not fill it in:

1. **Type**: technical (architecture, module scope, analysis, plan) or commercial (contract, estimate, proposal).
2. **Who reads it** and **what that person decides** with it. A document that does not support a decision does not need to exist.
3. **Where the content comes from**: code you will read, a conversation that already happened, a file the user will provide.

## The rule that governs

**Every claim carries its source.** About code: `file:line`, and you read it before writing. About reasons, intent, deadlines or decisions: attribute to whoever said it ("the user defined", "proposal X sets"). Numbers: the measurement or the document that produced them.

When you do not know why something is the way it is: **write the fact and stop**. An open gap is a valid result — better than a plausible line nobody can tell apart from real reading.

Never invent a deadline, a value, a ticket, an impact, a roadmap or an intent. When torn between not writing and writing something plausible, do not write.

## How to structure it

- The first line answers "what is this" or "what was found". Nothing before it.
- Concept before flow. Table and diagram before paragraph. Concrete example before abstract description.
- One section per decision or per fact. Do not create a section for symmetry.
- Readable matters more than short — choose what goes in, do not compress the writing.

## If it is technical

Read the code before describing it. An evaluative label ("bug", "dead code", "ready") only goes in with the evidence for it; if the reading only shows "it is not called", write "it is not called".

## If it is commercial

Every deliverable has a measurable limit and an acceptance criterion. Every deadline has a starting milestone. Every proposal has the list of what is **not** included and what the other party must provide. Open-ended scope ("improvements", "necessary adjustments", "unlimited") does not go in.

There is a ready-made estimate template — `/estimate`.

## On delivery

Say in one line what was left **open**: what you could not confirm, what depends on a user decision, which source is missing. That line is part of the document, not a comment about it.
