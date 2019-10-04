/// @description Handle Horizontal and/or Vertical Movement

if (is_moving_horizontally)
{
	var toMove = movespeed * horizontal_direction;
	if (x + toMove >= startX && x + toMove <= endX)
	{
		x += toMove;
	}
	else
	{
		// Make sure that the platform remains in the same position.
		if (x < startX)
		{
			x = startX;	 
		}
		else if (x > endX)
		{
			x = endX;
		}
		horizontal_direction *= -1;
	}
}