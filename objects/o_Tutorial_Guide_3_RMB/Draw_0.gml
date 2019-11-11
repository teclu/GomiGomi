if (player.isAllowedToGrapple)
{
	var instructions = "Release Grapple";
	draw_set_font(f_Consolas_Debug);
	draw_set_color(c_yellow);
	draw_text(x + 96, y + 56, instructions);
	
	draw_set_color(c_white);
	draw_text(x + 64, y, "OR");
}
draw_self();