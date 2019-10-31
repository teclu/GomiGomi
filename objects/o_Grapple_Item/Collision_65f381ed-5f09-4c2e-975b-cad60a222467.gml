/// @description Enable Grapple for Player
var player = instance_find(o_Player_Get_Grapple, 0);
player.isAllowedToGrapple = true;
instance_destroy(id);