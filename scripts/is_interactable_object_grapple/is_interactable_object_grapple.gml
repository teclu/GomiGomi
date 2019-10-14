// is_interactable_object_grapple(grappleToXCheck, grappleToYCheck);
var grappleToXCheck, grappleToYCheck;
grappleToXCheck = argument0;
grappleToYCheck = argument1;

// Add interactable Objects to the List.
var interactable_objects_list = ds_list_create();
ds_list_add(interactable_objects_list, o_On_Off_Wall_Switch);

for (var i = 0; i < ds_list_size(interactable_objects_list); i++)
{
	var object_type = ds_list_find_value(interactable_objects_list, i);
	var collision_object = collision_point(grappleToXCheck, grappleToYCheck, object_type, true, true);
	if (collision_object != noone)
	{
		collision_object.type = object_type;
		switch (collision_object.type)
		{
			case o_On_Off_Wall_Switch:
			{
				// Find all the On_Off_Walls and Toggle them.
				collision_object.is_switched_on = !collision_object.is_switched_on;
				collision_object.sprite_index = ((collision_object.is_switched_on) ? sp_On_Wall_Switch : sp_Off_Wall_Switch);
				for (var j = 0; j < instance_number(o_On_Off_Wall); j++)
				{
					var instance = instance_find(o_On_Off_Wall, j);
					if (instance != noone)
					{
						instance.is_switched_on = collision_object.is_switched_on;
						instance.sprite_index = ((collision_object.is_switched_on) ? sp_On_Wall : sp_Off_Wall);
					}
				}
				
				// Find all the On_Off_Walls_Switches and Toggle them.
				for (var i = 0; i < instance_number(o_On_Off_Wall_Switch); i++)
				{
					var instance = instance_find(o_On_Off_Wall_Switch, i);
					if (instance != noone)
					{
						instance.sprite_index = ((collision_object.is_switched_on) ? sp_On_Wall_Switch : sp_Off_Wall_Switch);
						instance.is_switched_on = collision_object.is_switched_on;
					}
				}
			}
			break;
		}
		return true;
	}
}
return false;