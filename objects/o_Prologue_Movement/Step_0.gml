if (global.pause)
{
	exit;	
}

if (time_to_move > 0)
{
	x += speed_to_move;
	time_to_move -= 1;
}