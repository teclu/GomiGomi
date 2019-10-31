if (global.show_pause_menu)
{
	return;
}

draw_set_font(f_Consolas_Smaller);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var color = c_white;
draw_text_color(840,410,"Use 'A' and 'D' to swing yourself while grappled!", color, color, color, color, 256);
draw_text_color(840,442,"Hold onto the direction that you wish to swing towards", color, color, color, color, 256);
draw_text_color(840,474,"without letting go for more momentum!", color, color, color, color, 256)
