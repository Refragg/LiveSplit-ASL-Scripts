state("Firewing64_v21")
{
	int shardsCount : 0x00FCF7D0, 0x54, 0x88, 0x4CC, 0x34, 0x80;
	int scenequestionmark : 0x101AE50;
}

startup
{
	vars.line = "";
	vars.prevLine = "";
	vars.splitDelay = 0;
	vars.saveFile = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile) + @"\AppData\LocalLow\Studio Besus\Firewing 64\1Firewing64.sav";
	vars.saveExist = true;
	vars.previousSaveExist = true;
	vars.startRun = false;
	vars.resetRun = false;
	vars.ESplit = 0;
	vars.previousESplit = 0;
}

start
{
	if(vars.startRun == true)
	{	
		vars.ESplit = 0;
		return true;
	}
}

update
{
	vars.splitDelay = Math.Max(0, vars.splitDelay-1);
	vars.saveExist = File.Exists(vars.saveFile);
	if(vars.previousSaveExist == false && vars.saveExist == true)
	{
		vars.startRun = true;
	}
	else
	{
		vars.startRun = false;
	}
	
	if(vars.previousSaveExist == true && vars.saveExist == false)
	{
		vars.resetRun = true;
	}
	else
	{
		vars.resetRun = false;
	}
	
	if(vars.saveExist)
	{
		string lines = File.ReadAllText(vars.saveFile);
		vars.line = lines;
		if (vars.line != vars.prevLine)
		{
			vars.ESplit = 1;
			vars.splitDelay = 60;
		}
		if (vars.splitDelay == 0)
		{
			vars.ESplit = 0;
		}
		vars.prevLine = vars.line;
	}
	else
	{
		vars.line = "";
	}
	vars.previousSaveExist = vars.saveExist;
}

split
{
	if(vars.ESplit == 1 && vars.previousESplit == 0)
	{
		vars.previousESplit = vars.ESplit;
		return true;
	}
	if(current.scenequestionmark != old.scenequestionmark)
	{
		return true;
	}
	vars.previousESplit = vars.ESplit;
}

reset
{
	if(vars.resetRun)
	{
		vars.resetRun = false;
		return true;
	}
}