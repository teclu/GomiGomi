/// @description Initialise Variables
horizontalSpeed = 0.0;
horizontalWalkAcceleration = 2.5;
horizontalWalkSpeedMaximum = 7.5;
horizontalWalkFriction = 1.25;
horizontalAirFriction = 1.0;
horizontalSpeedOnSwingingExit = 0.0;

verticalSpeed = 0.0;
verticalInitialJumpSpeed = -12.0;
gravityExperienced = 1.0;

coyoteTimeDuration = 30;
coyoteTimeCounter = coyoteTimeDuration;

grappleShotSpeedFactor = 32.0;
grappleSwingingVelocity = 0.0;
grappleSwingingVelocityMaximum = 3.0;
grappleAngle = 0.0;
grappleLength = 0.0;
grappleToX = 0.0;
grappleToY = 0.0;
grappleToMouseX = 0.0;
grappleToMouseY = 0.0;
grappleToXDirection = 0.0;
grappleToYDirection = 0.0;
grappleToDirectionMagnitude = 0.0;
grappleReelingSpeedFactor = 14.0;
grappleLengthRetractMinimum = 32.0;
grappleLengthRetractThreshold = 96.0;
grappleLengthMaximum = 480.0;
grappledObject = noone;

playerState = PlayerState.Normal;
enum PlayerState
{
	Normal,
	Swinging,
	Reeling,
	Dead
}

grappleState = GrappleState.Unused;
enum GrappleState
{
	Unused,
	Projecting,
	Retracting,
	Attached
}