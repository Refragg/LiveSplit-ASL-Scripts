/* SRB2Kart works approximately the same as SRB2 although it's an other executable so some things comes from SRB2's splitter.
I have a very basic knowledge about C# and ASL in general so this splitter is pretty basic and probably shouldn't be taken as an example.*/

state("srb2kart", "1.1 - 32 bits")
{
	int start_RA : 0x14BF9AC;
	int frameCounter_track : 0x14A8B84;
	int lap : 0x14A8B88;
	int laps_total : 0x1DCCF4;
	int level : 0x1DFE88;
}

state("srb2kart", "1.1 - 64 bits")
{
	int start_RA : 0x14F3888;
	int frameCounter_track : 0x14D9BA8;
	int lap : 0x14D9BAC;
	int laps_total : 0x1E2468;
	int level : 0x1E75E8;
}

state("srb2kart", "1.0.4 - 32 bits")
{
	int start_RA : 0x13E176C;
	int frameCounter_track : 0x13D98CC;
	int lap : 0x13D98D0;
	int laps_total : 0x1CDCF4;
	int level : 0x1D0C98;
}

state("srb2kart", "1.0.4 - 64 bits")
{
	int start_RA : 0x1413E28;
	int frameCounter_track : 0x14090B0;
	int lap : 0x14090B4;
	int laps_total : 0x1D2468;
	int level : 0x1D72C8;
}

state("srb2kart", "1.0.1")
{
	int start_RA : 0x13AC88C;
	int frameCounter_track : 0x13A5F00;
	int lap : 0x13A5F04;
	int laps_total : 0x1C0AD4;
	int level : 0x1C3A7C;
}

state("srb2kart", "1.1 - Shaders 64 bits")
{
	int start_RA : 0x151B1A8;
	int frameCounter_track : 0x15014C8;
	int lap : 0x15014CC;
	int laps_total : 0x1E2468;
	int level : 0x1E75E8;
}

state("srb2kart", "1.1 - mservfix 64 bits")
{
	int start_RA : 0x14D8888;
	int frameCounter_track : 0x14BEBA8;
	int lap : 0x14BEBAC;
	int laps_total : 0x1C8468;
	int level : 0x1CD5E8;
}

state("srb2kart", "1.1 - Shaders 32 bits")
{
	int start_RA : 0x14C822C;
	int frameCounter_track : 0x14B4034;
	int lap : 0x14B1408;
	int laps_total : 0x1C7CF4;
	int level : 0x1CAE88;
}

state("srb2kart", "1.1 - mservfix 32 bits")
{
	int start_RA : 0x147698C;
	int frameCounter_track : 0x145FB64;
	int lap : 0x145FB68;
	int laps_total : 0x1C2CF4;
	int level : 0x1C5E88;
}

init
{
	if (modules.First().ModuleMemorySize == 22675456) version = "1.1 - 32 bits";
	if (modules.First().ModuleMemorySize == 23027712) version = "1.1 - 64 bits";
	if (modules.First().ModuleMemorySize == 21766144) version = "1.0.4 - 32 bits";
	if (modules.First().ModuleMemorySize == 22110208) version = "1.0.4 - 64 bits";
	if (modules.First().ModuleMemorySize == 21483520) version = "1.0.1";
	if (modules.First().ModuleMemorySize == 23220224) version = "1.1 - Shaders 64 bits";
	if (modules.First().ModuleMemorySize == 22917120) version = "1.1 - mservfix 64 bits";
	if (modules.First().ModuleMemorySize == 22732800) version = "1.1 - Shaders 32 bits";
	if (modules.First().ModuleMemorySize == 22372352) version = "1.1 - mservfix 32 bits";

	else if(version == "")
	{
		var result = MessageBox.Show(timer.Form,
		"Your executable is not supported by this script version\n"
		+ "Also make sure your executable name is srb2kart.exe\n"
		+ "This script version works with vanilla V1.0.1, V1.0.4, V1.1 and some modded exes\n"
		+ "\nClick OK if you want to open the README webpage",
		"SRB2Kart Livesplit Script",
		MessageBoxButtons.OKCancel,
		MessageBoxIcon.Information);
		if (result == DialogResult.OK)
		{
			Process.Start("https://github.com/R3FR4G/LiveSplit-ASL-Scripts/blob/master/Sonic%20Robo%20Blast%202%20Kart/README.md");
		}
	}

	refreshRate = 35;
}

startup
{
	vars.totalTime = 0;
	settings.Add("split", false, "Split every lap");
}

start
{
	vars.totalTime = 0;
	if(current.start_RA == 1 && old.start_RA == 0)
	{
		return true;
	}
}

update
{
	//print("Executable size is : " + modules.First().ModuleMemorySize);
	int timeToAdd = Math.Max(0, current.frameCounter_track-old.frameCounter_track);
	if(current.frameCounter_track-old.frameCounter_track < 35)
	{
		vars.totalTime += timeToAdd;
	}
}

split
{
	if(settings["split"] && current.lap > old.lap && current.frameCounter_track != 0 && current.lap != old.lap && current.lap != current.laps_total)
	{
		return true;
	}
	if(current.lap == current.laps_total && current.lap != old.lap)
	{
		return true;
	}
}

reset
{
	if(current.level == 1 && current.start_RA == 1 && current.start_RA != old.start_RA)
	{
		return true;
	}
}

gameTime
{
	return TimeSpan.FromMilliseconds(vars.totalTime*28.5714285714);
}

isLoading
{
	return true;
}
