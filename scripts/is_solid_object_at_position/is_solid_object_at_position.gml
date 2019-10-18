// is_solid_object_at_position(pos_x, pos_y);
var pos_x, pos_y;
pos_x = argument0;
pos_y = argument1;

// Add Solid Objects to the List.
var solid_objects_list = ds_list_create();
ds_list_add(solid_objects_list, o_Wall);
ds_list_add(solid_objects_list, o_On_Off_Blue_Wall);
ds_list_add(solid_objects_list, o_On_Off_Red_Wall);
ds_list_add(solid_objects_list, o_Moving_Platform);

for (var i = 0; i < ds_list_size(solid_objects_list); i++)
{
	var object_type = ds_list_find_value(solid_objects_list, i);
	if (place_meeting(pos_x, pos_y, object_type))
	{
		if (object_type == o_On_Off_Blue_Wall || object_type == o_On_Off_Red_Wall)
		{
			if (place_meeting(pos_x, pos_y, o_On_Off_Blue_Wall) && place_meeting(pos_x, pos_y, o_On_Off_Red_Wall))
			{
				var instance_blue = instance_place(pos_x, pos_y, o_On_Off_Blue_Wall);
				var instance_red = instance_place(pos_x, pos_y, o_On_Off_Red_Wall);
				return (instance_blue.is_switched_on || instance_red.is_switched_on);
			}
			var instance = instance_place(pos_x, pos_y, object_type);
			return (instance.is_switched_on);
		}
		return true;
	}
}

return false;