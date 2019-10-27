/// @description Handle Collision and Countdown.

// Set the boolean to true when player has stood on the Fragile block.
if (!hasBeenSteppedOn && place_meeting(x, y - 1, o_Player))
{
	hasBeenSteppedOn = true;	
}

// Don't do the countdown if the Fragile block has not yet been stepped on.
if (!hasBeenSteppedOn)
{
	return;	
}

// Decrement the counter.
while (timeToBreakInTicks > 0)
{
	timeToBreakInTicks--;
	return;
}

// Destroy the Fragile block.
if (timeToBreakInTicks == 0)
{
	instance_destroy(id);
}