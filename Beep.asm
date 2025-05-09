F_BeepManage:
	jsr		L_LoudManage
	bbs3	Timer_Flag,L_Beeping
	rts
L_Beeping:
	rmb3	Timer_Flag

	bbr3	Clock_Flag,L_SerialBeep_Mode
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
	PB2_PB2_NOMS								; PB2选择NMOS输出0避免漏电
	rmb2	PB
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

	lda		Louding_Counter						; 根据响闹的秒数判断响几声
	cmp		#10
	bcs		No_LoudLevel_1
	rmb3	Clock_Flag							; 切换到序列响铃模式
	lda		#2
	sta		Beep_Serial							; 前10S响1声
	bra		LoudCounter_Juge
No_LoudLevel_1:
	cmp		#20
	bcs		No_LoudLevel_2
	lda		#4
	sta		Beep_Serial							; 10S~20S响2声
	bra		LoudCounter_Juge
No_LoudLevel_2:
	cmp		#30
	bcs		No_LoudLevel_3
	lda		#8
	sta		Beep_Serial							; 20S~30S响4声
	bra		LoudCounter_Juge
No_LoudLevel_3:
	smb3	Clock_Flag							; 30S以后切换到持续响铃模式
LoudCounter_Juge:
	lda		Louding_Counter
	cmp		#60
	bcs		Louding_Overflow					; 响闹计时达到60S后关闭
	inc		Louding_Counter
	rts
Louding_Overflow:
	jsr		F_DisZz
	bbr0	Sys_Status_Flag,L_CloseLoud			
	rmb6	IER
	rmb3	Timer_Switch

L_CloseLoud:									; 结束并关闭响闹
	lda		#0
	sta		Louding_Counter
	PWM_OFF
	PB2_PB2_NOMS								; PB2选择NMOS输出1避免漏电
	smb2	PB

	rmb3	Timer_Switch						; 关闭21Hz计时
	rmb3	Timer_Flag

	rmb1	Time_Flag
	rmb1	Clock_Flag							; 复位响闹模式和响闹加时1S
	rmb0	Clock_Flag							; 复位闹钟触发标志
	rmb3	Clock_Flag							; 复位持续响闹标志
	rts
