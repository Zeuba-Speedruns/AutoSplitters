// We Were Here - Autostart, Autosplit, Autoreset
// Made by Vocatis
// Autosplitter Version 2.0.2
// Game Version 2.0.21 (20251007)

state("We Were Here"){
    bool isVideoPlaying: "MSAudDecMFT.dll", 0x6BF30;
    int currentPuzzleIndex: "GameAssembly.dll", 0x4088F48, 0xB8, 0xBB0, 0x20, 0x28;
    bool isEyeEndDoorLock: "UnityPlayer.dll", 0x1EF0348, 0xF0, 0x80, 0x60, 0x30, 0xD0, 0x50, 0x0, 0x40, 0x20, 0x28;
    bool isSpikeEndDoorOpen: "UnityPlayer.dll", 0x1F20440, 0x8, 0x258, 0x28, 0x818, 0xC0, 0x50, 0x0, 0x20, 0x20, 0x54;
    bool isTheaterFinished: "GameAssembly.dll", 0x3DC0868, 0xB8, 0x0, 0x18, 0xCF0, 0x78, 0x50, 0x20, 0x29;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;
}

init
{
    vars.solvedPuzzleCount = 0;
    vars.maxSolvedPuzzleCount = 7;

    // Starting Checkpoints
    vars.startCheckpoint = 0;
    vars.chessCheckpoint = 1;
    vars.spikeCheckpoint = 2;

    // Current Puzzle Index
    vars.hieroglyphIndex = 0;
    vars.chessIndex = 1;
    vars.waterIndex = 2;
    vars.theaterIndex = 3;
    vars.spikeIndex = 4;
    //vars.eyeIndex = 5;
    vars.dungeonIndex = 6;

    // Scene Index
    vars.loadingSceneIndex = -1;
    vars.menuSceneIndex = 3;
    vars.gameoverSceneIndex = 4;
    vars.gameSceneIndex = 5;

    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var wwhcheckpoint = mono["WWHCheckpointController"];
        vars.Helper["startingCheckpoint"] = wwhcheckpoint.Make<int>("currentCheckpoint");

        return true;
    });
}


update
{
    current.SceneIndex = vars.Helper.Scenes.Active.Index ?? old.SceneIndex;
}

reset
{
    if ((current.SceneIndex == vars.menuSceneIndex) && (vars.solvedPuzzleCount < vars.maxSolvedPuzzleCount)) {
        return true;
    }
}

split
{
    if ((!old.isEyeEndDoorLock) && current.isEyeEndDoorLock && (current.currentPuzzleIndex == vars.hieroglyphIndex) && (vars.solvedPuzzleCount == 0) && (vars.maxSolvedPuzzleCount == 7)) {
        vars.solvedPuzzleCount++;
        return true;
    }
    if ((old.currentPuzzleIndex == vars.hieroglyphIndex) && (current.currentPuzzleIndex == vars.waterIndex) && (vars.solvedPuzzleCount == 1)) {
        vars.solvedPuzzleCount++;
        return true;
    }
    if ((old.currentPuzzleIndex == vars.waterIndex) && (current.currentPuzzleIndex == vars.dungeonIndex)) {
        vars.solvedPuzzleCount++;
        return true;
    }
    if ((old.currentPuzzleIndex == vars.dungeonIndex) && (current.currentPuzzleIndex == vars.chessIndex)) {
        vars.solvedPuzzleCount++;
        return true;
    }
    if ((old.currentPuzzleIndex == vars.chessIndex) && (current.currentPuzzleIndex == vars.spikeIndex)) {
        vars.solvedPuzzleCount++;
        return true;
    }
    if (old.isSpikeEndDoorOpen && (!current.isSpikeEndDoorOpen) && (vars.solvedPuzzleCount == (vars.maxSolvedPuzzleCount - 2))) {
        vars.solvedPuzzleCount++;
        return true;
    }
    if ((current.currentPuzzleIndex == vars.theaterIndex) && current.isTheaterFinished && (!old.isTheaterFinished) && (vars.solvedPuzzleCount == (vars.maxSolvedPuzzleCount - 1))) {
        vars.solvedPuzzleCount++;
        return true;
    }
    if ((old.SceneIndex == vars.gameSceneIndex) && (current.SceneIndex == vars.loadingSceneIndex) && (vars.solvedPuzzleCount == vars.maxSolvedPuzzleCount)) {
        return true;
    }
}

start
{
    if (current.SceneIndex != vars.gameSceneIndex) return false;
    if (current.startingCheckpoint == vars.startCheckpoint) {
        if (old.isVideoPlaying && (!current.isVideoPlaying)) {
            vars.maxSolvedPuzzleCount = 7;
            return true;
        }
    }
    else if ((current.startingCheckpoint == vars.chessCheckpoint) && (current.currentPuzzleIndex == vars.chessIndex)) {
        vars.maxSolvedPuzzleCount = 3;
        return true;
    }
    else if ((current.startingCheckpoint == vars.spikeCheckpoint) && (current.currentPuzzleIndex == vars.spikeIndex)) {
        vars.maxSolvedPuzzleCount = 2;
        return true;
    }
}

onStart
{
    vars.solvedPuzzleCount = 0;
}
