if (global.show_pause_menu)
{
	return;
}

draw_set_font(f_Consolas_Smaller);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var color = c_white;
var text_displayed = "Level 10";
draw_text_color(64, 32, text_displayed, color, color, color, color, 256);
