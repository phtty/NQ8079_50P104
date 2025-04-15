;--------COM------------
c0		EQU		0
c1		EQU		1
c2		EQU		2
c3		EQU		3
c4		EQU		4
c5		EQU		5
;;--------SEG------------
s44		EQU		44
s43		EQU		43
s42		EQU		42
s41		EQU		41
s40		EQU		40
s39		EQU		39
s38		EQU		38
s37		EQU		37
s36		EQU		36
s35		EQU		35
s34		EQU		34
s33		EQU		33
s32		EQU		32
s31		EQU		31
s30		EQU		30
s29		EQU		29
s28		EQU		28
s27		EQU		27
s26		EQU		26
s25		EQU		25
s24		EQU		24
s23		EQU		23
s22		EQU		22
s21		EQU		21
s20		EQU		20
s19		EQU		19
s18		EQU		18
s17		EQU		17
s16		EQU		16
s15		EQU		15
s14		EQU		14
s13		EQU		13
s12		EQU		12
s11		EQU		11
s10		EQU		10
s9		EQU		9
s8		EQU		8
s7		EQU		7
s6		EQU		6
s5		EQU		5
s4		EQU		4
s3		EQU		3
s2		EQU		2
s1		EQU		1
s0		EQU		0

; LCD显示，每个COM占用6个byte
.MACRO	db_c_s	com,seg
		.byte	com*6+seg/8
.ENDMACRO

.MACRO	db_c_y	com,seg
		.byte	1.shl.(seg-seg/8*8)
.ENDMACRO

Lcd_byte:							;段码<==>SEG/COM表
lcd_table:
lcd_d0	equ	$-lcd_table
	db_c_s	c1,s43	; 0BC

lcd_d1	equ	$-lcd_table
	db_c_s	c1,s41	; 1A
	db_c_s	c1,s40	; 1B
	db_c_s	c0,s40	; 1C
	db_c_s	c0,s43	; 1D
	db_c_s	c0,s42 	; 1E
	db_c_s	c1,s42	; 1F
	db_c_s	c0,s41	; 1G

lcd_d2	equ	$-lcd_table
	db_c_s	c1,s14	; 2AD
	db_c_s	c1,s13	; 2B
	db_c_s	c0,s13	; 2C
	db_c_s	c0,s15	; 2E
	db_c_s	c1,s15	; 2F
	db_c_s	c0,s14	; 2G

lcd_d3	equ	$-lcd_table
	db_c_s	c1,s10	; 3A
	db_c_s	c1,s9	; 3B
	db_c_s	c0,s9	; 3C
	db_c_s	c0,s8	; 3D
	db_c_s	c0,s11	; 3E
	db_c_s	c1,s11	; 3F
	db_c_s	c0,s10	; 3G

lcd_dot:
lcd_PM		equ	$-lcd_table
	db_c_s	c1,s44	; PM
lcd_bell	equ	$-lcd_table
	db_c_s	c1,s8	; bell
lcd_COL		equ	$-lcd_table
	db_c_s	c0,s44	; COL
lcd_Zz		equ	$-lcd_table
	db_c_s	c0,s12	; Zz


;==========================================================
;==========================================================

Lcd_bit:
	db_c_y	c1,s43	; 0BC

	db_c_y	c1,s41	; 1A
	db_c_y	c1,s40	; 1B
	db_c_y	c0,s40	; 1C
	db_c_y	c0,s43	; 1D
	db_c_y	c0,s42 	; 1E
	db_c_y	c1,s42	; 1F
	db_c_y	c0,s41	; 1G

	db_c_y	c1,s14	; 2AD
	db_c_y	c1,s13	; 2B
	db_c_y	c0,s13	; 2C
	db_c_y	c0,s15	; 2E
	db_c_y	c1,s15	; 2F
	db_c_y	c0,s14	; 2G

	db_c_y	c1,s10	; 3A
	db_c_y	c1,s9	; 3B
	db_c_y	c0,s9	; 3C
	db_c_y	c0,s8	; 3D
	db_c_y	c0,s11	; 3E
	db_c_y	c1,s11	; 3F
	db_c_y	c0,s10	; 3G

	db_c_y	c1,s44	; PM
	db_c_y	c1,s8	; bell
	db_c_y	c0,s44	; COL
	db_c_y	c0,s12	; Zz