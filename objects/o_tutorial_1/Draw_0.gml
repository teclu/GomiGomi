if (global.show_pause_menu)
{
	return;
}

draw_set_font(f_Consolas_Smaller);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var color = c_white;
var text_displayed = "Use 'A' and 'D' to move\nleft or right!";
draw_text_color(x, y, text_displayed, color, color, color, color, 256);
