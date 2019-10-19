# EveCarcassonneCounter  

The EveCarcassonneCounter is a little helper script that manages a scorelist of coins collected in the Carcassonne Table game.

Why? Because the "Carcassonne Table" is a little buggy and removes the scores at the end of the game.

## Usage

Rez an object with this script in it close to the carcassonne table. Before starting a game, use the `!reset` command to clear the scorelist.

During gameplay, the owner can use the `!alter` command to modify the amount of coins a player has. 

Players can click the prim to get the current scorelist.

## Owner commands

The following commands can be executed by the owner in nearby chat. I've chosen channel 0 so its clear to the other players which commands get executed.

### !reset

This command will reset the scorelist.

### !scores

This command displays the current scorelist in the chat

### !alter <amount> <username>

Use this command to alter the amount of coins. This will only work if the player already has coins. 

For example, if you want to remove 2 coins from "Player X", use "-2" as a score:

`!alter -2 Player X`

Or if you want to add 4 coins:

`!alter 4 Player X`

Be aware that the username is case sensitive.

## Public commands

### !scores

This prints the current scorelist. This is the same as clicking the prim.

## License

- You are free to use and modify this script for personal usage.
- You are NOT allowed to sell items with this script in it.
- You are NOT allowed to sell this script.


---


❤ Made by evelin
