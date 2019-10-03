/// @description Initialising Variables

// Player States
// The "state machine" of the player.
state = State.Normal;

enum State {
	Normal,
	Shooting,
	Swinging,
	Reeling,
	Dead
}

// Player Variables
// These variables are measured in Pixels per Tick.
// Take note that the default room speed is 60 ticks, which equivalent to 1 second. 
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

// Grapple Variables
// These variables are measured in Pixels per Tick.
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
ropeLengthStart = 0;
ropeLengthMinimum = 128.0; // Powers of 2; for reference, 1 Wall is 64 pixels in width.
ropeLengthThreshold = 256.0 // A check to slow down the reel-to speed.
ropeLengthMaximum = 512.0;
objectGrappled = noone;


// Coyote Time Variables
// These variables are measured in Ticks.
coyoteTimeDuration = 60;
coyoteTimeCounter = coyoteTimeDuration;
