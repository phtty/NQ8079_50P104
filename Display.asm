F_Display_Time:									; ������ʾ������ʾ��ǰʱ��
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

L_DisTime_Hour:									; ��ʾСʱ
	lda		R_Time_Hour
	cmp		#12
	bcs		L_Time12h_PM
	jsr		F_ClrPM								; 12hģʽAM��Ҫ��PM��
	lda		R_Time_Hour							; ���Դ溯�����Aֵ������ȡ����
	cmp		#0
	beq		L_Time_0Hour
	bra		L_Start_DisTime_Hour
L_Time12h_PM:
	jsr		F_DisPM								; 12hģʽPM��Ҫ��PM��
	lda		R_Time_Hour							; ���Դ溯�����Aֵ������ȡ����
	sec
	sbc		#12
	cmp		#0
	bne		L_Start_DisTime_Hour
L_Time_0Hour:									; 12hģʽ0����Ҫ���12��
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




; ��ʾ����ʱ��
F_Display_Alarm:								; ������ʾ������ʾ��ǰ����
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

L_DisAlarm_Hour:								; ��ʾ����Сʱ
	lda		R_Alarm_Hour
	cmp		#12
	bcs		L_Alarm12h_PM
	jsr		F_ClrPM								; 12hģʽAM��Ҫ��PM��
	lda		R_Alarm_Hour						; ���Դ溯�����Aֵ������ȡ����
	cmp		#0
	beq		L_Alarm_0Hour
	bra		L_Start_DisAlarm_Hour
L_Alarm12h_PM:
	jsr		F_DisPM								; 12hģʽPM��Ҫ��PM��
	lda		R_Alarm_Hour						; ���Դ溯�����Aֵ������ȡ����
	sec
	sbc		#12
	cmp		#0
	bne		L_Start_DisAlarm_Hour
L_Alarm_0Hour:									; 12hģʽ0����Ҫ���12��
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




F_UnDisplay_D0_1:								; ��˸ʱȡ����ʾ�õĺ���
	lda		#0
	jsr		L_Dis_1Bit_DigitDot
	lda		#10
	ldx		#lcd_d1
	jsr		L_Dis_7Bit_DigitDot
	rts


F_UnDisplay_D2_3:								; ��˸ʱȡ����ʾ�õĺ���
	lda		#10
	ldx		#lcd_d2
	jsr		L_Dis_6Bit_DigitDot
	lda		#10
	ldx		#lcd_d3
	jsr		L_Dis_7Bit_DigitDot
	rts



F_SymbolRegulate:								; ����Zz��Ĺ���
	lda		Clock_Flag
	and		#%0110
	beq		L_SymbolDisOver						; �����̰˯������״̬������Zz��
	bbs1	Symbol_Flag,L_SymbolDis
	rts
L_SymbolDis:
	rmb1	Symbol_Flag							; Zz���S��־
	bbs0	Symbol_Flag,L_ALM_Dot_Clr
	jsr		F_DisZz
	rts
L_ALM_Dot_Clr:
	rmb0	Symbol_Flag							; Zz��1S��־
	jsr		F_ClrZz
L_SymbolDisOver:
	rts




; �����
F_DisCol:
	ldx		#lcd_COL
	jsr		F_DisSymbol
	rts

; ��PM��
F_DisPM:
	ldx		#lcd_PM
	jsr		F_DisSymbol
	rts

; ��PM��
F_ClrPM:
	ldx		#lcd_PM
	jsr		F_ClrSymbol
	rts

; ��Zz��
F_DisZz:
	ldx		#lcd_Zz
	jsr		F_DisSymbol
	rts

; ��Zz��
F_ClrZz:
	ldx		#lcd_Zz
	jsr		F_ClrSymbol
	rts

; ��Bell��
F_DisBell:
	ldx		#lcd_bell
	jsr		F_DisSymbol
	rts

; ��Bell��
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



; ��256���ڵ�����ʮ���ƴ洢��ʮ�����Ƹ�ʽ��
; A==ת��������X==��λ
L_A_DecToHex:
	sta		P_Temp								; ��ʮ�������뱣�浽P_Temp
	ldx		#0
	lda		#0
	sta		P_Temp+1							; ʮλ����
	sta		P_Temp+2							; ��λ����

L_DecToHex_Loop:
	lda		P_Temp
	cmp		#10
	bcc		L_DecToHex_End						; ���С��10������ת��

	sec
	sbc		#10									; ��ȥ10
	sta		P_Temp								; ����ʮ����ֵ
	inc		P_Temp+1							; ʮλ+1���ۼ�ʮ�����Ƶ�ʮλ
	bra		L_DecToHex_Loop						; �ظ�ѭ��

L_DecToHex_End:
	lda		P_Temp								; ���ʣ���ֵ�Ǹ�λ
	sta		P_Temp+2							; �����λ

Juge_3Positions:
	lda		P_Temp+1							; ��ʮλ����A�Ĵ������
	cmp		#10
	bcc		No_3Positions						; �ж��Ƿ��а�λ
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
	rol											; ����4�Σ���ɳ�16
	clc
	adc		P_Temp+2							; ���ϸ�λֵ

	rts
