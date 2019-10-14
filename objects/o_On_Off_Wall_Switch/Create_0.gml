/// @description Initialise all On_Off_Walls and Switches if this is the Master Switch
if (is_master_switch)
{
	// Walls
	for (var i = 0; i < instance_number(o_On_Off_Wall); i++)
	{
		var instance = instance_find(o_On_Off_Wall, i);
		if (instance != noone)
		{
			instance.sprite_index = ((is_switched_on) ? sp_On_Wall : sp_Off_Wall);
			instance.is_switched_on = is_switched_on;
		}
	}

	// Switches
	for (var i = 0; i < instance_number(o_On_Off_Wall_Switch); i++)
	{
		var instance = instance_find(o_On_Off_Wall_Switch, i);
		if (instance != noone)
		{
			instance.sprite_index = ((is_switched_on) ? sp_On_Wall_Switch : sp_Off_Wall_Switch);
			instance.is_switched_on = is_switched_on;
		}
	}
}