# grimoire
A collection of helpful scripts and macros designed to be used a Submodule in GameMaker projects for easy updates.

# How to Use this in a GameMaker Project
- Add a script to your project like `scr_grimoire`
- Navigate to the file location of this new asset and script.
- Initialize this git submodule at this location.
  - Something like `git submodule add https://github.com/theinfamousmrmeow/grimoire .\scripts\scr_grimoire`
  - Assuming location is `scripts\scr_grimoire`, you can run `grimoire_add_submodule.bat`
- It will override your `scr_grimoire` with this and from that point can be updated automatically as the Grimoire expands.


# How to get lastest

`git submodule update --remote -f ./scripts/scr_grimoire`

# How to remove
 git submodule deinit --all -f
