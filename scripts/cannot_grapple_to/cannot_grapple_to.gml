// can_grappable_to(grappleToXCheck, grappleToYCheck);
var grappleToXCheck, grappleToYCheck;
grappleToXCheck = argument0;
grappleToYCheck = argument1;

// Add Grappable Objects to the List.
var grappable_objects_list = ds_list_create();
ds_list_add(grappable_objects_list, o_Wall);
ds_list_add(grappable_objects_list, o_On_Off_Blue_Wall);
ds_list_add(grappable_objects_list, o_On_Off_Red_Wall);
ds_list_add(grappable_objects_list, o_Saw);
ds_list_add(grappable_objects_list, o_Fragile);

for (var i = 0; i < ds_list_size(grappable_objects_list); i++)
{
	var collision_object = collision_point(grappleToXCheck, grappleToYCheck, ds_list_find_value(grappable_objects_list, i), true, true);
	if (collision_object != noone)
	{
		var object_type = ds_list_find_value(grappable_objects_list, i);
		if (object_type == o_On_Off_Blue_Wall || object_type == o_On_Off_Red_Wall)
		{
			return collision_object.is_switched_on;
		}
		return true;	
	}
}
return noone;