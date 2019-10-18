// is_interactable_object_grapple(grappleToXCheck, grappleToYCheck);
var grappleToXCheck, grappleToYCheck;
grappleToXCheck = argument0;
grappleToYCheck = argument1;

// Add interactable Objects to the List.
var interactable_objects_list = ds_list_create();
ds_list_add(interactable_objects_list, o_Blue_Red_Wall_Switch);

for (var i = 0; i < ds_list_size(interactable_objects_list); i++)
{
	var object_type = ds_list_find_value(interactable_objects_list, i);
	var collision_object = collision_point(grappleToXCheck, grappleToYCheck, object_type, true, true);
	
	if (collision_object != noone)
	{
		switch (object_type)
		{
			case o_Blue_Red_Wall_Switch:
			{
				// Find all the Blue_Red_Wall_Switches and Toggle them.
				for (var j = 0; j < instance_number(o_Blue_Red_Wall_Switch); j++)
				{
					var instance = instance_find(o_Blue_Red_Wall_Switch, j);
					instance.toggle = !instance.toggle;
					instance.sprite_index = ((instance.toggle) ? sp_Blue_Wall_Switch : sp_Red_Wall_Switch);
				}
			
				// Find all the On_Off_Blue_Walls and Toggle them.
				for (var j = 0; j < instance_number(o_On_Off_Blue_Wall); j++)
				{
					var instance = instance_find(o_On_Off_Blue_Wall, j);
					if (instance != noone)
					{
						instance.is_switched_on = !instance.is_switched_on;
						instance.sprite_index = ((instance.is_switched_on) ? sp_On_Blue_Wall : sp_Off_Blue_Wall);
					}
				}
				
				// Find all the On_Off_Red_Walls and Toggle them.
				for (var j = 0; j < instance_number(o_On_Off_Red_Wall); j++)
				{
					var instance = instance_find(o_On_Off_Red_Wall, j);
					if (instance != noone)
					{
						instance.is_switched_on = !instance.is_switched_on;
						instance.sprite_index = ((instance.is_switched_on) ? sp_On_Red_Wall : sp_Off_Red_Wall);
					}
				}
			}
			break;
		}
		return true;
	}
}
return false;