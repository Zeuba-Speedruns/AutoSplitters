// Escape From School - Autostart, Autosplit, Autoreset
// Made by Vocatis, Rouzard, bobbywan-kenoby
// Version 1.0.0

state("EscapeFromSchool-Win64-Shipping")
{
    int gameState: 0x0413A2D0, 0x38, 0x520, 0x488; // 0 --> menu, 1045220557 --> lobby, 1041865114 --> in game

    //int playerCount: 0x04485500, 0x100, 0x268, 0x128; // Lobby player count

    // Player position coordinates
    float playerPositionX: 0x468D730, 0x180, 0x38, 0x0, 0x30, 0x260, 0x290, 0x11C;
    float playerPositionY: 0x468D730, 0x180, 0x38, 0x0, 0x30, 0x260, 0x290, 0x120;
    float playerPositionZ: 0x468D730, 0x180, 0x38, 0x0, 0x30, 0x260, 0x290, 0x124;

    // Online player(s) position coordinates
    float onlinePlayersPositionX: 0x468D730, 0x38, 0x90, 0x0, 0x30, 0x260, 0x290, 0x11C;
    float onlinePlayersPositionY: 0x468D730, 0x38, 0x90, 0x0, 0x30, 0x260, 0x290, 0x120;
    float onlinePlayersPositionZ: 0x468D730, 0x38, 0x90, 0x0, 0x30, 0x260, 0x290, 0x124;

}

init
{
    vars.timerOn = 0;

    vars.inMenu = 0;
    vars.inLobby = 1045220557;
    vars.inGame = 1041865114;

    vars.classroomSplit = 0;
    vars.closetSplit = 0;
    vars.hallwaySplit = 0;
    vars.bathroomSplit = 0;
    vars.endScreenSplit = 0;
}


update
{
    if(current.gameState == vars.inMenu) {
        vars.timerOn = 0;

        vars.classroomSplit = 0;
        vars.closetSplit = 0;
        vars.hallwaySplit = 0;
        vars.bathroomSplit = 0;
        vars.endScreenSplit = 0;
    }
}

reset
{
    if ((old.gameState == vars.inGame) && (current.gameState == vars.inMenu)) {
        return true;
    }
}

split
{
    if ((vars.classroomSplit == 0) && ((current.playerPositionX > 1286) || (current.onlinePlayersPositionX > 1286))) {
        vars.classroomSplit = 1;
        return true;
    }

    if ((vars.closetSplit == 0) && ((current.playerPositionY < -218) || (current.onlinePlayersPositionY < -218))) {
        vars.closetSplit = 1;
        return true;
    }

    if ((vars.hallwaySplit == 0) && ((current.playerPositionY < -653) || (current.onlinePlayersPositionY < -653))) {
        vars.hallwaySplit = 1;
        return true;
    }

    if ((vars.bathroomSplit == 0) && (((current.playerPositionX < 1773) && (current.playerPositionY < -835)) || ((current.onlinePlayersPositionX < 1773) && (current.onlinePlayersPositionY < -835)))) {
        vars.bathroomSplit = 1;
        return true;
    }

    if ((vars.endScreenSplit == 0) && ((current.playerPositionZ <= -2325) || (current.onlinePlayersPositionZ <= -2325))) {
        vars.endScreenSplit = 1;
        return true;
    }

}

start
{
    if ((current.gameState == vars.inGame) && (vars.timerOn == 0)) {
        return true;
    }
}

onStart
{
    vars.timerOn = 1;
}
