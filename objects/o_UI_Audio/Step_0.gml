switch (room)
{
	case r_Main_Menu:
	case r_Instructions:
	case r_Credits_1:
	case r_Credits_2:
	{
		if (audio_is_playing(snd_Leaving_Home))
		{
			audio_stop_sound(snd_Leaving_Home);	
		}
		if (audio_is_playing(snd_Almost_New))
		{
			audio_stop_sound(snd_Almost_New);	
		}
		if (audio_is_playing(snd_Grim_Idol))
		{
			audio_stop_sound(snd_Grim_Idol);	
		}
		if (!audio_is_playing(snd_Robobozo))
		{
			audio_play_sound(snd_Robobozo, 1, false);	
		}
		break;
	}
	case r_FBR_Lv_28:
	{
		if (audio_is_playing(snd_Robobozo))
		{
			audio_stop_sound(snd_Robobozo);	
		}
		if (audio_is_playing(snd_Leaving_Home))
		{
			audio_stop_sound(snd_Leaving_Home);	
		}
		if (audio_is_playing(snd_Almost_New))
		{
			audio_stop_sound(snd_Almost_New);	
		}
		if (!audio_is_playing(snd_Grim_Idol))
		{
			audio_play_sound(snd_Grim_Idol, 1, false);	
		}
		break;
	}
	case r_End:
	{
		if (audio_is_playing(snd_Robobozo))
		{
			audio_stop_sound(snd_Robobozo);	
		}
		if (audio_is_playing(snd_Leaving_Home))
		{
			audio_stop_sound(snd_Leaving_Home);	
		}
		if (audio_is_playing(snd_Grim_Idol))
		{
			audio_stop_sound(snd_Grim_Idol);	
		}
		
		if (!audio_is_playing(snd_Almost_New))
		{
			audio_play_sound(snd_Almost_New, 1, false);	
		}
		break;
	}
	default: // The rest of the levels should play only Leaving Home.
	{
		if (audio_is_playing(snd_Robobozo))
		{
			audio_stop_sound(snd_Robobozo);	
		}
		if (audio_is_playing(snd_Grim_Idol))
		{
			audio_stop_sound(snd_Grim_Idol);	
		}
		if (audio_is_playing(snd_Almost_New))
		{
			audio_stop_sound(snd_Almost_New);	
		}
		
		if (!audio_is_playing(snd_Leaving_Home))
		{
			audio_play_sound(snd_Leaving_Home, 1, false);	
		}
	}
}