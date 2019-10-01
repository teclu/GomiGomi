// Player Variables
horizontalSpeed = 0.0;
verticalSpeed = 0.0;
horizontalSpeedFraction = 0.0;
verticalSpeedFraction = 0.0;
walkSpeed = 7.5;
walkAcceleration = 2.5;
jumpSpeed = 10.0;
horizontalFrictionGround = 2.5;
horizontalFrictionAir = 1.0;
gravityExperienced = 0.5; 

// Coyote Time Variables
coyoteTimeDuration = 60;
coyoteTimeCounter = coyoteTimeDuration;
show_debug_message(room_speed);

// Player States
state = State.Normal;

enum State {
	Normal,
	Shooting,
	Swinging,
	Reeling,
	Dead
}

// Grapple Variables
grappleToX = x;
grappleToY = y;
grappleToXCheck = x;
grappleToYCheck = y;
grappleToXSpeed = 0.0;
grappleToYSpeed = 0.0;
grappleReelInSpeed = 25.0;
grappleReelToSpeed = 15.0;
grappleShootOutSpeed = 25.0;
grappleFromX = x;
grappleFromY = y;
ropeLengthThreshold = 75.0;
