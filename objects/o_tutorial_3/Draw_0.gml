if (global.show_pause_menu)
{
	return;
}

draw_set_font(f_Consolas_Smaller);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var color = c_white;
draw_text_color(440,460,"Use your mouse to aim your grapple!", color, color, color, color, 256);
draw_text_color(440,492,"Use W to reel your grapple!", color, color, color, color, 256);
draw_text_color(440,524,"Hit 'Space' or the RMB to release the grapple!", color, color, color, color, 256)