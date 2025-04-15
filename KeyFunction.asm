; 切换时间设置模式
SwitchState_ClockSet:
	bbs0	Sys_Status_Flag,?TimeDisMode
	bbs2	Sys_Status_Flag,?TimeSetMode
	rts
?TimeDisMode:
	lda		#%100
	sta		Sys_Status_Flag
	jmp		F_Display_Time
?TimeSetMode:
	lda		#%001
	sta		Sys_Status_Flag
	jmp		F_Display_Time




; 切换闹钟设置模式
SwitchState_AlarmSet:
	bbs0	Sys_Status_Flag,?TimeDisMode
	bbs2	Sys_Status_Flag,?AlarmSetMode
	rts
?TimeDisMode:
	lda		#%010
	sta		Sys_Status_Flag
	jmp		F_Display_Alarm
?AlarmSetMode:
	lda		#%001
	sta		Sys_Status_Flag
	jmp		F_Display_Time




; 时增加
Time_HourAdd:
	lda		R_Time_Hour
	cmp		#23
	bcs		TimeHour_AddOverflow
	inc		R_Time_Hour
	bra		TimeHour_Add_Exit
TimeHour_AddOverflow:
	lda		#0
	sta		R_Time_Hour
TimeHour_Add_Exit:
	jsr		F_Display_Time
	rts




; 分增加
Time_MinAdd:
	lda		#0
	sta		R_Time_Sec							; 调整分钟会清空秒

	lda		R_Time_Min
	cmp		#59
	bcs		TimeMin_AddOverflow
	inc		R_Time_Min
	bra		TimeMin_Add_Exit
TimeMin_AddOverflow:
	lda		#0
	sta		R_Time_Min
TimeMin_Add_Exit:
	jsr		F_Display_Time
	rts




; 闹钟分增加
Alarm_MinAdd:
	lda		R_Alarm_Min
	cmp		#59
	bcs		AlarmMin_AddOverflow
	clc
	adc		#1
	sta		R_Alarm_Min
	bra		AlarmMin_Add_Exit
AlarmMin_AddOverflow:
	lda		#0
	sta		R_Alarm_Min
AlarmMin_Add_Exit:
	jsr		F_Display_Alarm
	rts




; 闹钟时增加
Alarm_HourAdd:
	lda		R_Alarm_Hour
	cmp		#23
	bcs		AlarmHour_AddOverflow
	clc
	adc		#1
	sta		R_Alarm_Hour
	bra		AlarmHour_Add_Exit
AlarmHour_AddOverflow:
	lda		#0
	sta		R_Alarm_Hour
AlarmHour_Add_Exit:
	jsr		F_Display_Alarm
	rts
