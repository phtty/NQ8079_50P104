; 响闹判断
F_Alarm_Handler:
	bbr2	Time_Flag,Alarm_NoJuge				; 每S只进1次闹钟判断
	rmb2	Time_Flag
	lda		Alarm_Switch
	bne		Is_Alarm_Trigger					; 没有任何闹钟开启则不会判断闹钟是否触发
Alarm_NoJuge:
	rts

; 闹钟设定值的时、分符合当前时间，就设置闹钟触发标志位
Is_Alarm_Trigger:
	lda		Alarm_Switch
	and		#001B
	beq		L_Alarm_NoMatch					; 如果此闹钟没有开启，则不会判断它
	lda		R_Time_Hour
	cmp		R_Alarm_Hour
	beq		L_Alarm_HourMatch
L_Alarm_NoMatch:
	rts

L_Alarm_HourMatch:
	lda		R_Time_Min
	cmp		R_Alarm_Min
	beq		L_Alarm_MinMatch
	rts

L_Alarm_MinMatch:
	lda		R_Time_Sec
	cmp		#00
	bne		Alarm_SecNoMatch
	jmp		L_Alarm_Match_Handle
Alarm_SecNoMatch:
	rts


; 确定闹钟触发后的处理
L_Alarm_Match_Handle:
	smb0	Clock_Flag							; 同时满足小时和分钟的匹配，设置闹钟触发
	smb1	Clock_Flag							; 开启响闹模式

	smb6	IER									; 开启LCD中断
	smb1	Time_Flag
	smb3	Timer_Switch						; 开启21Hz蜂鸣间隔定时
	lda		#0
	sta		Counter_21Hz
	sta		Louding_Counter

	rts




; 贪睡部分的处理
L_SnoozeManage:
	bbs2	Clock_Flag,Snooze_Handle
	rts
Snooze_Handle:
	lda		R_Snooze_Time
	beq		SnoozeAlarm_Trigger
	dec		R_Snooze_Time
	rts
SnoozeAlarm_Trigger:
	lda		#7
	sta		R_Snooze_Time
	rmb2	Clock_Flag
	jmp		L_Alarm_Match_Handle




; X存商，A为余数
L_A_Div_3:
	ldx		#0
L_A_Div_3_Start:
	cmp		#3
	bcc		L_A_Div_3_Over
	sec
	sbc		#3
	inx
	bra		L_A_Div_3_Start
L_A_Div_3_Over:
	rts


; 将A左移X位
L_A_LeftShift_XBit:
	sta		P_Temp
Shift_Start:
	txa
	beq		Shift_End
	lda		P_Temp
	clc
	rol		P_Temp
	dex
	bra		Shift_Start
Shift_End:
	lda		P_Temp
	rts
