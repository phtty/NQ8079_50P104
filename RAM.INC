.Kdata
;***************************************
; RAM Address
;***************************************
RamStarAddr		EQU		1800H											;RAM的开始地址
LCD_RamAddr		EQU		RamStarAddr										;LCD RAM的地址
Time_Addr		EQU		RamStarAddr+Time_Str_Addr-Page0RamStarAddr		;事件相关数据的地址
;***************************************
;Time_Addr		EUQ		B0H
;***************************************
.PAGE0     ;page 0的内存布局
;***************************************
;---------------------------------------------------------------------
	ORG	0080H
Page0RamStarAddr		EQU		$
LCDRAM					DS		6*6

R_Int_Backup			DS		1

Counter_1Hz				DS		1
Counter_4Hz				DS		1
Counter_21Hz			DS		1
Counter_42Hz			DS		1

QuickAdd_Counter		DS		1
Backlight_Counter		DS		1
Louding_Counter			DS		1

Clock_Flag				DS		1
;bit0 = 1 闹钟触发
;bit1 = 1 响闹模式
;bit2 = 1 贪睡模式
;bit3 = 1 

Alarm_Switch			DS		1
;bit0 = 1 闹钟1开启

Timer_Flag				DS		1
;bit0 = 1 1Hz标志
;bit1 = 1 2Hz标志
;bit2 = 1 4Hz标志
;bit3 = 1 21Hz标志
;bit4 = 1 42Hz标志

Timer_Switch			DS		1
;bit0 = 1 1Hz开关
;bit1 = 1 2Hz开关
;bit2 = 1 4Hz开关
;bit3 = 1 21Hz开关
;bit4 = 1 42Hz开关

Time_Flag				DS		1
;bit0 = 1 走时加时1S标志
;bit1 = 1 响闹加时1S标志
;bit2 = 1 闹钟判断标志
;bit3 = 1 
;bit4 = 1 
;bit5 = 1 
;bit6 = 1 

Symbol_Flag				DS		1	; 符号操作
;bit0 = 1 ALM点半S标志
;bit1 = 1 ALM点1S标志

Sys_Status_Flag			DS		1
;bit0 = 1 时钟显示
;bit1 = 1 设置闹钟
;bit2 = 1 设置时钟

;Sys_Status_Ordinal		DS		1
; 子模式的序号

Key_Flag				DS		1
;bit0 = 1 扫键标志位
;bit1 = 1 首次触发
;bit2 = 1 快加标志位
;bit3 = 1 长按4Hz标志

Backlight_Flag			DS		1
;bit0 = 1 开启背光
;bit1 = 1 背光开启加时1S
;bit2 = 1 


Beep_Serial				DS		1
;响铃序列

PA_IO_Backup			DS		1
PC_IO_Backup			DS		1
PD_IO_Backup			DS		1

;---------------------------------------
Time_Str_Addr			EQU		$
R_Time_Sec				DS		1	;时间秒
R_Time_Min				DS		1	;时间分
R_Time_Hour				DS		1	;时间小时
R_Alarm_Min				DS		1	;触发闹钟分
R_Alarm_Hour			DS		1	;触发闹钟小时

R_Snooze_Time			DS		1	;贪睡计时

;---------------------------------------       
P_Temp					DS		8
LED_Temp				DS		5
;---------------------------------------
;---------------------------------------
;***************************************
.ENDS
;***************************************
.Udata
;---------------------------------------
	ORG		1880H
;---------------------------------------
;---------------------------------------
.ENDS
