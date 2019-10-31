/// @description Rising Movement
if (global.pause)
{
	exit;	
}

image_yscale += risingSpeed / room_speed;
y -= risingSpeed;
topPool.x = x;
topPool.y = y;

if (place_meeting(x, y - 1, o_Player))
{
	kill_player();	
}