if (state == State.Swinging || state == State.Reeling)
{
	draw_line_width_color(grappleFromX, grappleFromY, grappleToX, grappleToY, 2, c_yellow, c_yellow);
	draw_circle_color(grappleToX, grappleToY, 5, c_red, c_red, false);
}
else if (state == State.Shooting)
{
	draw_line_width_color(x, y, grappleToXCheck, grappleToYCheck, 2, c_yellow, c_yellow);
	draw_circle_color(grappleToXCheck, grappleToYCheck, 5, c_red, c_red, false);
}
else if (state == State.Normal && ropeLength > ropeLengthThreshold)
{
	draw_line_width_color(x, y, grappleToX, grappleToY, 2, c_yellow, c_yellow);
	draw_circle_color(grappleToX, grappleToY, 5, c_red, c_red, false);	
}
else if (state == State.Normal)
{
	draw_line_width_color(x, y, mouse_x, mouse_y, 1, c_red, c_red);
}
draw_circle_color(mouse_x, mouse_y, 5, c_red, c_red, true);
draw_self();
