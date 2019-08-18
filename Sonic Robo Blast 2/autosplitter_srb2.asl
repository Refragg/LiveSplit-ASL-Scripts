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
	string3 scr_id : 0x37B680;
	byte scr_temple : 0x387D9A;
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
	string3 scr_id : 0x334A80;
	byte scr_temple : 0x34077A;
}

init
{
	if (modules.First().ModuleMemorySize == 22024192) version = "2.1.25 - 64 bits";
	if (modules.First().ModuleMemorySize == 21602304) version = "2.1.25 - 32 bits";

	else if(version == "")
	{
		var result = MessageBox.Show(timer.Form,
		"Your game version is not supported by this script version\n"
		+ "You have to use the good version of the game\n"
		+ "This script version works with SRB2 V2.1.25\n"
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
	vars.totalTime = 0;
	settings.Add("TA_S", true, "Start on Record Attack");
	settings.Add("split", true, "Split time");
	settings.Add("finnish", false, "Finish sign", "split");
	settings.Add("a_clear", false, "Act clear appears", "split");
	settings.Add("s_b_clear", false, "Bonuses clear", "split");
	settings.Add("loading", false, "Next level Loading", "split");
	settings.Add("emerald", false, "Split on emeralds");
	settings.Add("emblem", false, "Split on emblems (hover here please)");
	settings.Add("temple", false, "(Mystic Realm) Temple split");
	settings.SetToolTip("split","You shouldn't choose more than 1 split timiing");
	settings.SetToolTip("finnish","Splits when you cross the finish sign");
	settings.SetToolTip("a_clear","Splits when the act clear screen appears");
	settings.SetToolTip("s_b_clear", "Splits when your bonuses got added to the total");
	settings.SetToolTip("loading","Splits when the transition to the next level begins");
	settings.SetToolTip("emblem","Splits on hidden emblems, not on the record attack ones. At every restart of the game, you'll need to take one first emblem then it'll start to split");
	settings.SetToolTip("temple","Splits when activating a temple");
}

start
{
	vars.OSplit = 0;
	vars.totalTime = 0;
	if(settings["TA_S"] == true)
	{
		return (current.start == 1 && current.start != old.start);
	}
	else
	{
		return (current.start == 1 && current.start != old.start && current.TA == 0);
	}
}

update
{
	//print("Executable size is : " + modules.First().ModuleMemorySize);
	int timeToAdd = Math.Max(0, current.framecounter-old.framecounter);
	if(current.framecounter-old.framecounter < 15)
	{
		vars.totalTime += timeToAdd;
	}

	if(current.split == 0 && vars.OSplit == 1)
	{
		vars.OSplit = 0;
	}
}

split
{
	if(settings["temple"] && current.scr_id == "4.6" && current.scr_temple != old.scr_temple && current.scr_temple > 1)
	{
		return true;
	}
	if(settings["s_b_clear"] && current.LBonus == 0 && old.LBonus != 0)
	{
		return true;
	}
	if(settings["loading"] && current.level != old.level && old.level >= 50 && old.level <= 57)
	{
		return true;
	}
	if(settings["emerald"] && current.emerald > old.emerald)
	{
		return true;
	}
	if(settings["emblem"] && current.emblem == -1 && old.emblem == -2)
	{
		return true;
	}

	if(current.level == 25)
    {
        return (old.a_c_countdown == 0 && current.a_c_countdown != 0);
    }
	else if(current.scr_id == "4.6" && current.level == 122 || current.level == 134)
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
	if(current.reset == 0 && current.reset != old.reset)
	{
		return true;
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
