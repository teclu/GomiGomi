/// @description Player State and Controls

if (global.pause)
{
	exit;	
}

// Disable all Grappling Features.
// Player Keyboard and Mouse Inputs
var key_left = keyboard_check(ord("A"));
var key_right = keyboard_check(ord("D"));
var key_space = keyboard_check(vk_space);

// Boolean Checks
isGrounded = is_solid_object_at_position(x, y + 1);

// Make the player wait if dead or moving between rooms.
var moveDirection = key_right - key_left;
if (waitDuration > 0)
{
	moveDirection = 0;
	key_space = 0;
	waitDuration--;	
}

// The Player State Machine
switch (playerState)
{
	case PlayerState.Normal:
	{		
		// Resolve Horizontal and Vertical Translation
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
			verticalSpeed = clamp(verticalSpeed, -verticalSpeedMaximum, verticalSpeedMaximum);
			
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
			
			if (hasJumped)
			{
				if (!audio_is_playing(snd_Land))
				{
					audio_play_sound(snd_Land, 1, false);	
				}
				hasJumped = false;	
			}
		}
		
		// If the player is grounded or there is Coyote Time remaining, perform the jump.
		if (key_space && (isGrounded || coyoteTimeCounter > 0))
		{
			verticalSpeed = verticalInitialJumpSpeed;
			coyoteTimeCounter = 0;
			hasJumped = true;
		}
	}
	break;
		
	case PlayerState.Dead:
	{	
		if (!isDead && !audio_is_playing(snd_Death))
		{
			audio_play_sound(snd_Death, 1, false);
			isDead = true;
		}
		
		// Make the player wait if dead or moving between rooms.
		if (waitDuration > 0)
		{
			waitDuration--;	
		}
		else
		{
			room_restart();
		}
		return;	
	}
}

// The Player Sprite Appearance
if (isGrounded && key_right - key_left != 0)
{
	sprite_index = sp_Player_Walking;
	if (!audio_is_playing(snd_Movement))
	{
		audio_play_sound(snd_Movement, 1, false);	
	}
}
else if (isGrounded && key_right - key_left == 0)
{
	sprite_index = sp_Player_Idle;
}

if (hasJumped)
{
	sprite_index = sp_Player_Jump_Up;
	if (isGrounded && !audio_is_playing(snd_Jump))
	{
		audio_play_sound(snd_Jump, 1, false);	
	}
}
 
// Invert the X-axis of the sprite depending on the move direction or mouse cursor.
if (mouse_x > x || key_right)
{
	image_xscale = 1;
}
else if (mouse_x < x || key_left)
{
	image_xscale = -1;
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
}
y += verticalSpeed;

// Prevent slight phasing through solid objects.
while (is_solid_object_at_position(x, y + 1))
{
	y -= 1;
} 
y += 1;