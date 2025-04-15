; ��������
F_KeyHandler:
	bbs2	Key_Flag,L_Key4Hz					; ��ӵ�����4Hzɨһ�Σ����ƿ��Ƶ��
	bbr1	Key_Flag,L_KeyScan					; �״ΰ�������
	rmb1	Key_Flag							; ��λ�״δ���
	jsr		L_KeyDelay
	lda		PC
	and		#$7e
	bne		L_KeyYes							; ����Ƿ��а�������
	jmp		L_KeyExit
L_KeyYes:
	sta		PA_IO_Backup
	bra		L_KeyHandle							; �״δ����������

L_Key4Hz:
	bbr2	Timer_Flag,L_KeyScanExit
	rmb2	Timer_Flag
L_KeyScan:										; ����������
	bbr0	Key_Flag,L_KeyExit					; û��ɨ����־��Ϊ�ް���������

	bbr4	Timer_Flag,L_KeyScanExit			; û��ʼ���ʱ����42Hzɨ��
	rmb4	Timer_Flag
	lda		PA
	and		#$7e
	bne		L_4_42Hz_Count						; ɨ�赽���κΰ������£����˳�
	bra		L_KeyExit
L_4_42Hz_Count:
	bbs2	Key_Flag,Counter_NoAdd				; �ڿ�Ӵ������ټ������Ӽ���
	inc		QuickAdd_Counter					; ������������ᵼ�²�������������
Counter_NoAdd:
	lda		QuickAdd_Counter
	cmp		#84
	bcs		L_QuikAdd
	rts											; ������ʱ��������2S���п��
L_QuikAdd:
	bbs2	Key_Flag,NoQuikAdd_Beep
NoQuikAdd_Beep:
	smb2	Key_Flag
	rmb2	Timer_Flag
	smb2	Timer_Switch						; ����4Hz��ʱ

L_KeyHandle:
	lda		PC
	and		#$7e
	cmp		#$02
	bne		No_KeyHTrigger						; ������תָ��Ѱַ���������⣬�������jmp������ת
	jmp		L_KeyHTrigger						; H������
No_KeyHTrigger:
	cmp		#$04
	bne		No_KeyMTrigger
	jmp		L_KeyMTrigger						; M������
No_KeyMTrigger:
	cmp		#$08
	bne		No_KeyBTrigger
	jmp		L_KeyBTrigger						; B������
No_KeyBTrigger:
	cmp		#$10
	bne		No_KeyCTrigger
	jmp		L_KeyCTrigger						; C������
No_KeyCTrigger:
	cmp		#$20
	bne		No_KeyATrigger
	jmp		L_KeyATrigger						; A������
No_KeyATrigger:
	cmp		#$40
	bne		L_KeyExit
	jmp		L_KeyTTrigger						; T������

L_KeyExit:
	bbr0	Sys_Status_Flag,KeepScan			; ��������ʱ��ģʽ�򲻹ر�42Hzɨ��
	rmb6	IER
	rmb4	Timer_Switch						; �ر�42Hz��4Hz��ʱ
	rmb2	Timer_Switch
KeepScan:
	lda		#0									; ������ر�������־λ
	sta		QuickAdd_Counter
	sta		Key_Flag

	jsr		F_PortWaitKey_Mode					; ��PA��PC�ڻ�ԭ�صȴ��жϻ���ģʽ

	rmb4	IFR									; ��λ��־λ,�����жϿ���ʱֱ�ӽ����жϷ���
	smb4	IER									; ����������������¿���PA���ж�
L_KeyScanExit:
	rts




; ���������������ж�ÿ���������������Ӧ���������ݵ�ǰ��״̬��ͬ������ͬ�Ĺ��ܺ���
L_KeyHTrigger:
	jsr		L_Key_Backlight						; ������������
	jsr		L_Key_UniversalHandle

	bbr0	Sys_Status_Flag,?No_TimeDisMode
	jmp		L_KeyExit							; ʱ����ʾģʽ��H���޹���
?No_TimeDisMode:
	bbr1	Sys_Status_Flag,?No_AlarmSetMode
	jmp		Alarm_HourAdd						; ����Сʱ����
?No_AlarmSetMode:
	bbr1	Sys_Status_Flag,?No_TimeSetMode
	jmp		Time_HourAdd						; ʱ��Сʱ����
?No_TimeSetMode:
	jmp		L_KeyExit
	


L_KeyMTrigger:
	jsr		L_Key_Backlight						; ������������
	jsr		L_Key_UniversalHandle

	bbr0	Sys_Status_Flag,?No_TimeDisMode
	jmp		L_KeyExit							; ʱ����ʾģʽ��M���޹���
?No_TimeDisMode:
	bbr1	Sys_Status_Flag,?No_AlarmSetMode
	jmp		Alarm_MinAdd						; ���ӷ�������
?No_AlarmSetMode:
	bbr1	Sys_Status_Flag,?No_TimeSetMode
	jmp		Time_MinAdd							; ʱ�ӷ�������
?No_TimeSetMode:
	jmp		L_KeyExit


L_KeyBTrigger:
	jsr		L_Key_Backlight						; ������������
	jsr		L_Key_UniversalHandle

	jmp		L_KeyExit


L_KeyCTrigger:
	jsr		L_Key_UniversalHandle

	lda		Alarm_Switch
	eor		#%01
	sta		Alarm_Switch
	jsr		F_SymbolRegulate					; ��������

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





; ����ͨ�ô���
L_Key_UniversalHandle:
	bbr1	Clock_Flag,No_AlarmLouding

	lda		PC
	and		#$0e
	beq		No_KeySNZ
	smb2	Clock_Flag							; ���Ƕ��������������̰˯
No_KeySNZ:
	jsr		L_CloseLoud							; �������
	pla
	pla
	jmp		L_KeyExit
No_AlarmLouding:
	bbr2	Clock_Flag,?No_AlarmSnooze			; ������ʱ�����ж��Ƿ���Ҫ���̰˯
	rmb2	Clock_Flag							; ���̰˯
	jsr		L_CloseLoud							; �������
	pla
	pla
	jmp		L_KeyExit
?No_AlarmSnooze:
	rts


; ��������
L_Key_Backlight:
	lda		#0
	sta		Backlight_Counter
	smb0	Backlight_Flag
	rts




F_Is_KeyTKeep:
	bbs3	Timer_Flag,L_QA_KeyTKeep			; �п��ʱ���˳�
	bbr6	PA,L_NoKeyT_Keep
L_QA_KeyTKeep:
	rts
L_NoKeyT_Keep:
	lda		#0									; ������ر���
	sta		QuickAdd_Counter
	lda		#001B								; �ص���ʱģʽ
	sta		Sys_Status_Flag

	jsr		L_KeyExit
	jsr		F_Display_Time
	jsr		L_CloseLoud
	rts


F_Is_KeyAKeep:
	bbs3	Timer_Flag,L_QA_KeyAKeep			; �п��ʱ���˳�
	bbr4	PA,L_NoKeyA_Keep
L_QA_KeyAKeep:
	rts
L_NoKeyA_Keep:
	lda		#0									; ������ر���
	sta		QuickAdd_Counter
	lda		#001B								; �ص���ʱģʽ
	sta		Sys_Status_Flag

	jsr		L_KeyExit
	jsr		F_Display_Time
	jsr		L_CloseLoud
	rts



; ������������Ϊɨ��ģʽ
F_PortScanKey_Mode:
	lda		#$00
	sta		PA_DIR
	lda		#$04
	sta		PA									; PA2���������

	lda		#$7e
	sta		PC_DIR
	lda		#$7e
	sta		PC									; PC1~6������������
	rts


; ������������Ϊ�ȴ�����ģʽ
F_PortWaitKey_Mode:
	lda		#$04
	sta		PA_DIR
	lda		#$04
	sta		PA									; PA2������������

	lda		#$0
	sta		PC_DIR
	lda		PC
	ora		#$7e
	sta		PC									; PC1~6�����
	rts




L_KeyDelay:
	lda		#0
	sta		P_Temp
DelayLoop:
	inc		P_Temp
	bne		DelayLoop
	
	rts
