if (state == State.Swinging || state == State.Reeling)
{
	draw_line_width_color(grappleFromX, grappleFromY, grappleToX, grappleToY, 2, c_yellow, c_yellow);
	draw_circle_color(grappleToX, grappleToY, 5, c_red, c_red, false);
}

draw_self();
