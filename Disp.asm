;===========================================================
; LCD_RamAddr		.equ	0200H
;===========================================================
F_FillScreen:
	lda		#$ff
	bra		L_FillLcd
F_ClearScreen:
	lda		#0
L_FillLcd:
	sta		$1800
	sta		$1801
	sta		$1804
	sta		$1805
	sta		$1806
	sta		$1807
	sta		$180A
	sta		$180B
	sta		$180C
	sta		$180D
	sta		$1810
	sta		$1811
	sta		$1812
	sta		$1813
	sta		$1816
	sta		$1817
	sta		$1818
	sta		$1819
	sta		$181C
	sta		$181D
	sta		$181E
	sta		$181F
	sta		$1822
	sta		$1823
	rts


;===========================================================
;@brief		��ʾ������һ������
;@para:		A = 0~9
;			X = offset	
;@impact:	P_Temp��P_Temp+1��P_Temp+2��P_Temp+3, X��A
;===========================================================
L_Dis_7Bit_DigitDot:
	stx		P_Temp+1					; ƫ�����ݴ��P_Temp+2, �ڳ�X������ַѰַ

	tax
	lda		Table_Digit_7bit,x			; ����ʾ������ͨ������ҵ���Ӧ�Ķ�����A
	sta		P_Temp						; �ݴ����ֵ��P_Temp

	lda		#7
	sta		P_Temp+2					; ������ʾ����Ϊ7
L_Judge_Dis_7Bit_DigitDot:				; ��ʾѭ���Ŀ�ʼ
	ldx		P_Temp+1					; ��ͷƫ����->X
	lda		Lcd_bit,x					; ���λĿ��ε�bitλ
	sta		P_Temp+3					; bitλ->P_Temp+3
	lda		Lcd_byte,x					; ���λĿ��ε��Դ��ַ
	tax									; �Դ��ַƫ��->X
	ror		P_Temp						; ѭ������ȡ��Ŀ�������������
	bcc		L_CLR_7bit					; ��ǰ�ε�ֵ����0�������ӳ���
	lda		LCD_RamAddr,x				; ��Ŀ��ε��Դ���ض�bitλ��1������
	ora		P_Temp+3					; ��COM��SEG��Ϣ��LED RAM��ַ�����߼������

	sta		LCD_RamAddr,x
	bra		L_Inc_Dis_Index_Digit_7bit	; ��ת����ʾ�������ӵ��ӳ���
L_CLR_7bit:	
	lda		LCD_RamAddr,x				; ����LED RAM�ĵ�ַ
	ora		P_Temp+3					; ����1ȷ��״̬�����ת��0
	eor		P_Temp+3
	sta		LCD_RamAddr,x				; �����д��LED RAM�������Ӧλ�á�
L_Inc_Dis_Index_Digit_7bit:
	inc		P_Temp+1					; ����ƫ������������һ����
	dec		P_Temp+2					; �ݼ�ʣ��Ҫ��ʾ�Ķ���
	bne		L_Judge_Dis_7Bit_DigitDot	; ʣ�����Ϊ0�򷵻�
	rts




;===========================================================
;@brief		��ʾ1���߲���ʾ
;@para:		A = 0~1
;			X = offset	
;@impact:	X��A
;===========================================================
L_Dis_1Bit_DigitDot:
	bne		One_Digit
	ldx		#lcd_d0						; ������ʾ
	jsr		F_ClrSymbol
	rts
One_Digit:
	ldx		#lcd_d0						; һ����ʾbc����
	jsr		F_DisSymbol
	rts




;-----------------------------------------
;@brief:	�����Ļ��㡢��㺯��,һ������MS��ʾ
;@para:		X = offset
;@impact:	A, X, P_Temp
;-----------------------------------------
F_DisSymbol:
	jsr		F_DisSymbol_Com
	sta		LCD_RamAddr,x				; ����
	rts

F_ClrSymbol:
	jsr		F_DisSymbol_Com				; ���
	eor		P_Temp
	sta		LCD_RamAddr,x
	rts

F_DisSymbol_Com:
	lda		Lcd_bit,x					; ����֪Ŀ��ε�bitλ
	sta		P_Temp
	lda		Lcd_byte,x					; ����֪Ŀ��εĵ�ַ
	tax
	lda		LCD_RamAddr,x				; ��Ŀ��ε��Դ���ض�bitλ��1������
	ora		P_Temp
	rts


;============================================================
Table_Digit_7bit:
	.byte	$3f	; 0
	.byte	$06	; 1
	.byte	$5b	; 2
	.byte	$4f	; 3
	.byte	$66	; 4
	.byte	$6d	; 5
	.byte	$7d	; 6
	.byte	$07	; 7
	.byte	$7f	; 8
	.byte	$6f	; 9
	.byte	$00	; undisplay

Table_Word_7bit:
	.byte	$61 ; c 0
	.byte	$71	; F 1
	.byte	$5c	; o 2
	.byte	$37	; N 3
	.byte	$77	; A 4
	.byte	$5e	; d 5
	.byte	$73	; p 6
	.byte	$76	; H 7
	.byte	$50	; r 8
	.byte	$40	; - 9

Table_Week_7bit:
	.byte	$01	; SUN
	.byte	$02	; MON
	.byte	$04	; TUE
	.byte	$08	; WED
	.byte	$10	; THU
	.byte	$20	; FRI
	.byte	$40	; SAT
	.byte	$00	; undisplay

Table_COMx_SEL:
	.byte	$f7	; COM0_SEL
	.byte	$fb	; COM1_SEL
	.byte	$fd	; COM2_SEL
