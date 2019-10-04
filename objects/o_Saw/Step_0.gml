/// @description Handle Horizontal and/or Vertical Movement and Saw Rotation
image_angle += 5;

if (is_moving_horizontally)
{
	var toMoveX = movespeed * horizontal_direction;
	if (x + toMoveX >= startX && x + toMoveX <= endX)
	{
		x += toMoveX;
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

if (is_moving_vertically)
{
	var toMoveY = movespeed * vertical_direction;
	if (y + toMoveY <= startY && y + toMoveY >= endY)
	{
		y += toMoveY;
	}
	else
	{
		// Make sure that the platform remains in the same position.
		if (y > startY)
		{
			y = startY;	 
		}
		else if (y < endY)
		{
			y = endY;
		}
		vertical_direction *= -1;
	}
}