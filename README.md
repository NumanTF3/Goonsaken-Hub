# Goonsaken Hub

**A powerful all-in-one Roblox script hub featuring player animations, ESP, stats tracking, and useful utilities.**

---

## Features

### 1. **Goon**
- **Description:** You start gooning... yeah i don't know what to say.
- **Usage:** Click the **Goon** button in the GUI to enable/disable the animation.

### 2. **Lay Down**
- **Description:** You lay down on the floor. This can be combined with the goon animation for some uhhh questionable stuff...
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

---

## How to Use

1. Paste the loadstring (below) into your Roblox executor.
2. Execute the script.
3. ez pz now you goon all day everyday

---

## Loadstring

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/NumanTF3/Goonsaken-Hub/refs/heads/main/main.lua"))()
