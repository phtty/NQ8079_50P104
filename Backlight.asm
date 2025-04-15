F_Backlight_Manage:
	bbr0	Backlight_Flag,L_Backlight_Exit
	bbr1	Backlight_Flag,L_Backlight_Exit

	rmb1	Backlight_Flag
	lda		Backlight_Counter
	cmp		#6
	bcs		L_Backlight_Stop
	inc		Backlight_Counter
	bra		L_Backlight_Exit
L_Backlight_Stop:
	lda		#0
	sta		Backlight_Counter
	rmb0	Backlight_Flag
	lda		#$7e
	sta		PC
L_Backlight_Exit:
	rts
