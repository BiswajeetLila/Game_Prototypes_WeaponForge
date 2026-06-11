Why I think the gacha rates written in-game aren't exactly accurate - r/AFKJourney
	

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

		
	
	
	
	
	
	
	
	
	
	
	
	
	

		
	
		
		
			
				redlib.
				
	
		Feeds
		
			MAIN FEEDS

			Home
			
				Popular
				All
			
			
		

	

			

			
	
	
	
	
		
		in /r/AFKJourney
	

	
	
		
			
			
			→
		
	


			
				
					reddit
					
						
						
					
				
				
				
					settings
					
						settings
						
					
				
			

		
		
		
		
		
			
	
		

	
		r/AFKJourney
		•
		u/LucasTyph
		
		•
		Apr 12 '24
		
	

	
		
			Discussion
		
		Why I think the gacha rates written in-game aren't exactly accurate
		
		
	


	
	
	

	
	
		There have been quite a few posts in this sub regarding gacha rates, with a lot of people just saying you're unlucky, others saying there's some conspiracy afoot. I believe it's neither of those -- what I think is actually happening is that the rates are not the actual odds of getting a S-level hero in a pull, but it's actually the average you should get, taking pity into consideration.


I used a simple python script to try to calculate what are the actual odds each pull. TL;DR at the bottom.


Why do I believe this is true?


I can't say with certainty until the game itself talks about this, but a few things make me believe that's the case:


A lot of people are complaining about never getting off-pity S-level heroes. That's not exactly proof, as there will always be people complaining, but in this game there's a lot of complaints. Anecdotally, I myself did not get any off-pity S heroes until a few days after reaching 400 pulls, which is extremely unlucky. In fact, it's a 0.02% chance with the rates we have. If we take into consideration the rates I found, the odds of not getting any off-pity S heroes goes to about 6%, which is a lot more believable.

The official rates are really weird. Again, nothing definitive, but the hell would they use 2.05%, 5.22% and 3.25% as rates? That's quite unusual in gacha games, it seems more likely to me that these rates are adjusted from some other value they put in.

The game is not very clear about these rates. Nowhere does it say these rates are adjusted or not, whereas similar games such as Reverse:1999 list both the actual rates and the adjusted rates that take pity into consideration.


The process


I didn't do anything too fancy, just bruteforced some numbers to reach the "expected" value of S-level heroes after a large number of rolls. Here's the code:


import random
it = 1000000
s = 0
count = 0
i = 0
odds = 0.01

for i in range(it):
if (random.uniform(0,1))

Not exactly well-written code, but it just keeps track of the pity counter in the variable count, makes a roll and adds +1 to the S-level heroes counter if the generated number is smaller than the specified odds. The check to see if count == 59 is there to check if we have hit pity, and that number changes depending on the banner


The important thing here is that we change the value of odds until the end result is close to the odds indicated in the game.


Results


For the standard banner, with 2.05% chance and hard pity at 60 rolls, the calculated odds of getting a S-level hero on a random pull is of approximately 0.72%.


For the Epic banner, with 5.22% chance and hard pity at 30 rolls, the odds were approximately 3.35%.


For the Stargaze banner, with 3.25% chance and pity at 40 rolls, we get approximately 1.4%.


For the Vala Rate up banner, with 3% chance and pity at 40 rolls, we get approximately 1%.


TL;DR: I believe the odds written in game are not representative of the actual odds per pull. If what I'm saying is correct, the true odds are 0.72% for the standard banner, 3.35% for the epic banner, 1.4% for the Stargaze banner, and 1% for the Vala banner.


I really wish the game would at least communicate better on this point, I want to know whether the odds they tell us are adjusted or not.


		
	
	

	

327

Upvotes

	
		
			
				
					permalink
				
			

			
			
			

	reddit

	


			
		
		94% Upvoted

	


		

		
			118 comments sorted by

			
				
		
			Confidence
		
	
		
			Top
		
	
		
			New
		
	
		
			Controversial
		
	
		
			Old
		
	


→


		
		
			
			
			


	


118


	

	
		
			
				u/Xalrons1
			
			
			Apr 12 '24
			
			
		
		
		Going 1 purple, hard pity over and over feels so bad


		
		


	


15


	

	
		
			
				u/Samky95
			
			
			Apr 14 '24
			
			
		
		
		I didn't expect to get the Genshin experience in this game as well. At least in Genshin you need fewer copies of a 4 star to get them strong and all characters at C0 are perfectly viable.


EDIT: Of course in this game you get way more pulls than in Genshin, but the amount of pulls is worthless if I just get 1 purple per 10 pull and I have to get 32 of them to get a purple character to Mythic+ to make them shine. Pulling more is pointless if the quality of the pull is just as bad.


		
		
		
	


		
	


		

			
			
			


	


89


	

	
		
			
				u/[deleted]
			
			
			Apr 12 '24
			
			
		
		
		I don't believe the rates at all


		
		
		
	


		

			
			
			


	


78


	

	
		
			
				u/NyaCat1333
			
			
			Apr 12 '24
			
			
		
		
		I have been saying this since forever.


There was a time in the PTR days where the standard banner pity got lowered from 80 to 60. You know what suddenly happened? The shown rates in the info "increased" from from 1.65% to 2.05%. This for me was a dead giveaway that the shown rates are basically consolidated rates and taking the pity into account and not the chance that any given roll has a 2.05% chance to be a S-Rank. Just that over the course of a million pulls, with the pity, you would average a 2.05% chance.


Genshin for example has a consolidated rate of 1.6% which takes the pity into account, but the real rate for any given pull before soft pity is 0.6%.


With some simulations it would be quite easy to guess the exact rate of the standard banner with these two rates of 1.65% and 80 pity and 2.05% and 60 pity. Whatever real gacha rate result you get for the 2.05% and 60 pity simulation, you just put into the 1.65% and 80 pity simulation and see if it works out. Someone smarter than me could do this pretty fast I think.


		
		


	


56


	

	
		
			
				u/LucasTyph
			
			
			Apr 12 '24
			
			
		
		
		Using the probability I calculated for the standard banner (0.72%), and swapping the 60-roll pity to an 80-roll pity, I get... 1.64% adjusted rates.


I think the theory just got a lot more credible lmao


		
		
		
	


	


3


	

	
		
			
				u/ConspicuousPineapple
			
			
			Apr 16 '24
			
			
		
		
		You don't need to perform any simulation. If you know the pity and the consolidated rate, you can just calculate the real rate.


		
		
		
	


		
	


		

			
			
			


	


42


	

	
		
			
				u/AsianEleven101
			
			
			Apr 12 '24
			
			
		
		
		I agree, I spent some money and probably did a bit over 1,000 pulls so far and this game is the first AFK game with the weirdest usual AFK rates (3-5%) I’ve ever seen, pity after pity after pity, usually with 5% rate you see double pretty regularly and sometimes if you’re lucky triple or quadruple even but this game, god bless me if I pull one before I hit pity.


		
		


	


9


	

	
		
			
				u/Zenooz
			
			
			Apr 13 '24
			
			
		
		
		Yeah its rough. I did 400 pulls and got only 1 non pity hero


		
		


	


5


	

	
		
			
				u/Critical_Health_2292
			
			
			Apr 13 '24
			edited Apr 13 '24
			
		
		
		same ... quit the scam after 460 pulls with one non pity s level.


(Thanks OP for the numbers!)


		
		
		
	


		
	


		
	


		

			
			
			


	


79


	

	
		
			
				u/kaizokuo_grahf
			
			
			Apr 12 '24
			
			
		
		
		Anecdotal. I’m working on my 6th copy of Vala, every single one has been pity. Every single Epic from the Epic pick-a-hero pool has been pity. The rates are NOT indicative of what I can expect from a single pull, and that is completely misleading and the EU could have an absolute field day with them, considering they’re one of the reasons we have the rates published in the first place.


I CERTAINLY would not have spent any money on diamonds if I knew the “true” rate for a pull.


		
		


	


24


	

	
		
			
				u/LucasTyph
			
			
			Apr 12 '24
			
			
		
		
		Yeah, this right here is the issue. Them not saying whether the rates are truthful or adjusted is very misleading.


		
		
		
	


	


8


	

	
		
			
				u/NZ_Gecko
			
			
			Apr 13 '24
			
			
		
		
		N00b here - what does "pity" mean in this context?


		
		


	


9


	

	
		
			
				u/fi_bo_nacci
			
			
			Apr 13 '24
			
			
		
		
		Getting the guaranteed S tier from 60 pulls. If you do not get any S tiers before that - you will get the pity one after you do enough pulls.


		
		


	


3


	

	
		
			
				u/NZ_Gecko
			
			
			Apr 13 '24
			
			
		
		
		Thank you!


		
		
		
	


		
	


		
	


	


2


	

	
		
			
				u/JavierDurante
			
			
			Apr 13 '24
			
			
		
		
		Yeah, I'm on that only pity Vala train. Seems totally bullshit, even on the other banners, it's pity or bust for around 500 summons so far. Seems fked up.


		
		
		
	


	


1


	

	
		
			
				u/Swindleys
			
			
			Apr 17 '24
			
			
		
		
		I got 2 Vala from non pity.. But maybe I just got lucky.


		
		
		
	


		
	


		

			
			
			


	


23


	

	
		
			
				u/HieuBot
			
			
			Apr 13 '24
			
			
		
		
		I pretty much came to the same conclusion but thanks for running the numbers. To me, this is just shy of false advertisement since it's clearly a deliberate choice to leave room for ambiguity, probably knowing or at least expecting that some players will think the rates are higher than they are and fall into spending traps.


It might not be technically false advertisement, but it sure is scummy and makes me want to stay away from supporting them financially.


		
		


	


1


	

	
		
			
				u/pianodude7
			
			
			Apr 13 '24
			
			
		
		
		every gacha game does this, blame the industry and lack of regulation


		
		


	


2


	

	
		
			
				u/tthompson5
			
			
			Apr 13 '24
			
			
		
		
		Yes, a lot of gachas do, but not every one. Fire Emblem Heroes has a pity system similar to this for most banners, and the rates don't take the pity into account. Although it could be either because Nintendo is on IS's ass about being too greedy and tarnishing their reputation or because they didn't have the system when the game launched 7 years ago. (Btw, although I love FEH, it has its own problems with rampant power creep and locking pity on many desirable banners behind a paywall.)


		
		
		
	


		
	


		
	


		

			
			
			


	


14


	

	
		
			
				u/Vexxxy
			
			
			Apr 12 '24
			
			
		
		
		Just another drop in the bucket here, but yeah. I'm around 450 pulls now and every time has been all the way to pity on each banner. Kinda whack.


		
		


	


2


	

	
		
			
				u/XTasteRevengeX
			
			
			Apr 13 '24
			
			
		
		
		Around 500-600 pulls and have gotten out of pity probably 3-4 times only. Currently on my 4th pity streak lol


		
		
		
	


		
	


		

			
			
			


	


12


	

	
		
			
				u/reddt-garges-mold
			
			
			Apr 12 '24
			
			
		
		
		I'd be willing to contribute to a crowd sourced rate comparison


		
		


	


4


	

	
		
			
				u/SituationHopeful
			
			
			Apr 12 '24
			
			
		
		
		definetly need that. the only way to really know.


		
		
		
	


		
	


		

			
			
			


	


38


	

	
		
			
				u/MikeOxlong8008135
			
			
			Apr 12 '24
			
			
		
		
		That's a pretty sneaky way of making some garbage base rates look better lmao. I'm glad you took the initiative to investigate though.


		
		
		
	


		

			
			
			


	


26


	

	
		
			
				u/theozzon
			
			
			Apr 12 '24
			
			
		
		
		man I swear the weirdest thing happened today, it said I had 10 til guarantee, I pop a 10, get 2 purple...... then it says 56 til next... just me?


		
		


	


24


	

	
		
			
				u/[deleted]
			
			
			Apr 12 '24
			
			
		
		
		A lot of people are getting this, but you should contact them, I think it’s a bug.. all the times that I hit pity i got the 5 star


		
		


	


1


	

	
		
			
				u/theozzon
			
			
			Apr 13 '24
			
			
		
		
		ahh, nice to know that Im not loosing my mind just yet then


		
		
		
	


		
	


	


2


	

	
		
			
				u/FarSetting750
			
			
			Apr 13 '24
			
			
		
		
		Same i got it too and talked to customer service theysaid "that's pretty weird" and ask for my ingame id still waiting for response....


		
		
		
	


	


1


	

	
		
			
				u/theozzon
			
			
			Apr 17 '24
			
			
		
		
		update, they said my "data" looked normal and then quit


		
		
		
	


		
	


		

			
			
			


	


9


	

	
		
			
				u/brighto187
			
			
			Apr 12 '24
			
			
		
		
		I’m nearly at the 600 pull mark (f2p if it matters) and iv only gotten 2 non-pity’s


		
		


	


4


	

	
		
			
				u/[deleted]
			
			
			Apr 13 '24
			
			
		
		
		yep pretty much same


		
		
		
	


	


1


	

	
		
			
				u/tiptoppoet
			
			
			Apr 14 '24
			
			
		
		
		I'm around the same mark, also f2p, and I've had several non-pity pulls. Even got a tripple and a double. I also got Vala on my first 10 pull. I almost have all the non-celestial S-ranks. I guess RNG is a fickle b@#*c. I doubt the rates in game are accurate and I believe I'm probably just an outlier that had some luck. 2 weeks is a short time to sample and my dry spell is probably coming.


		
		
		
	


		
	


		

			
			
			


	


36


	

	
		
			
				u/Responsible-War-9389
			
			
			Apr 12 '24
			
			
		
		
		I believe you are right. I think Genshin is the same way, there was enough data to plot out the entire soft and hard pity curve, and it averaged their listed value. Or maybe I’m mixing things up.


It’s so rare to not hit hard pity, I can’t imagine pity isn’t accounted for in the rates. There also seems to be no soft pity.


		
		


	


13


	

	
		
			
				u/LucasTyph
			
			
			Apr 12 '24
			
			
		
		
		I haven't played Genshin in a while, but I think they have their adjusted values as well as per-pull values (at least they do on the wiki, can't check in-game because I don't have it installed). This game should at the very least do the same.


And yeah, different from some other games, this one has no soft pity. Your roll 1 is the exact same as roll 59 on the standard banner, for instance. And right after that, you get the full guaranteed S-level hero.


		
		
		
	


	


6


	

	
		
			
				u/undeadfire
			
			
			Apr 12 '24
			
			
		
		
		Genshin and hsr def mention the 0.6 rate on a single vs a 1.6 aggregate rate due to pity. Not to mention the soft pity is useful and basically cuts the char pity from 90 to around 75-80. That's one of the reasons I was so wary of this one and one of the first things I noticed just scouring the gacha pages


Based on previous experience, Lilith doesn't do soft pity. And the fact they didn't specify if it was aggregate vs individual pull rate was pretty sus in itself. Everyone's just too distracted with the up front content and one time rewards to really care yet.


		
		
		
	


		
	


		

			
			
			


	


19


	

	
		
			
				u/geltza7
			
			
			Apr 12 '24
			
			
		
		
		I've currently done close to 1000 pulls overall and have never got an S-Rank outside of pity, and never more than one S-rank in a single pull. I'm used to having terrible luck so I just roll with it and enjoy the game regardless


		
		
		
	


		

			
			
			


	


12


	

	
		
			
				u/FdPros
			
			
			Apr 13 '24
			
			
		
		
		surely this is illegal


		
		


	


8


	

	
		
			
				u/LucasTyph
			
			
			Apr 13 '24
			
			
		
		
		It has to be in China/EU where there are stricter regulations about gacha and similar mechanics... I hope they clarify this regardless.


		
		
		
	


	


3


	

	
		
			
				u/[deleted]
			
			
			Apr 13 '24
			
			
		
		
		You'd assume there are independent authorities that have access to source code/databases to ensure that pull rates aren't a scam. These companies earn millions, but seemingly are allowed to deceive users in every way possible - how is that possible?


If I bought a product that didn't have the content it advertised, it would be a scam. Same thing with these drop rates, IF the allegations are true.


		
		
		
	


	


-2


	

	
		
			
				u/FatherStretchMyAss_
			
			
			Apr 13 '24
			
			
		
		
		nearly impossible to prove sadly.


		
		


	


3


	

	
		
			
				u/XTasteRevengeX
			
			
			Apr 13 '24
			
			
		
		
		Ehh, absolutely not. This is just literally code in the game. Easiest shit to prove lol


		
		
		
	


	


2


	

	
		
			
				u/liangendary
			
			
			Apr 14 '24
			
			
		
		
		What a ridiculous statement


		
		
		
	


		
	


		
	


		

			
			
			


	


5


	

	
		
			
				u/watakushi
			
			
			Apr 13 '24
			
			
		
		
		I did 4 10-pulls in the Valla banner and not only did I get her only at pity, every other 10-pull featured a single purple unit, everything else were acorns.


For the regular banners I've never got an S-rank outside of the guaranteed one. Terrible rates.


		
		
		
	


		

			
			
			


	


5


	

	
		
			
				u/Doomsyhappiness
			
			
			Apr 13 '24
			
			
		
		
		I'm assuming this logic also applies to a-level heroes as well? Makes sense why we see so many 1 purple pulls even though it's listed at over 20%.


Kinda sucks bc this is the first gacha I've played that wasn't transparent about this, so I just assumed I was very unlucky. Kinda wish I didn't throw money at the game now lmao


		
		


	


2


	

	
		
			
				u/LucasTyph
			
			
			Apr 13 '24
			
			
		
		
		This one I have no idea, and I think it's a lot more difficult to actually test out...


		
		
		
	


		
	


		

			
			
			


	


4


	

	
		
			
				u/nuttySAN
			
			
			Apr 13 '24
			
			
		
		
		So that's why I can't feel the 2%. Compared to Arknights who has a 2% chance for 6-star pull pull, the rates feel really off here. In Arknights, you could easily get a 6-star around 50 pulls and off-pity 6-star are expected for every other or every other two pities.


To reflect what you're saying, the rates of 2% include the guaranteed pity at 60. For instance, we could look at HSR pity which has an average rate including the pity at 1.6% but having a base rate of 0.6% for 5-star. This is perhaps what is happening to the AFKJ's gacha system.


Though these are assumptions, I am definitely leaning on agreeing with you.


		
		


	


3


	

	
		
			
				u/SheepRoll
			
			
			Apr 13 '24
			
			
		
		
		same with AL. Out of all the UR banner, I hit maybe two or three potty so far since start and there are quite a few of them now. Pretty much similar count as my other friend. That about the expected rate they posted.


But here so far after couple hundred build, I have hit putty every time except like once. Even most of the 10 pulls has only pity purple. Since the pity count isn’t as high as 200 in AL, but it sucks every time is pity, to the point I’m not expecting pull anything except when it hit the pity count.


		
		
		
	


		
	


		

			
			
			


	


4


	

	
		
			
				u/xBiGuSDicKuSx
			
			
			Apr 13 '24
			
			
		
		
		Well to be honest I was just reading the other day how one of these companies for gacha actually patented their gacha algorithm. However they also got in a shitload of trouble for it too. So much in fact because they straight up lied about them. Chose to change the actual rates based on individual user activity, money spent etc if I recall. Then these dumb shits not only discussed not disclosing all of it via email bit didn't remove said emails. They intentionally reduced rewards for people's time and money spent. Greatly increased rewards for accounts that logged back in after a period of time to give them a huge dopamine rush to entice them in to getting back in to the game before literally setting the highest rewards on their gacha scam to 0% which is why they initially were being investigated to begin with because nobody ever won the best stuff.... so if people actually believe these companies don't straight up fuck over their players just to make more money you're smoking crack. Never listen to the bs rate up disclosure. If the majority of player base feels its a scam then it mostt certainly could be.


		
		
		
	


		

			
			
			


	


12


	

	
		
			
				u/[deleted]
			
			
			Apr 12 '24
			
			
		
		
		Your math is good and logic is sound but at the end of the day the numbers you're producing are being compared to how often we think people are getting S rank pulls based on the amount of complaining which is....to be honest a completely pointless comparison. Bias is going to gaurentee that people always feel like the odds are worse than they actually are and we can't tell if that is causing it or if your assumption regarding pity being factored in is true.


If we want to know for sure we would need to test it with a very large data set.


		
		


	


11


	

	
		
			
				u/LucasTyph
			
			
			Apr 12 '24
			
			
		
		
		Oh, for sure. I'm not saying with 100% certainty that this is the case, but it sure looks like it. And if it's not, how hard would it be for the devs to just include this information together with the pulls? It's shady at best.


		
		


	


2


	

	
		
			
				u/[deleted]
			
			
			Apr 13 '24
			
			
		
		
		I think this post stirs the pot of people who have no idea what you are talking about and all they see is "devs are liars". Its not helpful in my opinion and can be argued only causes more community outcry for an issue they don't understand.


		
		
		
	


		
	


		
	


		

			
			
			


	


3


	

	
		
			
				u/Easy-Stranger-12345
			
			
			Apr 13 '24
			
			
		
		
		Does this game have rate records "scanner" or "reader" like R1999 and Star Rail have?


If it is possible and we crowdsource the data we can deduce some rough rates.


		
		


	


6


	

	
		
			
				u/jorger4456
			
			
			Apr 13 '24
			
			
		
		
		The game needs to have a record to begin with and as far as I'm aware there isn't one that we can see, and maybe there's a reason for that... so we can't corroborate as easily. /tinfoil


		
		
		
	


		
	


		

			
			
			


	


3


	

	
		
			
				u/[deleted]
			
			
			Apr 13 '24
			
			
		
		
		I played a bit with the code. My output:


Rate Up: Hitting odds '0.0300' before pity '40': 0.696 (69596/100000)
All-Hero: Hitting odds '0.0205' before pity '60': 0.703 (70338/100000)
Epic: Hitting odds '0.0522' before pity '30': 0.791 (79052/100000)
Stargaze: Hitting odds '0.0325' before pity '40': 0.724 (72435/100000)


My code:


import random


def perform_test(seed: int, iterations: int, rarity_odds: float, pity_limit: int, recruit_type: str) -> None:
random_object = random.Random(seed) # setting random object to make test results reproducible
hits_before_pity = 0
for iteration in range(iterations):
for draw_counter in range(pity_limit-1): # -1 to exclude pity
if drew_s_hero(random_object, rarity_odds):
hits_before_pity += 1
break
recruit_type_str = f"{recruit_type}:".ljust(10)
fraction = hits_before_pity / iterations
print(f"{recruit_type_str} Hitting odds '{rarity_odds:.4f}' before pity '{pity_limit}': {fraction:.3f} ({hits_before_pity}/{iterations})")


def drew_s_hero(random_object: random.Random, s_hero_odds: float) -> bool:
return get_random_float(random_object, 0, 1) float:
return random_object.uniform(min_val, max_val)


def run_program() -> None:
iterations = 100_000
seed = 0
hero_odds = [0.03, 0.0205, 0.0522, 0.0325]
pity_limit = [40, 60, 30, 40]
recruit_types = ["Rate Up", "All-Hero", "Epic", "Stargaze"]

for i in range(len(hero_odds)):
perform_test(seed, iterations, hero_odds[i], pity_limit[i], recruit_types[i])


if __name__ == "__main__":
run_program()
import random


def perform_test(seed: int, iterations: int, rarity_odds: float, pity_limit: int, recruit_type: str) -> None:
random_object = random.Random(seed) # setting random object to make test results reproducible

hits_before_pity = 0
for iteration in range(iterations):
for draw_counter in range(pity_limit-1): # -1 to exclude pity
if drew_s_hero(random_object, rarity_odds):
hits_before_pity += 1
break

recruit_type_str = f"{recruit_type}:".ljust(10)
fraction = hits_before_pity / iterations
print(f"{recruit_type_str} Hitting odds '{rarity_odds:.4f}' before pity '{pity_limit}': {fraction:.3f} ({hits_before_pity}/{iterations})")


def drew_s_hero(random_object: random.Random, s_hero_odds: float) -> bool:
return get_random_float(random_object, 0, 1) float:
return random_object.uniform(min_val, max_val)


def run_program() -> None:
iterations = 100_000
seed = 0

hero_odds = [0.03, 0.0205, 0.0522, 0.0325]
pity_limit = [40, 60, 30, 40]
recruit_types = ["Rate Up", "All-Hero", "Epic", "Stargaze"]

for i in range(len(hero_odds)):
perform_test(seed, iterations, hero_odds[i], pity_limit[i], recruit_types[i])


if __name__ == "__main__":
run_program()


PS: Reddit is a buggy mess.


		
		
		
	


		

			
			
			


	


2


	

	
		
			
				u/FarSetting750
			
			
			Apr 13 '24
			
			
		
		
		I knew something was weird I've been pretty lucky so far for all the gacha games I've played but this game was the only one to really make me hit all pity out of my 640 pulls and not even give dupes but a separate s hero???


		
		
		
	


		

			
			
			


	


2


	

	
		
			
				u/cerespea
			
			
			Apr 13 '24
			
			
		
		
		rates are definitely fake. I played loads of gacha and pull rates this good would mean many S heroes outside pity. Even 0.50% rates im gachas were better than the rates in this game.


		
		
		
	


		

			
			
			


	


3


	

	
		
			
				u/JC0100101001000011
			
			
			Apr 13 '24
			
			
		
		
		rate in this game is suss for sure.


		
		
		
	


		

			
			
			


	


2


	

	
		
			
				u/KGamingFF
			
			
			Apr 13 '24
			
			
		
		
		I’m at 600+ pulls and every time has always been at the pity. Wtf!


		
		
		
	


		

			
			
			


	


2


	

	
		
			
				u/Educational-Run5235
			
			
			Apr 13 '24
			
			
		
		
		I would exepect it to be like Genshins. You start at extremely low chance and when you 85% near pity the chances get extremely high. In the end it averages around what they say


		
		


	


3


	

	
		
			
				u/LucasTyph
			
			
			Apr 13 '24
			
			
		
		
		If that were the case, even more reason for them to be upfront about it, like what Genshin does to a certain extent.


		
		
		
	


		
	


		

			
			
			


	


2


	

	
		
			
				u/legacyxi
			
			
			Apr 13 '24
			
			
		
		
		If the standard banner is closer to 0.72% this makes a lot more sense. As I was just telling my friend the rates don't seem right with the amount of faction acorns x30 I get which is 0.5% compared to the off pity rates of S-Levels I get being at 2.05%. Is this why they don't show history pulls like other gacha games do? Fairly certain in Honkai Star Rail you can look at all your previous pulls on the different banners.


		
		
		
	


		

			
			
			


	


2


	

	
		
			
				u/bbholepink
			
			
			Apr 13 '24
			
			
		
		
		I thought every 10 pulls you get at least one purple but when I reached pity and did a 10 pull I got 1 orange and 0 purples.


		
		
		
	


		

			
			
			


	


2


	

	
		
			
				u/Vicar69
			
			
			Apr 13 '24
			
			
		
		
		The rates are definitely garbage.


		
		
		
	


		

			
			
			


	


2


	

	
		
			
				u/Eliminence
			
			
			Apr 14 '24
			
			
		
		
		I would be more likely to spend money in game if the odds were better, otherwise count me out. They're missing out on a big target audience.


"Let's make $1000 from 100 people!"


Vs


"Let's make $50 from 10,000 people, and make $900 each from those same 100 people who are going to spend anyways"


		
		
		
	


		

			
			
			


	


2


	

	
		
			
				u/SorrySummer4
			
			
			Apr 14 '24
			
			
		
		
		Guess what, Got Vala to S+ through pity. Every single time. With no additional S rank char.


		
		
		
	


		

			
			
			


	


2


	

	
		
			
				u/Sea_Sandwich_2739
			
			
			Apr 14 '24
			
			
		
		
		So basically it a scam ? Mods should put this up.


		
		
		
	


		

			
			
			


	


2


	

	
		
			
				u/fhidodhdoslsje
			
			
			Apr 14 '24
			
			
		
		
		I agree with this. I did manage to get two S-levels on my second ever pull, to which I was pleasantly surprised. But afterwards it's always been hard pity. Must have been that extremely tiny 0.72% off chance 😭


		
		
		
	


		

			
			
			


	


2


	

	
		
			
				u/alexbrunzella
			
			
			Apr 16 '24
			
			
		
		
		I’m pretty sure doing that is illegal and I’d assume that Lilliths lawyers are very well aware of gambling laws.
A pulling rate is supposed to reflect the chance of obtaining a certain type of hero on a singular pull, if not it’s false advertising and extremely illegal.


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/kalarro
			
			
			Apr 13 '24
			
			
		
		
		4 in 460 pulls. I'm way below the official rates. Could be bad luck ofc


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/rabbit_hole_diver
			
			
			Apr 13 '24
			
			
		
		
		Just today i got eironn at 60 pity


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/rabbit_hole_diver
			
			
			Apr 13 '24
			
			
		
		
		During beta, drop rate was great i imagine to hook people. Now that the game is live, theyve dialed back the drops


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/Andros_4113
			
			
			Apr 14 '24
			
			
		
		
		This is all anecdotal, but the rates seem fine to me....I've been playing for 5 days and i have pulled at least 3 non pity golds...im at close to 300 pulls so that's around 3%


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/blitzkarion
			
			
			Apr 14 '24
			
			
		
		
		Can i ask you how you got the numbers exactly?
I wrote down a formula where x% is the probability of getting an S hero and n is the pitty to calculate the "real" probability of getting an S hero but i can't do the math for n=60.


		
		


	


1


	

	
		
			
				u/LucasTyph
			
			
			Apr 14 '24
			
			
		
		
		To be fair there wasn't much math in what I did, mostly bruteforcing. I just know the pity and how the rolls work, then try a number in the odds variable until the average number of S heroes I get is the average percent the game tells us. I don't really know how to reach those numbers mathematically, it's probably possible but I find using the python script and trying different values to be far easier and faster lol.


For instance, I try 1% as odds with 60 pity and get an average bigger than 2.05%. So I try 0.5% and we get less than 2.05%, so I know the actual value is between these two. Next 0.75%, and I realize this gives a value just over the 2.05% we're looking for, so I try something slightly less than that, and so on. If my number of iterations is enough, eventually I'll get very close to the actual value.


		
		


	


1


	

	
		
			
				u/blitzkarion
			
			
			Apr 15 '24
			
			
		
		
		Hey, i managed to do it!
For the normal pulls it is exactly 0.72604365090895292315% so you were spot on!


		
		


	


1


	

	
		
			
				u/blitzkarion
			
			
			Apr 15 '24
			
			
		
		
		And the vala banner is 0.9622245010225717%


		
		
		
	


	


1


	

	
		
			
				u/LucasTyph
			
			
			Apr 15 '24
			
			
		
		
		Nice! Since this post is a bit old already, you might want to make a new one if you want to let people know the exact rates you found (and how you found them)


		
		
		
	


		
	


		
	


		
	


		

			
			
			


	


1


	

	
		
			
				u/An-Aromatic-Apple
			
			
			Apr 15 '24
			
			
		
		
		The math: let p be the pre-pity probability, q be the post-pity probability, and n the number of pulls to hit pity. We can calculate the expected number of pulls per epic in two ways, which gives us a relationship between p and q.


First, by definition, = 1/q.


Second, we can evaluate directly as a weighted average. For i , we have the standard geometric probability P(N = i) = (1-p)^(i-1)*p, and for i = n, we have P(N = n) = (1-p)^(n-1) from hitting pity. Explicitly evaluating the expectation value yields = (1-(1-p)^n)/p.


Hence, we have 1/q = = (1-(1-p)^n)/p. Taking reciprocals shows that q = p/(1-(1-p)^n), which allows us to interpret 1/(1-(1-p)^n) as the pity correction factor that transforms the pre-pity probability into the post-pity probability.


		
		


	


1


	

	
		
			
				u/blitzkarion
			
			
			Apr 15 '24
			
			
		
		
		So you lost me at


For i , we have the standard geometric probability P(N = i) = (1-p)^(i-1)*p


But looking at the result isn't it
0 n n n )
So how does the probability exceed 100%?
I am just trying to understand it would be great if you could help


		
		


	


1


	

	
		
			
				u/blitzkarion
			
			
			Apr 15 '24
			
			
		
		
		I now understand what you did but i can't simplify the equation to 1/(1 - (1 - p)n ) it just becomes a huge monster because of terms like 2(1 - x) + 3(1 - x)2 + 4(1 - x)3 ... +
(n - 1)*(1 - x)n - 1


		
		


	


1


	

	
		
			
				u/blitzkarion
			
			
			Apr 15 '24
			
			
		
		
		I did it! p/(1 - (1 - p)n ) so i guess you forgot the p


		
		
		
	


		
	


		
	


	


1


	

	
		
			
				u/blitzkarion
			
			
			Apr 15 '24
			
			
		
		
		
Explicitly evaluating the expectation value yields = (1-(1-p)^n)/p.


Can i ask you how you got this equation it was a struggle for me and i wonder if there is an easier way to do it


		
		


	


1


	

	
		
			
				u/An-Aromatic-Apple
			
			
			Apr 15 '24
			
			
		
		
		Hey! I'm glad you were interested in the details. I think you seem to have resolved all your other questions, but let me know if that's not the case.


To compute in terms of p, the most straightforward approach is to do the summation analogue of 'differentiation under the integral sign', see ex: https://math.stackexchange.com/questions/310816/deriving-the-mean-of-the-geometric-distribution


Rewrite the summand in the form of a derivative, then swap the order of summation and differentiation. As you might imagine, trying to show this explicitly with Reddit's lack of math formatting is annoying enough that I chose not to do it.


		
		
		
	


		
	


		
	


		

			
			
			


	


1


	

	
		
			
				u/RaihaUesugii
			
			
			Apr 15 '24
			
			
		
		
		I've never gotten an off pity ssr, also I definitely didn't read all that


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/Aventle
			
			
			Apr 15 '24
			
			
		
		
		I got a lot of s rated heroes in my first ~80 on my first day. Since my 2nd day, ive ALWAYS gone to hard pity


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/Situation_Separate
			
			
			Apr 16 '24
			
			
		
		
		Have I just been really lucky? I've got them off pity a few times. Not sure about stargazing but the others seem pretty generous to me.


Also maybe it adjusts based on how many you are to pity?


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/YunoxMaki
			
			
			Apr 16 '24
			
			
		
		
		I might be the outlier here but for some reason… but for the first week, my pulls were as you guys said for the most part, but for the last week or so I’ve been getting them way before pity. Even 2 back to back 10 pulls being 5 star. But I definitely agree with you guys


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/BsyFcsin
			
			
			Apr 16 '24
			
			
		
		
		In the other guy. I’m F2P and have unlocked all heroes and even got Reiner on my 4th single pull. I’ve had a shit ton of non-pity S heroes and still have 40k gems.


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/potleafkeyblade
			
			
			Apr 16 '24
			
			
		
		
		Not that I think yall are wrong this is just crazy to me lol I usually have shit luck in these games and I've pulled 4 S tiers in less than 100 pulls. Only hit pity once. I actually thought this game just had better pull rates


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/TrillyBear
			
			
			Apr 17 '24
			
			
		
		
		Companies have been caught rigging the rates before, not this company but I mean…


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/LargeGrowth8089
			
			
			Apr 17 '24
			
			
		
		
		I got two S levels without pity while playing for 3 days total


Guess it was real lucky


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/Passion-Severe
			
			
			Apr 17 '24
			
			
		
		
		Imba confirmation bias in the comments incoming


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/Mykyta-UA
			
			
			May 15 '24
			
			
		
		
		I am doing single pulls, and I am getting S hero way to often before guarantee


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/FlippySoGreen
			
			
			May 15 '24
			
			
		
		
		Well this aged like fine wine. Repost bro, death to Lilith scum!


		
		
		
	


		

			
			
			


	


1


	

	
		
			
				u/drakonath
			
			
			Apr 12 '24
			
			
		
		
		If this is true then I feel like winning the lottery on my triple last week. Great write up


		
		


	


1


	

	
		
			
				u/Ethrem
			
			
			Apr 13 '24
			
			
		
		
		I've had a triple not once, not twice, but three times, so I guess I should have won the lottery many times over...


		
		


	


1


	

	
		
			
				u/[deleted]
			
			
			Apr 13 '24
			
			
		
		
		someone downvoted you because you arent saying the game is shit and pulls are bad + devs are liars.


		
		


	


1


	

	
		
			
				u/XTasteRevengeX
			
			
			Apr 13 '24
			
			
		
		
		Hes just a huge outlier lol. Also, what about he adds up all his non-pity S ranks and see if hes even “on rate”. Would be fun to see how even with 3 triples hes still under rate or just on “average” rate


		
		
		
	


		
	


		
	


		
	


		

			
			
			


	


1


	

	
		
			
				u/[deleted]
			
			
			Apr 13 '24
			
			
		
		
		I pity you. 


		
		
		
	


		

			
			
			


	


-7


	

	
		
			
				u/galmenz
			
			
			Apr 12 '24
			
			
		
		
		the pity is included in the probability, its the standard of this gacha games cause it makes the probability looks better


if you play any gacha, you need to accept. the house always wins


		
		


	


13


	

	
		
			
				u/LucasTyph
			
			
			Apr 12 '24
			
			
		
		
		Do you know other gachas that show only the adjusted rates, and not the actual odds for each normal pull? The ones I played and remember the rates (Genshin, Reverse, Arknights) either show the odds per pull or both. I've never seen only the adjusted rates, and it feels scummy to not say that's the case.


		
		
		
	


		
	


		

			
			
			


	


-3


	

	
		
			
				u/Ethrem
			
			
			Apr 13 '24
			
			
		
		
		If you run these rates through a probability calculator they're all set so that you had a 70-80% chance of getting one or more S rank units at the pity count even if there wasn't a pity counter anyway so it's going to feel like you're hitting pity more often than not. I've had three triples and a few doubles out of my thousand plus pulls on my global account and I'm more inclined to believe that it's just them putting the probability close to pity anyway.


		
		
		
	


		

			
			
			


	


-7


	

	
		
			
				u/[deleted]
			
			
			Apr 13 '24
			
			
		
		
		I’ve had like maybe 150 pulls and I think 5-6 S rank that weren’t pity… I think I’m pretty lucky then lol


		
		
		
	


		

			
			
			


	


-8


	

	
		
			
				u/Middle-Necessary2314
			
			
			Apr 13 '24
			
			
		
		
		I mean in every gacha game there will be post about how people think the rates aren’t what it seems, yet they were just unlucky.


When new events and codes come out, and more ways to earn summon currency. Those unlucky people will get lucky and those lucky people will be unlucky.


Happened all the time in AFK arena.


		
		


	


9


	

	
		
			
				u/LucasTyph
			
			
			Apr 13 '24
			
			
		
		
		The issue is the rates not being exactly what's being shown. Unlucky stuff will eventually happen to some people, of course, but if they're not being 100% upfront about the rates, that's kinda misleading.


People think they're getting 1 S every 50 rolls + the guarantee after 60 pulls, but they're actually getting 1 S every 140 rolls with a guarantee, no wonder we get hard pity all the time. This right here is the issue.


		
		
		
	


	


1


	

	
		
			
				u/XTasteRevengeX
			
			
			Apr 13 '24
			
			
		
		
		Unlucky and fake rates are 2 different things tho. What about the devs speak about it and “confirm” the rates are as stated and not taking into consideration the pity? Thats all they need to do


		
		
		
	


		
	


		

			
			
			


	


-10


	

	
		
			
				u/Mightyballmann
			
			
			Apr 13 '24
			
			
		
		
		I dont get it. It doesnt make a difference. 2,05% is always 2,05%. You dont pull more heroes one way or the other.


		
		


	


5


	

	
		
			
				u/LucasTyph
			
			
			Apr 13 '24
			
			
		
		
		Here's the thing: if what I said is true, in any given pull, your odds are not 2.05%, but actually 0.72%.


If they don't say anything, you'd expect to get 1 S-level hero every ~50 pulls, and if you get unlucky, you have pity at 60. What actually happens is you are expected to get 1 S-level hero every ~142 pulls, but most of the time, you'll get the hero when reaching hard pity on 60.


It's a big difference, in particular in expectations, and if they're not upfront about this, then that's a big issue.


		
		


	


-2


	

	
		
			
				u/Mightyballmann
			
			
			Apr 13 '24
			
			
		
		
		You are guaranteed to get a hero every 60 pulls. That means, in 142 pulls you expect to get 3 heroes not 1.


		
		


	


3


	

	
		
			
				u/XTasteRevengeX
			
			
			Apr 13 '24
			
			
		
		
		Thats literally his point dude. If the rates are actually 2%, you would get around 3 heroes on average FROM NON PITY at 142 pulls. But what is happening is that you are getting those 3 heroes COUNTING the pity. Instead, theres a 0.7% rate to get an S outside of pity, which would only give you 1 S hero every 140ish non-pity summons on average, instead of the 3 that would be with 2% that is listed


		
		
		
	


		
	


		
	


		
	


		

			
			
			


	


-12


	

	
		
			
				u/IndianaCrash
			
			
			Apr 12 '24
			
			
		
		
		I mean, yeah, people tend to complain more than be happy.


I myself got very lucky (got 2 Vala in 2 x10, Berial in only 4 summons, and a bunch of off-pity) but I'm not gonna scream it here, because, well, who cares?


But if someone complain about pull rates, people who also didn't have good pull are likely to come and complain as well


		
		


	


1


	

	
		
			
				u/XTasteRevengeX
			
			
			Apr 13 '24
			
			
		
		
		Count them all up and see if you are even on rate before talking trash here. I assume you have over 500 summons if you have Berial. You should be looking at OVER 10 S-ranks outside of pity to be on AVERAGE rate. Even with your luck i assure you that you will be close to the average, so yeah, rates are fake and taking pity into consideration


		
		


	


0


	

	
		
			
				u/IndianaCrash
			
			
			Apr 14 '24
			
			
		
		
		Jeez, chill.


I don't have over 500 summons, as I only did 8 on his banner, and then 4 or 5 x10 on the regular one, but because it's easier to calc with that, so let's say I already am at 500 summons.


If I remove the one I got from arena, login reward, puzzle piece and what I assume to be a guaranteed one early on (Rowan), I got 18 S-rank.


18 S-rank for 500 summons is 3.6%. So, higher than the rate for Berial (3.25%), Vala (3%) and where most of my summons went, the regular banner (2.05%).


Dare I say my luck is above average, or is that talking trash?


		
		


	


1


	

	
		
			
				u/XTasteRevengeX
			
			
			Apr 14 '24
			
			
		
		
		Assuming you counted them right, and subtracted correctly, you would be slightly above than average considering also the ones you got on 5.22% on epic recruitment.


So for someone that got VERY LUCKY to not even he 2x on the “supposed” rate, then you know something is wrong.


All OP is saying is that the shown rate includes pity into consideration, and thats most likely the case. We will know for sure when devs actually respond


		
		
		
	


		
	


		
	


		
	


		


	


		
		

		
		
			
				
					v0.36.0-yunyun&emsp;ⓘ View instance info&emsp;<> Code