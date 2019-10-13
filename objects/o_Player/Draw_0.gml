/// @description Draw Grapple Visuals

// Target Reticle
draw_circle_color(mouse_x, mouse_y, 5, c_red, c_red, true);

if (grappleState != GrappleState.Unused)
{
	draw_line_width_color(x, y, grappleToX, grappleToY, 2, c_yellow, c_yellow);
	draw_circle_color(grappleToX, grappleToY, 5, c_red, c_red, false);	
}

draw_self();
