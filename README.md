# Trekress MVP Skeleton (Godot)

Systems-first vertical slice for Trekress. The sim layer is deterministic and decoupled from UI.

## Requirements
- Godot 4.2+ (tested conceptually with 4.x project format)

## How to run
1. Open Godot and import this folder (`/workspace/Trekress`) as a project.
2. Run the project (`F5`).
3. In the main menu:
   - Select **New Game** to start fresh.
   - Select **Continue** (if shown) to load autosave.

## Controls
- Move captain: `WASD` or Arrow keys or left stick / d-pad
- End turn: `E` key or controller `A`
- UI buttons:
  - **Raise Shields** (issues order through sim)
  - **End Turn**

## How to verify
1. Launch game and click **New Game**.
2. Move the captain 3 tiles.
   - Confirm tick increases by 3.
   - Confirm movement events appear in Message Log.
3. Click **Raise Shields**.
   - Confirm log contains `Tactical: Aye, Captain.`
   - Confirm `Shields: Raised` appears.
4. Quit game and relaunch.
5. Main menu should show **Continue**.
6. Click **Continue**.
   - Confirm previous shield state remains raised.
   - Confirm tick count persisted from autosave.

## Architecture notes
- `/sim` contains deterministic game state, turn engine, orders, and save/load.
- `/ui` contains Godot scenes and input/rendering only.
- `/content/crew.json` provides roster data loaded into sim on new game.

## Files changed (MVP slice)
- Added project bootstrap and scenes/scripts for main menu + playable slice.
- Added deterministic sim core and order handling.
- Added autosave/continue support.
- Added data-driven crew content.
- Added tiny deterministic harness script in `/tests/sim_harness.gd`.
