F_Time_Run:
	bbs0	Time_Flag,L_TimeRun_Add					; 有加时1S标志才进处理
	rts
L_TimeRun_Add:
	rmb0	Time_Flag								; 清增S标志

	inc		R_Time_Sec
	lda		R_Time_Sec
	cmp		#60
	bcc		L_Time_SecRun_Exit						; 未发生分钟进位
	lda		#0
	sta		R_Time_Sec
	jsr		L_SnoozeManage							; 每次分钟更新判断一次贪睡
	inc		R_Time_Min
	lda		R_Time_Min
	cmp		#60
	bcc		L_Time_SecRun_Exit						; 未发生小时进位
	lda		#0
	sta		R_Time_Min
	inc		R_Time_Hour
	lda		R_Time_Hour
	cmp		#24
	bcc		L_Time_SecRun_Exit						; 未发生天进位
	lda		#0
	sta		R_Time_Hour
L_Time_SecRun_Exit:
	rts
