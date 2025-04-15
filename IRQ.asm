I_DivIRQ_Handler:
	nop										; 未使用DIV中断
	jmp		L_EndIrq


I_Timer0IRQ_Handler:
	nop										; 未使用Tim0中断
	jmp		L_EndIrq


I_Timer1IRQ_Handler:
	nop										; 未使用Tim1中断
	jmp		L_EndIrq


I_Timer2IRQ_Handler:						; Tim2用于走时
	smb1	Timer_Flag						; 2Hz标志
	smb1	Symbol_Flag

L_1Hz_Juge:
	inc		Counter_1Hz
	lda		Counter_1Hz						; 1Hz计数
	cmp		#2
	bcc		Timer2IRQ_Exit
	lda		#0
	sta		Counter_1Hz
	smb0	Timer_Flag
	smb0	Symbol_Flag
	smb4	Backlight_Flag

	lda		#$07
	ora		Time_Flag
	sta		Time_Flag						; 走时加时、响铃加时、闹钟判断
Timer2IRQ_Exit:
	jmp		L_EndIrq


I_PaIRQ_Handler:
	rmb4	SYSCLK							; 唤醒后回到弱模式
	smb0	Key_Flag						; 开启扫键
	smb1	Key_Flag						; 首次触发，要消抖
	rmb2	Key_Flag						; 如果有新的下降沿到来，清快加标志位
	rmb4	Timer_Flag						; 清42Hz标志位

	smb6	IER
	rmb4	IER
	smb4	Timer_Switch					; 打开快加定时，暂时关闭PA中断

	nop										; 开始扫描按键将PA口设为输出，PC口设为输入

	jmp		L_EndIrq


I_LcdIRQ_Handler:							; 按键扫描，蜂鸣间隔，快加间隔
	bbr4	Timer_Switch,L_21Hz_Juge		; 42Hz计数开关
	smb4	Timer_Flag						; 42Hz标志

L_21Hz_Juge:
	bbr3	Timer_Switch,L_4Hz_Juge			; 16Hz计数开关
	inc		Counter_21Hz
	lda		Counter_21Hz
	cmp		#2
	bcc		L_4Hz_Juge
	lda		#0
	sta		Counter_21Hz
	smb3	Timer_Flag						; 21Hz标志

L_4Hz_Juge:
	bbr2	Timer_Switch,LcdIRQ_Exit		; 4Hz计数开关
	inc		Counter_4Hz
	lda		Counter_4Hz
	cmp		#4
	bcc		LcdIRQ_Exit
	lda		#0
	sta		Counter_4Hz
	smb2	Timer_Flag						; 4Hz标志

LcdIRQ_Exit:
	jmp		L_EndIrq
