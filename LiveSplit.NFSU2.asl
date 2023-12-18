state("SPEED2")
{
    //Representing the name of the Scene
    string7 fmvName : 0x4382A0;
	string8 fmvName : 0x4382A0;
	string10 fmvName : 0x4382A0;

	// 0 = Main menu
	// 1 = Freeroam or inside a race
	// 2 = Drag Race 
    // 3 = Winner Endscreen
    int raceState : 0x49CE00;
    
	//0 not playing and 1 is playing
	int fmvPlaying : "SPEED2.EXE", 0x4383AC;

    //ingame 1 loading 0
    int loadingScreen: "SPEED2.EXE", 0x432E58;
	
	// 2 = SMS menu is open
    // 0 = SMS menu is not open
    int smsMenu : "speed2.exe", 0x43632C;

    // 636674500 = NIS cutscene that plays when leaving a shop or garage
    // 0 = Cutscene is not playing
    int inAShop : "speed2.exe", 0x427EC0;

    // 2 = Star Event
    // 0 = no Event
    int starEvent : "speed2.exe", 0x438578;
    
    //obsolete, but still here if something happens
    int loadingScreen2: "SPEED2.EXE", 0x432FA8;	//ingame 1 loading 0
    int loadingScreen3: "SPEED2.EXE", 0x463774;	//ingame 2 loading 3
    int loadingScreen4: "SPEED2.EXE", 0x465498;	//ingame 0 loading 1 bad value, because it flickers between 0 and 1 sometimes while loading
    int loadingScreen5: "SPEED2.EXE", 0x46E778;	//ingame 1 loading 0
    int loadingScreen6: "SPEED2.EXE", 0x46E794;	//ingame 1 loading 0
}

startup
{
	settings.Add("fullrunstart", true, "Full run start split");
	settings.SetToolTip("fullrunstart", "Starts the timer when entering Career Mode for the first time.");
	
	settings.Add("stagestart", false, "Stage IL start split");
	settings.SetToolTip("stagestart", "Starts the timer when you close the SMS prompt that appears at the start of each stage.");
	
	settings.Add("shopsplit", true, "Split when exiting a car lot, garage or tuning shop");
	
	settings.Add("racesplit", true, "Split when finishing a race");
	settings.SetToolTip("racesplit", "Splits on drag restarts.");
	
	settings.Add("starsplit", true, "Split when taking a DVD cover");
	
	settings.Add("stagesplit", false, "Split on the last cutscene of each Stage");
}

start
{
	return current.fmvName == "scene01" && current.fmvPlaying == 1 && old.fmvPlaying == 0 && settings["fullrunstart"] || current.smsMenu == 0 && old.smsMenu == 2 && settings["stagestart"];
}

split 
{
	//Last race in stage 1
    if(current.fmvName == "Scene07" && current.fmvPlaying == 1 && old.fmvPlaying == 0 && settings["stagesplit"]) {
        return true;
    }
	//Last race in stage 2
    else if(current.fmvName == "SUBURBAN" && current.fmvPlaying == 1 && old.fmvPlaying == 0 && settings["stagesplit"]) {
        return true;
    }
	//Last race in stage 3
    else if(current.fmvName == "INDUSTEAST" && current.fmvPlaying == 1 && old.fmvPlaying == 0 && settings["stagesplit"]) {
        return true;
    }
	//Last race in stage 4
    else if(current.fmvName == "INDUSTWEST" && current.fmvPlaying == 1 && old.fmvPlaying == 0 && settings["stagesplit"]) {
        return true;
    }
	//Last race vs caleb in stage 5
    else if(current.fmvName == "Scene15" && current.fmvPlaying == 1 && old.fmvPlaying == 0 && settings["stagesplit"]) {
        return true;
    }
	//Split when leaving a car lot, shop or garage
    else if(old.inAShop == 0 && current.inAShop == 636674500 && settings["shopsplit"]) {
        return true;
    }
    //Split for normal races
    else if(current.raceState == 3 && old.raceState == 1 && settings["racesplit"]) {
        return true;
    }
    //Split for drag races
    else if(current.raceState == 3 && old.raceState == 2 && settings["racesplit"]) {
        return true;
    }
    //Split for star events
    else if(old.starEvent == 2 && current.starEvent == 0 && settings["starsplit"]) {
        return true;
    }
    else {
        return false;
    }
}

isLoading
{
    return current.loadingScreen == 0 && current.fmvPlaying == 0;
}

exit
{
	timer.IsGameTimePaused = false;
}
