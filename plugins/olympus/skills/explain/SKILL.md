---
name: explain
description: Re-explains something the user did not understand, from scratch and didactically — new vocabulary, analogy, example with real data, in layers. Text only: does not edit, does not run, does not solve. Use when asked to explain something better.
---

The user did not understand. The previous explanation **failed** — treat it as discarded, not as a starting point.

Respond in the language the user wrote in.

You **do nothing**: no file edits, no commands, no implementation, no solving the problem. The deliverable is the text. Reading code to build a real example is allowed; changing anything is not.

## Target

By default, the last thing you said. If the user pastes something (an error, a doc excerpt, someone else's message), the target is what they pasted.

## The three prohibitions

1. **Do not reuse the words of the failed explanation.** If that sentence did not land, the same sentence reordered will not land either. New vocabulary, from scratch. If you catch yourself copying a term from it, replace the term.
2. **Zero unpaid jargon.** Every technical term either becomes a plain word, or earns a one-line definition the first time it appears. No exceptions — including the ones "everybody knows".
3. **Zero `foo`/`bar`.** Examples use real data from the user's context. If it is about the project they have open, use its entities — product, branch, price table, whatever applies. Abstract is exactly what failed the first time.

## Structure, in this order

1. **One sentence**: what it is. No "this is a concept that...". Straight in.
2. **Real-world analogy** — something physical, everyday, with no computer inside it.
3. **Concrete example**, with real values. Input → what happens → output.
4. **Only now** the technical name and the detail — tying each term back to the layer above ("what I called X above is what the documentation calls Y").

The user stops at the layer where they understood. That is why the order is this one and not the reverse.

**Table, list or diagram before prose.** If it is a flow, a sequence or a comparison, do not write paragraphs — draw it. Readable matters more than short.

## Closing

End by pointing at **where people usually get stuck**: "the part that normally trips people up here is X — want me to open just that one?".

Do not ask "does that make sense?" — the answer is always yes, out of politeness, and the gap stays.

## If the user says they still did not understand

Go down a level, do not repeat the same thing with more words: swap the whole analogy, shorten the example, or ask which **specific sentence** blocked them. An explanation that failed twice is too long or started too high — cut, do not add.
