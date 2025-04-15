; 按键处理
F_KeyHandler:
	bbs2	Key_Flag,L_Key4Hz					; 快加到来则4Hz扫一次，控制快加频率
	bbr1	Key_Flag,L_KeyScan					; 首次按键触发
	rmb1	Key_Flag							; 复位首次触发
	jsr		L_KeyDelay
	lda		PC
	and		#$7e
	bne		L_KeyYes							; 检测是否有按键触发
	jmp		L_KeyExit
L_KeyYes:
	sta		PA_IO_Backup
	bra		L_KeyHandle							; 首次触发处理结束

L_Key4Hz:
	bbr2	Timer_Flag,L_KeyScanExit
	rmb2	Timer_Flag
L_KeyScan:										; 长按处理部分
	bbr0	Key_Flag,L_KeyExit					; 没有扫键标志则为无按键处理了

	bbr4	Timer_Flag,L_KeyScanExit			; 没开始快加时，用42Hz扫描
	rmb4	Timer_Flag
	lda		PA
	and		#$7e
	bne		L_4_42Hz_Count						; 扫描到无任何按键按下，则退出
	bra		L_KeyExit
L_4_42Hz_Count:
	bbs2	Key_Flag,Counter_NoAdd				; 在快加触发后不再继续增加计数
	inc		QuickAdd_Counter					; 否则计数溢出后会导致不触发按键功能
Counter_NoAdd:
	lda		QuickAdd_Counter
	cmp		#84
	bcs		L_QuikAdd
	rts											; 长按计时，必须满2S才有快加
L_QuikAdd:
	bbs2	Key_Flag,NoQuikAdd_Beep
NoQuikAdd_Beep:
	smb2	Key_Flag
	rmb2	Timer_Flag
	smb2	Timer_Switch						; 开启4Hz计时

L_KeyHandle:
	lda		PC
	and		#$7e
	cmp		#$02
	bne		No_KeyHTrigger						; 由于跳转指令寻址能力的问题，这里采用jmp进行跳转
	jmp		L_KeyHTrigger						; H键触发
No_KeyHTrigger:
	cmp		#$04
	bne		No_KeyMTrigger
	jmp		L_KeyMTrigger						; M键触发
No_KeyMTrigger:
	cmp		#$08
	bne		No_KeyBTrigger
	jmp		L_KeyBTrigger						; B键触发
No_KeyBTrigger:
	cmp		#$10
	bne		No_KeyCTrigger
	jmp		L_KeyCTrigger						; C键触发
No_KeyCTrigger:
	cmp		#$20
	bne		No_KeyATrigger
	jmp		L_KeyATrigger						; A键触发
No_KeyATrigger:
	cmp		#$40
	bne		L_KeyExit
	jmp		L_KeyTTrigger						; T键触发

L_KeyExit:
	bbr0	Sys_Status_Flag,KeepScan			; 若不处于时显模式则不关闭42Hz扫描
	rmb6	IER
	rmb4	Timer_Switch						; 关闭42Hz、4Hz计时
	rmb2	Timer_Switch
KeepScan:
	lda		#0									; 清理相关变量、标志位
	sta		QuickAdd_Counter
	sta		Key_Flag

	jsr		F_PortWaitKey_Mode					; 将PA和PC口还原回等待中断唤醒模式

	rmb4	IFR									; 复位标志位,避免中断开启时直接进入中断服务
	smb4	IER									; 按键处理结束，重新开启PA口中断
L_KeyScanExit:
	rts




; 按键触发函数，判断每个按键触发后的响应条件，根据当前的状态不同，进不同的功能函数
L_KeyHTrigger:
	jsr		L_Key_Backlight						; 顶键会亮背光
	jsr		L_Key_UniversalHandle

	bbr0	Sys_Status_Flag,?No_TimeDisMode
	jmp		L_KeyExit							; 时间显示模式下H键无功能
?No_TimeDisMode:
	bbr1	Sys_Status_Flag,?No_AlarmSetMode
	jmp		Alarm_HourAdd						; 闹钟小时增加
?No_AlarmSetMode:
	bbr1	Sys_Status_Flag,?No_TimeSetMode
	jmp		Time_HourAdd						; 时钟小时增加
?No_TimeSetMode:
	jmp		L_KeyExit
	


L_KeyMTrigger:
	jsr		L_Key_Backlight						; 顶键会亮背光
	jsr		L_Key_UniversalHandle

	bbr0	Sys_Status_Flag,?No_TimeDisMode
	jmp		L_KeyExit							; 时间显示模式下M键无功能
?No_TimeDisMode:
	bbr1	Sys_Status_Flag,?No_AlarmSetMode
	jmp		Alarm_MinAdd						; 闹钟分钟增加
?No_AlarmSetMode:
	bbr1	Sys_Status_Flag,?No_TimeSetMode
	jmp		Time_MinAdd							; 时钟分钟增加
?No_TimeSetMode:
	jmp		L_KeyExit


L_KeyBTrigger:
	jsr		L_Key_Backlight						; 顶键会亮背光
	jsr		L_Key_UniversalHandle

	jmp		L_KeyExit


L_KeyCTrigger:
	jsr		L_Key_UniversalHandle

	lda		Alarm_Switch
	eor		#%01
	sta		Alarm_Switch
	jsr		F_SymbolRegulate					; 开关闹钟

	jmp		L_KeyExit


L_KeyATrigger:
	jsr		L_Key_UniversalHandle

	bbr0	Sys_Status_Flag,?No_TimeDisMode
	lda		#%010
	sta		Sys_Status_Flag
	jsr		F_Display_Alarm
?No_TimeDisMode:
	jmp		L_KeyExit


L_KeyTTrigger:
	jsr		L_Key_UniversalHandle

	bbr0	Sys_Status_Flag,?No_TimeDisMode
	lda		#%100
	sta		Sys_Status_Flag
	jsr		F_Display_Time
?No_TimeDisMode:
	jmp		L_KeyExit





; 按键通用处理
L_Key_UniversalHandle:
	bbr1	Clock_Flag,No_AlarmLouding

	lda		PC
	and		#$0e
	beq		No_KeySNZ
	smb2	Clock_Flag							; 若是顶键打断响闹则开启贪睡
No_KeySNZ:
	jsr		L_CloseLoud							; 打断响闹
	pla
	pla
	jmp		L_KeyExit
No_AlarmLouding:
	bbr2	Clock_Flag,?No_AlarmSnooze			; 无响闹时，再判断是否需要打断贪睡
	rmb2	Clock_Flag							; 打断贪睡
	jsr		L_CloseLoud							; 打断响闹
	pla
	pla
	jmp		L_KeyExit
?No_AlarmSnooze:
	rts


; 开启背光
L_Key_Backlight:
	lda		#0
	sta		Backlight_Counter
	smb0	Backlight_Flag
	rts




F_Is_KeyTKeep:
	bbs3	Timer_Flag,L_QA_KeyTKeep			; 有快加时不退出
	bbr6	PA,L_NoKeyT_Keep
L_QA_KeyTKeep:
	rts
L_NoKeyT_Keep:
	lda		#0									; 清理相关变量
	sta		QuickAdd_Counter
	lda		#001B								; 回到走时模式
	sta		Sys_Status_Flag

	jsr		L_KeyExit
	jsr		F_Display_Time
	jsr		L_CloseLoud
	rts


F_Is_KeyAKeep:
	bbs3	Timer_Flag,L_QA_KeyAKeep			; 有快加时不退出
	bbr4	PA,L_NoKeyA_Keep
L_QA_KeyAKeep:
	rts
L_NoKeyA_Keep:
	lda		#0									; 清理相关变量
	sta		QuickAdd_Counter
	lda		#001B								; 回到走时模式
	sta		Sys_Status_Flag

	jsr		L_KeyExit
	jsr		F_Display_Time
	jsr		L_CloseLoud
	rts



; 按键矩阵设置为扫描模式
F_PortScanKey_Mode:
	lda		#$00
	sta		PA_DIR
	lda		#$04
	sta		PA									; PA2设置输出高

	lda		#$7e
	sta		PC_DIR
	lda		#$7e
	sta		PC									; PC1~6设置下拉输入
	rts


; 按键矩阵设置为等待触发模式
F_PortWaitKey_Mode:
	lda		#$04
	sta		PA_DIR
	lda		#$04
	sta		PA									; PA2设置下拉输入

	lda		#$0
	sta		PC_DIR
	lda		PC
	ora		#$7e
	sta		PC									; PC1~6输出高
	rts




L_KeyDelay:
	lda		#0
	sta		P_Temp
DelayLoop:
	inc		P_Temp
	bne		DelayLoop
	
	rts
