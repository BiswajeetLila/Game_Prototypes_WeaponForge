"""Inject +40% sizing + viewport-fill override CSS into the deck."""
import pathlib

DECK = pathlib.Path(__file__).parent / "afk-journey-deck.html"
html = DECK.read_text(encoding="utf-8")

OVERRIDE = """
/* ============================================================
   SIZING OVERRIDE — +40% base scale + viewport-fill content
   Last rule wins (same specificity) — applies on top of all earlier rules.
   ============================================================ */
/* Reduce padding waste */
.slide{padding:2.4vh 3.2vw 4.5vh;}
.slide footer{font-size:1rem;bottom:1.4vh;}

/* Bigger headings + body */
.slide h1{font-size:clamp(3.4rem,6.6vw,6rem);}
.slide h2{font-size:clamp(2.2rem,3.6vw,3.4rem);margin:0 0 0.45em;}
.slide h3{font-size:1.35rem;}
.slide p,.slide li{font-size:clamp(1.15rem,1.55vw,1.45rem);line-height:1.55;}
.slide .subtitle{font-size:1.3rem;letter-spacing:0.16em;}
.src{font-size:0.92rem;padding:0.2em 0.7em;}

/* Stats / cover */
.stat .label,.stat-card .sc-label,.day-section .ds-label{font-size:0.88rem;}
.stat .value{font-size:clamp(1.7rem,2.5vw,2.6rem);}
.stat .sub,.stat-card .sc-sub{font-size:0.95rem;}
.stat-card{padding:2vh 1.5vw;}
.stat-card .sc-val{font-size:1.3rem;line-height:1.3;}
.cover-text .tagline{font-size:clamp(1.2rem,1.7vw,1.55rem);max-width:42ch;}

/* Force layout wrappers to FILL viewport */
.whatitis-wrap,.takeaways-grid,.loop-wrap,.anatomy-wrap,.resonhall-wrap,.matrix-wrap,
.iap-table-wrap,.tier-ladder-wrap,.bento-6,.modes-wrap,.hd-wrap,.season-wrap,
.deepdive-wrap,.cohort-3col,.layer-stack,.monetize-wrap,.barchart-wrap,
.comparator-grid,.vfx-wrap,.cover-wrap{flex:1 1 0;height:100%;}

/* Slide is flex column — children stretch */
.slide{justify-content:flex-start;}

/* Tables fill vertical space */
.matrix-wrap,.iap-table-wrap{display:flex;flex-direction:column;}
.matrix-wrap table,.iap-table{flex:1;width:100%;}
.faction-matrix th,.faction-matrix td{font-size:1.05rem;padding:1.1vh 0.9vw;}
.faction-matrix th{font-size:1rem;}
.iap-table th,.iap-table td{font-size:1.05rem;padding:1.1vh 1vw;}
.iap-table th{font-size:1rem;}

/* iap-table wrap: row layout with stretched sidebar */
.iap-table-wrap{flex-direction:row;align-items:stretch;}
.iap-sidebar{min-width:260px;max-width:300px;justify-content:flex-start;}
.iap-sidebar .sidebar-card{padding:1.6vh 1.3vw;}
.iap-sidebar .sidebar-card h3{font-size:1.05rem;}
.iap-sidebar .sidebar-card p{font-size:0.95rem;line-height:1.5;}

/* Cards bigger text */
.callout-row{padding:1vh 1.4vw;}
.callout-row h3{font-size:1.05rem;margin:0 0 0.2em;}
.callout-row p{font-size:0.95rem;line-height:1.45;}
.bento-card{padding:1.8vh 1.5vw;}
.bento-card h3{font-size:1.1rem;margin:0 0 0.35em;}
.bento-card p{font-size:0.95rem;line-height:1.5;}
.verbatim-quote{font-size:1rem;padding:1.2vh 1.5vw;}

/* Tier ladder rows */
.tier-rung{padding:1.4vh 1.5vw;}
.tier-rung .tr-name{font-size:1.4rem;min-width:160px;}
.tier-rung .tr-desc{font-size:1.05rem;line-height:1.5;}

/* Bento 6 cards */
.bento6-card{padding:1.8vh 1.4vw;}
.bento6-card h3{font-size:1.15rem;}
.in-out{font-size:0.95rem;line-height:1.55;}

/* Modes grid */
.bento-8{height:100%;}
.mode-card{padding:1.4vh 1.2vw;}
.mode-card h3{font-size:1.05rem;margin:0 0 0.3em;}
.mode-card p{font-size:0.9rem;line-height:1.45;}
.modes-sidebar{justify-content:flex-start;}
.miasma-callout{padding:1.4vh 1.2vw;}
.miasma-callout h3{font-size:1.05rem;}
.miasma-callout p{font-size:0.92rem;line-height:1.45;}

/* Honor Duel timeline */
.tl-slot{padding:0.9vh 0.3vw;font-size:0.85rem;}
.hd-fact{padding:1vh 1.2vw;font-size:1rem;line-height:1.5;}
.hd-quote{padding:1.2vh 1.3vw;font-size:0.98rem;}
.art-tier{padding:1vh 1vw;}
.art-tier h3{font-size:1rem;margin:0 0 0.15em;}
.art-tier p{font-size:0.88rem;}

/* Season bands */
.season-band{padding:1.4vh 1.4vw;}
.season-band h3{font-size:1.15rem;margin:0 0 0.35em;}
.season-band p{font-size:0.98rem;line-height:1.5;}
.season-side-card{padding:1.1vh 1vw;}
.season-side-card h3{font-size:1rem;}
.season-side-card p{font-size:0.88rem;line-height:1.45;}
.season-img{max-height:30vh;}

/* Deep-dive day cards */
.day-cards{height:auto;flex:1;}
.day-card{padding:1.5vh 1.2vw;}
.day-card h3{font-size:1.15rem;margin:0 0 0.55em;}
.day-section{margin-bottom:0.55em;}
.day-section .ds-label{font-size:0.82rem;}
.day-section p{font-size:0.95rem;line-height:1.5;}
.day-band{padding:1.3vh 1.5vw;}
.day-band h3{font-size:1.1rem;}
.day-band p{font-size:0.98rem;line-height:1.5;}

/* Cohort cards */
.cohort-card{padding:1.8vh 1.6vw;}
.cohort-card h3{font-size:1.18rem;}
.cohort-card p{font-size:0.98rem;line-height:1.55;}
.cohort-signal{font-size:0.92rem;padding:0.7vh 1vw;}

/* Layer stack */
.layer-card{padding:1.4vh 1.6vw;}
.layer-card h3{font-size:1.15rem;}
.layer-card p{font-size:0.98rem;line-height:1.5;}

/* Bar chart */
.bar-row{gap:0.25vh;}
.bar-list{gap:1.2vh;flex:1;}

/* Takeaways pillars */
.takeaway-card{padding:2.4vh 1.8vw;gap:1.2vh;}
.takeaway-card h3{font-size:1.3rem;}
.takeaway-card p{font-size:1rem;line-height:1.6;}
.takeaway-card ul{font-size:1rem;line-height:1.7;}
.big-statement{font-size:clamp(1.3rem,1.9vw,1.7rem);padding:1.6vh 2.5vw;margin-bottom:1.8vh;}

/* Anatomy + Resonhall: larger image */
.anatomy-img{max-height:80vh;}
.resonhall-img{max-height:78vh;}

/* Layout wrappers: stretch (was 'start') so cards fill vertically */
.whatitis-wrap{align-items:stretch;}
.anatomy-wrap{align-items:stretch;}
.resonhall-wrap{align-items:stretch;}
.tier-ladder-wrap{align-items:stretch;}
.modes-wrap{align-items:stretch;}
.hd-wrap{align-items:stretch;}
.season-wrap{align-items:stretch;}
.monetize-wrap{align-items:stretch;}
.barchart-wrap{align-items:stretch;}

/* Tier-ladder + iap-sidebar etc: column flex with even spacing */
.tier-ladder{flex:1;justify-content:space-between;}
.season-bands{flex:1;justify-content:space-between;}
.day-cards{display:grid;grid-template-columns:repeat(3,1fr);gap:1.2vw;flex:1;}
.layer-stack{flex:1;justify-content:space-evenly;}

/* Nav dots: bigger + more visible */
.nav-dot{width:11px;height:11px;}
.nav-bottom{padding:8px 18px;gap:10px;}

/* Hint */
.hint{font-size:0.85rem;}
"""

# Insert just before </style>
new_html = html.replace("</style>", OVERRIDE + "\n</style>", 1)
DECK.write_text(new_html, encoding="utf-8")
print(f"Patched. New size: {len(new_html)//1024} KB (was {len(html)//1024} KB)")
