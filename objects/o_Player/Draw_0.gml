/// @description Grapple Visuals

// Target Reticle
if (can_grapple_to(mouse_x, mouse_y))
{
	draw_circle_color(mouse_x, mouse_y, 8, c_lime, c_lime, false);
}
else
{
	draw_circle_color(mouse_x, mouse_y, 5, c_red, c_red, true);
}

if (grappleState != GrappleState.Unused && playerState != PlayerState.Dead)
{
	draw_line_width_color(x, y, grappleToX, grappleToY, 4, c_yellow, c_yellow);
	draw_circle_color(grappleToX, grappleToY, 6, c_red, c_red, false);	
}
else
{
	// Green coloured line if cursor is within range, and red otherwise.
	if (point_distance(x, y, mouse_x, mouse_y) <= grappleLengthMaximum * 1.125)
	{
		draw_line_width_color(x, y, mouse_x, mouse_y, 4, c_lime, c_lime);
	}
	else
	{
		draw_line_width_color(x, y, mouse_x, mouse_y, 1, c_red, c_red);
	}
}

// Current Player Details (For Debugging)
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

// Draw the Player
draw_self();
