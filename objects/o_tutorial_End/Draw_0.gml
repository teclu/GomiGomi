if (global.show_pause_menu)
{
	return;
}

draw_set_font(f_Consolas_Smaller);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var color = c_white;
draw_text_color(640,160,"You're good to go!", color, color, color, color, 256);
draw_text_color(640,192,"Have fun and good luck!", color, color, color, color, 256);