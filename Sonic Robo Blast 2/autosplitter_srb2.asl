/*I have a very basic knowledge about C# and ASL in general so this splitter is pretty basic and probably shouldn't be taken as an example.*/

state("srb2win", "2.1.25 - 64 bits")
{
	int start : 0x13DFDC8;
	int split : 0x388280;
	int level : 0x1BEBE4;
	int framecounter : 0x13D2850;
	int a_c_countdown : 0x13D2830;
	int TBonus : 0x388310;
	int RBonus : 0x388324;
	int LBonus : 0x388330;
	int TA : 0x37B658;
	int reset : 0x345EF0;
	int emblem : 0x23E3E4;
	int emerald : 0x13D1C8C;
	string10 mod_id : 0x37B680;
	byte scr_temple : 0x387D9A;
	int sugoiBoss : 0x013D2760, 0x8, 0xF0, 0x0, 0xE0;
}

state("srb2win", "2.1.25 - 32 bits")
{
	int start : 0x13914AC;
	int split : 0x340C40;
	int level : 0x194F7C;
	int framecounter : 0x138630C;
	int a_c_countdown : 0x13862EC;
	int TBonus : 0x340CD0;
	int RBonus : 0x340CE4;
	int LBonus : 0x340CF0;
	int TA : 0x334A4C;
	int reset : 0x306DB0;
	int emblem : 0x1FDE28;
	int emerald : 0x1385CA0;
	string10 mod_id : 0x334A80;
	byte scr_temple : 0x34077A;
	int sugoiBoss : 0x01391420, 0x38, 0x0, 0x7C, 0x0, 0x90;
}

state("srb2win", "2.2.0")
{
	int start : 0x43FA508;
	int split : 0x3CA800;
	int level : 0x2259A4;
	int framecounter : 0x54DEFDC;
	int a_c_countdown : 0x54DEFB8;
	int TBonus : 0x3CA8B8;
	int RBonus : 0x3CA8CC;
	int LBonus : 0x3CA8D8;
	int TA : 0x3BE1DC;
	int emerald : 0x54E3BE0;
	string4 music : 0x43F52D8;
	int file : 0x22A5CC;
}

init
{
	if (modules.First().ModuleMemorySize == 22024192) version = "2.1.25 - 64 bits";
	if (modules.First().ModuleMemorySize == 21602304) version = "2.1.25 - 32 bits";
	if (modules.First().ModuleMemorySize == 96985088) version = "2.2.0";

	else if(version == "")
	{
		var result = MessageBox.Show(timer.Form,
		"Your game version is not supported by this script version\n"
		+ "You have to use the good version of the game\n"
		+ "This script version works with SRB2 V2.1.25 and V2.2.0\n"
		+ "\nClick Yes to open the game update page.",
		"SRB2 Livesplit Script",
		MessageBoxButtons.YesNo,
		MessageBoxIcon.Information);
		if (result == DialogResult.Yes)
		{
			Process.Start("https://www.srb2.org/download");
		}
	}
	refreshRate = 35;
	vars.OSplit = 0;
}

startup
{
  vars.timerModel = new TimerModel { CurrentState = timer };
	vars.dummy = 0;
	vars.totalTime = 0;
	settings.Add("startS", false, "(2.2 only) Only start at the first level");
	settings.Add("TA_S", true, "Start on Record Attack");
	settings.Add("split", true, "Split time");
	settings.Add("finnish", false, "Finish sign", "split");
	settings.Add("a_clear", false, "Act clear appears", "split");
	settings.Add("s_b_clear", false, "Bonuses clear", "split");
	settings.Add("loading", false, "Next level Loading", "split");
	settings.Add("CEZR", false, "(2.2 only) Split at the bridge falling section of CEZ1");
	settings.Add("emerald", false, "Split on emerald tokens");
	settings.Add("resetS", false, "(2.2 only) Reset even if playing on a file");
	settings.Add("emblem", false, "(2.1 only) Split on emblems (hover here please)");
	settings.Add("temple", false, "(2.1 only) (Mystic Realm) Temple split");
	settings.Add("sugo_WSplit", false, "(2.1 only) (SUGOI 1/2) Teleport Station split");
	settings.SetToolTip("startS","Avoids starting on existing files");
	settings.SetToolTip("split","You shouldn't choose more than 1 split timiing");
	settings.SetToolTip("finnish","Splits when you cross the finish sign");
	settings.SetToolTip("a_clear","Splits when the act clear screen appears");
	settings.SetToolTip("s_b_clear", "Splits when your bonuses got added to the total");
	settings.SetToolTip("loading","Splits when the transition to the next level begins");
	settings.SetToolTip("resetS","Avoids accidental timer resets");
	settings.SetToolTip("emblem","Splits on hidden emblems, not on the record attack ones. At every restart of the game, you'll need to take one first emblem then it'll start to split");
	settings.SetToolTip("temple","Splits when activating a temple");
	settings.SetToolTip("sugo_WSplit","Splits when you warp into a level from the Teleport Station");
}

start
{
	vars.dummy = 0;
	vars.OSplit = 0;
	vars.totalTime = 0;
	if(version == "2.2.0" && settings["startS"])
	{
		if(settings["TA_S"])
		{
			return (current.level == 1 && old.level == 99);
		}
		else
		{
			return (current.TA == 0 && current.level == 1 && old.level == 99);
		}
	}
	else
	{
		if(settings["TA_S"])
		{
			return (current.start == 1 && current.start != old.start);
		}
		else
		{
			return (current.start == 1 && current.start != old.start && current.TA == 0);
		}
	}
}

update
{
	//print("Executable size is : " + modules.First().ModuleMemorySize);
	//print("vars.dummy = " + vars.dummy);
	int timeToAdd = Math.Max(0, current.framecounter-old.framecounter);
	if(current.framecounter-old.framecounter < 15)
	{
		vars.totalTime += timeToAdd;
	}

	if(current.split == 0 && vars.OSplit == 1)
	{
		vars.OSplit = 0;
	}

	if(current.mod_id == "SUBARASHII" && current.level == 100 && old.level == 101)
	{
		vars.timerModel.UndoSplit();
	}
}

split
{
	if(settings["sugo_WSplit"] && version != "2.2.0" && current.mod_id == "SUGOI V1.2" || current.mod_id == "SUBARASHII" && old.level == 100 && current.level != old.level)
	{
		return true;
	}
	if(version != "2.2.0" && current.mod_id == "SUGOI V1.2" && current.level == 28 && current.sugoiBoss == 0 && old.sugoiBoss == 1)
	{
		return true;
	}
	if(version == "2.2.0" && settings["CEZR"] && current.music == "CEZR" && current.music != old.music)
	{
		return true;
	}
	if(version != "2.2.0" && settings["temple"] && current.mod_id == "4.6" && current.scr_temple != old.scr_temple && current.scr_temple > 1)
	{
		return true;
	}
	if(settings["s_b_clear"] && current.LBonus == 0 && old.LBonus != 0)
	{
		return true;
	}
	if(version != "2.2.0" && settings["loading"] && current.level != old.level && old.level >= 50 && old.level <= 57)
	{
		return true;
	}
	if(version == "2.2.0" && settings["loading"] && current.level != old.level && old.level >= 50 && old.level <= 73)
	{
		return true;
	}
	if(settings["emerald"] && current.emerald > old.emerald)
	{
		return true;
	}
	if(version != "2.2.0" && settings["emblem"] && current.emblem == -1 && old.emblem == -2)
	{
		return true;
	}

	if(version != "2.2.0" && current.level == 25)
  {
    return (old.a_c_countdown == 0 && current.a_c_countdown != 0);
  }
	if(version == "2.2.0" && current.level == 25 || current.level == 26 || current.level == 27)
	{
		return (old.a_c_countdown > 1 && current.a_c_countdown <= 1);
	}
	else if(version != "2.2.0" && current.mod_id == "4.6" && current.level == 122 || current.level == 134)
	{
		return (old.a_c_countdown == 0 && current.a_c_countdown != 0);
	}
  else if(settings["finnish"])
  {
    return (old.a_c_countdown == 0 && current.a_c_countdown != 0);
  }
	else if(settings["a_clear"])
	{
		return (old.a_c_countdown != 1 && current.a_c_countdown == 1);
  }
	else if(settings["s_b_clear"] && current.split == 1 && current.TBonus == 0 && current.RBonus == 0 && vars.OSplit == 0)
	{
		vars.OSplit = 1;
		return true;
	}
  else if(settings["loading"])
  {
  	return (current.split == 0 && old.split == 1);
  }
}

reset
{
	if(version != "2.2.0" && current.reset == 0 && current.reset != old.reset)
	{
		return true;
	}
	if(version == "2.2.0" && settings["resetS"])
	{
		return (current.level == 99 && current.level != old.level);
	}
	else if(version == "2.2.0" && current.file == 0)
	{
		return (current.level == 99 && current.level != old.level);
	}
	else
	{
		return false;
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
