Updated for Version 1.3

Note that the information given may change if new discoveries are made. More extensive testing is in progress.

Join our Discord to check on and participate in the theorycrafting process.

Table of Contents

## Introduction

Fu Xuan is a 5★ Quantum character who follows the Path of Preservation. She offers a unique take on damage mitigation by primarily focusing on redirecting a portion of the damage her allies receive onto herself instead of directly preventing or healing sustained damage.

With a well-built Fu Xuan on the team, it is very unlikely that any team member will die before a fight is over. If the team is lacking damage or a single ally is targeted multiple times in a row, a unit may be knocked down, but these are not issues that could be solved with a different sustain unit.

## Infographic

Credits to: erisdc, euphorysm, Mayonnaise, and KQM Staff

## Mechanics

Fu Xuan’s primary mechanic is the Matrix of Prescience from her Skill, which redirects 65% of all DMG her allies would take onto herself before this DMG is mitigated by any Shields. In fact, it redirects DMG before it is mitigated by any parts of the incoming DMG formula.

How does Incoming DMG work?

To understand how Fu Xuan’s damage mitigation works, it’s necessary to understand how incoming DMG is calculated. All enemy attacks have a certain ‘damage value’ associated with them. When an attack hits an ally, this ‘damage value’ is modified by four things: the ally’s DEF, Type RES, DMG Reduction, and any Vulnerability debuff present on the ally.

The Incoming DMG formula, if you’re interested:

 \(\text{Total DMG Taken = Incoming DMG} \times \text{Incoming DMG Multiplier}\)

 \(\text{Incoming DMG Multiplier = DEF Multipler} \times \text{Type RES} \times \text{DMG Reduction} \times \text{Vulnerability}\)

 \(\text{DEF Multiplier = 1 } – \frac{\text{DEF}}{\text{DEF + 200 + 10 } \times \text{ Attacker Level}}\)

Where does the Matrix come into the formula?

The Matrix of Prescience distributes incoming DMG before any mitigation by the aforementioned 4 stats. If an ally other than Fu Xuan is hit, 35% of incoming DMG is distributed to the ally taking the hit, and 65% is distributed to Fu Xuan. After the DMG is distributed, it goes through the incoming DMG formula for Fu Xuan and the ally individually. If Fu Xuan herself is hit, no DMG is distributed to other allies, and the DMG goes directly through the incoming DMG formula without any extra steps.

Redirected damage is calculated against Fu Xuan’s defensive stats while the 35% that other characters take is calculated against their own stats. Fu Xuan does not generate Energy when damaged via the redirected damage. Only attacks directly targeting her cause her to gain Energy.

### Trace Priority

 > >> =

Talent > Skill >> Basic ATK = Ultimate

Talent and Skill levels both improve Fu Xuan’s team support capabilities. Leveling her Talent increases the DMG Reduction she provides to the party and marginally increases her self-sustain, which both noticeably affect her team sustain capabilities. Skill levels increase the Max HP and CRIT Rate buffs, which are convenient, but not critically important. Her Basic ATK and Ultimate lack utility and should not be prioritized.

While Fu Xuan’s Basic ATK and Ultimate both scale on her Max HP, she can not afford to invest into offensive stats without giving up the significant amounts of defensive stats necessary to keep your team alive.

### Traces

 Basic ATK
 Skill
 Ultimate
 Talent
 Technique
 A2 Bonus
 A4 Bonus
 A6 Bonus
 Basic ATK

 Basic ATK | Novaburst

Trace Description

Novaburst [Single Target]

Deals Quantum DMG equal to 25/50/55% of Fu Xuan’s Max HP to a single enemy.

While it scales with her Max HP, it still does not do significant damage due to her stat priority.

Skill

 Skill | Known by Stars, Shown by Hearts

Trace Description

Known by Stars, Shown by Hearts [Defense]

Activates Matrix of Prescience, via which other team members will Distribute 65% of the DMG they receive (before this DMG is mitigated by any Shields) to Fu Xuan for 3 turn(s).
While affected by Matrix of Prescience, all team members gain the Knowledge effect, which increases their respective Max HP by 3/6/6.6% of Fu Xuan’s Max HP, and increases CRIT Rate by 6/12/13.2%.
When Fu Xuan is knocked down, the Matrix of Prescience will be dispelled.

Her bread 🍞 and butter 🧈 ability. To ensure full uptime, use her Skill once every three turns at minimum. When the purple circle on the ground created by the Matrix is flashing, her Skill should be recast because it means the Matrix will expire when her current turn ends.

Ultimate

 Ultimate | Woes of Many Morphed to One

Trace Description

Woes of Many Morphed to One [AoE]

Deals Quantum DMG equal to 60/100/108% of Fu Xuan’s Max HP to all enemies and obtains 1 trigger count for the HP Restore effect granted by Fu Xuan’s Talent.

Damage scales with HP, but it has low scaling and should not be used for its damage. Instead, it should be viewed primarily as a tool to refresh Talent charges.

Talent

 Talent | Bleak Breeds Bliss

Trace Description

Bleak Breeds Bliss [Restore]

While Fu Xuan is still active in battle, Misfortune Avoidance is applied to the entire team. With Misfortune Avoidance, allies take 10/18/19.6% less DMG.
When Fu Xuan’s current HP falls to 50% of her Max HP or less, HP Restore will be triggered for Fu Xuan, restoring her HP by 80/90/92% of the amount of HP she is currently missing. This effect cannot be triggered if she receives a killing blow. This effect possesses 1 trigger count by default and can have a maximum of 2 trigger counts.

The core of her self-sustain. Cannot trigger if she is affected by a Crowd Control debuff.

Technique

 Technique | Of Fortune Comes Fate

Trace Description

Of Fortune Comes Fate [Defense]

After the Technique is used, all team members receive a Barrier, lasting for 20 seconds. This Barrier can block all enemy attacks, and the team will not enter battle when attacked. Entering battle while the Barrier is active will have Fu Xuan automatically activate Matrix of Prescience at the start of the battle, lasting for 2 turn(s).

Allows for full uptime on the Matrix of Prescience before any enemy is able to act.

A2 Bonus

 Ascension 2 Bonus Ability | Taiyi, the Macrocosmic

Trace Description

Taiyi, the Macrocosmic

When Matrix of Prescience is active, Fu Xuan will regenerate 20 extra Energy when she uses her Skill.

Fu Xuan should be using her Skill every third turn at minimum, so she should always get this bonus.

A4 Bonus

 Ascension 4 Bonus Ability | Dunjia, the Metamystic

Trace Description

Dunjia, the Metamystic

When Fu Xuan’s Ultimate is used, heals all other allies by an amount equal to 5% of Fu Xuan’s Max HP plus 133.

Since Fu Xuan drastically decreases the damage her allies take, this healing is worth significantly more than the raw numbers would suggest.

A6 Bonus

 Ascension 6 Bonus Ability | Liuren, the Sexagenary

Trace Description

Liuren, the Sexagenary

If a target enemy applies Crowd Control debuffs to allies while the Matrix of Prescience is active, all allies will resist all Crowd Control debuffs applied by the enemy target during the current action. This effect can only be triggered once. When Matrix of Prescience is activated again, the number of times this effect can be triggered will reset.

Crowd Control debuff prevention is especially powerful, as it prevents effects before they’re even applied. Note that this Crowd Control debuff prevention takes priority over Effect RES; that is, if an enemy attempts to apply a Crowd Control debuff to a party member while this effect is active, it will be consumed before that party member’s Effect RES has a chance to resist the debuff.

Note: Trace levels shown are 1/10/12 (Basic ATK 1/6/7).

### Eidolons

 Eidolon 1
 Eidolon 2
 Eidolon 3
 Eidolon 4
 Eidolon 5
 Eidolon 6
 Eidolon 1

 Eidolon 1 | Dominus Pacis

The Knowledge effect increases CRIT DMG by 30%.

Great Eidolon for her offensive support capabilities. With this Eidolon, she grants the team half as much CRIT Value as a Yukong Ultimate, permanently.

Eidolon 2

 Eidolon 2 | Optimus Felix

If any team member is struck by a killing blow while Matrix of Prescience is active, then all allies who were struck by a killing blow during this action will not be knocked down, and 70% of their Max HP is immediately restored. This effect can trigger 1 time per battle.

Can be a good safety net against heavy AoE content as it works on Fu Xuan herself, but if this is triggering, you likely would not have won the battle anyway.

Eidolon 3

 Eidolon 3 | Apex Nexus

Skill Lv. +2, up to a maximum of Lv. 15.
Talent Lv. +2, up to a maximum of Lv. 15.

Nice increases to her support capability, but relatively minor.

Eidolon 4

 Eidolon 4 | Fortuna Stellaris

When other allies under Matrix of Prescience are attacked, Fu Xuan regenerates 5 Energy.

Provides Fu Xuan with significantly more Energy generation, but without E6, this isn’t particularly valuable.

Eidolon 5

 Eidolon 5 | Arbiter Primus

Ultimate Lv. +2, up to a maximum of Lv. 15.
Basic ATK Lv. +1, up to a maximum of Lv. 10.

Her personal damage is not that notable, so do not go for this unless aiming for E6.

Eidolon 6

 Eidolon 6 | Omnia Vita

Once Matrix of Prescience is activated, it will keep a tally of the total HP lost by all team members in the current battle. Fu Xuan’s Ultimate DMG will increase by 200% of this tally of HP loss.
This tally is also capped at 120% of Fu Xuan’s Max HP and the tally value will reset and re-accumulate after Fu Xuan’s Ultimate is used.

Significantly increases her Ultimate’s damage. If you’re going for this, you know what you’re doing.

## Playstyles

Fu Xuan should always use her Skill every third turn to keep the damage redirection effect permanently active. When the purple circle on the ground created by the Matrix is flashing, her Skill should be recast because it means the Matrix will expire when her current turn ends. If you’re unsure of its duration, you can open her stat page in battle and recast when it says “1 Turn Left”.

Her Ultimate should be used when she has it available and doesn’t have full Talent charges, or if it’s needed to damage enemy Toughness bars.

While she should generally be using Skill-Basic-Basic in sequence, it can be beneficial to use Skill more often if she needs to recharge her Ultimate faster or reapply the Crowd Control debuff resistance from her A6 Trace.

DPS Fu Xuan

Don’t. Please. She has so much to live for.

Do NOT
Build
Damage.

Fu Xuan gains a significant amount of CRIT Rate from her Skill and Traces, and her Basic ATK and Ultimate both deal damage scaling with her Max HP. It may seem tempting to build her for damage, but doing so requires sacrificing her own survivability for insignificant returns. If Fu Xuan deals twice her normal damage but requires you to use a second sustain unit because she can’t keep the team alive, the team will be doing lower damage overall compared to a team where Fu Xuan builds for full survivability and can include a more offensive second unit.

## Builds

### Relics

Fu Xuan benefits immensely from the 2-Pc Set Effect of Guard of Wuthering Snow, but makes poor use of its 4-Pc Set Effect. Damage reduction is vital for surviving redirected AoE damage, but because her Talent triggers immediately whenever she drops below 50% HP, it’s unlikely she will be below 50% HP when her turn begins, which is necessary to benefit from the healing and extra Energy granted by the 4-Pc Set Effect. As such, Fu Xuan’s optimal sets will almost universally contain 2-Pc Guard combined with another 2-Pc set.

#### Recommended Relic Sets

| / 2-Pc Guard of Wuthering Snow / 2-Pc Longevous Disciple | Offering a mix of DMG Reduction and HP%, the combination of Guard of Wuthering Snow and Longevous Disciple results in a large overall gain in durability for Fu Xuan, particularly against redirected AoE damage. This combination also increases her ability to heal and buff the rest of the team. / / Fu Xuan’s most well rounded set, offering everything she wants with no trade-offs. |
| --- | --- |
| / 2-Pc Guard of Wuthering Snow / 2-Pc Knight of Purity Palace | The combination of Guard of Wuthering Snow and Knight of Purity Palace offers Fu Xuan the largest source of personal durability available from Relic Sets, but does nothing for her healing or Max HP buff. Outside of allowing Fu Xuan to take marginally more damage, 2-Pc Knight of Purity Palace has no inherent strengths over 2-Pc Longevous Disciple and is worse to farm. |

#### Suboptimal Relic Sets

| / 2-Pc Guard of Wuthering Snow / 2-Pc Messenger Traversing Hackerspace | The combination of Guard of Wuthering Snow and Messenger Traversing Hackerspace is acceptable, but since Fu Xuan has low base SPD, 2-Pc Messenger Traversing Hackerspace will always be less stat-efficient than 2-Pc Longevous Disciple. Furthermore, since Messenger and Disciple can be obtained from the same Cavern of Corrosion, any account with Messenger pieces will also have Disciple pieces. |
| --- | --- |
| / 2-Pc or 4-Pc Passerby of Wandering Cloud | Fu Xuan does provide some healing, but her primary value comes from taking damage for the team. 2-Pc Passerby does not effectively amplify her value as much as other options. / / The 4-Pc Set Effect can be useful for first-turn setup, but is so situational that it is not generally recommended. |
| / 4-Pc Longevous Disciple | While the bonus CRIT Rate may sound appealing in conjunction with her CRIT Rate Traces and the Matrix of Prescience, the Matrix’s damage redirection will not trigger the 4-Pc Set Effect, which, when combined with her lack of aggro bonuses, makes the Set Effect uptime dubious. |
| / 4-Pc Guard of Wuthering Snow | The 4-Pc Set Effect only procs on the wearer’s turn, and her Talent heals her when she is under 50% HP, which prevents the Set Effect from activating in most scenarios. If your Fu Xuan is ever in a scenario where she can take advantage of 4-Pc Guard, there are probably larger problems to deal with than a lack of Energy. |
| Any Damage-focused Set | Do not build Fu Xuan for damage. Please. |

#### Planar Ornaments

| / Broken Keel | The extra CRIT DMG from Broken Keel works exceptionally well with the CRIT Rate from Knowledge, giving Fu Xuan the ability to fully commit to the CRIT support side of her kit. Effect RES is also useful and with 10% Effect RES from stat Traces, Fu Xuan has little issue activating Broken Keel. |
| --- | --- |
| / Fleet of the Ageless | The HP% increase from Fleet of the Ageless is helpful in general, and ATK% is useful for most characters. Fu Xuan can reach 120 SPD with just SPD Boots, making this set effect easier to trigger than Broken Keel. |

### Light Cones

| / She Already Shut Her Eyes | Fu Xuan’s signature Light Cone She Already Shut Her Eyes is her best universal option, providing many useful bonuses. It offers the highest Base HP of any Preservation Light Cone along with an additional HP% increase, giving her much higher Max HP than other Light Cones. / / The ERR buff results in a notable increase in Ultimate frequency, especially when paired with an ERR Link Rope. / / Thanks to her Skill’s damage redirection, she easily has 100% uptime on the party-wide DMG% buff (equating ~3% to 6% damage increase), although it won’t trigger if all damage to her is mitigated by Shields. / / The on-wave healing effect is nice, but it is not significant in practice. |
| --- | --- |
| / Texture of Memories | Texture of Memories is a highly accessible option from Herta’s Store that offers a Shield for several turns after Fu Xuan is directly targeted by an attack, as well as DMG reduction while shielded. At S5, it can be difficult for even the strongest AoE attacks in the game to penetrate the Shield. / / The Effect RES is quite useful for Fu Xuan, helping to activate Broken Keel as well as offering a chance to avoid any effects that would prevent her Talent from activating. / / Recall that the only way Fu Xuan’s team can lose is if she dies. While Texture of Memories lacks the aggro increase of other options, it provides the highest personal survivability for Fu Xuan in virtually all scenarios. The fringe case where this may not be true is practically unreachable in reality, making this a surprisingly potent and consistent option. |
| / Day One of My New Life | Day One of My New Life provides approximately the same personal damage mitigation as other options aside from Texture of Memories, but also bestows the entire party with extra damage mitigation in the form of All-Type RES, granting the highest teammate survivability of any Light Cone. |
| / Moment of Victory | Moment of Victory is a good general defensive option with high Base HP and DEF, a permanent DEF% increase, and increased aggro for the wearer. / / The increased aggro does several things: / It draws non-AoE enemy attacks away from allies, further reducing the damage they take.It makes activating the conditional DEF% effect more consistent.It gives Fu Xuan additional Energy generation by means of enemy attacks, about the same expected Energy generation as She Already Shut Her Eyes. / However, increased aggro is a double-edged sword. If Fu Xuan takes too many hits instead of her allies, she can end up dying while the rest of the team remains at or near full health. Since she takes a portion of her allies’ incoming damage, it is not an effective use of total team HP for Fu Xuan to take the majority of enemy hits directly. / / It’s also worth noting that when Fu Xuan is paired with allies that rely on being attacked by enemies (such as Clara), aggro-increasing Light Cones like Moment of Victory become significantly worse than other options. |
| / Landau’s Choice | While its base stats are lower than Moment of Victory, Landau’s Choice provides comparable survivability at high Superimposition Ranks and is an excellent defensive choice. Like Moment of Victory, Landau’s Choice offers increased aggro and personal damage mitigation, with all the same benefits and drawbacks. |
| / Defense | Defense has the Max HP of a 4-Star Light Cone while offering a large self heal when Fu Xuan uses her Ultimate. At S5, Fu Xuan heals for 30% of her Max HP every activation of her Ultimate. / / Defense has very poor Base DEF however, making Fu Xuan more vulnerable to being knocked down by redirecting AoE damage to herself. / / If you have any of the above options, use them instead. |
| / We Are Wildfire | While We Are Wildfire offers some DMG reduction to the team, it only applies to the first five turns of each ally and does not refresh on new waves. Combined with its low Base HP, this generally makes it outclassed by the other free options such as Defense and Texture of Memories. / / The HP restoration effect is functionally useless for most hard content as it will only trigger upon the start of a battle and not on subsequent waves. / / If you have any of the above options, use them instead. |

Sources
Survivability and Energy Calculator by jas and Soul Fish
Light Cone Comparison Calcs by Soul Fish

### Stats

| / Body | / Boots | / Sphere | / Rope |
| --- | --- | --- | --- |
| HP% | SPD or HP% | HP% | ERR% or HP% |

#### Substats

SPD >= HP% > DEF% >= Effect RES

SPD vs HP% Boots

While Fu Xuan is SP-positive, her redirection based damage mitigation can put heavy strain on her HP in AoE heavy encounters. Taking more actions allows Fu Xuan to refresh her Talent more frequently, but it is important that she survives long enough to do so. The relative rarity of SPD as a substat makes SPD Boots the more common pick, but for players with sufficient SPD from substats, HP% Boots can help Fu Xuan survive to refresh her Talent or heal her allies more effectively.

Energy Regeneration Rate vs HP% Link Rope

Depending on Light Cone and content, Fu Xuan may not meaningfully benefit from Energy Regeneration Rate. With She Already Shut Her Eyes, Fu Xuan only needs 8 additional Energy (before ERR) in order to use her Ultimate every third turn. With other Light Cones, Fu Xuan needs 19 additional Energy (also before ERR) in order to achieve a 3-turn Ultimate rotation. When running She Has Already Shut Her Eyes or an aggro-increasing Light Cone, Energy Regeneration Rate becomes a powerful option provided Fu Xuan is not being instantly killed.

DEF% is not a Dead Stat

While Fu Xuan does not have any Abilities that directly scale with DEF, her primary value comes from taking damage for allies, and DEF decreases the damage she receives. However, while DEF is valuable for her, HP is still more valuable, and HP% mainstats will always be preferable to DEF% mainstats.

## E1 or S1?

Fu Xuan functions very well without Eidolons or her signature Light Cone. However, if looking to invest into Fu Xuan further, she will almost certainly get more value out of her first Eidolon. She Already Shut Her Eyes does not provide enough DMG% or ERR% to noticeably beat out other Light Cone options, including free and 4-Star options, and the healing effect is fairly situational.

## Character Comparisons

### Gepard

 [img: Gepard Sticker - Second Closed Beta]

Fu Xuan is not as SP-positive as Gepard due to needing to use her Skill every third turn, while Gepard can generally go fully SP-positive. However, she provides greater overall durability and sustain to the team, and an ability to proactively block Crowd Control debuffs. What Gepard offers that Fu Xuan doesn’t, however, is a Shield. For characters who require a Shield to work, like Arlan and Yanqing, Gepard cannot be replaced by Fu Xuan. In addition, Gepard has higher aggro via his Traces unlike Fu Xuan, increasing the reliability of who the enemy attacks.

Fu Xuan is much easier to gear than Gepard, as her SPD and Energy requirements are not as strict. While Gepard’s Ultimate is the majority of his kit’s sustain, Fu Xuan’s sustain is balanced across her Talent, Skill, and Ultimate. While a poorly geared Gepard is almost nonfunctional, a poorly geared Fu Xuan can still somewhat protect the team. 

Another point to consider is that Gepard’s Shields expire based upon each teammates’ turns, so faster teammates, or teammates that act too many times, can desync from his Shields. Meanwhile, Fu Xuan’s effects are tied to her personal turns and cannot desync.

### Lynx

 [img: Lynx Sticker 03 - Celestial Eyes Above Mortal Ruins]

Being a Quantum-Type sustain unit with party-wide debuff mitigation, Lynx fills a similar niche to Fu Xuan. While on the surface they may appear to fulfill the same role on a team, they provide quite different utility. 

Fu Xuan has high base aggro that can be increased with certain Light Cones and offers preventative damage and debuff mitigation for allies, while Lynx grants allies increased aggro and offers reactive healing and debuff cleansing. 

Lynx brings better synergies with Destruction or Preservation characters that benefit from being attacked, such as Clara or Blade.

### Luocha

Luocha provides absurd teamwide sustain through his Abyss Flower Field, and can reasonably maintain it indefinitely. Combining this with a free single-target emergency heal every 2 turns from his Skill’s effect, Luocha ends up sustaining the team at no SP cost at all, making him far and away the most SP-positive sustain unit in the game.

However, Luocha can only heal what isn’t dead, so if any member of your team is taking enough damage to instantly down them, Luocha will not be able to save you. This is where Fu Xuan has the edge over Luocha, as her Max HP increase and large amounts of DMG Reduction and redirection can prevent characters from taking what would otherwise be lethal damage. This, plus the CRIT Rate provided by Fu Xuan’s Skill, makes Fu Xuan a more offense-oriented sustain unit, albeit at the cost of being slightly less SP-positive.

If you value having an on-demand cleanse and an AoE buff dispel, then Luocha may be preferable. If you value having limited Crowd Control immunity, persistent damage reduction, and CRIT Rate, then Fu Xuan will appeal more.

But if you’re getting one-shot, then Fu Xuan definitely has the edge.

Both.

## Notable Synergies

### Supportive Options

| / Silver Wolf | Fu Xuan is a strong Quantum defensive option when paired with Silver Wolf, and can increase the consistency of the Weakness implant Silver Wolf provides. Fu Xuan also provides supplementary buffs for the main damage dealer to take advantage of. |
| --- | --- |

### Secondary Defensive Options

| [Stelle Sticker 02 - Second Closed Beta] / Fire Trailblazer | The constant small Shields of Fire Trailblazer have their impact multiplied by Fu Xuan’s DMG reduction and damage redirection, granting them close to 4x as much effective durability. / / As Fire Trailblazer refreshes their Shields with every action, it can be nearly impossible for enemies to damage characters besides Fu Xuan. The additional DMG reduction given by Fire Trailblazer’s Skill helps to further increase Fu Xuan’s durability against AoE damage, making it exceptionally difficult for her to be knocked down. |
| --- | --- |
| [March 7th Sticker 01 - March 7th] / March 7th | The added Taunt value from March’s Shield helps redirect attacks away from allies, and her Ultimate offers the ability to Freeze enemies. March should be built to prioritize Effect Hit Rate over DEF when run with Fu Xuan, as it’s unlikely that Fu Xuan will be knocked down through March’s Shield. / / Particularly potent when Fu Xuan is running Texture of Memories for the added DMG reduction. |

## Notable Anti-Synergies

| [Yanqing Sticker 02 - Final Closed Beta] / Yanqing | Fu Xuan, while drastically improving Yanqing’s survivability, has no way of preventing Yanqing from taking damage and hence losing Soulsteel Sync. |
| --- | --- |
| [Arlan Sticker - Second Closed Beta] / Arlan | With no means of creating a Shield and limited healing capabilities, Fu Xuan is the worst of both worlds for Arlan. No amount of DMG reduction will reduce his self-damage, nor can it redirect 100% of the damage away from him. The healing from Fu Xuan only serves to slow Arlan’s ramping damage which potentially weakens his attacks. |

## Teams

### Defensive Flex

*Fu Xuan — Flex — Flex — Flex*

Fu Xuan is very versatile, and can easily slot in as a solo sustain option on most teams. Her damage mitigation effect is based upon her own turns, not her teammates’, so she will not have issues with large SPD gaps.

However, SP should be kept in mind, as she is not quite as SP-positive as units such as Gepard and Luocha as she needs to use her Skill regularly.

#### Example Teams

##### Jing Yuan Hypercarry

*Jing Yuan — Tingyun — Asta — Fu Xuan*

Jing Yuan appreciates the Crowd Control debuff resistance that Fu Xuan’s A6 provides. While she is unable to cleanse Crowd Control debuffs, preventing them in the first place is preferable, as effects like Entanglement and Imprisonment will delay Jing Yuan’s turn, reducing the amount of stacks he can generate before the Lightning-Lord attacks.

##### Blade Hypercarry

*Fu Xuan — Blade — Bronya — Pela*

Fu Xuan’s HP and CRIT buffs are appreciated by Blade, though this team requires careful management of Blade’s HP through his Ultimate and Talent, as Fu Xuan can not easily heal him on demand. 

Fu Xuan should not be using an aggro increasing Light Cone in this team, as Blade will want to be hit as much as possible.

##### Seele Hypercarry

*Seele — Pela — Tingyun — Fu Xuan*

A standard Seele hypercarry team format.

### Silver Wolf-Centric Teams

*Fu Xuan — Silver Wolf — Flex — Flex*

As one of the two Quantum sustain options currently in the game, Fu Xuan prevents one more Combat Type from entering the equation. This is especially helpful for Combat Types that do not have any sustain character, as well as potentially enabling a Mono-Quantum team.

Most often this team format includes a damage dealer and a support of the same Combat Type so Silver Wolf’s Weakness implant only has two Types to choose between.

#### Example Teams

##### Kafka Hypercarry

*Kafka — Tingyun — Silver Wolf — Fu Xuan*

Kafka teams still benefit greatly from Fu Xuan’s DMG mitigation even though they do not rely on CRIT. Using Tingyun as Kafka’s support prevents Weaknesses other than Lightning and Quantum from being implanted.

##### Wind-Quantum

*Fu Xuan — Blade — Silver Wolf — Bronya*

Some Types like sparse survivability options. Fu Xuan’s Quantum-Type prevents another Type from being added to the mix while providing survivability.

##### Mono Quantum

*Seele — Qingque — Silver Wolf — Fu Xuan*

While guaranteeing a Quantum-Type Weakness implant seems appealing at first glance, it is often a smaller damage increase than a Harmony character could provide, and the desired Weakness implant can still be guaranteed in many cases by matching the last slot with the enemy Weaknesses. Since Fu Xuan is perfectly capable of sustaining a team on her own, Qingque is a far better addition to the team than Lynx as a fourth Quantum unit. In this team, Qingque should only be using Basic ATKs unless there is extra SP available.

## Credits

AnemoneMeer
chase
Cyn
jas
Ley
nyte
skylarke
Soul Fish
Sushou

## References

Survivability and Energy Calculator by jas and Soul Fish
Light Cone Comparison Calcs by Soul Fish
Energy Calculations by Soul Fish

## Changelog

- 21 September 2023 – Published for v1.3

- 22 September 2023 – Guard + Messenger Relic combination added to Suboptimal Relic Sets.
