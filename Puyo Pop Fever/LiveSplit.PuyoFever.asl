state("PuyoF", "1.05")
{
	int state : 0x1590E4;
	int menuTransition : 0x36D5A4;
	int split : 0x10D52C;
	int deathCheck : 0x01509AC, 0x67C, 0x3D8;
}
state("PuyoF", "2.0")
{
	int state : 0x144F24;
	int menuTransition : 0x79460C;
	int split : 0xF8F54;
}

startup
{
    vars.timerModel = new TimerModel { CurrentState = timer };
}

update
{
	
	if(current.deathCheck == 1 && current.deathCheck != old.deathCheck){
    vars.timerModel.UndoSplit();
}
}

init
{
	if (modules.First().ModuleMemorySize == 4578726) version = "1.05";
	if (modules.First().ModuleMemorySize == 11993088) version = "2.0";
}

start
{
	if(current.state == 1 && current.menuTransition != 0 && old.menuTransition == 0)
	{
		return true;
	}
}

split
{
	if(current.split == 1 && old.split == 0)
	{
		return true;
	}
}

reset
{
	if(current.menuTransition == 0 && old.menuTransition == 31 && old.state == 18)
	{
		return true;
	}
}
