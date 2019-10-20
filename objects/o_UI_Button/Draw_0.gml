draw_set_font(f_Consolas);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var color = c_white;
if (place_meeting(x, y, o_UI_Cursor))
{
	color = c_yellow;
}
draw_text_color(x, y, button_name, color, color, color, color, 256);