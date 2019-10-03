/// @description Player State and Controls

// Player Keyboard and Mouse Inputs
var key_up = keyboard_check(ord("W"));
var key_left = keyboard_check(ord("A"));
var key_right = keyboard_check(ord("D"));
var key_space = keyboard_check(vk_space);
// var key_down = keyboard_check(ord("S")); <-- Unused.
var mouse_left = mouse_check_button_pressed(mb_left);
var mouse_right = mouse_check_button_pressed(mb_right);

// Boolean Checks
isGrounded = is_solid_object_at_position(x, y + 1);

// The Player State Machine
switch (state)
{
	// This is when the Player doing anything unrelated to grappling.
	case State.Normal:
	{
		// Coyote Time for Jumping
		if (!isGrounded && coyoteTimeCounter > 0)
		{
			coyoteTimeCounter--;
		}
		else if (isGrounded && coyoteTimeCounter < coyoteTimeDuration)
		{
			coyoteTimeCounter = coyoteTimeDuration;	
		}
		
		// Visually reel back the line to the Player.
		ropeLength = point_distance(x, y, grappleToX, grappleToY);
		if (ropeLength > ropeLengthMinimum)
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
		
		// Determine the Horizontal and Vertical speeds.
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
		
		// If the player is not grounded, apply gravity.
		if (!isGrounded)
		{
			verticalSpeed += gravityExperienced;
		}
		else
		{
			verticalSpeed = 0;
		}
		
		// If the player is grounded or there is Coyote Time remaining, perform the jump.
		if (key_space && (isGrounded || coyoteTimeCounter > 0))
		{
			coyoteTimeCounter = 0;
			verticalSpeedFraction = 0.0;
			verticalSpeed = -jumpSpeed;
		}
		
		// Attempt to shoot the Grapple.
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
			
			// Smoothing of the grappling speed so that it looks visually consistent.
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
		// Determine the Horizontal and Vertical speeds. In this case, the Player is not allowed to move anymore.
		var horizontalFriction = horizontalFrictionGround;
		if (!isGrounded)
		{
			horizontalFriction = horizontalFrictionAir;	
			verticalSpeed += gravityExperienced;
		}
		else
		{
			verticalSpeed = 0;	
		}
		horizontalSpeed = approach(horizontalSpeed, 0, horizontalFriction);
		
		// Increment the grapple-to check; this can be visually seen.
		grappleToXCheck += grappleToXSpeed;
		grappleToYCheck += (grappleToYSpeed + ((!isGrounded) ? verticalSpeed : 0));
		
		// If the rope is going beyond its maximum distance, then stop the shooting and go back to the Normal State. Else, proceed with the grappling. 
		if (point_distance(grappleToXCheck, grappleToYCheck, x, y) > ropeLengthMaximum)
		{
			grappleToX = grappleToXCheck;
			grappleToY = grappleToYCheck;
			coyoteTimeCounter = 0;
			state = State.Normal;
			break;
		}
		
		// Only grapple if the closet object that is in-between or at the position we clicked is grappable to.
		var objectGrappledCheck = can_grapple_to(grappleToXCheck, grappleToYCheck);
		if (objectGrappledCheck != noone)
		{		
			// Grapple to the surface contact; handle any "overshooting".
			objectGrappled = objectGrappledCheck;
			grappleToX = grappleToXCheck;
			grappleToY = grappleToYCheck;
			
			// This while-loop makes sure that the contact point appears on the surface of the object.
			while (position_meeting(grappleToX, grappleToY, objectGrappled))
			{
				grappleToX -= grappleToXSpeed * 0.01;
				grappleToY -= grappleToYSpeed * 0.01;
			}
			ropeAngleVelocity = 0;
			ropeLengthStart = point_distance(grappleToX, grappleToY, grappleFromX, grappleFromY);
			state = State.Swinging;
		}
	}
	break;
	
	case State.Swinging:
	{	
		grappleFromX = x;
		grappleFromY = y;
		
		// If the player is grappled to the moving platform, make sure that the grapple moves as well; this indirectly moves the player.
		if (objectGrappled.type == o_Moving_Platform)
		{
			grappleToX += objectGrappled.horizontal_direction * objectGrappled.movespeed;
		}
		
		// Allow horizontal movement while swinging.
		var moveDirection = key_right - key_left;
		var toMoveX = moveDirection * walkAcceleration;
		grappleFromX += (!is_solid_object_at_position(x + toMoveX, y)) ? toMoveX : 0;
		ropeAngle = point_direction(grappleToX, grappleToY, grappleFromX, grappleFromY);
		ropeLength = (point_distance(grappleToX, grappleToY, grappleFromX, grappleFromY) < ropeLengthStart) ? point_distance(grappleToX, grappleToY, grappleFromX, grappleFromY) : ropeLengthStart;
		
		// Determine the Horizontal and Vertical speeds based on the grapple swinging.
		var ropeAngleAcceleration = -0.1 * dcos(ropeAngle);
		ropeAngleVelocity += (!isGrounded) ? ropeAngleAcceleration : 0;
		ropeAngle += ropeAngleVelocity;
		ropeAngleVelocity *= 0.99;
		grappleFromX = (!is_solid_object_at_position(x + toMoveX, y)) ? grappleToX + lengthdir_x(ropeLength, ropeAngle) : x;
		grappleFromY = grappleToY + lengthdir_y(ropeLength, ropeAngle);
		horizontalSpeed = grappleFromX - x;
		verticalSpeed = (y < grappleToY) ? verticalSpeed + gravityExperienced : approach(verticalSpeed, 0.125 * (grappleFromY - y), horizontalFrictionAir);
		
		// Reel towards the Grapple.
		if (key_up && ropeLength > ropeLengthMinimum)
		{
			grappleToXSpeed = 0;
			grappleToYSpeed = 0;
			
			// Make the grapple-to speed approximately equal or greater to our defined speed limit.
			var grappleToSpeed = sqrt(grappleToXSpeed * grappleToXSpeed + grappleToYSpeed * grappleToYSpeed);
			while (grappleToSpeed < grappleReelToSpeed)
			{
				grappleToXSpeed += (grappleToX - grappleFromX) * 0.01;
				grappleToYSpeed += (grappleToY - grappleFromY) * 0.01;
				grappleToSpeed = sqrt(grappleToXSpeed * grappleToXSpeed + grappleToYSpeed * grappleToYSpeed);
			}
			state = State.Reeling;
			break;
		}
		
		// Release the Grapple.
		if (mouse_right)
		{
			objectGrappled = noone;
			verticalSpeedFraction = 0;
			verticalSpeed = (verticalSpeed - jumpSpeed) / 2;
			coyoteTimeCounter = 0;
			state = State.Normal;
		}
	}
	break;
	
	case State.Reeling:
	{
			// If the player is grappled to the moving platform, make sure that the grapple moves as well; this indirectly moves the player.
		if (objectGrappled.type == o_Moving_Platform)
		{
			grappleToX += objectGrappled.horizontal_direction * objectGrappled.movespeed;
		}
		
		// Determine the Horizontal and Vertical speeds based on the grapple reeling.
		var ropeAngleAcceleration = -0.1 * dcos(ropeAngle);
		ropeAngle = point_direction(grappleToX, grappleToY, grappleFromX, grappleFromY);
		ropeLength = point_distance(grappleToX, grappleToY, grappleFromX, grappleFromY);
		ropeAngleVelocity += ropeAngleAcceleration;
		ropeAngle += ropeAngleVelocity;
		ropeAngleVelocity *= 0.99;
		grappleFromX += grappleToXSpeed;
		grappleFromY += grappleToYSpeed;
		horizontalSpeed = (!is_solid_object_at_position(x + sign(horizontalSpeed), y)) ? (grappleFromX - x) : 0;
		verticalSpeed = (!is_solid_object_at_position(x, y + sign(verticalSpeed))) ? ((y < grappleToY) ? (verticalSpeed + gravityExperienced) : 0.125 * (grappleFromY - y)) : 0;
		
		// Start slowing down the reel-to speed when the rope is shorter than the threshold. This also makes it feel smoother rather than abrupt.
		var grappleToSpeed = sqrt(grappleToXSpeed * grappleToXSpeed + grappleToYSpeed * grappleToYSpeed);
		if (ropeLength <= ropeLengthThreshold && grappleToSpeed > 4.0)
		{
			grappleToXSpeed -= grappleToXSpeed * 0.25;
			grappleToYSpeed -= grappleToYSpeed * 0.25;
		}
		
		// If we have reeled in sufficiently, stop and go back to the swinging state.
		if (ropeLength <= ropeLengthMinimum)
		{
			ropeLength = ropeLengthMinimum;
			ropeLengthStart = point_distance(grappleToX, grappleToY, grappleFromX, grappleFromY);
			ropeAngleVelocity = 0;
			state = State.Swinging;
			break;
		}
		
		// Release the Grapple.
		if (mouse_right)
		{
			objectGrappled = noone;
			verticalSpeedFraction = 0;
			verticalSpeed = (verticalSpeed - jumpSpeed) / 2;
			coyoteTimeCounter = 0;
			state = State.Normal;
		}
	}
	break;
	
	case State.Dead:
	{
		var key_r = keyboard_check(ord("R"));		
		if (key_r)
		{
			room_restart();
		}
		return;	
	}
}

// The Player Sprite Appearance, which is currently mouse or key press dependent.
if (mouse_x > x || key_right)
{
	sprite_index = sp_Player_Right;	
}
else if (mouse_x < x || key_left)
{
	sprite_index = sp_Player_Left;	
}

// Finally, resolve and apply the "true" speed of the Player.
horizontalSpeed += horizontalSpeedFraction;
verticalSpeed += verticalSpeedFraction;
horizontalSpeedFraction = frac(horizontalSpeed);
verticalSpeedFraction = frac(verticalSpeed);
horizontalSpeed -= horizontalSpeedFraction;
verticalSpeed -= verticalSpeedFraction;

// If we encounter any walls while moving horizontally, stop translation in that direction.
if (is_solid_object_at_position(x + horizontalSpeed, y))
{
	var horizontalStep = sign(horizontalSpeed);
	while (!is_solid_object_at_position(x + horizontalStep, y))
	{		
		x += horizontalStep;
	}
	
	// If we happen to be grappling, ensure that the rope variables are reset.
	if (state == State.Swinging || state == State.Reeling)
	{
		ropeAngle = point_direction(grappleToX, grappleToY, x, y);
		ropeAngleVelocity = 0;
		
		// Prevent phasing through walls and make the player go back to swinging state.
		if (is_solid_object_at_position(x + sign(horizontalSpeed), y) && abs(horizontalSpeed) > grappleReelInSpeed)
		{
			state = State.Swinging;
		}
	}
	horizontalSpeed = 0;
	horizontalSpeedFraction = 0.0;
}
x += horizontalSpeed;

// If player is standing on a moving platform or colliding from below, add the Moving Platform's speed.
var movingPlatformStanding = collision_line(x, y, x, y + 32, o_Moving_Platform, false, true);
if (movingPlatformStanding != noone)
{
	x += movingPlatformStanding.horizontal_direction * movingPlatformStanding.movespeed;
}

// If we encounter any walls while moving vertically, stop translation in that direction.
if (is_solid_object_at_position(x, y + verticalSpeed))
{
	var verticalStep = sign(verticalSpeed);
	while (!is_solid_object_at_position(x, y + verticalStep))
	{
		y += verticalStep;	
	}
	
	// If we happen to be grappling, ensure that the rope variables are reset.
	if (state == State.Swinging || state == State.Reeling)
	{
		ropeAngle = point_direction(grappleToX, grappleToY, x, y);
		ropeAngleVelocity = 0;
		
		// Prevent phasing through walls and make the player go back to swinging state.
		if (is_solid_object_at_position(x, y + sign(verticalSpeed)) && abs(verticalSpeed) > grappleReelInSpeed)
		{
			state = State.Swinging;	
		}
	}
	verticalSpeed = 0;
	verticalSpeedFraction = 0.0;
}
y += verticalSpeed;
