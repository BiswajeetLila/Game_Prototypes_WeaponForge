export const meta = {
  name: 'marketing-reels-learn-fanout',
  description: 'LEARN phase: pull genre ad creatives per network, rank by ad longevity, synthesize a longevity-weighted pattern library entry.',
  phases: [
    { title: 'Pull', detail: 'app-intel ad_top_creatives per network' },
    { title: 'Synthesize', detail: 'merge into one genre pattern-library entry' },
  ],
}

// v0.1 — heavy edits expected. Workflow scripts have NO filesystem access:
// this returns the synthesized markdown; the runbook writes it to
// ../knowledge/pattern-library/<genre>.md.

const genre = (args && args.genre) || 'unknown-genre'
const networks = (args && args.networks) || ['Applovin', 'Unity', 'Instagram', 'TikTok']
const country = (args && args.country) || 'US'
const os = (args && args.os) || 'ios'
const category = (args && args.category) || 6014 // iOS Games
const date = (args && args.date) || '2026-05-01' // a POPULATED month (Date.now() is unavailable here)
const period = (args && args.period) || 'month'
const limit = (args && args.limit) || 50

const NET_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['network', 'creatives'],
  properties: {
    network: { type: 'string' },
    creatives: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['app', 'run_days', 'first_seen', 'last_seen', 'hook_guess'],
        properties: {
          app: { type: 'string' },
          publisher: { type: 'string' },
          duration_s: { type: 'number' },
          dims: { type: 'string' },
          first_seen: { type: 'string' },
          last_seen: { type: 'string' },
          run_days: { type: 'number' },
          hook_guess: { type: 'string', description: 'inferred first-1-3s hook archetype + what the opening frame likely shows' },
        },
      },
    },
    notes: { type: 'string' },
  },
}

phase('Pull')
const perNetwork = await parallel(
  networks.map((net) => () =>
    agent(
      `You are pulling competitor ad-creative intelligence for the "${genre}" mobile-game genre.\n` +
        `Use ToolSearch to load the tool "mcp__6b3af0bd-11b2-4b6a-aeae-b86eb0c40485__ad_top_creatives", then call it with:\n` +
        `{ os: "${os}", category: ${category}, country: "${country}", network: "${net}", ad_types: "video", date: "${date}", period: "${period}", limit: ${limit} }.\n` +
        `GOTCHAS: valid networks exclude "Facebook" (use "Instagram"); usage.limit:0 does NOT mean blocked; if count:0 the date/network combo is empty — try one earlier month before giving up.\n` +
        `From the results, compute run_days = (last_seen_at - first_seen_at) in days and KEEP THE LONGEST-RUNNING creatives (longevity = performance proxy). Return the top ${'10'} by run_days, each with app name, publisher, video duration, dims, first/last seen, run_days, and a hook_guess (the first-1-3s archetype + what the opening frame shows, inferred from app + format). Be honest if data is thin.`,
      { label: `pull:${net}`, phase: 'Pull', schema: NET_SCHEMA }
    )
  )
)

const clean = perNetwork.filter(Boolean)
log(`pulled ${clean.length}/${networks.length} networks for ${genre}`)

phase('Synthesize')
const synthesis = await agent(
  `Synthesize a single longevity-weighted pattern-library entry (markdown) for the "${genre}" genre from these per-network ad-creative pulls.\n\n` +
    `DATA:\n${JSON.stringify(clean, null, 2)}\n\n` +
    `Write markdown exactly matching the format in Marketing-Reels/knowledge/pattern-library/README.md: a header line (source/networks/date/N), a "Winning hooks (longevity-ranked)" table, "Winning structures", "Saturated / avoid" (short-run high-frequency = burned out), and "Copy / caption phrases that recur". Rank by run length. CITE the apps so every claim is auditable. Output ONLY the markdown.`,
  { label: 'synthesize', phase: 'Synthesize' }
)

return { genre, date, networks, perNetwork: clean, markdown: synthesis }
