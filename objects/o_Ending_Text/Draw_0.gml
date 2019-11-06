if (global.show_pause_menu)
{
	return;
}

draw_set_font(f_Consolas);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var color = c_white;
draw_text_color(640,160,"Thank you for", color, color, color, color, 256);
draw_text_color(640,192,"Playing the DEMO! :)", color, color, color, color, 256);