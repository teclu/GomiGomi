/// @description Grapple Visuals

// Target Reticle
if (can_grapple_to(mouse_x, mouse_y))
{
	draw_circle_color(mouse_x, mouse_y, 8, c_lime, c_lime, false);
}
else if (!global.pause)
{
	draw_circle_color(mouse_x, mouse_y, 5, c_red, c_red, true);
}

// Draw the Player
draw_self();

// Handle Global Pause
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