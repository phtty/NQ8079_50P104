F_Time_Run:
	bbs0	Time_Flag,L_TimeRun_Add					; 有加时1S标志才进处理
	rts
L_TimeRun_Add:
	rmb0	Time_Flag								; 清增S标志

	inc		R_Time_Sec
	lda		R_Time_Sec
	cmp		#60
	bcs		L_TimeSec_Overflow						; 发生分钟进位
	rts
L_TimeSec_Overflow:
	lda		#0
	sta		R_Time_Sec
	inc		R_Time_Min
	jsr		L_SnoozeManage							; 每次分钟更新判断一次贪睡
	lda		R_Time_Min
	cmp		#60
	bcs		L_TimeMin_Overflow						; 发生小时进位
	jsr		L_DisTime_Min							; 刷新分钟显示
	rts
L_TimeMin_Overflow:
	lda		#0
	sta		R_Time_Min
	inc		R_Time_Hour
	lda		R_Time_Hour
	cmp		#24
	bcc		L_TimeRun_Exit
	lda		#0
	sta		R_Time_Hour								; 发生天进位
L_TimeRun_Exit:
	jsr		F_Display_Time							; 清空分钟，显示小时
	rts
	