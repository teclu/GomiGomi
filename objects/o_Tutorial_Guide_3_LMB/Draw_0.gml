if (player.isAllowedToGrapple)
{
	var instructions = "Shoot Grapple";
	draw_set_font(f_Consolas_Debug);
	draw_set_color(c_yellow);
	draw_text(x, y + 56, instructions);
}
draw_self();