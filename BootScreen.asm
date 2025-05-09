F_BootScreen:
	jsr		F_FillScreen
	lda		#00
	sta		P_Temp
	rmb1	Timer_Flag
L_BootScreen_Loop:								; �ϵ�ȫ��2S
	bbr1	Timer_Flag,L_BootScreen_Loop
	rmb1	Timer_Flag
	inc		P_Temp
	lda		P_Temp
	cmp		#4
	bcs		?L_BeepLoop
	bra		L_BootScreen_Loop

?L_BeepLoop:
	lda		#4
	sta		Beep_Serial							; ����ʱ������������
	smb6	IER									; ����LCD�ж��������ֵļ��
	rmb3	Clock_Flag							; ����Ϊ��������ģʽ
	smb3	Timer_Switch
?Loop_Start:
	jsr		F_BeepManage
	lda		Beep_Serial
	bne		?Loop_Start

	rmb6	IER									; �رշ�����ʹ�õ��ж�
	rmb3	Timer_Switch
	jsr		F_ClearScreen
	rmb0	SYSCLK								; ����Ϊ��ģʽ
	rts
