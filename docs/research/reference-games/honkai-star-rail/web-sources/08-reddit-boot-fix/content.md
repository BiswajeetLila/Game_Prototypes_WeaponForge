# How should I fix this? Every time I boot HSR it lags like this. Even when logged in it lags. I always restart my laptop.

**Author:** Foreign_Wear1663  
**Score:** 5

---

## Post body

*(no selftext — link/image post)*

---

## Comments (28)

- **u/Flashy_Golf_3288** (1 point)
  Hey man, have you found a fix? I've run into the same problem. Thanks in advance

    - **u/Foreign_Wear1663** (1 point)
      I just switched back to its own launcher

        - **u/Flashy_Golf_3288** (1 point)
          Using it's own launcher isn't working for me. So i've been trying other launchers. Any other ideas?

            - **u/Foreign_Wear1663** (1 point)
              Repair the resources, reinstall other than that I have no idea

- **u/Disk_This** (1 point)
  Did you ever find a fix for this I’m also having issues like this

    - **u/Foreign_Wear1663** (1 point)
      The launchers have already merged into one, have they?

- **u/[deleted]** (1 point)
  Check her in task manager as the game is running.

    - **u/Foreign_Wear1663** (1 point)
      Ok now what

        - **u/[deleted]** (2 points)
          I have no clue what I wanted to say.

            - **u/Foreign_Wear1663** (4 points)
              Lmao

- **u/Foreign_Wear1663** (-2 points)
  For context I use Collapse Launcher

    - **u/AStrangeCharacter** (6 points)
      I don't know anyone who has heard of that

    - **u/kmeck518** (3 points)
      why are you using this of the actual launcher for the game?

        - **u/Foreign_Wear1663** (1 point)
          Cuz it's easy to use? I can just switch between the 3 games easily. Don't have to open up 3 separate launchers or look for em.

            - **u/kmeck518** (1 point)
              Well, have you tried launching the game through the normal launcher to rule out that Collapse launcher isn't the issue? If it runs fine like that then there might be an issue with launching the game through collapse launcher. If it runs the same then you know there's an issue with the game itself and you can troubleshoot further from there.

                - **u/Foreign_Wear1663** (1 point)
                  It's just the same with it's own launcher as well

- **u/crest_of_the_lord** (1 point)
  First try checking the file integrity ( though i doubt it's that).

  If that doesn't work try the old uninstall reinstall.

  If it still doesn't work check if HSR is using the dgpu and not the igpu because that might be causing the lag.

    - **u/Foreign_Wear1663** (1 point)
      What's igpu and dgpu?

        - **u/crest_of_the_lord** (1 point)
          The igpu is your Integrated Graphics Processing Unit which is generally way less powerful than your Dedicated Graphics Processing Unit (Dgpu).

          The dgpu should handle all your graphics heavy workloads but sometimes an app may instead have the igpu as the default graphics processor.

          So you just have to see which one HSR is using and change the gp to the dgpu if it's using the igpu.

            - **u/Foreign_Wear1663** (1 point)
              Idk which one is either of those but on task manager it says GPU 0 and GPU 1

            - **u/Foreign_Wear1663** (1 point)
              And when the game starts the GPU 0 overloads to 100%

                - **u/crest_of_the_lord** (1 point)
                  Tell me what names GPU 0 and 1 show

                    - **u/Foreign_Wear1663** (1 point)
                      GPU 0 shows NVIDIA GeForce GTX 1650
                      GPU 1 shows AMD Radeon (TM) RX Vega 10 Graphics

                        - **u/crest_of_the_lord** (1 point)
                          GPU 0 is your dgpu so if taskbar shows that's in use then you have no problem there.

                          Try out the other solutions mentioned.

                            - **u/Foreign_Wear1663** (1 point)
                              I was using Collapse Launcher, then it just stopped working, so I reinstalled its own launcher. And it still lags.

- **u/Bustar211** (1 point)
  Have you checked your RAM? It lags like that when memory is full. I had the same issue when I was playing Genshin with full memory. Had to close Chrome to make some space.

    - **u/Foreign_Wear1663** (1 point)
      74%

    - **u/Foreign_Wear1663** (1 point)
      I use Opera GX
