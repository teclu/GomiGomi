/// @description Handle Horizontal and/or Vertical Movement

if (global.pause)
{
	exit;	
}

if (is_moving_horizontally)
{
	var toMove = movespeed * horizontal_direction;
	if ((starting_direction > 0 && x + toMove >= startX && x + toMove <= endX) ||
		(starting_direction < 0 && x + toMove <= startX && x + toMove >= endX))
	{
		x += toMove;
		image_xscale = (toMove > 0) ? 1 : -1;
	}
	else
	{
		// Make sure that the platform remains in the same position.
		if ((starting_direction > 0 && x < startX) || (starting_direction < 0 && x > startX))
		{
			x = startX;	 
		}
		else if ((starting_direction > 0 && x > endX) || (starting_direction < 0 && x < endX))
		{
			x = endX;
		}
		horizontal_direction *= -1;
	}
}