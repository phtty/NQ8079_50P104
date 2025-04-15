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




; 6bit����	lcd_d2
L_Dis_6Bit_DigitDot:
	stx		P_Temp+1					; ƫ�����ݴ��P_Temp+3, �ڳ�X������ַѰַ
	sta		P_Temp						; ����ʾ������ת��Ϊ�ڴ�ƫ����

	tax
	lda		Table_Digit_6bit,x			; ����ʾ������ͨ������ҵ���Ӧ�Ķ�����A
	sta		P_Temp						; �ݴ����ֵ��P_Temp

	ldx		P_Temp+1					; ��ƫ����ȡ��
	stx		P_Temp+1					; �ݴ�ƫ������P_Temp+3
	lda		#6
	sta		P_Temp+2					; ������ʾ����Ϊ6
L_Judge_Dis_6Bit_DigitDot				; ��ʾѭ���Ŀ�ʼ
	ldx		P_Temp+1					; ȡ��ƫ������Ϊ����
	lda		Lcd_bit,x					; ���λĿ��ε�bitλ
	sta		P_Temp+3	
	lda		Lcd_byte,x					; ���λĿ��ε��Դ��ַ
	tax
	ror		P_Temp						; ѭ������ȡ��Ŀ�������������
	bcc		L_CLR_6bit					; ��ǰ�ε�ֵ����0�������ӳ���
	lda		LCD_RamAddr,x				; ��Ŀ��ε��Դ���ض�bitλ��1������
	ora		P_Temp+3
	sta		LCD_RamAddr,x
	bra		L_Inc_Dis_Index_Prog_6bit	; ��ת����ʾ�������ӵ��ӳ���
L_CLR_6bit:	
	lda		LCD_RamAddr,x				; ����LCD RAM�ĵ�ַ
	ora		P_Temp+3					; ��COM��SEG��Ϣ��LCD RAM��ַ�����߼������
	eor		P_Temp+3					; ���������������������Ӧ�ĶΡ�
	sta		LCD_RamAddr,x				; �����д��LCD RAM�������Ӧλ�á�
L_Inc_Dis_Index_Prog_6bit:
	inc		P_Temp+1					; ����ƫ������������һ����
	dec		P_Temp+2					; �ݼ�ʣ��Ҫ��ʾ�Ķ���
	bne		L_Judge_Dis_6Bit_DigitDot	; ʣ�����Ϊ0�򷵻�
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

Table_Digit_6bit:
	.byte	$1f	; 0
	.byte	$06	; 1
	.byte	$2b	; 2
	.byte	$27	; 3
	.byte	$36	; 4
	.byte	$35	; 5
	.byte	$00	; undisplay