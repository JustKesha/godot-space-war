# 👾 Godot - Space War

>[!WARNING]
>#### 🐙 Early Development Stage
>This project is in an early active-development stage and its foundation may not be fully formed.  
>This includes but is not limited to possible changes to the architecture and class APIs in the near future.  

This is an arcade shooter game being developed on [Godot 4](https://github.com/godotengine/godot) with the idea of synergies and content variety,
inspired by games like [The Binding of Isaac](https://store.steampowered.com/app/250900/The_Binding_of_Isaac_Rebirth) and [Inscryption](https://store.steampowered.com/app/1092790/Inscryption).

## Direction

This is a recreation of my older game jam project, with main goals being improved architecture and expandability.  
The planned gameplay mechanics are roughly outlined below & in the [progress section](#progress) and are subject to change.

### Game-loop

As of right now, the main game loop is seen by me as a semi-endless cycle of:
1. Fight off waves of enemies
1. Upgrade
1. Repeat

Except instead of going in the classic endless scroller approach, I'd like to do something similar to The Binding of Isaac or Inscryption with runs being split into clear sections/locations each with its own boss fight and perhaps even an option to take different routes.  

The upgrades however is (at least to me) the most interesting part in this topic and I'm still deciding on the approach.  
I personally really enjoy the deck building mechanics used in Inscryption and the great amount of possible synergies given by The Binding of Isaac.  

### Theme

The project theme is yet to be settled on but if nothing changes, it will receive the same arcady/space theme as in the game jam version presented below.

<img alt="older game-jam project version" src="preview/game_jam_version.gif" width="50%" />

## Progress

- [x] Foundation
- [ ] Playable
  - [x] Wave manager
  - [x] [Early test build](https://github.com/JustKesha/godot-space-war/releases#release-v0.0.1)
  - [ ] Score system
  - [ ] UI/HUD
- [ ] Expansion
  - [ ] Stat system
  - [ ] Upgrades / Progression system
- [ ] Polish
  - [ ] Animations
  - [ ] VFX & SFX
  - [ ] Shaders & Camera effects

## Contribution

While this is a small passion project, any help would be welcomed.  
If you're new to Godot or just wanna learn more - you can contact me on [Discord](https://discord.gg/mh6ZwSSPcy).  

>[!NOTE]
>#### 🍦 Assets Content
>This repository does not contain the asset folder for this project.  
>A fresh version can be requested through the discord.  

### Requirements

- Godot 4.7 or higher
- [Assets content](#-assets-content)

<img alt="sticker" src="https://media.tenor.com/G32hUnhj_RwAAAAi/waze-driving.gif" width="50px" />

## Documentation

The project is in a very raw state so the documentation will be kept to minimum as of now.  

>[!TIP]
>#### 📖 Docstrings
>Some classes like the ones in [src/common](./src/common/) are documented using gd script docstrings.  
>This documentation can be viewed using godot gui and only applies to public api.  

### Structure

Files are generally organized by feature, with the exception of shared global resources like sprites and audio, which belong in the [src/assets](./src/assets/) directory.

| Directory | Description | Git |
|-|-|-|
| [build](./build/) | Project builds | **Excluded from Git** |
| [src](./src/) | Project source code | Included in Git |
| [src/assets](./src/assets/) | Project assets (sprites, audio, icons, etc.) | **Excluded from Git** |
| [src/autoload](./src/autoload/) | Global autoload/singleton scripts | Included in Git |
| [src/common](./src/common/) | Generic classes & utils with no tight relation to the project | Included in Git |
| [src/data](./src/data/) | Resource files | Included in Git |
| [src/prefabs](./src/prefabs/) | Interactable objects (prefab scenes, preset scripts) & project specific classes/components | Included in Git |
| [src/scenes](./src/scenes/) | Playable areas (such as levels) | Included in Git |
| [src/test](./src/test/) | Testing ground for new/temp features | **Excluded from Git** |

### Architecture

The project follows a resource-driven components system, which you can read about in more details below.

#### Patterns

To keep code clean and prevent pieces from getting tangled up, the project generally follows a "signals up, calls down" design pattern.  
- **Signals Up:**  
Child components should never directly tell their parents what to do.  
Instead, they emit a signal, and the parent chooses how to respond.  
- **Calls Down:**  
Parent objects can directly tell their child components to do something by calling a function.  
>[!NOTE]
>This is a flexible guideline rather than a strict, unbreakable rule.  
>Use best judgment if a specific situation requires a different approach.  


#### Hierarchy

The foundation of every object in the game relies on two main concepts: inheritance for the node structure, and preset resources for the settings.  

- **Base Entity**:  
Everything starts from a single, foundational blueprint called the [base entity packed scene](./src/prefabs/entity/entity.tscn).  
- **Inheritance Tree:**  
Specialized game objects (like player, enemies or projectiles) are created by extending this base entity blueprint, forming a structured family tree of prefabs.  
- **Preset Resources:**  
To change how an object behaves or looks, the project uses custom data files called presets (such as an [Entity Preset](./src/prefabs/entity/entity_preset.gd) or [Player Preset](./src/prefabs/entity/durable/obstacle/combatant/player/player_preset.gd)).
These files hold settings and variables. Instead of changing the code, settings are changed by swapping or adjusting these decoupled resource files.  
