/// @description Enable Grapple for Player
var player = instance_find(o_Player_Get_Grapple, 0);
if (!player.isAllowedToGrapple)
{
	player.isAllowedToGrapple = true;
	audio_play_sound(snd_Obtain, 1, false);
	sprite_index = sp_Grapple_Giver_Without;
}