// We Were Here - Autostart, Autosplit, Autoreset
// Made by Vocatis, Rouzard
// Version 1.0.0

state("We Were Here"){}

startup
{
    settings.Add("chess_start", false, "Starting at Chess (Be sure to use the according Splits file)");
    settings.SetToolTip("chess_start", "Check if your starting at Chess");
    settings.Add("spike_start", false, "Starting at Spike (Be sure to use the according Splits file)");
    settings.SetToolTip("spike_start", "Check if your starting at Spike");

    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;

    vars.checkpoints = 0;

    vars.gameStartedLog = "[GameSceneController]: Game Started";
    vars.unlockedLog = "Achievement Unlocked: ";
    vars.eyeSolvedExplorerLog = vars.unlockedLog + "EYES_PUZZLE_ROAM";
    vars.eyeSolvedLibrarianLog = vars.unlockedLog + "EYES_PUZZLE_STUDY";
    vars.hieroglyphSolvedExplorerLog = vars.unlockedLog + "PAINTING_PUZZLE_ROAM";
    vars.hieroglyphSolvedLibrarianLog = vars.unlockedLog + "PAINTING_PUZZLE_STUDY";
    vars.waterSolvedExplorerLog = vars.unlockedLog + "WATER_PUZZLE_ROAM";
    vars.waterSolvedLibrarianLog = vars.unlockedLog + "WATER_PUZZLE_STUDY";
    vars.dungeonSolvedExplorerLog = vars.unlockedLog + "DUNGEON_PUZZLE_ROAM";
    vars.dungeonSolvedLibrarianLog = vars.unlockedLog + "DUNGEON_PUZZLE_STUDY";
    vars.chessSolvedExplorerLog = vars.unlockedLog + "CHESS_PUZZLE_ROAM";
    vars.chessSolvedLibrarianLog = vars.unlockedLog + "CHESS_PUZZLE_STUDY";
    vars.spikeSolvedExplorerLog = vars.unlockedLog + "SPIKE_PUZZLE_ROAM";
    vars.spikeSolvedLibrarianLog = vars.unlockedLog + "SPIKE_PUZZLE_STUDY";
    vars.theaterSolvedExplorerLog = vars.unlockedLog + "THEATER_PUZZLE_ROAM";
    vars.theaterSolvedLibrarianLog = vars.unlockedLog + "THEATER_PUZZLE_STUDY";

    vars.logPath = "";
    vars.logPath += Environment.GetEnvironmentVariable("LocalAppData");
    vars.logPath += "\\..\\LocalLow\\Total Mayhem Games\\We Were Here\\";
    vars.logPath += "output_log.txt";
}

init
{
    try {
        FileStream fs = new FileStream(vars.logPath, FileMode.Open, FileAccess.Write, FileShare.ReadWrite);
        fs.SetLength(0);
        fs.Close();
    } catch {
        print("Failed to load and clear logfile!");
    }

    vars.reader = new StreamReader(new FileStream(vars.logPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
}


update
{
    current.Scene = vars.Helper.Scenes.Active.Name ?? old.Scene;

    if(current.Scene == "lobbyscreen") {
        vars.checkpoints = 0;
    }

    vars.logLine = vars.reader.ReadLine();
}

reset
{
    if(old.Scene == "loadingscreen" && current.Scene == "mainmenu" && vars.checkpoints < 8) {
        return true;
    }
}

split
{
    if ((vars.logLine == vars.eyeSolvedExplorerLog || vars.logLine == vars.eyeSolvedLibrarianLog) && vars.checkpoints == 0) {
        vars.checkpoints++;
        return true;
    }

    if ((vars.logLine == vars.hieroglyphSolvedExplorerLog || vars.logLine == vars.hieroglyphSolvedLibrarianLog) && vars.checkpoints == 1) {
        vars.checkpoints++;
        return true;
    }

    if ((vars.logLine == vars.waterSolvedExplorerLog || vars.logLine == vars.waterSolvedLibrarianLog) && vars.checkpoints == 2) {
        vars.checkpoints++;
        return true;
    }

    if ((vars.logLine == vars.dungeonSolvedExplorerLog || vars.logLine == vars.dungeonSolvedLibrarianLog) && vars.checkpoints == 3) {
        vars.checkpoints++;
        return true;
    }

    if ((vars.logLine == vars.chessSolvedExplorerLog || vars.logLine == vars.chessSolvedLibrarianLog) && vars.checkpoints == 4) {
        vars.checkpoints++;
        return true;
    }

    if ((vars.logLine == vars.spikeSolvedExplorerLog || vars.logLine == vars.spikeSolvedLibrarianLog) && vars.checkpoints == 5) {
        vars.checkpoints++;
        return true;
    }

    if ((vars.logLine == vars.theaterSolvedExplorerLog || vars.logLine == vars.theaterSolvedLibrarianLog) && vars.checkpoints == 6) {
        vars.checkpoints++;
        return true;
    }

    if (current.Scene == "gameoverscreen" && vars.checkpoints == 7) {
        vars.checkpoints++;
        return true;
    }
}

start
{
    if (vars.logLine == vars.gameStartedLog) {
        return true;
    }
}

onStart
{
    if (settings["chess_start"]) {
        vars.checkpoints = 4;
    }
    if (settings["spike_start"]) {
        vars.checkpoints = 5;
    }
}
