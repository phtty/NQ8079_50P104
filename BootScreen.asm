F_BootScreen:
	jsr		F_FillScreen
	lda		#00
	sta		P_Temp
	rmb1	Timer_Flag
L_BootScreen_Loop:								; 上电全显2S
	bbr1	Timer_Flag,L_BootScreen_Loop
	rmb1	Timer_Flag
	inc		P_Temp
	lda		P_Temp
	cmp		#4
	bcs		?L_BeepLoop
	bra		L_BootScreen_Loop

?L_BeepLoop:
	lda		#4
	sta		Beep_Serial							; 启动时蜂鸣器响两声
	smb6	IER									; 开启LCD中断用于响闹的间隔
	rmb3	Clock_Flag							; 配置为序列响铃模式
	smb3	Timer_Switch
?Loop_Start:
	jsr		F_BeepManage
	lda		Beep_Serial
	bne		?Loop_Start

	rmb6	IER									; 关闭蜂鸣器使用的中断
	rmb3	Timer_Switch
	jsr		F_ClearScreen
	rmb0	SYSCLK								; 设置为弱模式
	rts
