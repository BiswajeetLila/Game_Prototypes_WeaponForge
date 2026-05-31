# Custom skills used:

/play-store-reviews
/video-analysis



# Workflow

## 1. Get All Websites Locally: Knowledge Base Creation

This first phase focuses on building a local, verified knowledge base by orchestrating a feedback loop of agents to extract and verify raw information (text and images) from specific web sources (wikis, forums). This methodical approach is used to prevent shallow queries and reduce hallucinations before moving to analysis.



### Prompt

We'll perform a thorough game research on <Ask_User>.
Here is how we'll approach game research: I'll share a bunch of links with you, I want you to extract raw information from those files and save them into a folder called "Web Sources."
Later, we'll scan through all of the data that we have acquired and try to build a detailed game design spec. (Don't start this until I tell you to)
These links are websites and YouTube videos. From the website, you will need to scrape all text, image data, and store the whole transcript to infer from it.
I've also attached some good images that I could find, but you should extract images from webpages, store them and also infer from them. 

In all of these websites, if you feel the need to click on links and go deeper, feel free to do so

- <Ask_Links>



Smartly orchestrate a team of agents to get this done.

Once it's done, orchestrate another set of agents that verify the output of the first
Make sure that when extracting, it's word-for-word on what is found on the website, and do not do any sampling or consolidation
Store all of the source files, including frames, transcript, and any other processing data, in a <C:\_BISU\_WORKSPACE\AI_Explorations\_Claude\Game_Prototypes\docs\research\reference-games> in a folder based on this game we're researching



## 2. Parse All Video and Play Store Reviews: Multimedia & Sentiment Analysis

This second phase involves using multimodal AI tools and public APIs to gather deep gameplay insights and conduct context-rich sentiment analysis from player reviews. The workflow includes splitting YouTube gameplay videos into individual frames for analysis to extract moment-to-moment details like VFX, camera shakes, or skill pick rates. Public APIs are used to gather Steam and Play Store reviews into CSV files for analysis.



### Prompt

Use /video-analysis skill to fetch information from the videos below for any missing content.
<Prompt for what you're trying to extract from video Example: I also want you to analyze the moment-to-moment gameplay(including camera shake, VFX, etc) in the pit thoroughly with all edge cases and make sure these are captured in the transcript or notes>

Make sure you have full transcripts and don't sample any of your data

- <List of YouTube Videos>

Store all of the source files, including frames, transcript, and any other processing data, in an appropiate folder after you've created the main folder for this research
Also, use/play-store-reviews to fetch reviews as data


Smartly orchestrate a team of agents to get this done.
Once it's done, orchestrate another set of agents that verify the output of the first



## 3. Consolidated Design Spec: Design Specification Generation

This final phase integrates the verified data from Phase 1 and the insights from Phase 2 to generate a detailed design specification (D1 to D30 experience). A crucial part of this step is explicitly instructing the AI to tag all information as either "genuine source" or "assumed," which allows the team to track the reliability of the output and identify potential hallucinations.



### Prompt

Now using all collected information, can you write up a detailed design documentation of how this game works, what its core loop is, what the progression systems are, with details to great depth? What do players experience in D1-D7? What do players like? Why do players come back to play this? What unlocks when? Be specific and include everything possible from your gathered information.
In your doc, clearly state what is inferred from a genuine source with tagging, and what is it that you're assuming