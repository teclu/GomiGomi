/// @description Debugging States
// Current Player Details (For Debugging)
if (false) // Change to enable/disable debugging messages.
{
	var playerDetails = "";
	switch (playerState)
	{
		case PlayerState.Normal:
			playerDetails = "Normal (";
			if (!isGrounded) {
				playerDetails += "Air)"
			}
			else
			{
				playerDetails += "Grounded)"
			}
			break;
		case PlayerState.Swinging:
			playerDetails = "Swinging (";
			if (!isGrounded) {
				playerDetails += "Air)"
			}
			else
			{
				playerDetails += "Grounded)"
			}
			break;
		case PlayerState.Reeling:
			playerDetails = "Reeling";
			break;
		case PlayerState.Dead:
			playerDetails = "Dead";
			break;
	}
	playerDetails += " " + string(coyoteTimeCounter);
	draw_set_font(f_Consolas_Debug);
	draw_set_color(c_yellow);
	draw_text(x, y, playerDetails);
}