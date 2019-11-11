if (global.pause)
{
	if (image_speed_temp == -1)
	{
		image_speed_temp = image_speed;
	}
	image_speed = 0;
	exit;	
}


if (image_speed_temp != -1)
{
	image_speed = image_speed_temp;
	image_speed_temp = -1;
}

if (x < 640) 
{
	x += horizontalWalkSpeed;
	return;
}

sprite_index = sp_Gomi_Smile;