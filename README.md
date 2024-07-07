# Godot-Base-Template
A basic game template for the Godot engine, featuring functionalities that nearly all games would require, such as customizable video/audio/control settings, basic main menu and UI, and other misc. pieces of code.

## Can I use this?
This code is freely available for anyone to make use of. I mainly created this template for my own use, as it would make starting new projects easier due to not having to re-write these basic functionalities. As such, I don't expect to do much activate maintenance or updating, unless I find it useful for myself. Therefore, be aware that this template could be out-of-date, should the engine be updated. **The current version was made on Godot 4.2.1.**

## Features

### Video Settings
Customizable video settings such as:

- Fullscreen / (Bordered) Window toggle
- Window Size
- Monitor to display on
- Vsync toggle

### Audio Settings
Three commonly used audio buses with configurable volume sliders:

- Master Volume
- Music Volume
- SFX Volume

### Customizable Keybindings
Fully customizable keybindings for gameplay and UI controls, with full keyboard, mouse, and controller support. Apart from the default godot UI actions (ui_up, ui_down, ui_left, ui_right, ui_accept, ui_cancel) another action for opening the ingame pause menu (ui_game_menu), as well as four ingame movement actions (move_up, move_down, move_left, move_right) have been added. All these mentioned controls are customizable, having 2 binding options per action to simultaneously support keyboard/mouse and controller.

#### Smooth controller stick controls
The current control scheme supports the basic 8-direction movement system. Controller games often use the full range of the controller sticks instead of being limited to only 8 directions. This is a feature you'd have to implement yourself.

### Pause Menu
In-game pause menu that pauses the game and displays a menu with:

- Continue Game
- Settings Menu
- Quit to Main Menu
- Quit to Desktop

### Misc. Reusable Code
Several pieces of misc. reusable code:

- Scene switch script
