# Guided Learning Skill

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that turns your Obsidian vault into a structured learning environment. It runs interactive sessions through your literature collection using a **spiral curriculum** — three passes of increasing depth, with spaced recall, comprehension checks, and auto-generated interactive HTML visualizations.

Built for researchers, PhD students, and anyone who learns from academic papers and wants to actually retain what they read.

## What It Does

When you say `/guided-learning` (or just "teach me the next concept"), the skill:

1. **Picks the next concept** from your learning roadmap
2. **Checks recall** of previously learned concepts (spaced repetition: 3d → 7d → 21d)
3. **Explains the concept** using adaptive archetypes (misconception flip, problem-first, contrast, historical narrative, worked example)
4. **Builds an interactive HTML visualization** in the background (for quantitative/visual concepts)
5. **Runs a comprehension check** from a pool of 18 formats (never the same two sessions in a row)
6. **Applies the concept** via interactive exploration, scenario exercise, or writing exercise
7. **Maps connections** to previously learned concepts
8. **Logs everything** — session protocol, execution log, recall queue, glossary updates

The spiral curriculum means you visit each concept up to three times:

| Pass | Goal | Depth |
|------|------|-------|
| **Pass 1: Overview** | "What is this and why does it matter?" | ~10-20 min |
| **Pass 2: Working Understanding** | "How does it work? Can I evaluate and apply it?" | ~20-30 min |
| **Pass 3: Fluency** | "Can I write and argue with this in a paper?" | ~30-45 min |

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (CLI, desktop, or IDE extension)
- An [Obsidian](https://obsidian.md) vault (or any markdown-based knowledge vault)
- Concept notes backed by literature (the skill reads these to build explanations)

## Quick Start

### 1. Copy the skill into your vault

```bash
# Clone this repo
git clone https://github.com/wse-research/guided-learning-skill.git

# Copy into your vault's skill directory
cp -r guided-learning-skill/SKILL.md YOUR_VAULT/SKILLS/guided-learning/SKILL.md
cp -r guided-learning-skill/CHANGELOG.md YOUR_VAULT/SKILLS/guided-learning/CHANGELOG.md
cp -r guided-learning-skill/references/ YOUR_VAULT/SKILLS/guided-learning/references/
mkdir -p YOUR_VAULT/SKILLS/guided-learning/logs/
```

### 2. Set up the interactive system (optional but recommended)

The skill generates interactive HTML visualizations for quantitative concepts. These need a shared CSS design system and a build script that inlines the CSS for Obsidian compatibility.

```bash
# Copy the design system
mkdir -p YOUR_VAULT/learning/interactives/
cp guided-learning-skill/interactives/interactive.css YOUR_VAULT/learning/interactives/
cp guided-learning-skill/interactives/build.sh YOUR_VAULT/learning/interactives/
chmod +x YOUR_VAULT/learning/interactives/build.sh
```

### 3. Create your learning roadmap

The roadmap is a markdown file that lists concepts grouped by cluster, ordered by dependency. The skill reads this to know what to teach next.

Copy the example and adapt it to your domain:

```bash
cp guided-learning-skill/examples/learning-roadmap.md YOUR_VAULT/learning/learning-roadmap.md
```

See [examples/learning-roadmap.md](examples/learning-roadmap.md) for the format. The key structure:

```markdown
## Pass 1: Overview

### Cluster 1: Foundations
- [ ] [[concept-a]]
- [ ] [[concept-b]]

### Cluster 2: Core Methods
- [ ] [[concept-c]]   ← depends on concept-a
- [ ] [[concept-d]]
```

### 4. Create concept notes

Each concept in the roadmap should have a corresponding note in `concepts/`. The skill reads these to build explanations. Minimal format:

```markdown
---
title: Your Concept Name
type: concept
sources:
  - "[[literature/papers/author-year/summary]]"
tags:
  - your-domain
---

# Your Concept Name

## Core Claim
One-sentence statement of what this concept says.

## Evidence
- Key finding from source paper (citation)

## Implications
- What this means for your research
```

### 5. Create the recall queue

```bash
cp guided-learning-skill/examples/recall-queue.md YOUR_VAULT/learning/recall-queue.md
```

This starts empty and fills up as you complete sessions.

### 6. Register the skill in Claude Code

Add the skill trigger to your Claude Code configuration. If you're using the [Superpowers](https://github.com/anthropics/claude-code) skill system, the skill description in `SKILL.md` handles auto-triggering. Otherwise, you can invoke it directly:

```
/guided-learning
```

Or just say: "teach me the next concept", "let's do a learning session", "continue my roadmap".

## Vault Structure

After setup, your vault should look like this:

```
your-vault/
├── SKILLS/
│   └── guided-learning/
│       ├── SKILL.md          ← the skill definition
│       ├── CHANGELOG.md
│       ├── logs/             ← execution logs (auto-generated)
│       └── references/
├── learning/
│   ├── learning-roadmap.md   ← your concept order
│   ├── recall-queue.md       ← spaced repetition tracker
│   ├── protocols/            ← session journals (auto-generated)
│   └── interactives/
│       ├── interactive.css   ← shared design system
│       ├── build.sh          ← CSS inliner for Obsidian
│       └── *.html            ← generated visualizations
├── concepts/                 ← your concept notes
├── literature/papers/        ← paper summaries
└── research/
    └── glossary.md           ← domain glossary
```

## How Sessions Work

### The Spiral

Concepts are organized into **clusters** (groups of related ideas) and visited in **three passes**:

- **Pass 1** gives you the intuition. You should be able to explain the concept in one sentence and say why it matters.
- **Pass 2** gives you working knowledge. You trace the method with real numbers, evaluate the evidence, find the boundary conditions, and connect it to other concepts.
- **Pass 3** gives you fluency. You read the original paper critically, write arguments using the concept, handle reviewer objections, and teach it to others.

### Spaced Recall

Every concept you learn enters the recall queue. Before each new session, the skill checks if any concepts are due for recall and quizzes you:

- **Solid** → interval advances (3d → 7d → 21d → removed)
- **Fuzzy** → same interval, try again next time
- **Blank** → reset to 3d, brief refresher before continuing

### Interactive Visualizations

For quantitative concepts (statistics, metrics, tradeoff spaces, sequential processes), the skill generates self-contained HTML files with:

- Sliders and controls to explore parameter spaces
- Real-time charts and visualizations
- Preset configurations for key scenarios
- "What to notice" prompts for guided exploration

These open directly in Obsidian or any browser. The dark-theme design system (`interactive.css`) keeps them visually consistent.

### Comprehension Checks

18 different formats across three passes — conference pitches, devil's advocate challenges, spot-the-flaw exercises, reviewer simulations, writing tasks. The skill never uses the same format two sessions in a row.

### Struggle Pattern Tracking

The skill tracks recurring correction types across sessions using six tags (`implication-gap`, `terminology-confusion`, `math-gap`, `scope-creep`, `shallow-framing`, `connection-blind`). Every 5 sessions, it reviews the pattern and adapts its teaching style if any tag is trending.

## Customization

### Adapting to Your Domain

The skill is domain-agnostic — it works with any research field. To make it work well for yours:

1. **Write good concept notes.** The richer your concept notes (core claim, evidence, implications, connections), the better the explanations.
2. **Order your roadmap by dependency.** Concepts that build on earlier ones should come later in the roadmap.
3. **Use realistic examples.** When the skill asks for "realistic values from the learner's domain," it draws from your concept notes and paper summaries.

### Changing Paths

All vault paths are listed in the **Configuration** section at the top of `SKILL.md`. Change them to match your vault structure.

### Adding Explanation Archetypes

The five archetypes (misconception flip, problem-first, contrast, historical narrative, worked example) are defined in Phase 1. You can add new ones by extending that section.

### Custom Comprehension Checks

The check pool in Phase 2 can be extended with domain-specific formats. Just add them under the appropriate pass level.

## Design Decisions

**Why a spiral curriculum?** Single-pass learning doesn't stick. Revisiting concepts at increasing depth builds layered understanding — first intuition, then mechanics, then fluency. This mirrors how experts actually learn.

**Why interactive HTML instead of static diagrams?** Parameter exploration builds intuition that reading can't. When you drag a slider and watch the ROC curve shift, you understand the tradeoff viscerally. The HTML files are self-contained (no server needed) and work in Obsidian's built-in browser.

**Why spaced recall?** Without it, you forget 70% within a week. The 3/7/21-day schedule is a simplified Leitner system that catches forgetting before it compounds.

**Why struggle pattern tracking?** Recurring correction types reveal systematic gaps. If you keep missing implications, the skill preemptively adds "What this means for your system" sections. This is how the skill adapts to your learning style over time.

**Why execution logs + session protocols?** Logs are operational (machine-readable YAML for the skill's self-improvement loop). Protocols are human-readable journals for your own review. Both serve different purposes.

## Version History

See [CHANGELOG.md](CHANGELOG.md) for the full version history. This skill has been through 12+ iterations based on real session feedback, with changes driven by execution log analysis.

## License

MIT. See [LICENSE](LICENSE).

## Credits

Developed by [Jonas Gwozdz](https://github.com/jonasgwozdz) at the [WSE Research Group](https://github.com/wse-research), HTWK Leipzig. Born from the need to actually remember what you read during a PhD.
