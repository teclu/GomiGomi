switch (room)
{
	case r_Main_Menu:
	case r_Instructions:
	case r_Credits_1:
	case r_Credits_2:
	{
		if (!audio_is_playing(snd_Main_Menu_BGM))
		{
			audio_play_sound(snd_Main_Menu_BGM, 1, false);	
		}
		break;
	}
	default:
	{
		if (audio_is_playing(snd_Main_Menu_BGM))
		{
			audio_stop_sound(snd_Main_Menu_BGM);	
		}
		if (!audio_is_playing(snd_Area_1))
		{
			audio_play_sound(snd_Area_1, 1, false);	
		}
	}
}