state("MetalEden-Win64-Shipping"){}
state("MetalEden-WinGDK-Shipping"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.Helper.AlertLoadless();
}

init
{
	IntPtr gEngine = vars.Helper.ScanRel(3, "48 89 05 ???????? 48 85 c9 74 ?? e8 ???????? 48 8d 4d");
	IntPtr fNames = vars.Helper.ScanRel(3, "48 8d 0d ???????? e8 ???????? c6 05 ?????????? 0f 10 07");
	IntPtr gSyncLoad = vars.Helper.ScanRel(21, "33 C0 0F 57 C0 F2 0F 11 05");
	
	vars.Helper["isLoading"] = vars.Helper.Make<bool>(gSyncLoad);
	
	vars.Helper["Level"] = vars.Helper.Make<ulong>(gEngine, 0xA58, 0x78, 0x18);
	
	vars.Helper["localPlayer"] = vars.Helper.Make<ulong>(gEngine, 0x1080, 0x38, 0x0, 0x30, 0x18);
	vars.Helper["localPlayer"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

	vars.Helper["MissionSummary"] = vars.Helper.Make<byte>(gEngine, 0x1080, 0x548, 0x1E8, 0x0, 0xB30, 0xE4);
	
	vars.Helper["Objective"] = vars.Helper.Make<byte>(gEngine, 0xA58, 0x78, 0x838, 0x188, 0x88, 0x8);
	
	vars.Helper["Maybe"] = vars.Helper.Make<ulong>(gEngine, 0x1080, 0x38, 0x0, 0x30, 0x340, 0x928, 0x0);
	
	//vars.Helper["MissionSummary"] = vars.Helper.Make<ulong>(gEngine, 0x1080, 0x38, 0x0, 0x30, 0x340, 0x780, 0xC0, 0x0);
	//vars.Helper["MissionSummary"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
	
	//vars.Helper["Inv1"] = vars.Helper.Make<ulong>(gEngine, 0x1080, 0x38, 0x0, 0x30, 0x340, 0x778, 0x2E0, 0xD60);
	
	//vars.Helper["Inv2"] = vars.Helper.Make<ulong>(gEngine, 0x1080, 0x38, 0x0, 0x30, 0x340, 0x828, 0x8);
	
	//vars.Helper["Inv3"] = vars.Helper.Make<ulong>(gEngine, 0x1080, 0x38, 0x0, 0x30, 0x340, 0x1510, 0xD8, 0x18);

    vars.FNameToString = (Func<ulong, string>)(fName =>
	{
		var nameIdx  = (fName & 0x000000000000FFFF) >> 0x00;
		var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
		var number   = (fName & 0xFFFFFFFF00000000) >> 0x20;

		IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + (int)chunkIdx * 0x8);
		IntPtr entry = chunk + (int)nameIdx * sizeof(short);

		int length = vars.Helper.Read<short>(entry) >> 6;
		string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

		return number == 0 ? name : name + "_" + number;
	});
	
	vars.FNameToShortString = (Func<ulong, string>)(fName =>
	{
		string name = vars.FNameToString(fName);

		int dot = name.LastIndexOf('.');
		int slash = name.LastIndexOf('/');

		return name.Substring(Math.Max(dot, slash) + 1);
	});
	
	vars.FNameToShortString2 = (Func<ulong, string>)(fName =>
	{
		string name = vars.FNameToString(fName);

		int under = name.LastIndexOf('_');

		return name.Substring(0, under + 1);
	});
}

update
{
    vars.Helper.Update();
	vars.Helper.MapPointers();
	
	//print(vars.FNameToString(current.Maybe));
	
	//print(current.Maybe.ToString());
}

start
{
	return vars.FNameToString(current.Level) == "M_00_Prologue_P_Game" && vars.FNameToString(old.Level) != "M_00_Prologue_P_Game";
}

isLoading
{
	return current.isLoading || vars.FNameToShortString2(current.localPlayer) != "PlayerController_C_" || vars.FNameToString(current.Level) == "me-mainmenu_art" ||
		vars.FNameToString(current.Level) == "EmptyTransitionMap" || vars.FNameToString(current.Level) == "Planet_001" || current.MissionSummary == 4;
}

split
{
	return current.MissionSummary == 4 && old.MissionSummary == 1;
}
