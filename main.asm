	.CHIP		W65C02S								; cpu的选型
	.MACLIST	ON

CODE_BEG	EQU		F000H							; 起始地址

PROG		SECTION OFFSET CODE_BEG					; 定义代码段的偏移量从CODE_BEG开始，用于组织程序代码。
.include	50Px1x.h								; 头文件
.include	RAM.INC	
.include	Init.mac
.include	MACRO.mac

STACK_BOT		EQU		FFH							; 堆栈底部
.PROG												; 程序开始

V_RESET:
	nop
	nop
	nop
	ldx		#STACK_BOT
	txs												; 使用这个值初始化堆栈指针，这通常是为了设置堆栈的底部地址，确保程序运行中堆栈的正确使用。
	lda		#$07									; #$97
	sta		SYSCLK									; 设置系统时钟

	lda		#00										; 清整个RAM
	ldx		#$ff
	sta		$1800
L_Clear_Ram_Loop:
	sta		$1800,x
	dex
	bne		L_Clear_Ram_Loop

	jsr		F_ClearScreen							; 清显存

	lda		#$0
	sta		DIVC									; 分频控制器，定时器与DIV异步
	sta		IER										; 除能中断
	lda		FUSE
	sta		MF0										; 为内部RC振荡器提供校准数据	

	jsr		F_Init_Sys								; 初始化外设

	cli												; 开总中断

	jsr		F_BootScreen
	jsr		F_Display_Time
	jsr		F_DisCol								; S点常亮
; 测试部分
	;lda		#1
	;sta		Alarm_Switch
	bra		Global_Run


; 状态机
MainLoop:
	smb4	SYSCLK
	sta		HALT									; 休眠
	rmb4	SYSCLK
Global_Run:											; 全局生效的功能处理
	jsr		F_KeyHandler
	jsr		F_BeepManage
	jsr		F_Backlight_Manage						; 背光管理
	jsr		F_Time_Run								; 走时
	jsr		F_Alarm_Handler							; 响闹判断
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
	F_Init_SystemRam								; 初始化系统RAM并禁用所有断电保留的RAM
	F_Port_Init										; 初始化用到的IO口
	F_Beep_Init

	F_Timer_Init
	F_LCD_Init
	rts




; 中断服务函数
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
	rmb0	IFR									; 清中断标志位
	jmp		I_DivIRQ_Handler

L_Timer0Irq:
	rmb1	IFR									; 清中断标志位
	jmp		I_Timer0IRQ_Handler

L_Timer1Irq:
	rmb2	IFR									; 清中断标志位
	jmp		I_Timer1IRQ_Handler

L_Timer2Irq:									; 用于走时和半S更新
	rmb3	IFR									; 清中断标志位
	jmp		I_Timer2IRQ_Handler

L_PaIrq:										; 用于按键
	rmb4	IFR									; 清中断标志位
	jmp		I_PaIRQ_Handler

L_LcdIrq:										; 用于按键扫描、蜂鸣间隔和快加间隔
	rmb6	IFR									; 清中断标志位
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



.BLKB	0FFFFH-$,0FFH							; 从当前地址到FFFF全部填充0xFF

.ORG	0FFF8H
	DB		C_RST_SEL+C_VOLT_V30+C_OMS0
	DB		C_PB32IS+C_PROTB
	DW		0FFFFH

.ORG	0FFFCH
	DW		V_RESET
	DW		V_IRQ


.ENDS
.END
