if (global.show_pause_menu)
{
	visible = true;
	if (room == r_FBRv2_Level_1_MINUS2)
	{
		y = camera_get_view_y(view_camera[0]) + initial_y;
	}
	else
	{
		y = initial_y;	
	}
}
else
{
	visible = false;
}