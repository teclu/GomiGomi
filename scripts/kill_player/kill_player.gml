// kill_player();
var player = instance_find(o_Player, 0);
if (player.playerState != PlayerState.Dead)
{
	player.image_yscale = -1
	player.playerState = PlayerState.Dead;
	make_player_wait(60);
}