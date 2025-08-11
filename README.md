# Goonsaken Hub

**A powerful all-in-one Roblox script hub featuring player animations, ESP, stats tracking, and useful utilities.**
**Special Note: All features might not be supported on mobile**

---

## Features

### 1. **Goon**
- **Description:** You start gooning... yeah i don't know what to say.
- **Usage:** Click the **Goon** button in the GUI to enable/disable the animation.

### 2. **Lay Down**
- **Description:** You lay down on the floor. This can be combined with the goon animation for some uhhh questionable stuff...
- **Special Notes:** To use this with goon, you must first enable this and then enable goon.
- **Usage:** Click the **LayDown** button in the GUI to start or stop the looped animation manually.

### 3. **Frontflip**
- **Description:** hahaha funny button that makes you do a very very big jump like a front flip
- **Usage:** Press **F** on your keyboard or click the **Frontflip** button to trigger the flip.

### 4. **Infinite Yield**
- **Description:** Loads Infinite Yield (I usually use this to run the command NoFog and LoopFullBright).
- **Usage:** Click the **Infinite Yield** button to execute the script.

### 5. **Player Stats Tracker (Toggle)**
- **Description:** Displays a draggable GUI panel showing live stats for all other players (time played, wins, losses, kills, emotes).
- **Usage:** Click **StatsTracker** to toggle visibility of the stats panel. The panel updates stats every time someone joins and lets you copy player info by clicking on their entry.

### 6. **ESP (Toggle)**
- **Description:** Highlights Survivors (green), Killers (red), Medkits (green), BloxyCola (blue), and Generators (yellow) on the map with dynamic visibility control.
- **Special Note:** This ESP script **does not highlight Noli's Fake Generators** at all. A future script update will  disable highlights on fake Noli as well.
- **Usage:** Click **ESP** to toggle visibility of all ESP highlights. When off, highlights are made invisible but tracking continues in the background.

### 7. **Infinite Stamina (Toggle)**
- **Description:** Disables stamina loss (actual skill issue if you can't stamina manage lmao).
- **Usage:** Toggle **Infinite Stamina** to enable/disable infinite stamina.

### 8. **Auto Rejoin on Kick (Toggle)**
- **Description:** Automatically rejoins the current game session if kicked or disconnected (next time be less obvious when cheating loser).
- **Usage:** Enabled by default. Toggle **Auto Rejoin on Kick** to enable or disable this feature.

### 9. **Rejoin Button**
- **Description:** Rejoins the current server incase there was a glitch or anything.
- **Usage:** Click **Rejoin** in the GUI to instantly rejoin the same server.

### 10. **Walkspeed**
- **Description:** Sets your speed. (Only works in round as a survivor or killer)
- **Usage:** Drag the slider to automatically set your speed value forever. Click the X icon to stop the loop

### 11. **Jumppower**
- **Description:** Sets your jump height.
- **Special Notes:** This only works on PC as jump button is disabled on Mobile. (will not add jump support for mobile due to overlapping issues with the other abilities and plus you can always use frontflip)
- **Usage:** Drag the slider to automatically set your jump height value forever. Click the X icon to stop the loop.

### 12. **Chance Aimbot**
- **Description:** Aims at the killer when you shoot.
- **Usage:** Enable it and just shoot as chance. it will automatically aim at the killer. Best used without shiftlock.

### 13. **Block TP**
- **Description:** Teleports to the killer when they use an attack and Blocks to get a punch and then teleport back.
- **Usage:** Enable it and when the killer attacks, you will automatically teleport to the killer, get a punch and teleport back to your last position. If you already have a punch then you do not teleport unless you've used up that punch.

### 14. **Fully invisible upon cloning as 007n7**
- **Description:** When you clone as 007n7, you are fully invisible.
- **Usage:** Enable it and when you clone, you will become fully invisible

### 15. **Do Current Generator**
- **Description:** It does the current puzzle for you in the generator.
- **Usage:** Press T (note you may have to actually wait a few seconds in a puzzle around 3 seconds before using this so you dont get kicked by the anticheat).

### 16. **Play sound by ID**
- **Description:** It plays the sound when you enter its id...
- **Usage:** Just input the id and press enter.

### 17. **LMS Changer**
- **Description:** Change the LMS song when it plays (Only for one round then you have to activate it again)
- **Usage:** Select the LMS Song from the list (Burnout, Compass, Vanity, Close To Me, Plead and Creation Of Hatred) and then press the change lms song button.

### 18. **Do All Generators**
- **Description:** It teleports to every single generator and starts auto solving it
- **Usage:** Press the button and wait (must be out of a gen first to do this) (also VERY VERY blatant as you teleport all around and others can see).

### 19. **Emote as Killer**
- **Description:** You can now emote as the killer
- **Usage:** Press L.

### 20. **Geometry John Doe to Rochas**
- **Description:** Turn Geometry John Doe into his Rochas counterpart.
- **Usage:** Press the button which will bring up a small gui with a button to start. which will then wait for geometry john doe to exist and then turn him into rochas.

### 21. **Auto 404 Parry**
- **Description:** Automatically use 404 Error right before being stunned to get a speedboost.
- **Usage:** Press the button. thats literally it. it will run in the background forever till you leave or serverhop.

### 22. **Invisibility**
- **Description** Become invisible to others
- **Special Notes:** There will be a block where your player's torso was. that is ONLY seen by you and no one else. it is just meant to guide you on your screen where you are currently.
- **Usage:** Toggle it on and you will become invisible.

### 23. **Hitbox Modifier**
- **Description** Modify your hitbox to hit anyone within a customizable range
- **Special Notes:** You can modify the range by editing the value below the toggle option.
- **Usage:** Toggle it on and play. your hitbox will be modified to always reach the killer as survivor within a range from you and vise versa

- ### 24. **Auto 1x1x1x1 Popups**
- **Description** Automatically does the 1x1x1x1 popups for you.
- **Usage:** Toggle it on and play. when you get entangled. the popups will immediately close.

## How to Use

1. Paste the loadstring (below) into your Roblox executor.
2. Execute the script.
3. ez pz now you goon all day everyday

---

## Loadstring

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/NumanTF3/Goonsaken-Hub/refs/heads/main/main.lua"))()
