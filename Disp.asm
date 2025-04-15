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
;@brief		显示完整的一个数字
;@para:		A = 0~9
;			X = offset	
;@impact:	P_Temp，P_Temp+1，P_Temp+2，P_Temp+3, X，A
;===========================================================
L_Dis_7Bit_DigitDot:
	stx		P_Temp+1					; 偏移量暂存进P_Temp+2, 腾出X来做变址寻址

	tax
	lda		Table_Digit_7bit,x			; 将显示的数字通过查表找到对应的段码存进A
	sta		P_Temp						; 暂存段码值到P_Temp

	lda		#7
	sta		P_Temp+2					; 设置显示段数为7
L_Judge_Dis_7Bit_DigitDot:				; 显示循环的开始
	ldx		P_Temp+1					; 表头偏移量->X
	lda		Lcd_bit,x					; 查表定位目标段的bit位
	sta		P_Temp+3					; bit位->P_Temp+3
	lda		Lcd_byte,x					; 查表定位目标段的显存地址
	tax									; 显存地址偏移->X
	ror		P_Temp						; 循环右移取得目标段是亮或者灭
	bcc		L_CLR_7bit					; 当前段的值若是0则进清点子程序
	lda		LCD_RamAddr,x				; 将目标段的显存的特定bit位置1来打亮
	ora		P_Temp+3					; 将COM和SEG信息与LED RAM地址进行逻辑或操作

	sta		LCD_RamAddr,x
	bra		L_Inc_Dis_Index_Digit_7bit	; 跳转到显示索引增加的子程序。
L_CLR_7bit:	
	lda		LCD_RamAddr,x				; 加载LED RAM的地址
	ora		P_Temp+3					; 先置1确定状态再异或翻转成0
	eor		P_Temp+3
	sta		LCD_RamAddr,x				; 将结果写回LED RAM，清除对应位置。
L_Inc_Dis_Index_Digit_7bit:
	inc		P_Temp+1					; 递增偏移量，处理下一个段
	dec		P_Temp+2					; 递减剩余要显示的段数
	bne		L_Judge_Dis_7Bit_DigitDot	; 剩余段数为0则返回
	rts




;===========================================================
;@brief		显示1或者不显示
;@para:		A = 0~1
;			X = offset	
;@impact:	X，A
;===========================================================
L_Dis_1Bit_DigitDot:
	bne		One_Digit
	ldx		#lcd_d0						; 零则不显示
	jsr		F_ClrSymbol
	rts
One_Digit:
	ldx		#lcd_d0						; 一则显示bc两段
	jsr		F_DisSymbol
	rts




;-----------------------------------------
;@brief:	单独的画点、清点函数,一般用于MS显示
;@para:		X = offset
;@impact:	A, X, P_Temp
;-----------------------------------------
F_DisSymbol:
	jsr		F_DisSymbol_Com
	sta		LCD_RamAddr,x				; 画点
	rts

F_ClrSymbol:
	jsr		F_DisSymbol_Com				; 清点
	eor		P_Temp
	sta		LCD_RamAddr,x
	rts

F_DisSymbol_Com:
	lda		Lcd_bit,x					; 查表得知目标段的bit位
	sta		P_Temp
	lda		Lcd_byte,x					; 查表得知目标段的地址
	tax
	lda		LCD_RamAddr,x				; 将目标段的显存的特定bit位置1来打亮
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
