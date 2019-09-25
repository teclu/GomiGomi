isGrounded = place_meeting(x, y + 1, o_Wall);

var key_left = keyboard_check(ord("A"));
var key_right = keyboard_check(ord("D"));
var key_up = keyboard_check(ord("W"));
var key_down = keyboard_check(ord("S"));
var key_jump = keyboard_check(vk_space);

var mouse_left = mouse_check_button_pressed(mb_left);
var mouse_right = mouse_check_button_pressed(mb_right);

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
			isGrounded = false;
			verticalSpeedFraction = 0.0;
			verticalSpeed = -jumpSpeed;
		}
		
		if (mouse_left)
		{
			grappleToX = mouse_x;
			grappleToY = mouse_y;
			grappleFromX = x;
			grappleFromY = y;
			state = State.Shooting;
		}
	}
	break;
	
	case State.Shooting:
	{
		// Only grapple if the closet object that is in-between or at the position we clicked is grappable to.
		var collision_objects = ds_list_create();
		var num_collision_objects = collision_line_list(grappleFromX, grappleFromY, grappleToX, grappleToY, o_Wall, true, true, collision_objects, true);
		if (num_collision_objects > 0)
		{
			grappleToX = collision_objects[| 0].x;
			grappleToY = collision_objects[| 0].y;
			ropeAngleVelocity = 0;			
			ropeAngle = point_direction(grappleToX, grappleToY, grappleFromX, grappleFromY);
			ropeLength = point_distance(grappleToX, grappleToY, grappleFromX, grappleFromY);
			state = State.Swinging;
		}
		else
		{
			state = State.Normal;
		}
	}
	break;
	
	case State.Swinging:
	{
		var ropeAngleAcceleration = -0.1 * dcos(ropeAngle);
		ropeAngleVelocity += (!isGrounded) ? ropeAngleAcceleration : 0;
		ropeAngle += ropeAngleVelocity;
		ropeAngleVelocity *= 0.99;
		grappleFromX = grappleToX + lengthdir_x(ropeLength, ropeAngle);
		grappleFromY = grappleToY + lengthdir_y(ropeLength, ropeAngle);
		horizontalSpeed = (!isGrounded) ? grappleFromX - x : 0;
		verticalSpeed = grappleFromY - y;
		
		if (mouse_right)
		{
			state = State.Reeling;
		}

		if (key_jump)
		{
			state = State.Normal;
			verticalSpeedFraction = 0;
			verticalSpeed = -jumpSpeed;
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
		grappleFromX = grappleToX + lengthdir_x(ropeLength, ropeAngle);
		grappleFromY = grappleToY + lengthdir_y(ropeLength, ropeAngle);
		grappleFromX += (grappleToX - grappleFromX) * 0.04;
		grappleFromY += (grappleToY - grappleFromY) * 0.04;
		horizontalSpeed = grappleFromX - x;
		verticalSpeed = grappleFromY - y;
		
		if (ropeLength <= 100)
		{
			grappleFromX = x;
			grappleFromY = y;
			ropeAngle = point_direction(grappleToX, grappleToY, grappleFromX, grappleFromY);
			ropeLength = point_distance(grappleToX, grappleToY, grappleFromX, grappleFromY);
			state = State.Swinging;
		}
		
		if (key_jump)
		{
			state = State.Normal;
			verticalSpeedFraction = 0;
			verticalSpeed = -jumpSpeed;
		}
	}
	break;
}

horizontalSpeed += horizontalSpeedFraction;
verticalSpeed += verticalSpeedFraction;
horizontalSpeedFraction = frac(horizontalSpeed);
verticalSpeedFraction = frac(verticalSpeed);
horizontalSpeed -= horizontalSpeedFraction;
verticalSpeed -= verticalSpeedFraction;

if (place_meeting(x + horizontalSpeed, y, o_Wall))
{
	var horizontalStep = sign(horizontalSpeed);
	horizontalSpeed = 0;
	horizontalSpeedFraction = 0.0;
	while (!place_meeting(x + horizontalStep, y, o_Wall))
	{
		x += horizontalStep;	
	}
	if (state == State.Swinging || state == State.Reeling)
	{
		ropeAngle = point_direction(grappleToX, grappleToY, x, y);
		ropeAngleVelocity = 0;
	}
}
x += horizontalSpeed;

if (place_meeting(x, y + verticalSpeed, o_Wall))
{
	var verticalStep = sign(verticalSpeed);
	verticalSpeed = 0;
	verticalSpeedFraction = 0.0;
	while (!place_meeting(x, y + verticalStep, o_Wall))
	{
		y += verticalStep;	
	}
	if (state == State.Swinging || state == State.Reeling)
	{
		ropeAngle = point_direction(grappleToX, grappleToY, x, y);
		ropeAngleVelocity = 0;
	}
}
y += verticalSpeed;
