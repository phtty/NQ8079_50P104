; ��������
F_KeyHandler:
	bbr1	Key_Flag,L_KeyScan					; ���״ΰ�������������
	rmb1	Key_Flag
	jsr		L_KeyDelay
	jsr		L_KeyDelay
	lda		PC
	and		#$7e
	bne		L_KeyHandle							; ��ʱ�����Ƿ��а�������
	jmp		L_KeyExit
L_KeyScan:										; ����������
	bbr0	Key_Flag,L_KeyScanExit				; û��ɨ����־��Ϊ�ް���������

	lda		Depress_Detect
	beq		No_DepressDetect
	bbr0	Depress_Detect,KeyH_NoDpreess		; �ɼ���⣬�����������ܣ���ֹɨ��ʱ���ִ��
	bbs1	PC,KeyH_NoDpreess					; ����ѹ����˵��û���ɼ�
	jsr		QuickAdd_Reset
	rmb0	Depress_Detect						; ��λH���ɼ����

KeyH_NoDpreess:
	bbr1	Depress_Detect,KeyM_NoDpreess
	bbs2	PC,KeyM_NoDpreess
	jsr		QuickAdd_Reset						; ��տ�������Դ
	rmb1	Depress_Detect						; ��λM���ɼ����

KeyM_NoDpreess:
	bbr2	Depress_Detect,KeyB_NoDpreess
	bbs3	PC,KeyB_NoDpreess
	rmb2	Depress_Detect						; ��λB���ɼ����

KeyB_NoDpreess:
	bbr3	Depress_Detect,No_DepressDetect
	bbs4	PC,No_DepressDetect
	rmb3	Depress_Detect						; ��λC���ɼ����

No_DepressDetect:
	lda		PC
	and		#$7e
	bne		L_KeyHandle							; ɨ�赽���κΰ������£����˳�
	bra		L_KeyExit

L_KeyHandle:
	bbr1	PC,No_KeyHTrigger					; ������תָ��Ѱַ���������⣬�������jmp������ת
	jmp		L_KeyHTrigger						; H������
No_KeyHTrigger:
	bbr2	PC,No_KeyMTrigger
	jmp		L_KeyMTrigger						; M������
No_KeyMTrigger:
	bbr3	PC,No_KeyBTrigger
	jmp		L_KeyBTrigger						; B������
No_KeyBTrigger:
	bbr4	PC,No_KeyCTrigger
	jmp		L_KeyCTrigger						; C������
No_KeyCTrigger:
	lda		PC
	and		#$60
	cmp		#$20
	bne		No_KeyATrigger
	jmp		L_KeyATrigger						; A������
No_KeyATrigger:
	cmp		#$40
	bne		L_KeyExit
	jmp		L_KeyTTrigger						; T������

L_KeyExit:
	rmb6	IER
	rmb4	Timer_Switch						; �ر�42Hz��4Hz��ʱ
	rmb2	Timer_Switch
	lda		#001B								; �ص���ʱģʽ����ʾ
	sta		Sys_Status_Flag
	jsr		F_Display_Time

	lda		#0									; ������ر�������־λ
	sta		QuickAdd_Counter
	sta		Key_Flag

	jsr		F_PortWaitKey_Mode					; ��PA��PC�ڻ�ԭ�صȴ��жϻ���ģʽ

	rmb4	IFR									; ��λ��־λ,�����жϿ���ʱֱ�ӽ����жϷ���
	smb4	IER									; ����������������¿���PA���ж�
L_KeyScanExit:
	rts



; ��Ӽ��
Is_QuickAdd:
	bbs3	Key_Flag,QuickAdd_4Hz_Juge
	bbs2	Key_Flag,QuickAdd_Block_Juge
	smb2	Key_Flag
	rts											; ��û�п�������Ϳ�Ӽ���������Ϊ�״ΰ������ܣ�ִ�а�������
QuickAdd_Block_Juge:
	bbr4	Timer_Flag,No_KeyFunction
	rmb4	Timer_Flag
	lda		QuickAdd_Counter
	cmp		#63
	bcs		QuickAdd_Trigger					; ����жϣ�����84��42Hz�򴥷����
	inc		QuickAdd_Counter
	bra		No_KeyFunction
QuickAdd_Trigger:
	smb2	Timer_Switch						; ����4Hz�����Ϳ�Ӽ����־
	smb3	Key_Flag
	rmb2	Timer_Flag
	rts
QuickAdd_4Hz_Juge:
	bbr2	Timer_Flag,No_KeyFunction
	rmb2	Timer_Flag							; ��Ӵ�����4Hz��һ�ΰ�������
	rts
No_KeyFunction:
	pla
	pla
	rts

QuickAdd_Reset:
	rmb2	Key_Flag
	rmb3	Key_Flag							; ��տ�������Դ
	rmb2	Timer_Switch
	lda		#0
	sta		QuickAdd_Counter
	rts




; ���������������ж�ÿ���������������Ӧ���������ݵ�ǰ��״̬��ͬ������ͬ�Ĺ��ܺ���
L_KeyHTrigger:
	smb0	Depress_Detect
	jsr		Is_QuickAdd
	jsr		L_Key_Backlight						; ������������
	jsr		L_Key_UniversalHandle

	bbr0	Sys_Status_Flag,?No_TimeDisMode
	rts											; ʱ����ʾģʽ��H���޹���
?No_TimeDisMode:
	bbr1	Sys_Status_Flag,?No_AlarmSetMode
	jmp		Alarm_HourAdd						; ����Сʱ����
?No_AlarmSetMode:
	bbr2	Sys_Status_Flag,?No_TimeSetMode
	jmp		Time_HourAdd						; ʱ��Сʱ����
?No_TimeSetMode:
	rts
	


L_KeyMTrigger:
	smb1	Depress_Detect
	jsr		Is_QuickAdd
	jsr		L_Key_Backlight						; ������������
	jsr		L_Key_UniversalHandle

	bbr0	Sys_Status_Flag,?No_TimeDisMode
	rts											; ʱ����ʾģʽ��M���޹���
?No_TimeDisMode:
	bbr1	Sys_Status_Flag,?No_AlarmSetMode
	jmp		Alarm_MinAdd						; ���ӷ�������
?No_AlarmSetMode:
	bbr2	Sys_Status_Flag,?No_TimeSetMode
	jmp		Time_MinAdd							; ʱ�ӷ�������
?No_TimeSetMode:
	rts


L_KeyBTrigger:
	bbr2	Depress_Detect,KeyB_Fuction			; �����ɼ����ʱ����ִ�а�������
	rts
KeyB_Fuction:
	smb2	Depress_Detect
	jsr		L_Key_Backlight						; ������������
	jsr		L_Key_UniversalHandle

	rts


L_KeyCTrigger:
	bbr3	Depress_Detect,KeyC_Fuction			; �����ɼ����ʱ����ִ�а�������
	rts
KeyC_Fuction:
	smb3	Depress_Detect
	jsr		L_Key_UniversalHandle

	lda		Alarm_Switch
	eor		#%01
	sta		Alarm_Switch
	jsr		F_SymbolRegulate					; ��������

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
	rts
No_AlarmLouding:
	bbr2	Clock_Flag,?No_AlarmSnooze			; ������ʱ�����ж��Ƿ���Ҫ���̰˯
	rmb2	Clock_Flag							; ���̰˯
	jsr		L_CloseLoud							; �������
	pla
	pla
?No_AlarmSnooze:
	rts


; ��������
L_Key_Backlight:
	lda		#0
	sta		Backlight_Counter
	smb0	Backlight_Flag
	smb1	Backlight_Flag
	lda		#$7f
	sta		PC
	rts




; T���п�
F_Is_KeyTKeep:
	bbr2	Sys_Status_Flag,L_QA_KeyA_NoJuge
	bbs3	Key_Flag,L_QA_KeyT_NoJuge			; �п��ʱ���˳�
	bbr6	PC,L_NoKeyT_Keep
L_QA_KeyT_NoJuge:
	rts
L_NoKeyT_Keep:
	jsr		L_KeyExit
	jsr		L_CloseLoud
	rts


; A���п�
F_Is_KeyAKeep:
	bbr1	Sys_Status_Flag,L_QA_KeyA_NoJuge
	bbs3	Key_Flag,L_QA_KeyA_NoJuge			; �п��ʱ���˳�
	bbr5	PC,L_NoKeyA_Keep
L_QA_KeyA_NoJuge:
	rts
L_NoKeyA_Keep:
	jsr		L_KeyExit
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
