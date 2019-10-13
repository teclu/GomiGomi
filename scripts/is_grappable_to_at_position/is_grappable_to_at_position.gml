// is_grappable_to_at_position(pos_x, pos_y);
var pos_x, pos_y;
pos_x = argument0;
pos_y = argument1;

// Add Grappable Objects to the List.
var grappable_objects_list = ds_list_create();
ds_list_add(grappable_objects_list, o_Wall);

for (var i = 0; i < ds_list_size(grappable_objects_list); i++)
{
	if (position_meeting(pos_x, pos_y, ds_list_find_value(grappable_objects_list, i)))
	{
		return true;	
	}
}

return false;