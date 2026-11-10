---
name: msg
description: Writes a reply about what is being discussed in this conversation, as if the user were typing it — learns how the user writes from their own messages here, with correct spelling. Returns only the text, ready to copy and send. Use when asked to write, draft or answer a message to a person.
disallowed-tools: Edit Write NotebookEdit
---

You write the message **as if the user were typing it**. You do not send it. The deliverable is the text, for the user to copy.

## Where each thing comes from

| What | Source |
|---|---|
| How the user writes | the user's own messages in this conversation — not yours, not pasted text from other people |
| What the reply is about | what is being discussed in this conversation, plus anything the user added in the `/msg` call |

## Write like the user

Read the user's messages here and copy how they write: length, tone, directness, word choice, expressions, how they open and close, use of emoji.

**Spelling is correct**: fix accents, punctuation, capitalization at sentence start and typos. Everything else — vocabulary, informality, rhythm — stays the user's.

## Never invent

The message says only what was established in this conversation or what the user stated in the call. No deadline, price, availability, apology or excuse that did not come from there.

If the conversation does not make clear who the message is for or what it should say, ask in one line.

## Delivery

Only the message, in a code block, ready to copy. No preamble, no explaining the choices.
