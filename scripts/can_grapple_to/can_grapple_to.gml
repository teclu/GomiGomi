// can_grappable_to(grappleFromX, grappleFromY, grappleToXCheck, grappleToYCheck);
var grappleFromX, grappleFromY, grappleToXCheck, grappleToYCheck;
grappleFromX = argument0;
grappleFromY = argument1;
grappleToXCheck = argument2;
grappleToYCheck = argument3;

// Add Grappable Objects to the List.
var grappable_objects_list = ds_list_create();
ds_list_add(grappable_objects_list, o_Wall);
ds_list_add(grappable_objects_list, o_Moving_Platform);

for (var i = 0; i < ds_list_size(grappable_objects_list); i++)
{
	var collision_object = collision_line(grappleFromX, grappleFromY, grappleToXCheck, grappleToYCheck, ds_list_find_value(grappable_objects_list, i), true, true);
	if (collision_object != noone)
	{
		collision_object.type = ds_list_find_value(grappable_objects_list, i);
		return collision_object;	
	}
}
return noone;