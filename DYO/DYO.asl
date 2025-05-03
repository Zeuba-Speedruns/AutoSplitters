// DYO - Autostart, Autosplit, Autoreset
// Made by Vocatis
// Version 1.0.0

state("DYO", "Standard"){
    int sceneIndex: 0x64E608;
    int isInLevel: 0x3C7434;
    int passDoorCount: 0x0043DD44, 0x0, 0x168, 0xC, 0xCC;
}

state("DYO", "DYO Lab"){
    int sceneIndex: 0x617EA0;
    int isInLevel: 0x3B4430;
    int passDoorCount: 0x0040761C, 0x0, 0x168, 0xC, 0xCC;
}

startup
{
    settings.Add("split_threshold_1", true, "Split at every level");
    settings.SetToolTip("split_threshold_1", "A total of 30 splits. (Be sure to use the according Splits file)");

    settings.Add("split_threshold_5", false, "Split every 5 levels");
    settings.SetToolTip("split_threshold_5", "A total of 6 splits. (Be sure to use the according Splits file)");

    settings.Add("split_threshold_10", false, "Split every 10 levels");
    settings.SetToolTip("split_threshold_10", "A total of 3 splits. (Be sure to use the according Splits file)");

    settings.Add("reset_config", true, "Autoreset configuration");
    settings.SetToolTip("reset_config", "Configure behaviours triggering the autoreset.");

    settings.Add("reset_titlescreen", true, "Autoreset with title screen", "reset_config");
    settings.SetToolTip("reset_titlescreen", "Pressing 'esc' in the level map screen will autoreset your current splits.");

    settings.Add("reset_controller", false, "Autoreset with controller choice screen", "reset_config");
    settings.SetToolTip("reset_controller", "Opennig controller choice screen will autoreset your current splits.");
}

init
{
    if (modules.First().ModuleMemorySize == 6914048){
        version = "Standard";
    }
    else { //if (modules.First().ModuleMemorySize == 6725632)
        version = "DYO Lab";
    }

    if (settings["split_threshold_1"]) {
        vars.splitThreshold = 1;
    }
    else if (settings["split_threshold_5"]) {
        vars.splitThreshold = 5;
    }
    else {
        vars.splitThreshold = 10;
    }
    vars.currentSplitThreshold = vars.splitThreshold;

    vars.titleScreen = 0;
    vars.controllersSettings = 1;
    vars.levelsMap = 2;
    vars.lastLevel = 30;

    vars.notInLevel = 2;
    vars.normalFinish = 0;

}


update
{
    if (current.passDoorCount != old.passDoorCount) {
        if (current.passDoorCount == 0 && (old.passDoorCount == 1 || old.passDoorCount == 2) && current.isInLevel != vars.notInLevel) {
            vars.normalFinish = 1;
        }
        else if (current.passDoorCount == 0 && old.passDoorCount == 0) {}
        else {
            vars.normalFinish = 0;
        }
    }
}

reset
{
    if (old.sceneIndex == vars.levelsMap && current.sceneIndex == vars.controllersSettings && settings["reset_controller"]) {
        return true;
    }
    if (old.sceneIndex == vars.levelsMap && current.sceneIndex == vars.titleScreen && settings["reset_titlescreen"]) {
        return true;
    }
}

split
{
    if (old.isInLevel != vars.notInLevel && current.isInLevel == vars.notInLevel && vars.normalFinish == 1) {
        vars.currentSplitThreshold--;
        if (vars.currentSplitThreshold == 0) {
            vars.currentSplitThreshold = vars.splitThreshold;
            return true;
        }
    }

    if (old.isInLevel != vars.notInLevel && current.isInLevel == vars.notInLevel && current.sceneIndex == vars.titleScreen) {
        vars.currentSplitThreshold--;
        if (vars.currentSplitThreshold == 0) {
            vars.currentSplitThreshold = vars.splitThreshold;
            return true;
        }
    }
}

start
{
    if (old.sceneIndex == vars.levelsMap && current.sceneIndex > vars.levelsMap) {
        return true;
    }
}