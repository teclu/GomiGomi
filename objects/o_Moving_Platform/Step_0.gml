/// @description Handle Horizontal and/or Vertical Movement

if (is_moving_horizontally)
{
	if (distanceCovered + movespeed <= distance)
	{
		distanceCovered += movespeed;
		x += movespeed * horizontal_direction;	
	}
	
	if (distanceCovered == distance)
	{
		distanceCovered = 0;
		horizontal_direction *= -1;
	}
}