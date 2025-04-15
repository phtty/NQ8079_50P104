F_BeepManage:
	jsr		L_LoudManage
	bbs3	Timer_Flag,L_Beeping
	rts
L_Beeping:
	rmb3	Timer_Flag

	bbr4	Clock_Flag,L_SerialBeep_Mode
	lda		Beep_Serial							; 持续响铃模式
	eor		#01B								; Beep_Serial翻转第一位
	sta		Beep_Serial
	bra		L_Beep_Juge
L_SerialBeep_Mode:
	lda		Beep_Serial
	beq		L_NoBeep_Serial_Mode
	dec		Beep_Serial
L_Beep_Juge:
	bbr0	Beep_Serial,L_NoBeep_Serial_Mode
	PB2_PWM
	PWM_ON
	rts
L_NoBeep_Serial_Mode:
	PWM_OFF
	PB2_PB2_NOMS								; PB2选择NMOS输出1避免漏电
	smb2	PB
	rts




; 响闹管理
L_LoudManage:
	bbr1	Clock_Flag,NoLouding				; 存在响闹标志位时才进处理
	bbr0	Clock_Flag,LoudHandle_Start			; 再判断是否存在闹钟触发标志
	bbs1	Time_Flag,LoudHandle_Start
NoLouding:
	rts
LoudHandle_Start:
	rmb1	Time_Flag

	nop											; 根据响闹的秒数进行判断
	;lda		#8									; 闹钟响闹的序列为8，4声
	;sta		Beep_Serial
	
LoudCounter_Juge:
	inc		Louding_Counter
	lda		Louding_Counter
	cmp		#60
	bcs		L_CloseLoud							; 响闹计时达到60S后关闭
	rts

L_CloseLoud:									; 结束并关闭响闹
	lda		#0
	sta		Louding_Counter
	PWM_OFF
	PB2_PB2_NOMS									; PB2选择NMOS输出1避免漏电
	smb2	PB

	rmb3	Timer_Switch						; 关闭21Hz计时
	rmb3	Timer_Flag

	rmb1	Time_Flag
	rmb1	Clock_Flag							; 复位响闹模式和响闹加时1S
	rmb0	Clock_Flag							; 复位闹钟触发标志
	rts
