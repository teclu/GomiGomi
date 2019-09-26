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
gravityExperienced = 0.9; 

// Player States
state = State.Normal;

enum State {
	Normal,
	Shooting,
	Swinging,
	Reeling
}

// Grapple Variables
grappleToX = x;
grappleToY = y;
grappleToXCheck = x;
grappleToYCheck = y;
grappleToXSpeed = 0.0;
grappleToYSpeed = 0.0;
grappleSpeed = 0.5;
grappleFromX = x;
grappleFromY = y;
grappleReelInPlayerMultiplier = 0.02;
grappleReelInRopeMultiplier = 0.1;
grappleShootOutMultiplier = 0.05;
ropeLengthThreshold = 75.0;
