/// @description Player State and Controls

// Player Keyboard and Mouse Inputs
var key_up = keyboard_check(ord("W"));
var key_left = keyboard_check(ord("A"));
var key_right = keyboard_check(ord("D"));
var key_space = keyboard_check(vk_space);
//var key_down = keyboard_check(ord("S"));
var mouse_left = mouse_check_button_pressed(mb_left);
var mouse_right = mouse_check_button_pressed(mb_right);

// Boolean Checks
isGrounded = is_solid_object_at_position(x, y + 1);

// The Player State Machine
switch (playerState)
{
	case PlayerState.Normal:
	{
		// Resolve Horizontal and Vertical Translation
		var moveDirection = key_right - key_left;
		horizontalSpeed += moveDirection * horizontalWalkAcceleration;
		
		// If the player is not grounded, apply gravity.
		if (!isGrounded)
		{
			if (moveDirection == 0)
			{
				horizontalSpeed = approach(horizontalSpeed, 0, horizontalAirFriction);
			}
			horizontalSpeed = clamp(horizontalSpeed, -1.5 * horizontalWalkSpeedMaximum, 1.5 * horizontalWalkSpeedMaximum);
			verticalSpeed += gravityExperienced;
			
			// Decrement the Coyote Time Counter.
			if (coyoteTimeCounter > 0)
			{
				coyoteTimeCounter--;	
			}
		}
		// Else the player is grounded, so don't apply gravity.
		else
		{
			if (moveDirection == 0)
			{
				horizontalSpeed = approach(horizontalSpeed, 0, horizontalWalkFriction);
			}
			horizontalSpeed = clamp(horizontalSpeed, -horizontalWalkSpeedMaximum, horizontalWalkSpeedMaximum);
			verticalSpeed = 0.0;
			
			// Reset the Coyote Time Counter when Grounded.
			if (coyoteTimeCounter < coyoteTimeDuration)
			{
				coyoteTimeCounter = coyoteTimeDuration;	
			}
		}
		
		// If the player is grounded or there is Coyote Time remaining, perform the jump.
		if (key_space && (isGrounded || coyoteTimeCounter > 0))
		{
			verticalSpeed = verticalInitialJumpSpeed;
			coyoteTimeCounter = 0;
		}
		
		// If the player presses the left mouse button and the grapple is unused, shoot the grapple.
		if (grappleState == GrappleState.Unused && mouse_left)
		{
			// Calculate the Direction Unit Vector.
			grappleToMouseX = mouse_x;
			grappleToMouseY = mouse_y;
			grappleToXDirection = grappleToMouseX - x;
			grappleToYDirection = grappleToMouseY - y;
			grappleToDirectionMagnitude = sqrt(grappleToXDirection * grappleToXDirection + grappleToYDirection * grappleToYDirection);
			grappleToXDirection *= grappleShotSpeedFactor / grappleToDirectionMagnitude;
			grappleToYDirection *= grappleShotSpeedFactor / grappleToDirectionMagnitude;
			
			// Initialise the grapple starting position.
			grappleToX = x;
			grappleToY = y;
			grappleState = GrappleState.Projecting;
		}
		
		// Handle the grapple translation and collision if any.
		if (grappleState == GrappleState.Projecting)
		{
			// Calculate the Direction Unit Vector.
			grappleToXDirection = grappleToMouseX - x;
			grappleToYDirection = grappleToMouseY - y;
			grappleToDirectionMagnitude = sqrt(grappleToXDirection * grappleToXDirection + grappleToYDirection * grappleToYDirection);
			grappleToXDirection *= grappleShotSpeedFactor / grappleToDirectionMagnitude;
			grappleToYDirection *= grappleShotSpeedFactor / grappleToDirectionMagnitude;
			
			// Move the grapple position.
			grappleToX += grappleToXDirection;
			grappleToY += grappleToYDirection;
			
			// If the Grapple collides into something, stop the Grapple Shot Translation.
			if (can_grapple_to(grappleToX, grappleToY) != noone)
			{
				var grappledObject = can_grapple_to(grappleToX, grappleToY);
				grappleToX = grappledObject.x;
				grappleToY = grappledObject.y;
				grappleSwingingVelocity = 0.0;
				grappleAngle = point_direction(grappleToX, grappleToY, x, y);
				grappleLength = point_distance(grappleToX, grappleToY, x, y);
				playerState = PlayerState.Swinging;
				grappleState = GrappleState.Attached;
				break;
			}
			
			// If we have reached the maximum grapple distance, retract the grapple.
			if (distance_to_point(grappleToX, grappleToY) > grappleLengthMaximum)
			{	
				// Visual Cleaning of Grapple Position
				while (can_grapple_to(grappleToX, grappleToY))
				{
					grappleToX -= grappleToXDirection * 0.01;
					grappleToY -= grappleToYDirection * 0.01;
				}
				grappleState = GrappleState.Retracting
			}
		}
		
		if (grappleState == GrappleState.Retracting)
		{
			// Calculate the Direction Unit Vector.
			grappleToXDirection = x - grappleToX;
			grappleToYDirection = y - grappleToY;
			grappleToDirectionMagnitude = sqrt(grappleToXDirection * grappleToXDirection + grappleToYDirection * grappleToYDirection);
			grappleToXDirection *= grappleShotSpeedFactor / grappleToDirectionMagnitude;
			grappleToYDirection *= grappleShotSpeedFactor / grappleToDirectionMagnitude;
			
			// Move the grapple position.
			grappleToX += grappleToXDirection;
			grappleToY += grappleToYDirection;

			// If we have reached the minimum grapple distance, hide the grapple.
			if (distance_to_point(grappleToX, grappleToY) <= grappleLengthRetractMinimum)
			{
				grappleToX = x;
				grappleToY = y;
				grappleState = GrappleState.Unused;
			}
		}
	}
	break;
	
	case PlayerState.Swinging:
	{				
		// If the player is grounded or there is Coyote Time remaining, perform the jump.
		if (isGrounded)
		{
			// Resolve Horizontal and Vertical Translation
			var moveDirection = key_right - key_left;
			horizontalSpeed += moveDirection * horizontalWalkAcceleration;
			if (moveDirection == 0)
			{
				horizontalSpeed = approach(horizontalSpeed, 0, horizontalWalkFriction);
			}
			horizontalSpeed = clamp(horizontalSpeed, -horizontalWalkSpeedMaximum, horizontalWalkSpeedMaximum);
			
			// Don't move if we go beyond the grapple length.
			if (point_distance(x + horizontalSpeed, y, grappleToX, grappleToY) >= grappleLengthMaximum)
			{	
				horizontalSpeed = 0;
			}
			grappleSwingingVelocity = 0.0;
			grappleAngle = point_direction(grappleToX, grappleToY, x, y);
			grappleLength = point_distance(grappleToX, grappleToY, x, y);
		}
		else
		{
			// Calculate the swinging speeds.
			var grappleSwingingAcceleration = -0.2 * dcos(grappleAngle);
			grappleSwingingVelocity += grappleSwingingAcceleration + ((grappleAngle > 247.5 && grappleAngle < 292.5) ? 0.075 * (key_right - key_left) : 0);
			grappleSwingingVelocity = clamp(grappleSwingingVelocity, -grappleSwingingVelocityMaximum, grappleSwingingVelocityMaximum);
			grappleAngle += grappleSwingingVelocity;
			grappleSwingingVelocity *= 0.99; // Damping.
			horizontalSpeed = grappleToX + lengthdir_x(grappleLength, grappleAngle) - x;
			verticalSpeed = grappleToY + lengthdir_y(grappleLength, grappleAngle) - y;
		}
		
		// If the grapple is attached.
		if (grappleState == GrappleState.Attached)
		{
			// And the player presses the right mouse button or space bar, retract the grapple.
			if (mouse_right || key_space)
			{
				// If it was the space bar pressed down, give a slight jump.
				if (key_space)
				{
					verticalSpeed = 0.5 * verticalInitialJumpSpeed;
					coyoteTimeCounter = 0;
				}
				horizontalSpeedOnSwingingExit = horizontalSpeed;
				playerState = PlayerState.Normal;
				grappleState = GrappleState.Retracting;
				break;
			}
			
			// And the player presses W, reel towards the grapple.
			if (key_up && grappleLength > grappleLengthRetractThreshold)
			{
				// Calculate the Direction Unit Vector.
				grappleToXDirection = grappleToX - x;
				grappleToYDirection = grappleToY - y;
				grappleToDirectionMagnitude = sqrt(grappleToXDirection * grappleToXDirection + grappleToYDirection * grappleToYDirection);
				grappleToXDirection *= grappleReelingSpeedFactor / grappleToDirectionMagnitude;
				grappleToYDirection *= grappleReelingSpeedFactor / grappleToDirectionMagnitude;
				horizontalSpeed = 0.0;
				verticalSpeed = 0.0;
				playerState = PlayerState.Reeling;
				break;
			}
		}
	}
	break;
	
	case PlayerState.Reeling:
	{
		grappleLength = point_distance(grappleToX, grappleToY, x, y);
		horizontalSpeed = approach(horizontalSpeed, grappleToXDirection, 0.125 * abs(grappleToXDirection));
		verticalSpeed = approach(verticalSpeed, grappleToYDirection, 0.125 * abs(grappleToYDirection));
		
		// If the player is not holding the up key or the grapple has reached the threshold, stop the reeling.
		if (grappleLength <= grappleLengthRetractThreshold)
		{
			grappleAngle = point_direction(grappleToX, grappleToY, x, y);
			horizontalSpeed = 0.0;
			verticalSpeed = 0.0;
			playerState = PlayerState.Swinging;
		}
	}
	break;
	
	case PlayerState.Dead:
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

// If the player is standing on a moving platform or colliding from below, add the Moving Platform's speed.
var movingPlatformStanding = collision_point(x, y + 32, o_Moving_Platform, true, true);
if (movingPlatformStanding != noone)
{
	var toTranslate = movingPlatformStanding.horizontal_direction * movingPlatformStanding.movespeed;
	if (!is_solid_object_at_position(x + toTranslate, y))
	{
		x += toTranslate;
	}
}

// If the player encounters any solid objects while moving horizontally, stop translation in that direction.
if (is_solid_object_at_position(x + horizontalSpeed, y))
{
	var horizontalStep = sign(horizontalSpeed);
	horizontalSpeed = 0.0;
	while (!is_solid_object_at_position(x + horizontalStep, y))
	{		
		x += horizontalStep;
	}
	if (playerState == PlayerState.Swinging || playerState == PlayerState.Reeling)
	{
		grappleAngle = point_direction(grappleToX, grappleToY, x, y);
		grappleSwingingVelocity = 0.0;
		
		if (playerState == PlayerState.Reeling)
		{
			//playerState = PlayerState.Swinging;
		}
	}
}
x += horizontalSpeed;

// If the player encounters any solid objects while moving vertically, stop translation in that direction.
if (is_solid_object_at_position(x, y + verticalSpeed))
{
	var verticalStep = sign(verticalSpeed);
	verticalSpeed = 0.0;
	while (!is_solid_object_at_position(x, y + verticalStep))
	{		
		y += verticalStep;
	}
	if (playerState == PlayerState.Swinging || playerState == PlayerState.Reeling)
	{
		grappleAngle = point_direction(grappleToX, grappleToY, x, y);
		grappleSwingingVelocity = 0.0;
		
		if (playerState == PlayerState.Reeling)
		{
			playerState = PlayerState.Swinging;
		}
	}
}
y += verticalSpeed;