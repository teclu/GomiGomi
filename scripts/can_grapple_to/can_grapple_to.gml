// can_grappable_to(grappleToXCheck, grappleToYCheck);
var grappleToXCheck, grappleToYCheck;
grappleToXCheck = argument0;
grappleToYCheck = argument1;

// Add Grappable Objects to the List.
var grappable_objects_list = ds_list_create();
ds_list_add(grappable_objects_list, o_Grappable_Thing_Left);
ds_list_add(grappable_objects_list, o_Grappable_Thing_Right);
ds_list_add(grappable_objects_list, o_Grappable_Thing_Ceiling);
ds_list_add(grappable_objects_list, o_Grappable_Thing_Ring);

for (var i = 0; i < ds_list_size(grappable_objects_list); i++)
{
	var collision_object = collision_point(grappleToXCheck, grappleToYCheck, ds_list_find_value(grappable_objects_list, i), true, true);
	if (collision_object != noone)
	{
		collision_object.type = ds_list_find_value(grappable_objects_list, i);
		return collision_object;	
	}
}
return noone;