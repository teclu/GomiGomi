var instructions = "Swing Left/Right while Grappled\n\nHold prior to releasing Grapple for extra momentum";
draw_set_font(f_Consolas_Debug);
draw_set_color(c_yellow);
draw_text(x + 64, y + 72, instructions);

draw_set_color(c_white);
draw_text(x + 48, y, "OR");

draw_self();