|  |  |
| --- | --- |
| [img:ELF Jingwei's Wings (Notice SVG)] | **Where's the Rest?**This article is a stub. You can help Honkai Impact 3 Wiki by expanding it. The following sections or aspects need to be expanded upon: IMG and SD elements. |

## Types

Each damaging attack has multiple types that determine how the damage is calculated.

### Element Type

*Element type* is one of:
- *Physical*: white damage numbers,
  - *Critical hit*: gold damage numbers
- *Lightning*: yellow damage numbers,
- *Fire*: red damage numbers,
- *Ice*: blue damage numbers.
The last three are collectively called *elemental damage*. Damage calculation is very different for physical and elemental damage:
- Resistance: enemies can have different resistance values for each element type.
- Criticals: physical attacks can crit, elemental attacks cannot.
- Defense: physical attacks are mitigated by enemy defense, elemental attacks are not.
- Shields: physical damage is mitigated by elite/boss passive shields, elemental damage is not.
Notably, Q-Singularis bleed, poison mist and reflected damage from shields are physical damage.

### Attack Type

*Attack type* is one of:

| Attack type | Example skill | Example modifier |
| --- | --- | --- |
| Basic attack | [img:White Comet (Icon)] White Comet's basic skill [Meteor Kata] | Otto Apocalypse T |
| Combo attack | [img:White Comet (Icon)] White Comet's special skill [Comet Fall] | Jixuanyuan Aqua T |
| Charge attack | [img:Swallowtail Phantasm (Icon)] Swallowtail Phantasm's special skill [Fluttering Ripple] | Jixuanyuan M |
| Dash attack | [img:Battle Storm (Icon)] Battle Storm's special skill [Storm Assault] |  |
| Switch skill/QTE | [img:White Comet (Icon)] White Comet's special skill [Neko Stomp] is a switch skill and [Aerial Helix] is a QTE | Jixuanyuan T |
| Weapon skill | Cross | Jixuanyuan B |
| Ultimate | Ultimate skills |  |
| No tag | Lier Scarlet M |  |

Notably, certain ultimates (e.g. [img:White Comet (Icon)] White Comet's [Neko-Charm!] and [img:Shadow Knight (Icon)] Shadow Knight's [Raging Dragon]) transform basic attacks into ultimate type during their burst mode. Consequently, effects such as Planck M will not work during the burst mode.

### Range Type

Attacks are either *melee*, *ranged* or *neither*.

For example, [img:Valkyrie Chariot (Icon)] Valkyrie Chariot's basic and charged attack are ranged but her QTE is melee. The second hit of [img:White Comet (Icon)] White Comet's basic attack string is ranged, other hits are melee. Lier Scarlet M, 5th Sacred Relic's shrapnel and Rinaldo T are neither melee nor ranged.

Jun-Ninja can block melee attacks. Joyo-Ninja can deflect and dodge ranged attacks.

## Damage

Damage values are computed using the formula:

Final damage
 =
 Base damage
 ×
 Character damage multiplier
 ×
 Target damage receive multiplier
 ×
 Type multiplier
 
 
 {\displaystyle \text{Final damage} = \text{Base damage} \times \text{Character damage multiplier} \times \text{Target damage receive multiplier} \times \text{Type multiplier}}
 
[img:{\displaystyle {\text{Final damage}}={\text{Base damage}}\times {\text{Character damage multiplier}}\times {\text{Target damage receive multiplier}}\times {\text{Type multiplier}}}]

The used variables are explained in more depth below.

### Base Damage

Base damage
 =
 Skill ATK multiplier
 ×
 ATK
 +
 Skill DMG
 ,
 
 
 {\displaystyle \text{Base damage} = \text{Skill ATK multiplier}\times\text{ATK}+\text{Skill DMG},}
 
[img:{\displaystyle {\text{Base damage}}={\text{Skill ATK multiplier}}\times {\text{ATK}}+{\text{Skill DMG}},}] where:
- Skill ATK multiplier
 
 
 {\displaystyle \text{Skill ATK multiplier}}
 
[img:{\displaystyle {\text{Skill ATK multiplier}}}] is the percentage listed in the used skill's description.
- ATK
 
 
 {\displaystyle \text{ATK}}
 
[img:{\displaystyle {\text{ATK}}}] is the sum of ATK stats of the attacking battlesuit and her weapon and stigmata.
- Skill DMG
 
 
 {\displaystyle \text{Skill DMG}}
 
[img:{\displaystyle {\text{Skill DMG}}}] is the flat damage listed on certain skills.
For example, consider [img:White Comet (Icon)] White Comet's basic attack [Meteor Kata]. The first sequence deals "100% ATK of Physical DMG", so 
 
 
 
 Skill ATK multiplier
 =
 1
 
 
 {\displaystyle \text{Skill ATK multiplier}=1}
 
[img:{\displaystyle {\text{Skill ATK multiplier}}=1}]. Furthermore, basic attack subskill [Comet Kata] reads "Physical DMG dealt by each sequence of the 4-sequence Basic ATK increases by 143.0", so 
 
 
 
 Skill DMG
 =
 143
 
 
 {\displaystyle \text{Skill DMG}=143}
 
[img:{\displaystyle {\text{Skill DMG}}=143}].

### Character Damage Multiplier

For summons, this is equal to 1. For players,

Character damage multiplier
 =
 (
 1
 +
 Total DMG Multiplier
 )
 ×
 (
 1
 +
 Element DMG Multiplier
 )
 ×
 Critical multiplier
 ,
 
 
 {\displaystyle \text{Character damage multiplier} = (1+\text{Total DMG Multiplier})\times (1+\text{Element DMG Multiplier})\times \text{Critical multiplier},}
 
[img:{\displaystyle {\text{Character damage multiplier}}=(1+{\text{Total DMG Multiplier}})\times (1+{\text{Element DMG Multiplier}})\times {\text{Critical multiplier}},}] where:
- Total DMG Multiplier
 
 
 {\displaystyle \text{Total DMG Multiplier}}
 
[img:{\displaystyle {\text{Total DMG Multiplier}}}] is the sum of the battlesuit's Total DMG multiplier stats, e.g., from stigmata.
- Element DMG Multiplier
 
 
 {\displaystyle \text{Element DMG Multiplier}}
 
[img:{\displaystyle {\text{Element DMG Multiplier}}}] is the sum of the battlesuit's DMG stats that match the attack's element, e.g., *Physical DMG* for physical attacks.
- Critical multiplier
 
 
 {\displaystyle \text{Critical multiplier}}
 
[img:{\displaystyle {\text{Critical multiplier}}}] is 1 for noncrits and 
 
 
 
 2
 +
 Crit damage
 
 
 {\displaystyle 2+\text{Crit damage}}
 
[img:{\displaystyle 2+{\text{Crit damage}}}] for crits.

### Target Damage Receive Multiplier

Target damage receive multiplier
 =
 (
 1
 +
 Target Total DMG Multiplier
 )
 ×
 (
 1
 +
 Target element multiplier
 )
 ×
 Target element resistance multiplier
 ×
 Target defense multiplier
 ,
 
 
 {\displaystyle \text{Target damage receive multiplier} = (1 + \text{Target Total DMG Multiplier})\times(1 + \text{Target element multiplier}) \times \text{Target element resistance multiplier}\times\text{Target defense multiplier},}
 
[img:{\displaystyle {\text{Target damage receive multiplier}}=(1+{\text{Target Total DMG Multiplier}})\times (1+{\text{Target element multiplier}})\times {\text{Target element resistance multiplier}}\times {\text{Target defense multiplier}},}]

- Target Total DMG Multiplier
 
 
 {\displaystyle \text{Target Total DMG Multiplier}}
 
[img:{\displaystyle {\text{Target Total DMG Multiplier}}}] is the sum of Total DMG multiplier stats applied on the target by debuffs.
- Target element multiplier
 
 
 {\displaystyle \text{Target element multiplier}}
 
[img:{\displaystyle {\text{Target element multiplier}}}] is the sum of element DMG bonuses applied on the target by debuffs, e.g., Blood Dance's skill [Blood Drake].
- Target element resistance multiplier
 
 
 {\displaystyle \text{Target element resistance multiplier}}
 
[img:{\displaystyle {\text{Target element resistance multiplier}}}] is determined by enemy type and cannot be affected by the player.
- Target defense multiplier
 =
 
 {
 
 
 
 1
  for elemental
 
 
 
 
 
 1
 
 1
 +
 
 DEF
 
 20
 ×
 (
 AttackerLevel
 +
 15
 )
 
 
 
 
  for physical
 
 
 
 
 
 
 
 {\displaystyle \text{Target defense multiplier}=\begin{cases}1\text{ for elemental}\\\frac{1}{1+\frac{\text{DEF}}{20\times(\text{AttackerLevel}+15)}}\text{ for physical}\end{cases}}
 
[img:{\displaystyle {\text{Target defense multiplier}}={\begin{cases}1{\text{ for elemental}}\\{\frac {1}{1+{\frac {\text{DEF}}{20\times ({\text{AttackerLevel}}+15)}}}}{\text{ for physical}}\end{cases}}}], where
  - DEF
 
 
 {\displaystyle \text{DEF}}
 
[img:{\displaystyle {\text{DEF}}}] is the target's DEF stat. Defense can be reduced with impair.

### Type Multiplier

Type multiplier is determined by the attacker's and target's types, which are either *mecha*, *biologic*, *psychic* or *quantum*. Mecha is strong against biologic, biologic is strong against psychic, and psychic is strong against mecha. Conversely, biologic is weak against mecha and so on. With this in mind, the type multiplier is given by

Type multiplier
 =
 
 {
 
 
 
 1.3
  if strong
 
 
 
 
 0.7
  if weak
 
 
 
 
 1
  otherwise
 
 
 
 
 
 
 
 {\displaystyle \text{Type multiplier}=\begin{cases}1.3\text{ if strong} \\ 0.7\text{ if weak} \\ 1\text{ otherwise} \end{cases} }
 
[img:{\displaystyle {\text{Type multiplier}}={\begin{cases}1.3{\text{ if strong}}\\0.7{\text{ if weak}}\\1{\text{ otherwise}}\end{cases}}}]

Quantum is neither strong nor weak against all types and hence has multiplier 1.

## Hidden Damage Stats

Attacks can deal extra damage to shields or have force power.

### Shield Damage

Shield Damage is based on at least 3 stats: Final Character Damage, Hit weight and Shield Damage Multiplier.

Shield Damage Multiplier
 =
 (
 1
 +
 Damage to shield
 )
 
 
 {\displaystyle \text{Shield Damage Multiplier} = (1 + \text{Damage to shield})}
 
[img:{\displaystyle {\text{Shield Damage Multiplier}}=(1+{\text{Damage to shield}})}]

### Force Power

Force Power depends on character attack velocity and weight.

[img:Yamabuki Armor (Icon)] Yamabuki Armor and [img:Divine Prayer (Icon)] Divine Prayer tag-in have highest force power in the game.

## Critical Strike Chance

Crit rate
 
 =
 
 
 CRT
 
 
 Level
 
 ×
 5
 +
 75
 
 
 
 ×
 100
 %
 +
 
 Bonus rate
 
 ,
 
 
 {\displaystyle {\text{Crit rate}}={\frac {\text{CRT}}{{\text{Level}}\times 5+75}}\times 100\%+{\text{Bonus rate}},}
 
[img:{\displaystyle {\text{Crit rate}}={\frac {\text{CRT}}{{\text{Level}}\times 5+75}}\times 100\%+{\text{Bonus rate}},}] where:
- CRT
 
 
 {\displaystyle \text{CRT}}
 
[img:{\displaystyle {\text{CRT}}}] is the sum of CRT stats of the attacking battlesuit and her weapon and stigmata.
- Level
 
 
 {\displaystyle \text{Level}}
 
[img:{\displaystyle {\text{Level}}}] is the attacking battlesuit's level.
- Bonus rate
 
 
 {\displaystyle \text{Bonus rate}}
 
[img:{\displaystyle {\text{Bonus rate}}}] is CRT added by skills (including leader skills) and buffs (e.g. Rowland 3 set).
For example, a level 80 battlesuit with 70 CRT from equipment will have 14.7% chance to crit.

## See also

The following pages list equipment that increase specific damage stats:

- Increases CRT
- Increases Crit Rate (to be merged)
- Increases Critical Rate (to be merged)
- Increases Attack Speed

## Notes

## References
