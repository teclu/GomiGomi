// Player Keyboard and Mouse Inputs
var key_left = keyboard_check(ord("A"));
var key_right = keyboard_check(ord("D"));
var key_jump = keyboard_check(vk_space);
var mouse_left = mouse_check_button_pressed(mb_left);
// var key_up = keyboard_check(ord("W")); <-- Unused.
// var key_down = keyboard_check(ord("S")); <-- Unused.
// var mouse_right = mouse_check_button_pressed(mb_right); <-- Unused.

// Boolean Checks
isGrounded = place_meeting(x, y + 1, o_Wall);

// The Player Sprite Appearance
if (mouse_x > x || key_right)
{
	sprite_index = sp_Player_Right;	
}
else if (mouse_x < x || key_left)
{
	sprite_index = sp_Player_Left;	
}

// The Player State Machine
switch (state)
{
	// This is when the Player doing anything unrelated to grappling.
	case State.Normal:
	{
		// Visually reel back the line to the Player.
		ropeLength = point_distance(x, y, grappleToX, grappleToY);
		if (ropeLength > ropeLengthThreshold)
		{			
			grappleToXSpeed = 0;
			grappleToYSpeed = 0;
			while (sqrt(grappleToXSpeed * grappleToXSpeed + grappleToYSpeed * grappleToYSpeed) < grappleReelInSpeed)
			{
				grappleToXSpeed += (x - grappleToX) * 0.01;
				grappleToYSpeed += (y - grappleToY) * 0.01;
			}
			grappleToX += grappleToXSpeed;
			grappleToY += grappleToYSpeed;
		}
		else
		{
			grappleToX = x;
			grappleToY = y;
		}
		
		var moveDirection = key_right - key_left;
		horizontalSpeed += moveDirection * walkAcceleration;
		if (moveDirection == 0)
		{
			var horizontalFriction = horizontalFrictionGround;
			if (!isGrounded)
			{
				horizontalFriction = horizontalFrictionAir;	
			}
			horizontalSpeed = approach(horizontalSpeed, 0, horizontalFriction);
		}
		horizontalSpeed = clamp(horizontalSpeed, -walkSpeed, walkSpeed);
		verticalSpeed += gravityExperienced;
		
		if (key_jump && isGrounded)
		{
			verticalSpeedFraction = 0.0;
			verticalSpeed = -jumpSpeed;
		}
		
		if (mouse_left)
		{
			grappleToX = mouse_x;
			grappleToY = mouse_y;
			grappleFromX = x;
			grappleFromY = y;
			grappleToXCheck = grappleFromX;
			grappleToYCheck = grappleFromY;
			grappleToXSpeed = 0;
			grappleToYSpeed = 0;
			while (sqrt(grappleToXSpeed * grappleToXSpeed + grappleToYSpeed * grappleToYSpeed) < grappleShootOutSpeed)
			{
				grappleToXSpeed += (grappleToX - grappleToXCheck) * 0.01;
				grappleToYSpeed += (grappleToY - grappleToYCheck) * 0.01;
			}
			state = State.Shooting;
		}
	}
	break;
	
	case State.Shooting:
	{
		var horizontalFriction = horizontalFrictionGround;
		if (!isGrounded)
		{
			horizontalFriction = horizontalFrictionAir;	
		}
		horizontalSpeed = approach(horizontalSpeed, 0, horizontalFriction);
		verticalSpeed += gravityExperienced;
		grappleToXCheck += grappleToXSpeed;
		grappleToYCheck += grappleToYSpeed;
		
		// Only grapple if the closet object that is in-between or at the position we clicked is grappable to.
		var collision_object = collision_line(grappleFromX, grappleFromY, grappleToXCheck, grappleToYCheck, o_Wall, true, true);
		if (collision_object != noone)
		{
			// Grapple to the surface contact; handle any "overshooting".
			grappleToX = grappleToXCheck;
			grappleToY = grappleToYCheck;
			while (position_meeting(grappleToX, grappleToY, o_Wall))
			{
				grappleToX -= grappleToXSpeed * 0.01;
				grappleToY -= grappleToYSpeed * 0.01;
			}
			ropeAngleVelocity = 0;		
			state = State.Swinging;
		}
	}
	break;
	
	case State.Swinging:
	{
		// Allow horizontal movement while swinging.
		grappleFromX = x;
		grappleFromY = y;
		
		var moveDirection = key_right - key_left;
		var toMoveX = moveDirection * walkAcceleration;
		grappleFromX += (!place_meeting(x + toMoveX, y, o_Wall)) ? toMoveX : 0;
		ropeAngle = point_direction(grappleToX, grappleToY, grappleFromX, grappleFromY);
		ropeLength = point_distance(grappleToX, grappleToY, grappleFromX, grappleFromY);
		
		var ropeAngleAcceleration = -0.1 * dcos(ropeAngle);
		ropeAngleVelocity += (!isGrounded) ? ropeAngleAcceleration : 0;
		ropeAngle += ropeAngleVelocity;
		ropeAngleVelocity *= 0.99;
		grappleFromX = (!place_meeting(x + toMoveX, y, o_Wall)) ? grappleToX + lengthdir_x(ropeLength, ropeAngle) : x;
		grappleFromY = grappleToY + lengthdir_y(ropeLength, ropeAngle) - ((!isGrounded) ? 0.01 * dcos(ropeAngle) : 0);
		horizontalSpeed = grappleFromX - x;
		verticalSpeed = (y <= grappleToY) ? (verticalSpeed + gravityExperienced) : approach(verticalSpeed, grappleFromY - y, horizontalFrictionAir);
		
		if (mouse_left)
		{
			grappleToXSpeed = 0;
			grappleToYSpeed = 0;
			while (sqrt(grappleToXSpeed * grappleToXSpeed + grappleToYSpeed * grappleToYSpeed) < grappleReelToSpeed)
			{
				grappleToXSpeed += (grappleToX - grappleFromX) * 0.01;
				grappleToYSpeed += (grappleToY - grappleFromY) * 0.01;
			}
			state = State.Reeling;
			break;
		}

		if (key_jump)
		{
			verticalSpeedFraction = 0;
			verticalSpeed = (verticalSpeed - jumpSpeed) / 2;
			state = State.Normal;
			break;
		}
	}
	break;
	
	case State.Reeling:
	{
		var ropeAngleAcceleration = -0.1 * dcos(ropeAngle);
		ropeAngle = point_direction(grappleToX, grappleToY, grappleFromX, grappleFromY);
		ropeLength = point_distance(grappleToX, grappleToY, grappleFromX, grappleFromY);
		ropeAngleVelocity += ropeAngleAcceleration;
		ropeAngle += ropeAngleVelocity;
		ropeAngleVelocity *= 0.99;
		grappleFromX += grappleToXSpeed;
		grappleFromY += grappleToYSpeed;
		horizontalSpeed = (!place_meeting(x + sign(horizontalSpeed), y, o_Wall)) ? (grappleFromX - x) : 0;
		verticalSpeed = (!place_meeting(x, y + sign(verticalSpeed), o_Wall)) ? ((y < grappleToY) ? (verticalSpeed + gravityExperienced) : (grappleFromY - y)) : 0;
		
		if (ropeLength <= ropeLengthThreshold)
		{
			ropeAngleVelocity = 0;
			state = State.Swinging;
			break;
		}
		
		if (key_jump)
		{
			verticalSpeedFraction = 0;
			verticalSpeed = (verticalSpeed - jumpSpeed) / 2;
			state = State.Normal;
			break;
		}
	}
	break;
}

// Resolve and apply the speed of the Player.
horizontalSpeed += horizontalSpeedFraction;
verticalSpeed += verticalSpeedFraction;
horizontalSpeedFraction = frac(horizontalSpeed);
verticalSpeedFraction = frac(verticalSpeed);
horizontalSpeed -= horizontalSpeedFraction;
verticalSpeed -= verticalSpeedFraction;

if (place_meeting(x + horizontalSpeed, y, o_Wall))
{
	var horizontalStep = sign(horizontalSpeed);
	while (!place_meeting(x + horizontalStep, y, o_Wall))
	{
		x += horizontalStep;	
	}
	
	if (state == State.Swinging || state == State.Reeling)
	{
		ropeAngle = point_direction(grappleToX, grappleToY, x, y);
		ropeAngleVelocity = 0;
		
		// Phasing Prevention
		if (place_meeting(x + sign(horizontalSpeed), y, o_Wall) && abs(horizontalSpeed) > grappleReelInSpeed)
		{
			state = State.Swinging;
		}
	}
	horizontalSpeed = 0;
	horizontalSpeedFraction = 0.0;
}
x += horizontalSpeed;

if (place_meeting(x, y + verticalSpeed, o_Wall))
{
	var verticalStep = sign(verticalSpeed);
	while (!place_meeting(x, y + verticalStep, o_Wall))
	{
		y += verticalStep;	
	}
	
	if (state == State.Swinging || state == State.Reeling)
	{
		ropeAngle = point_direction(grappleToX, grappleToY, x, y);
		ropeAngleVelocity = 0;
		
		// Phasing Prevention
		if (place_meeting(x, y + sign(verticalSpeed), o_Wall) && abs(verticalSpeed) > grappleReelInSpeed)
		{
			state = State.Swinging;	
		}
	}
	verticalSpeed = 0;
	verticalSpeedFraction = 0.0;
}
y += verticalSpeed;
