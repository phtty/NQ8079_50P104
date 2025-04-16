F_Display_Time:									; 调用显示函数显示当前时间
	jsr		L_DisTime_Min
	jsr		L_DisTime_Hour
	rts

L_DisTime_Min:
	lda		R_Time_Min
	jsr		L_A_DecToHex
	pha
	and		#$0f
	ldx		#lcd_d3
	jsr		L_Dis_7Bit_DigitDot
	pla
	and		#$f0
	jsr		L_LSR_4Bit
	ldx		#lcd_d2
	jsr		L_Dis_6Bit_DigitDot
	rts	

L_DisTime_Hour:									; 显示小时
	lda		R_Time_Hour
	cmp		#12
	bcs		L_Time12h_PM
	jsr		F_ClrPM								; 12h模式AM需要灭PM点
	lda		R_Time_Hour							; 改显存函数会改A值，重新取变量
	cmp		#0
	beq		L_Time_0Hour
	bra		L_Start_DisTime_Hour
L_Time12h_PM:
	jsr		F_DisPM								; 12h模式PM需要亮PM点
	lda		R_Time_Hour							; 改显存函数会改A值，重新取变量
	sec
	sbc		#12
	cmp		#0
	bne		L_Start_DisTime_Hour
L_Time_0Hour:									; 12h模式0点需要变成12点
	lda		#12
L_Start_DisTime_Hour:
	jsr		L_A_DecToHex
	pha
	and		#$0f
	ldx		#lcd_d1
	jsr		L_Dis_7Bit_DigitDot
	pla
	and		#$f0
	jsr		L_LSR_4Bit
	jsr		L_Dis_1Bit_DigitDot
	rts 




; 显示闹钟时间
F_Display_Alarm:								; 调用显示函数显示当前闹钟
	jsr		L_DisAlarm_Min
	jsr		L_DisAlarm_Hour
	rts

L_DisAlarm_Min:
	lda		R_Alarm_Min
	jsr		L_A_DecToHex
	pha
	and		#$0f
	ldx		#lcd_d3
	jsr		L_Dis_7Bit_DigitDot
	pla
	and		#$f0
	jsr		L_LSR_4Bit
	ldx		#lcd_d2
	jsr		L_Dis_6Bit_DigitDot
	rts	
	rts	

L_DisAlarm_Hour:								; 显示闹钟小时
	lda		R_Alarm_Hour
	cmp		#12
	bcs		L_Alarm12h_PM
	jsr		F_ClrPM								; 12h模式AM需要灭PM点
	lda		R_Alarm_Hour						; 改显存函数会改A值，重新取变量
	cmp		#0
	beq		L_Alarm_0Hour
	bra		L_Start_DisAlarm_Hour
L_Alarm12h_PM:
	jsr		F_DisPM								; 12h模式PM需要亮PM点
	lda		R_Alarm_Hour						; 改显存函数会改A值，重新取变量
	sec
	sbc		#12
	cmp		#0
	bne		L_Start_DisAlarm_Hour
L_Alarm_0Hour:									; 12h模式0点需要变成12点
	lda		#12
L_Start_DisAlarm_Hour:
	jsr		L_A_DecToHex
	pha
	and		#$0f
	ldx		#lcd_d1
	jsr		L_Dis_7Bit_DigitDot
	pla
	and		#$f0
	jsr		L_LSR_4Bit
	jsr		L_Dis_1Bit_DigitDot
	rts




F_UnDisplay_D0_1:								; 闪烁时取消显示用的函数
	lda		#0
	jsr		L_Dis_1Bit_DigitDot
	lda		#10
	ldx		#lcd_d1
	jsr		L_Dis_7Bit_DigitDot
	rts


F_UnDisplay_D2_3:								; 闪烁时取消显示用的函数
	lda		#10
	ldx		#lcd_d2
	jsr		L_Dis_6Bit_DigitDot
	lda		#10
	ldx		#lcd_d3
	jsr		L_Dis_7Bit_DigitDot
	rts



F_SymbolRegulate:								; 几个Zz点的管理
	lda		Clock_Flag
	and		#%0110
	beq		L_SymbolDisOver						; 如果非贪睡或响闹状态，则不闪Zz点
	bbs1	Symbol_Flag,L_SymbolDis
	rts
L_SymbolDis:
	rmb1	Symbol_Flag							; Zz点半S标志
	bbs0	Symbol_Flag,L_ALM_Dot_Clr
	jsr		F_DisZz
	rts
L_ALM_Dot_Clr:
	rmb0	Symbol_Flag							; Zz点1S标志
	jsr		F_ClrZz
L_SymbolDisOver:
	rts




; 亮秒点
F_DisCol:
	ldx		#lcd_COL
	jsr		F_DisSymbol
	rts

; 亮PM点
F_DisPM:
	ldx		#lcd_PM
	jsr		F_DisSymbol
	rts

; 灭PM点
F_ClrPM:
	ldx		#lcd_PM
	jsr		F_ClrSymbol
	rts

; 亮Zz点
F_DisZz:
	ldx		#lcd_Zz
	jsr		F_DisSymbol
	rts

; 灭Zz点
F_ClrZz:
	ldx		#lcd_Zz
	jsr		F_ClrSymbol
	rts

; 亮Bell点
F_DisBell:
	ldx		#lcd_bell
	jsr		F_DisSymbol
	rts

; 灭Bell点
F_ClrBell:
	ldx		#lcd_bell
	jsr		F_ClrSymbol
	rts



L_LSR_4Bit:
	clc
	ror
	ror
	ror
	ror
	rts



; 将256以内的数以十进制存储在十六进制格式中
; A==转换的数，X==百位
L_A_DecToHex:
	sta		P_Temp								; 将十进制输入保存到P_Temp
	ldx		#0
	lda		#0
	sta		P_Temp+1							; 十位清零
	sta		P_Temp+2							; 个位清零

L_DecToHex_Loop:
	lda		P_Temp
	cmp		#10
	bcc		L_DecToHex_End						; 如果小于10，则不用转换

	sec
	sbc		#10									; 减去10
	sta		P_Temp								; 更新十进制值
	inc		P_Temp+1							; 十位+1，累加十六进制的十位
	bra		L_DecToHex_Loop						; 重复循环

L_DecToHex_End:
	lda		P_Temp								; 最后剩余的值是个位
	sta		P_Temp+2							; 存入个位

Juge_3Positions:
	lda		P_Temp+1							; 将十位放入A寄存器组合
	cmp		#10
	bcc		No_3Positions						; 判断是否有百位
	sec
	sbc		#10
	sta		P_Temp+1
	inx
	bra		Juge_3Positions
No_3Positions:
	clc
	rol
	rol
	rol
	rol											; 左移4次，完成乘16
	clc
	adc		P_Temp+2							; 加上个位值

	rts
