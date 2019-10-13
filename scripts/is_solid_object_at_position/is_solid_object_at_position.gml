// is_solid_object_at_position(pos_x, pos_y);
var pos_x, pos_y;
pos_x = argument0;
pos_y = argument1;

// Add Solid Objects to the List.
var solid_objects_list = ds_list_create();
ds_list_add(solid_objects_list, o_Wall);
ds_list_add(solid_objects_list, o_Moving_Platform);

for (var i = 0; i < ds_list_size(solid_objects_list); i++)
{
	if (place_meeting(pos_x, pos_y, ds_list_find_value(solid_objects_list, i)))
	{
		return true;	
	}
}

return false;