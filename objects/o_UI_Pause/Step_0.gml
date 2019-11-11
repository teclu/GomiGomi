if (global.show_pause_menu)
{
	visible = true;
	if (room == r_FBR_Lv_28)
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