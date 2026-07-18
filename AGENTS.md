# Daniel's Agent Instructions

These are common instructions for Daniel's agents across all scenarios.

## General Guidelines

- Never use the em dash "—". Use plain dash "-" instead.
- When writing commit messages, NEVER auto-add your agent name as co-author.
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated.
- When writing or substantially editing long Markdown files, put each full sentence on its own line.
  Preserve normal Markdown structure, but avoid wrapping multiple sentences onto one physical line.
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible.
  This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
  If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
  If you see one, even if it is not caused by what you are working on right now, still get it fixed.

## Daniel's Opinions

When you are working on something that would benefit from being informed by Daniel's viewpoints, read ~/OPINIONS.md to understand his perspective.

## Voice Profile

When you are talking/posting on behalf of Daniel using his identity, read ~/VOICE.md to see how Daniel talks.

## Multi-Model Task Routing

- Handle general tasks directly with the model selected for the current session.
- Do not delegate merely because a task mentions frontend or backend work.
- Use the `backend` agent when substantial backend implementation benefits from a dedicated worker.
- Use the `frontend` agent when substantial frontend implementation benefits from a dedicated worker.
- Use the `orchestrator` agent for planning and integration review when a non-trivial task spans multiple specialties.
- When running as the `orchestrator` main agent, delegate independent backend and frontend work in parallel after defining shared contracts and file ownership.
- When the orchestrator is used from a normal session, let it produce the plan, have the main session dispatch the specialist work, and return the results to the same orchestrator for integration review when practical.
- Keep small, general, and tightly coupled tasks in the current session when delegation would add more overhead than value.
- The coordinating session must review delegated work and verify the integrated result before reporting completion.