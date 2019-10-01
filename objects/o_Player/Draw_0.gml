// Rope Visuals
if (state == State.Swinging || state == State.Reeling || (state == State.Normal && ropeLength > ropeLengthThreshold))
{
	draw_line_width_color(x, y, grappleToX, grappleToY, 2, c_yellow, c_yellow);
	draw_circle_color(grappleToX, grappleToY, 5, c_red, c_red, false);
}
else if (state == State.Shooting)
{
	draw_line_width_color(x, y, grappleToXCheck, grappleToYCheck, 2, c_yellow, c_yellow);
	draw_circle_color(grappleToXCheck, grappleToYCheck, 5, c_red, c_red, false);
}
else if (state == State.Normal)
{
	draw_line_width_color(x, y, mouse_x, mouse_y, 1, c_red, c_red);
}

// Target Reticle
draw_circle_color(mouse_x, mouse_y, 5, c_red, c_red, true);

// Current Player Details (For Debugging)
var playerDetails = "";
switch (state)
{
	case State.Normal:
		playerDetails = "Normal (";
		if (!isGrounded) {
			playerDetails += "Air)"
		}
		else
		{
			playerDetails += "Grounded)"
		}
		break;
	case State.Shooting:
		playerDetails = "Shooting";
		break;
	case State.Swinging:
		playerDetails = "Swinging";
		break;
	case State.Reeling:
		playerDetails = "Reeling";
		break;
}
playerDetails += " " + string(coyoteTimeCounter);
draw_text(x + 35, y - 10, playerDetails);

draw_self();
