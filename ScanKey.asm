; 按键处理
F_KeyHandler:
	bbr1	Key_Flag,L_KeyScan					; 非首次按键触发则不消抖
	rmb1	Key_Flag
	jsr		L_KeyDelay
	jsr		L_KeyDelay
	lda		PC
	and		#$7e
	bne		L_KeyHandle							; 延时后检测是否有按键触发
	jmp		L_KeyExit
L_KeyScan:										; 长按处理部分
	bbr0	Key_Flag,L_KeyScanExit				; 没有扫键标志则为无按键处理了

	lda		Depress_Detect
	beq		No_DepressDetect
	bbr0	Depress_Detect,KeyH_NoDpreess		; 松键检测，阻塞按键功能，防止扫键时多次执行
	bbs1	PC,KeyH_NoDpreess					; 键若压下则说明没有松键
	jsr		QuickAdd_Reset
	rmb0	Depress_Detect						; 复位H键松键检测

KeyH_NoDpreess:
	bbr1	Depress_Detect,KeyM_NoDpreess
	bbs2	PC,KeyM_NoDpreess
	jsr		QuickAdd_Reset						; 清空快加相关资源
	rmb1	Depress_Detect						; 复位M键松键检测

KeyM_NoDpreess:
	bbr2	Depress_Detect,KeyB_NoDpreess
	bbs3	PC,KeyB_NoDpreess
	rmb2	Depress_Detect						; 复位B键松键检测

KeyB_NoDpreess:
	bbr3	Depress_Detect,No_DepressDetect
	bbs4	PC,No_DepressDetect
	rmb3	Depress_Detect						; 复位C键松键检测

No_DepressDetect:
	lda		PC
	and		#$7e
	bne		L_KeyHandle							; 扫描到无任何按键按下，则退出
	bra		L_KeyExit

L_KeyHandle:
	bbr1	PC,No_KeyHTrigger					; 由于跳转指令寻址能力的问题，这里采用jmp进行跳转
	jmp		L_KeyHTrigger						; H键触发
No_KeyHTrigger:
	bbr2	PC,No_KeyMTrigger
	jmp		L_KeyMTrigger						; M键触发
No_KeyMTrigger:
	bbr3	PC,No_KeyBTrigger
	jmp		L_KeyBTrigger						; B键触发
No_KeyBTrigger:
	bbr4	PC,No_KeyCTrigger
	jmp		L_KeyCTrigger						; C键触发
No_KeyCTrigger:
	lda		PC
	and		#$60
	cmp		#$20
	bne		No_KeyATrigger
	jmp		L_KeyATrigger						; A键触发
No_KeyATrigger:
	cmp		#$40
	bne		L_KeyExit
	jmp		L_KeyTTrigger						; T键触发

L_KeyExit:
	rmb6	IER
	rmb4	Timer_Switch						; 关闭42Hz、4Hz计时
	rmb2	Timer_Switch
	lda		#001B								; 回到走时模式并显示
	sta		Sys_Status_Flag
	jsr		F_Display_Time

	lda		#0									; 清理相关变量、标志位
	sta		QuickAdd_Counter
	sta		Key_Flag

	jsr		F_PortWaitKey_Mode					; 将PA和PC口还原回等待中断唤醒模式

	rmb4	IFR									; 复位标志位,避免中断开启时直接进入中断服务
	smb4	IER									; 按键处理结束，重新开启PA口中断
L_KeyScanExit:
	rts



; 快加检测
Is_QuickAdd:
	bbs3	Key_Flag,QuickAdd_4Hz_Juge
	bbs2	Key_Flag,QuickAdd_Block_Juge
	smb2	Key_Flag
	rts											; 在没有快加阻塞和快加间隔的情况下为首次按键功能，执行按键功能
QuickAdd_Block_Juge:
	bbr4	Timer_Flag,No_KeyFunction
	rmb4	Timer_Flag
	lda		QuickAdd_Counter
	cmp		#63
	bcs		QuickAdd_Trigger					; 快加判断，计数84个42Hz则触发快加
	inc		QuickAdd_Counter
	bra		No_KeyFunction
QuickAdd_Trigger:
	smb2	Timer_Switch						; 开启4Hz计数和快加间隔标志
	smb3	Key_Flag
	rmb2	Timer_Flag
	rts
QuickAdd_4Hz_Juge:
	bbr2	Timer_Flag,No_KeyFunction
	rmb2	Timer_Flag							; 快加触发后，4Hz进一次按键功能
	rts
No_KeyFunction:
	pla
	pla
	rts

QuickAdd_Reset:
	rmb2	Key_Flag
	rmb3	Key_Flag							; 清空快加相关资源
	rmb2	Timer_Switch
	lda		#0
	sta		QuickAdd_Counter
	rts




; 按键触发函数，判断每个按键触发后的响应条件，根据当前的状态不同，进不同的功能函数
L_KeyHTrigger:
	smb0	Depress_Detect
	jsr		Is_QuickAdd
	jsr		L_Key_Backlight						; 顶键会亮背光
	jsr		L_Key_UniversalHandle

	bbr0	Sys_Status_Flag,?No_TimeDisMode
	rts											; 时间显示模式下H键无功能
?No_TimeDisMode:
	bbr1	Sys_Status_Flag,?No_AlarmSetMode
	jmp		Alarm_HourAdd						; 闹钟小时增加
?No_AlarmSetMode:
	bbr2	Sys_Status_Flag,?No_TimeSetMode
	jmp		Time_HourAdd						; 时钟小时增加
?No_TimeSetMode:
	rts
	


L_KeyMTrigger:
	smb1	Depress_Detect
	jsr		Is_QuickAdd
	jsr		L_Key_Backlight						; 顶键会亮背光
	jsr		L_Key_UniversalHandle

	bbr0	Sys_Status_Flag,?No_TimeDisMode
	rts											; 时间显示模式下M键无功能
?No_TimeDisMode:
	bbr1	Sys_Status_Flag,?No_AlarmSetMode
	jmp		Alarm_MinAdd						; 闹钟分钟增加
?No_AlarmSetMode:
	bbr2	Sys_Status_Flag,?No_TimeSetMode
	jmp		Time_MinAdd							; 时钟分钟增加
?No_TimeSetMode:
	rts


L_KeyBTrigger:
	bbr2	Depress_Detect,KeyB_Fuction			; 开启松键检测时，不执行按键功能
	rts
KeyB_Fuction:
	smb2	Depress_Detect
	jsr		L_Key_Backlight						; 顶键会亮背光
	jsr		L_Key_UniversalHandle

	rts


L_KeyCTrigger:
	bbr3	Depress_Detect,KeyC_Fuction			; 开启松键检测时，不执行按键功能
	rts
KeyC_Fuction:
	smb3	Depress_Detect
	jsr		L_Key_UniversalHandle

	lda		Alarm_Switch
	eor		#%01
	sta		Alarm_Switch
	jsr		F_SymbolRegulate					; 开关闹钟

	rts


L_KeyATrigger:
	jsr		L_Key_UniversalHandle

	bbr0	Sys_Status_Flag,?No_TimeDisMode
	lda		#%010
	sta		Sys_Status_Flag
	jsr		F_Display_Alarm
?No_TimeDisMode:
	rts


L_KeyTTrigger:
	jsr		L_Key_UniversalHandle

	bbr0	Sys_Status_Flag,?No_TimeDisMode
	lda		#%100
	sta		Sys_Status_Flag
	jsr		F_Display_Time
?No_TimeDisMode:
	rts





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
	rts
No_AlarmLouding:
	bbr2	Clock_Flag,?No_AlarmSnooze			; 无响闹时，再判断是否需要打断贪睡
	rmb2	Clock_Flag							; 打断贪睡
	jsr		L_CloseLoud							; 打断响闹
	pla
	pla
?No_AlarmSnooze:
	rts


; 开启背光
L_Key_Backlight:
	lda		#0
	sta		Backlight_Counter
	smb0	Backlight_Flag
	smb1	Backlight_Flag
	lda		#$7f
	sta		PC
	rts




; T键判空
F_Is_KeyTKeep:
	bbr2	Sys_Status_Flag,L_QA_KeyA_NoJuge
	bbs3	Key_Flag,L_QA_KeyT_NoJuge			; 有快加时不退出
	bbr6	PC,L_NoKeyT_Keep
L_QA_KeyT_NoJuge:
	rts
L_NoKeyT_Keep:
	jsr		L_KeyExit
	jsr		L_CloseLoud
	rts


; A键判空
F_Is_KeyAKeep:
	bbr1	Sys_Status_Flag,L_QA_KeyA_NoJuge
	bbs3	Key_Flag,L_QA_KeyA_NoJuge			; 有快加时不退出
	bbr5	PC,L_NoKeyA_Keep
L_QA_KeyA_NoJuge:
	rts
L_NoKeyA_Keep:
	jsr		L_KeyExit
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
