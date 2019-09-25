// Player Variables
horizontalSpeed = 0;
verticalSpeed = 0;
horizontalSpeedFraction = 0.0;
verticalSpeedFraction = 0.0;
walkSpeed = 3;
walkAcceleration = 1.5;
jumpSpeed = 10;
horizontalFrictionGround = 0.5;
horizontalFrictionAir = 0.0;
gravityExperienced = 0.5;

// Player States
state = State.Normal;

enum State {
	Normal,
	Shooting,
	Swinging,
	Reeling
}