if (hasGrappledOnce)
{
	var instructions = "Release Grapple with a Small Jump";
	draw_set_font(f_Consolas_Debug);
	draw_set_color(c_yellow);
	draw_text(x, y + 64, instructions);
}
draw_self();