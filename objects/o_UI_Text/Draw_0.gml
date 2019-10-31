if (small)
{
	draw_set_font(f_Consolas_Small);
}
else
{
	draw_set_font(f_Consolas);	
}
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var color = c_white;
draw_text_color(x, y, text_displayed, color, color, color, color, 256);
