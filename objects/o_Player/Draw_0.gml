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

// Draw the Grapple Rope or the distance-reference line.
if (grappleState != GrappleState.Unused && playerState != PlayerState.Dead)
{
	draw_line_width_color(x, y, grappleToX, grappleToY, 4, c_silver, c_silver);
}
else if (!global.pause)
{
	// Green coloured line if cursor is within range, and red otherwise.
	var distance = max(1, point_distance(x, y, mouse_x, mouse_y));
	var lineWidth = abs(8 + (7.5 / (1 - grappleLengthMaximum * 1.125)) * distance);
	if (point_distance(x, y, mouse_x, mouse_y) <= grappleLengthMaximum * 1.125)
	{
		draw_line_width_color(x, y, mouse_x, mouse_y, lineWidth, c_lime, c_lime);
	}
	else
	{
		draw_line_width_color(x, y, mouse_x, mouse_y, 0.5, c_red, c_red);
	}
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

// Current Player Details (For Debugging)
if (false) // Change to enable/disable debugging messages.
{
	var playerDetails = "";
	switch (playerState)
	{
		case PlayerState.Normal:
			playerDetails = "Normal (";
			if (!isGrounded) {
				playerDetails += "Air)"
			}
			else
			{
				playerDetails += "Grounded)"
			}
			break;
		case PlayerState.Swinging:
			playerDetails = "Swinging (";
			if (!isGrounded) {
				playerDetails += "Air)"
			}
			else
			{
				playerDetails += "Grounded)"
			}
			break;
		case PlayerState.Reeling:
			playerDetails = "Reeling";
			break;
		case PlayerState.Dead:
			playerDetails = "Dead";
			break;
	}
	playerDetails += " " + string(coyoteTimeCounter);
	draw_text(x + 35, y - 10, playerDetails);
}