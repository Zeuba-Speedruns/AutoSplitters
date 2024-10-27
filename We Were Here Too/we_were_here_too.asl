// We Were Here - Autostart, Autosplit, Autoreset
// Made by Vocatis, Rouzard
// Version 1.0.0

state("We Were Here Too"){
    bool isVideoPlaying: "UnityPlayer.dll", 0x15BEF20;
}

startup
{
    settings.Add("safe_end", false, "Final split - Safe mode");
    settings.SetToolTip("safe_end", "Splits at appearance of final cutscene (Late)");

    settings.Add("ritual_start", false, "Starting at The Ritual (Be sure to use the according Splits file)");
    settings.SetToolTip("ritual_start", "Check if your starting at The Ritual");

    settings.Add("stair_start", false, "Starting at The Stairwell (Be sure to use the according Splits file)");
    settings.SetToolTip("stair_start", "Check if your starting at The Stairwell");

    settings.Add("weapons_start", false, "Starting at The Promenade (Be sure to use the according Splits file)");
    settings.SetToolTip("weapons_start", "Check if your starting at The Promenade");

    settings.Add("battlefield_start", false, "Starting at The Council or at The Battlefield (Be sure to use the according Splits file)");
    settings.SetToolTip("battlefield_start", "Check if your starting at The Council or at The Battlefield");

    settings.Add("arena_start", false, "Starting at The Arena (Be sure to use the according Splits file)");
    settings.SetToolTip("arena_start", "Check if your starting at The Arena");

    settings.Add("incinerator_start", false, "Starting at The Incinerator (Be sure to use the according Splits file)");
    settings.SetToolTip("incinerator_start", "Check if your starting at The Incinerator");

    settings.Add("elevator_start", false, "Starting at The Elevator (Be sure to use the according Splits file)");
    settings.SetToolTip("elevator_start", "Check if your starting at The Elevator");

    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
}

init
{
    vars.checkpoints = 0;

    //vars.splashScreen = 0;
    vars.loadingScene = 1;
    vars.mainMenu = 2;
    vars.gameOver = 3;
    vars.gameScene = 4;
    //vars.infoScreen = 5;
    vars.lordSlot = 11;
    //vars.peasantSlot = 15;
    vars.lordRitual = 10;
    vars.peasantRitual = 14;
    vars.peasantStairs = 16;
    vars.lordWeapons = 12;
    vars.peasantWeapons = 17;
    vars.lordBattleboard = 9;
    vars.peasantBattleboard = 13;
    vars.arena = 6;
    vars.incinerator = 8;
    vars.elevator = 7;

    vars.TimerModel = new TimerModel { CurrentState = timer };

    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["gameSceneIndex"] = mono.Make<int>("GlobalNetworkSystem", "manager", "currentScene");
        return true;
    });

}


update
{
    if(current.gameSceneIndex == vars.mainMenu) {
        vars.checkpoints = 0;
    }

    if (!settings["safe_end"] && old.gameSceneIndex == vars.loadingScene && current.gameSceneIndex == vars.elevator && vars.checkpoints == 8) {
        vars.checkpoints--;
        vars.TimerModel.UndoSplit();
    }
}

reset
{

    if(old.gameSceneIndex == vars.loadingScene && current.gameSceneIndex == vars.mainMenu && vars.checkpoints < 8) {
        return true;
    }
}

split
{
    if ((current.gameSceneIndex == vars.lordRitual || current.gameSceneIndex == vars.peasantRitual) && vars.checkpoints == 0) {
        vars.checkpoints++;
        return true;
    }
    if (current.gameSceneIndex == vars.peasantStairs && vars.checkpoints == 1) {
        vars.checkpoints++;
        return true;
    }
    if ((current.gameSceneIndex == vars.lordWeapons && (vars.checkpoints == 1 || vars.checkpoints == 2)) || (current.gameSceneIndex == vars.peasantWeapons && vars.checkpoints == 2)) {
        vars.checkpoints++;
        if (current.gameSceneIndex == vars.lordWeapons && vars.checkpoints == 2) {
            vars.checkpoints++;
        }
        return true;
    }
    if ((current.gameSceneIndex == vars.lordBattleboard || current.gameSceneIndex == vars.peasantBattleboard) && vars.checkpoints == 3) {
        vars.checkpoints++;
        return true;
    }
    if (current.gameSceneIndex == vars.arena && vars.checkpoints == 4) {
        vars.checkpoints++;
        return true;
    }
    if (current.gameSceneIndex == vars.incinerator && vars.checkpoints == 5) {
        vars.checkpoints++;
        return true;
    }
    if (current.gameSceneIndex == vars.elevator && vars.checkpoints == 6) {
        vars.checkpoints++;
        return true;
    }
    if (!settings["safe_end"] && (old.gameSceneIndex == vars.gameScene || old.gameSceneIndex == vars.elevator) && current.gameSceneIndex == vars.loadingScene && vars.checkpoints == 7) {
        vars.checkpoints++;
        return true;
    }

    if (settings["safe_end"] && current.gameSceneIndex == vars.gameOver && current.isVideoPlaying && vars.checkpoints == 7) {
        vars.checkpoints++;
        return true;
    }

}

start
{
    if (current.gameSceneIndex == vars.gameScene && !current.isVideoPlaying && old.isVideoPlaying) {
        return true;
    }
    if (settings["ritual_start"] && (current.gameSceneIndex == vars.gameScene) && (old.gameSceneIndex == vars.lordRitual || old.gameSceneIndex == vars.peasantRitual)) {
        vars.checkpoints = 1;
        return true;
    }
    if (settings["stair_start"] && (current.gameSceneIndex == vars.gameScene) && (old.gameSceneIndex == vars.lordRitual || old.gameSceneIndex == vars.peasantStairs)) {
        vars.checkpoints = 2;
        return true;
    }
    if (settings["weapons_start"] && (current.gameSceneIndex == vars.gameScene) && (old.gameSceneIndex == vars.lordWeapons || old.gameSceneIndex == vars.peasantWeapons)) {
        vars.checkpoints = 3;
        return true;
    }
    if (settings["battlefield_start"] && (current.gameSceneIndex == vars.gameScene) && (old.gameSceneIndex == vars.lordBattleboard || old.gameSceneIndex == vars.peasantBattleboard)) {
        vars.checkpoints = 4;
        return true;
    }
    if (settings["arena_start"] && (current.gameSceneIndex == vars.gameScene) && old.gameSceneIndex == vars.arena) {
        vars.checkpoints = 5;
        return true;
    }
    if (settings["incinerator_start"] && (current.gameSceneIndex == vars.gameScene) && old.gameSceneIndex == vars.incinerator) {
        vars.checkpoints = 6;
        return true;
    }
    if (settings["elevator_start"] && (current.gameSceneIndex == vars.gameScene) && old.gameSceneIndex == vars.elevator) {
        vars.checkpoints = 7;
        return true;
    }
}