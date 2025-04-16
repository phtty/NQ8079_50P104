	.CHIP		W65C02S								; cpu��ѡ��
	.MACLIST	ON

CODE_BEG	EQU		F000H							; ��ʼ��ַ

PROG		SECTION OFFSET CODE_BEG					; �������ε�ƫ������CODE_BEG��ʼ��������֯������롣
.include	50Px1x.h								; ͷ�ļ�
.include	RAM.INC	
.include	Init.mac
.include	MACRO.mac

STACK_BOT		EQU		FFH							; ��ջ�ײ�
.PROG												; ����ʼ

V_RESET:
	nop
	nop
	nop
	ldx		#STACK_BOT
	txs												; ʹ�����ֵ��ʼ����ջָ�룬��ͨ����Ϊ�����ö�ջ�ĵײ���ַ��ȷ�����������ж�ջ����ȷʹ�á�
	lda		#$07									; #$97
	sta		SYSCLK									; ����ϵͳʱ��

	lda		#00										; ������RAM
	ldx		#$ff
	sta		$1800
L_Clear_Ram_Loop:
	sta		$1800,x
	dex
	bne		L_Clear_Ram_Loop

	jsr		F_ClearScreen							; ���Դ�

	lda		#$0
	sta		DIVC									; ��Ƶ����������ʱ����DIV�첽
	sta		IER										; �����ж�
	lda		FUSE
	sta		MF0										; Ϊ�ڲ�RC�����ṩУ׼����	

	jsr		F_Init_Sys								; ��ʼ������

	cli												; �����ж�

	jsr		F_BootScreen
	jsr		F_Display_Time
	jsr		F_DisCol								; S�㳣��
; ���Բ���
	;lda		#1
	;sta		Alarm_Switch
	bra		Global_Run


; ״̬��
MainLoop:
	smb4	SYSCLK
	sta		HALT									; ����
	rmb4	SYSCLK
Global_Run:											; ȫ����Ч�Ĺ��ܴ���
	jsr		F_KeyHandler
	jsr		F_BeepManage
	jsr		F_Backlight_Manage						; �������
	jsr		F_Time_Run								; ��ʱ
	jsr		F_Alarm_Handler							; �����ж�
	jsr		F_SymbolRegulate
Status_Juge:
	bbs0	Sys_Status_Flag,Status_DisTime
	bbs1	Sys_Status_Flag,Status_SetAlarm
	bbs2	Sys_Status_Flag,Status_SetTime

	bra		MainLoop
Status_DisTime:
	bra		MainLoop
Status_SetAlarm:
	jsr		F_Is_KeyAKeep
	bra		MainLoop
Status_SetTime:
	jsr		F_Is_KeyTKeep
	bra		MainLoop




F_Init_Sys:
	F_Init_SystemRam								; ��ʼ��ϵͳRAM���������жϵ籣����RAM
	F_Port_Init										; ��ʼ���õ���IO��
	F_Beep_Init

	F_Timer_Init
	F_LCD_Init
	rts




; �жϷ�����
V_IRQ:
	pha
	txa
	pha
	php
	lda		IER
	and		IFR
	sta		R_Int_Backup
	cld

	bbs0	R_Int_Backup,L_DivIrq
	bbs1	R_Int_Backup,L_Timer0Irq
	bbs2	R_Int_Backup,L_Timer1Irq
	bbs3	R_Int_Backup,L_Timer2Irq
	bbs4	R_Int_Backup,L_PaIrq
	bbs6	R_Int_Backup,L_LcdIrq
	jmp		L_EndIrq

L_DivIrq:
	rmb0	IFR									; ���жϱ�־λ
	jmp		I_DivIRQ_Handler

L_Timer0Irq:
	rmb1	IFR									; ���жϱ�־λ
	jmp		I_Timer0IRQ_Handler

L_Timer1Irq:
	rmb2	IFR									; ���жϱ�־λ
	jmp		I_Timer1IRQ_Handler

L_Timer2Irq:									; ������ʱ�Ͱ�S����
	rmb3	IFR									; ���жϱ�־λ
	jmp		I_Timer2IRQ_Handler

L_PaIrq:										; ���ڰ���
	rmb4	IFR									; ���жϱ�־λ
	jmp		I_PaIRQ_Handler

L_LcdIrq:										; ���ڰ���ɨ�衢��������Ϳ�Ӽ��
	rmb6	IFR									; ���жϱ�־λ
	jmp		I_LcdIRQ_Handler

L_EndIrq:
	plp
	pla
	tax
	pla
	rti

.include	IRQ.asm
.include	ScanKey.asm
.include	KeyFunction.asm
.include	Disp.asm
.include	Display.asm
.include	LcdTab.asm
.include	Beep.asm
.include	Backlight.asm
.include	Time.asm
.include	Alarm.asm
.include	BootScreen.asm



.BLKB	0FFFFH-$,0FFH							; �ӵ�ǰ��ַ��FFFFȫ�����0xFF

.ORG	0FFF8H
	DB		C_RST_SEL+C_VOLT_V30+C_OMS0
	DB		C_PB32IS+C_PROTB
	DW		0FFFFH

.ORG	0FFFCH
	DW		V_RESET
	DW		V_IRQ


.ENDS
.END
