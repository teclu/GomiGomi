// make_player_wait(ticksDuration);
var ticksDuration;
ticksDuration = argument0;
var player = instance_find(o_Player, 0);
show_debug_message(player);
player.waitDuration = ticksDuration;