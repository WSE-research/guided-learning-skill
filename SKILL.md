---
name: guided-learning
version: 3.0.0
description: >
  Run structured learning sessions through a literature-backed concept collection using a spiral
  curriculum. Each session covers 1-3 concepts with adaptive explanations, comprehension checks,
  interactive HTML visualizations, and spaced recall. Use when the learner wants to study, learn,
  continue their learning roadmap, work through specific concepts, review what they've learned,
  get quizzed, or asks to be taught or have something explained from their research domain.
---

# Guided Learning — Spiral Curriculum Sessions

## Purpose

Run structured learning sessions through a literature-backed concept collection using a spiral curriculum approach. Each session covers 1-3 concepts with explanations, comprehension checks, and hands-on application — including interactive HTML visualizations for concepts that benefit from them.

## Prerequisites

This skill expects the following vault structure (paths are configurable in the **Configuration** section below):

| Path | Purpose |
|------|---------|
| `learning/learning-roadmap.md` | Ordered list of concepts grouped by cluster and pass |
| `learning/recall-queue.md` | Spaced repetition tracker |
| `learning/protocols/` | Session protocols (learning journal) |
| `learning/interactives/` | Generated HTML visualizations |
| `concepts/` | Atomic concept notes (Zettelkasten-style) |
| `literature/papers/` | Paper summaries that back the concepts |
| `research/glossary.md` | Domain glossary |

See the `examples/` directory for starter templates.

## Configuration

Adapt these paths and references to your vault. The skill uses them throughout:

```yaml
# Paths (relative to vault root)
roadmap: learning/learning-roadmap.md
recall_queue: learning/recall-queue.md
protocols_dir: learning/protocols/
interactives_dir: learning/interactives/
concepts_dir: concepts/
glossary: research/glossary.md
skill_logs_dir: SKILLS/guided-learning/logs/

# Interactive HTML
css_file: learning/interactives/interactive.css
build_script: learning/interactives/build.sh
```

## When to Use

- The learner wants to study or work through their literature
- The learner asks to continue their learning roadmap
- The learner references a specific concept they want to understand
- The learner asks for an interactive explanation of something

## Input

One of:
- **No input** → pick the next unchecked item from the learning roadmap
- **Cluster name** → work on the next item in that cluster
- **Concept name** → jump to that specific concept
- **"continue"** → resume from last session

---

## Session Flow

### Phase 0: Orient (1 min)

1. Read the learning roadmap to find the next unchecked concept(s)
2. Determine which pass we're in (1 = Overview, 2 = Working Understanding, 3 = Fluency)
3. Tell the learner: "We're in **Pass X**, Cluster Y: *cluster name*. Next up: *concept name*."
4. If resuming, briefly recall what was covered last session

### Phase 0.5: Spaced Recall Check (2-5 min)

**Before teaching anything new, check whether any previously learned concepts are due for recall.**

1. Read the recall queue. Find all entries where `next_recall` is today or earlier.
2. If there are due items, pick up to 2 for this session. **If more than 3 are overdue**, prioritize previously "fuzzy" or "blank" items, then those with the lowest interval. Defer the rest by 3 days — don't let recall crowd out new learning. Ask the learner a **one-sentence recall prompt** for each selected item:
   - "Quick recall — what's the core claim of *[concept name]*?"
   - Or: "In one sentence, why does *[concept name]* matter for your research?"
3. **Evaluate the response:**
   - **Solid** — the learner nails the core idea without hesitation. Advance to the next interval (3d -> 7d -> 21d -> done). If already at 21d, remove from the queue — the concept is retained.
   - **Fuzzy** — the learner gets the gist but is imprecise or misses a key nuance. Keep the same interval and reschedule. Add a brief note about what was fuzzy.
   - **Blank** — the learner can't recall the core idea. Reset to 3d interval. Flag the concept for a brief refresher (2-3 sentences) before moving on.
4. If no items are due, skip this phase silently.
5. Log recall results in the session protocol under "## Recall checks".

**Recall queue format** (`learning/recall-queue.md`):

```markdown
# Recall Queue

| concept | learned | interval | next_recall | last_result | notes |
|---------|---------|----------|-------------|-------------|-------|
| [[concept-slug]] | YYYY-MM-DD | 7d | YYYY-MM-DD | solid | — |
| [[concept-slug]] | YYYY-MM-DD | 3d | YYYY-MM-DD | fuzzy | missed key implication |
```

Intervals: 3d -> 7d -> 21d -> removed. On "fuzzy", repeat same interval. On "blank", reset to 3d.

### Phase 1: Context & Explain

**Read the concept note** and its source paper summaries silently.

**Assess concept complexity** before deciding session depth:

| Complexity | Signals | Session depth |
|------------|---------|---------------|
| **Light** | Familiar territory, single clear claim, no math | ~10 min total, can pair with another concept |
| **Medium** | New mechanism or method, some statistical reasoning | ~20 min, standard session |
| **Heavy** | Unfamiliar math, multi-step process, requires prerequisites the learner doesn't have | ~30-40 min, single concept only |

Announce the assessment: "This one is [light/medium/heavy] — [one-line reason]." Adjust all subsequent phases proportionally. Don't spend 20 min on a concept that clicks in 5. Don't rush a concept that needs 35.

**Prerequisite probe (before explaining):**
Before launching into the main concept, identify its 1-3 key prerequisites — the terms or ideas
the learner must already understand for the explanation to land. Ask a brief warm-up question
about each prerequisite. If they are shaky on any, cover it first as a mini-module before the main
explanation. Don't assume familiarity with statistical or mathematical terms even if they seem standard.
Starting at the right level avoids false-start explanations that need to be rebuilt from scratch.

**Pass 1 (Overview) — adaptive explanation:**

The goal is for the learner to understand the core idea and why it matters for their research. Different concepts call for different narrative shapes — don't use the same structure every time. Choose the approach that fits the concept, and vary your style across sessions so each one feels fresh.

**Explanation archetypes** (pick the best fit, or blend two):

- **Misconception flip** — Start with the common/surface understanding, reveal why it's incomplete, rebuild correctly. Best for concepts where the obvious interpretation is wrong.
- **Problem-first** — Open with a concrete problem the learner faces in their research, then show how this concept solves it. Best for practical or design concepts where motivation matters more than mechanism.
- **Contrast** — "You already know X from [prior concept]. This is like X except..." Best when building on prior knowledge, especially within the same cluster.
- **Historical narrative** — "People tried A, then B, then this concept emerged because..." Best for field-evolution concepts where the journey illuminates why the destination matters.
- **Worked example** — Walk through concrete numbers from the learner's domain, let the pattern emerge from the math before naming it. Best for statistical and mathematical concepts.

**Guardrails across all approaches:**

- Start from what the learner already knows — connect to prior sessions, their existing work, or everyday intuition
- One analogy maximum. If it breaks at the edges, say where: "This analogy stops working when..."
- Land it specifically in the learner's research — their system, their hypotheses, their experimental design, their next paper. Not generic consequences.
- Build incrementally. No skipped steps, no "it's obvious that..."
- Keep it conversational — paragraphs that flow, not bullet walls. Warm, curious, a little irreverent.

**Pass 2 (Working Understanding):**

The learner already has the intuition from Pass 1. Now go deeper into *how* and *how well*.

- **Method walkthrough**: Step through the algorithm, process, or framework with concrete numbers from the learner's domain. Don't just describe — trace execution on a realistic example. Show the moving parts.
- **Evidence evaluation**: Walk through the key study behind this concept. Cover sample size, study design, effect sizes, and statistical tests used. Don't just report findings — evaluate them: "This effect size is [strong/modest], based on [N] participants, in [domain], which means..."
- **Limitations and boundary conditions**: Where does this concept break? Under what sample sizes, domains, or conditions does the finding not hold?
- **Cross-concept comparison**: Explicitly compare with related concepts already covered. What does this add that the other doesn't? Where do they agree, where do they conflict?
- **Application mapping**: Where exactly does this concept appear (or should appear) in the learner's work — submitted papers, experimental designs, system architecture?

**Pass 3 (Fluency):**

The learner understands the concept and its mechanism. Now they need to wield it in academic discourse — writing, argumentation, and synthesis.

- **Paper reading**: Read the key sections of the original paper together. Discuss methodology choices: what did the authors do well? What are the weak points?
- **Argumentation practice**: The learner writes a paragraph that deploys this concept in an argument — Related Work, Discussion, or Limitations section. Then stress-test it with reviewer simulation.
- **Synthesis**: How does this concept combine with 2-3 others to form a larger argument? The learner should articulate the argument chain.
- **Counter-evidence and honest limitations**: Name the strongest objection to this concept. Identify papers or findings that weaken it.
- **Teaching test**: Explain this concept to a hypothetical student who needs to implement it.

### Phase 1b: Launch Interactive in Background (concurrent with Phase 1)

**Immediately after delivering the Phase 1 explanation**, check whether this concept warrants an interactive HTML visualization (see "Choosing the application method" in Phase 3). If yes:

1. **Launch a background subagent** (Agent tool, `run_in_background: true`) to build the interactive HTML file.
   - Pass the subagent the full concept content, the CSS design system path, the build script path, and the output filename.
   - The subagent should follow all Interactive HTML Guidelines below.
2. **Do not wait** — proceed immediately to Phase 2 (Comprehension Check). The learner reads your explanation while the interactive builds.
3. When the subagent completes, **announce it** before the learner answers the comprehension check prompt: *"The interactive is ready — open `learning/interactives/YYYY-MM-DD_concept-slug.html` and explore it before answering."*
4. If the concept does not warrant an interactive (e.g., it's a writing or scenario exercise), skip this phase entirely.

**Why this order matters:** The interactive reinforces the explanation visually *before* the learner has to reproduce the concept — not after. Seeing the model in motion gives them something concrete to reason about during the comprehension check.

---

### Phase 2: Explore Interactive + Comprehension Check (5-10 min)

**If an interactive was built, the learner explores it first** — before answering the comprehension check. The interactive is a study tool, not a reward after the test.

1. **Announce the interactive** and invite the learner to explore it freely.
2. **After exploring**, ask the comprehension check question — pick ONE from the pool below. **Do not reuse the same format two sessions in a row.** Track the last format used in the execution log (`check_format` field).

**Comprehension check pool — pick by pass and variety:**

**Pass 1 (any of these):**
- **Conference pitch**: "Explain this to a fellow researcher at a poster session."
- **Elevator pitch**: "You have 30 seconds — sell me on why this concept matters for your research."
- **Predict the outcome**: "If [specific variable] changes from X to Y, what happens and why?"
- **Spot the flaw**: Present a deliberately wrong one-sentence summary. "What's wrong with this claim: '[flawed statement]'?"
- **Analogy check**: "Come up with your own analogy for this concept — different from the one I used."
- **What breaks?**: "If we ignored this concept entirely in your system, what would go wrong?"

**Pass 2 (any of these):**
- **Advisor pitch**: "How would you explain this mechanism to your advisor?"
- **Two-concept bridge**: "How does this connect to [[previously-learned-concept]]? What does one give you that the other doesn't?"
- **Design decision**: "You're building your system — where exactly does this concept change your design, and how?"
- **Devil's advocate**: "I think [opposing claim]. Convince me I'm wrong using this concept."
- **Evidence check**: "What's the strongest piece of evidence for this claim, and what's its biggest limitation?"
- **Predict the failure**: "Under what conditions would this approach fail? Give a concrete example from your domain."

**Pass 3 (any of these):**
- **Related Work sentence**: "Write the one sentence you'd put in a Related Work section about this."
- **Reviewer simulation**: "I'm Reviewer 2 and I say your use of this concept is superficial. Defend it."
- **Hypothesis link**: "Which of your hypotheses does this concept support, and how would you cite it as evidence?"
- **Counter-argument**: "Name one paper or concept that could be used to argue *against* this claim."
- **Teach it**: "Explain this to a student who has never read the paper. They need to understand it well enough to implement it."
- **Write the limitation**: "Write the 2-sentence limitation paragraph for this concept as it applies to your system."

If gaps appear, re-explain those parts. Don't move on until the core idea clicks.

### Phase 3: Apply (5-15 min, scaled to complexity)

**Choose the application method based on concept type.**

For HTML-interactive concepts where an interactive was already built, Phase 3 becomes **guided deep exploration**: ask the learner to try a specific preset or parameter combination that illustrates a non-obvious insight or edge case, then discuss what they see.

For non-interactive concepts, choose from:

**A) Interactive HTML Visualization** — for concepts that are inherently visual/dynamic:
- Statistical concepts (distributions, ROC curves, Bayesian posteriors, calibration curves)
- Sequential processes (adaptive testing, probabilistic models)
- Tradeoff spaces (accuracy-coverage, cost-quality)
- System architectures (pipeline flows, routing logic)

Create a self-contained HTML file with:
- Interactive controls (sliders, toggles, input fields)
- Real-time visualization that responds to parameter changes
- Brief explanatory text embedded in the page
- "What to notice" prompts that guide exploration
- Realistic values from the learner's research domain
- Save to `learning/interactives/YYYY-MM-DD_concept-slug.html`

**B) Scenario Exercise** — for design/decision concepts:
- Present a realistic scenario from the learner's domain and ask how they would apply the concept
- Connect to the learner's actual research questions or experimental data where possible

**C) Writing Exercise** — for argumentation and framing:
- Draft a paragraph for Related Work using this concept
- Write a hypothesis that builds on this concept
- Critique a claim using this concept as counter-evidence
- Rewrite a weak claim from a draft using this concept as support

**Choosing the application method:**
Prefer A for concepts that involve numbers, processes, or tradeoffs. Use B when the concept is about decision-making or system design. Use C when the concept is about framing, argumentation, or positioning — and always consider C in Pass 3.

### Phase 3b: Connection Mapping (2-5 min)

**After the application exercise, always close with connections.** This is not optional — linking new knowledge to existing knowledge is what makes it stick.

**Pass 1:** "Which 1-2 concepts you've already learned does this remind you of, support, or tension with?" Keep it lightweight. If the learner draws a blank, suggest one connection and ask if they see it. When listing previously covered concepts, use human-readable titles, not raw wikilink slugs.

**Pass 2:** "How does this concept change or strengthen your understanding of [[specific-previously-learned-concept]]?" Pick a specific concept from an earlier cluster that relates.

**Pass 3:** "If you were drawing the argument map for your dissertation, where does this concept sit? What does it support, and what supports it?" The learner should identify at least 2 upstream and 1 downstream connection.

If new connections are discovered that aren't in the concept notes, update the wikilinks in the relevant concept files.

### Phase 4: Update & Log (2 min)

1. **Update roadmap**: Check off the concept in the learning roadmap
2. **Link protocol from roadmap**: Add an indented protocol link below the checked-off concept:
   ```
   - [x] [[concept-slug]]
       - [[learning/protocols/YYYY-MM-DD_concept-slug|protocol]]
   ```
3. **Suggest paper status update**: List all source papers referenced in this session and their current `status`. Suggest updating them to `skimmed` (Pass 1) or `read` (Pass 2/3). Wait for the learner to confirm before changing any status.
4. **Update progress summary** at the top of the roadmap
5. **Update glossary**: Add any key terms introduced during the session to the glossary (alphabetical order, with research-domain context)
6. **Schedule recall**: Add the concept to the recall queue with `interval: 3d` and `next_recall` set to today + 3 days. If the concept is already in the queue (Pass 2/3 revisit), reset its interval to 3d.
7. **Write session protocol** to `learning/protocols/YYYY-MM-DD_concept-slug.md` (see template below)
8. **Write execution log** to `SKILLS/guided-learning/logs/YYYY-MM-DD_sessionNN.md` (see Execution Logging section)
9. **Ask**: "Want to do another concept, or is this a good stopping point?"

---

## Interactive HTML Guidelines

When creating interactive HTML pages:

- **Shared design system**: Every interactive uses the universal stylesheet from `learning/interactives/interactive.css`. New interactives should link it via:
  ```html
  <link rel="stylesheet" href="interactive.css">
  ```
  Then run the build script to inline the CSS (required for Obsidian compatibility):
  ```bash
  cd learning/interactives && ./build.sh
  ```
  The script replaces the `<link>` tag with an inline `<style>` block wrapped in `<!-- interactive.css:start -->` / `<!-- interactive.css:end -->` markers. It's idempotent — re-running after CSS edits updates all HTML files. Page-specific styles go in a separate inline `<style>` block.
- **Class conventions**: Use the standard classes from `interactive.css`:
  - Layout: `.layout` (sidebar+main), `.two-col`, `.container`, `.page-padding`
  - Surfaces: `.panel`, `.card`, `.notice`, `.notice--bar`
  - Controls: `.slider-row`, `.slider-label`, `.slider-val`, `.control-group`
  - Buttons: `.btn`, `.btn-secondary`, `.btn-sm`, `.btn-row`, `.preset-row`, `.preset-btn`
  - Metrics: `.metric` (inline), `.metric-row` + `.metric-bar-bg` + `.metric-bar-fill` (bar)
  - Navigation: `.nav`, `.tab-content`, `.header`, `.bottom-nav`
  - Content: `.formula`, `.explain`, `.prompt-box`, `.copy-btn`, `.tag`
  - Colors: use CSS vars (`var(--accent)`, `var(--green)`, etc.) or utility classes (`.color-tp`, `.color-cyan`, etc.)
- **Educational**: Not a tech demo — designed to teach. Include "What to notice" prompts and guided exploration steps.
- **Parameter exploration**: Let the user change inputs and see what happens in real time.
- **Domain-contextualized**: Use realistic values from the learner's research domain.
- **Mobile-friendly**: Should work in any modern browser.
- **Visually clean**: Use a simple, readable design. No flashy animations — clarity over aesthetics.
- **Cross-tab data provenance**: When an interactive has multiple tabs where later tabs depend on data configured in earlier tabs, always make this dependency explicit. Label the source tab as the shared data source, add a live summary at the end of the source tab previewing what flows into later tabs, and reference the source tab by name in later tabs' introductions. Never assume the learner tracks implicit state across tabs.
- **Toggle/switch components**: Custom toggles must use `<label for="inputId">` for the clickable track element, not `<div>`. The hidden-checkbox + styled-sibling pattern requires the visual element to be a `<label>` with a `for` attribute. CSS selectors targeting labels inside control rows must use the direct-child combinator (`>`) to avoid styling nested labels (e.g., `.toggle-row > label` not `.toggle-row label`).
- **Running build.sh**: The interactive subagent may not have Bash permission. After the subagent completes, the main agent MUST run `cd learning/interactives && ./build.sh` to inline the CSS. Do not rely on the subagent to do this. If the learner reports missing styles in Obsidian, build.sh was not run.
- **Store in**: `learning/interactives/` with naming scheme `YYYY-MM-DD_concept-slug.html`.

---

## Multi-Concept Sessions

If concepts are closely related (e.g., two from the same cluster in the same pass), they can be covered in a single session. Rules:
- Never exceed 3 concepts per session
- Depth over breadth — it's better to deeply understand 1 concept than to skim 3
- If the learner seems fatigued or distracted, wrap up early
- **Light** complexity concepts can be paired; **heavy** concepts always get a solo session

---

## Quality Bar

A session is successful when the learner can:

| Pass | Success Criterion |
|------|-------------------|
| **Pass 1** | State the core idea in one sentence and say why it matters for their research |
| **Pass 2** | Explain the mechanism AND identify how it connects to >=2 other concepts |
| **Pass 3** | Use the concept fluently in writing or argumentation without prompting |

---

## Struggle Patterns

Track recurring correction types to adapt explanations preemptively.

**In every execution log**, categorize each correction given during the session using one or more of these tags:

| Tag | Meaning | Example |
|-----|---------|---------|
| `implication-gap` | Understands the mechanism but misses the "so what" for their system | "Undersold the routing implication" |
| `terminology-confusion` | Confuses or misuses a technical term | "Used 'calibration' when meaning 'correlation'" |
| `math-gap` | Lacks prerequisite statistical/mathematical knowledge | "Didn't know what Cohen's kappa measures" |
| `scope-creep` | Explains too broadly, loses the specific claim | "Described all of Bayesian stats instead of the specific method" |
| `shallow-framing` | Describes the algorithm but not why it matters or when to use it | "Described EM steps but couldn't say when DS beats MV" |
| `connection-blind` | Fails to see how this concept relates to previously learned ones | "Didn't connect annotation quality to uncertainty quantification" |

**Every 5 sessions**, review the logs and count tag frequencies. If any tag appears in >=3 of the last 5 sessions:
- **Surface it to the learner**: "I've noticed a pattern — [tag] has come up in X of our last 5 sessions."
- **Adapt explanations**: For `implication-gap`, always end explanations with an explicit "What this means for your system" paragraph. For `math-gap`, extend the prerequisite probe. For `terminology-confusion`, add a glossary sidebar to the session. And so on.
- **Log the adaptation** in the CHANGELOG if it becomes a permanent skill change.

---

## Adaptation & Self-Improvement

This skill self-improves. After every 5 sessions, briefly review the logs:

- Which application methods worked best for which concept types?
- Which concepts needed re-explanation?
- Is the cluster ordering effective or should it be adjusted?
- Are sessions the right length?
- **Check struggle pattern frequencies** (see above)
- Note improvements in CHANGELOG.md

---

## Session Protocol

After each session, write a human-readable protocol to `learning/protocols/YYYY-MM-DD_concept-slug.md`. This is the learning journal — it captures what worked, what needed correction, and what to revisit. Unlike the execution log (which is operational), the protocol is written for the learner to review later.

```markdown
---
date: YYYY-MM-DD
pass: <1|2|3>
cluster: <cluster name>
concept: <concept wikilink slug>
complexity: <light|medium|heavy>
duration: ~XX min
comprehension: <passed|partial|needs-revisit>
---

# Session: <concept title in plain language>

## Recall checks
- <concept recalled>: <solid|fuzzy|blank> — <brief note if fuzzy/blank>
- <omit this section if no recalls were due>

## What we covered
- <bullet points: key ideas explained>

## How we learned it
- <which methods were used: conversational explanation, interactive HTML, scenario exercise, writing exercise, connection mapping>

## Artifacts
- <link to any interactives created, e.g. `[[learning/interactives/YYYY-MM-DD_concept-slug.html]]`>
- <omit this section if no artifacts were created>

## What worked well
- <which moments, presets, examples, or methods produced "aha" moments>

## Corrections given
- <any terminology fixes, misconceptions addressed, or gaps filled during the comprehension check>

## Connections made
- <which concepts the learner linked this to, and how>

## Next up
- <what concept comes next on the roadmap>
```

---

## Obsidian Formatting

Use Obsidian Flavored Markdown to make learning protocols rich:

- **LaTeX**: `$formula$` and `$$block$$` for mathematical notation — essential when concepts involve statistics, probability, or metrics
- **Callouts**: `> [!question]` for comprehension checks, `> [!tip]` for key insights, `> [!example]` for worked examples
- **Mermaid diagrams**: process flows, concept relationship maps, decision trees
- **Highlights**: `==key insight==` for the "aha" moments worth remembering

---

## Execution Logging

After each session, write a log to `SKILLS/guided-learning/logs/YYYY-MM-DD_sessionNN.md` (where NN is the next session number):

**YAML quoting rule:** Always quote all string values in frontmatter. Unquoted `~20` parses as null, bare `none` parses as null, and strings with colons or dashes can break Obsidian's YAML parser. Only leave numeric and boolean values unquoted.

```yaml
---
skill: "guided-learning"
version: "3.0.0"
trigger: "<how the session was initiated>"
pass: <1|2|3>
cluster: "<cluster name>"
concepts_covered:
  - "<concept-1>"
  - "<concept-2>"
complexity: "<light|medium|heavy>"
application_method: "<html-interactive|scenario|writing|connection-mapping>"
check_format: "<conference-pitch|elevator-pitch|predict-outcome|spot-flaw|analogy-check|what-breaks|advisor-pitch|two-concept-bridge|design-decision|devils-advocate|evidence-check|predict-failure|related-work|reviewer-sim|hypothesis-link|counter-argument|teach-it|write-limitation>"
artifacts_created:
  - "<path to interactive HTML or other output>"
comprehension_check: "<passed|partial|needs-revisit>"
recall_results:
  - concept: "<concept-slug>"
    result: "<solid|fuzzy|blank>"
struggle_tags:
  - "<implication-gap|terminology-confusion|math-gap|scope-creep|shallow-framing|connection-blind>"
session_duration_minutes: "<approximate, e.g. ~20>"
status: "<completed|partial|needs-followup>"
issues: "<any problems encountered>"
user_corrections: "<any feedback the learner gave about the process>"
---

## Session Notes

<Brief narrative: what was covered, what clicked, what needs revisit>
```
