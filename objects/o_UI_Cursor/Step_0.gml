// While in-game and toggling menu.
var key_escape = keyboard_check_pressed(vk_escape);
if (game_started)
{
	// Toggles the Pause Menu and freezes Gameplay.
	if (key_escape)
	{
		image_xscale = (global.pause) ? 0.0 : 0.5;
		global.pause = !global.pause;
		global.show_pause_menu = !global.show_pause_menu;
	}
	
	// For Developer Purposes; Restart Room.
	var key_r = keyboard_check_pressed(ord("R"));
	if (key_r)
	{
		global.pause = false;
		global.show_pause_menu = false;
		room_restart();	
		return;
	}
	
	// For Developer Purposes; Skip Rooms
	var key_pageup = keyboard_check_pressed(vk_pageup);
	if (key_pageup)
	{
		room_persistent = false;
		room_goto_next();	
	}
	
	var key_pagedown = keyboard_check_pressed(vk_pagedown);
	if (key_pagedown && room != r_Tutorial_Level_1_E)
	{
		room_persistent = false;
		room_goto_previous();	
	}
}

// Mouse Cursor Tracking
x = mouse_x;
y = mouse_y;

var option = noone;
if (global.show_pause_menu)
{
	option = instance_place(x, y, o_UI_Pause_Button);
}
else
{
	option = instance_place(x, y, o_UI_Button);	
}

var text = "";
if (option != noone)
{
	text = option.button_name;
	if (!menu_sound_played)
	{
		audio_play_sound(snd_Main_Menu_Move, 1, false);
		menu_sound_played = true;
	}
}
else
{
	menu_sound_played = false;
	return;	
}

// Handle Mouse Left Click
var mouse_left = mouse_check_button_pressed(mb_left);
if (mouse_left)
{
	switch (text)
	{
		case "Start Game":
		{
			audio_play_sound(snd_Main_Menu_Select, 1, false);
			room = r_Prologue_1;
			game_started = true;
			image_xscale = 0;
		}
		break;
		
		case "Main Menu":
		{
			audio_play_sound(snd_Main_Menu_Select, 1, false);
			global.pause = false;
			global.show_pause_menu = false;
			room_persistent = false;
			game_started = false;
			previous_room = room;
			room = r_Main_Menu;
		}
		break;
		
		case "Instructions":
		{
			audio_play_sound(snd_Main_Menu_Select, 1, false);
			if (global.pause)
			{
				global.show_pause_menu = false;
				game_started = false;
				room_persistent = true;
			}
			previous_room = room;
			room = r_Instructions;
		}
		break;
	
		case "Credits":
		{
			audio_play_sound(snd_Main_Menu_Select, 1, false);
			previous_room = room;
			room = r_Credits;
		}
		break;
		
		case "Back":
		{	
			audio_play_sound(snd_Main_Menu_Select, 1, false);
			var previous_room_temp = room;
			room = previous_room;
			previous_room = previous_room_temp;
			
			if (global.pause)
			{
				global.show_pause_menu = true;
				game_started = true;
			}
		}
		break;
	
		case "Quit":
		{
			audio_play_sound(snd_Main_Menu_Select, 1, false);
			game_end();
		}
		break;
	}
}