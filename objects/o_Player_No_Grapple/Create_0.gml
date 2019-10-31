/// @description Initialise Variables
hasJumped = false;
image_speed_temp = -1;
waitDuration = 30;
isDead = false;

horizontalSpeed = 0.0;
horizontalWalkAcceleration = 2.5;
horizontalWalkSpeedMaximum = 6.5;
horizontalWalkFriction = 1.25;
horizontalAirFriction = 1.0;
horizontalSpeedOnSwingingExit = 0.0;

verticalSpeed = 0.0;
verticalSpeedMaximum = 12.0;
verticalInitialJumpSpeed = -10.0;
gravityExperienced = 0.5;

coyoteTimeDuration = 5;
coyoteTimeCounter = coyoteTimeDuration;

playerState = PlayerState.Normal;
