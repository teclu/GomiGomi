if (global.pause)
{
	exit;	
}

if (time_to_move <= 0)
{
	vertical_speed += gravity_experienced;
	y += vertical_speed;	
}

if (y >= 768)
{
	room_goto_next();
}