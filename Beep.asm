F_BeepManage:
	jsr		L_LoudManage
	bbs3	Timer_Flag,L_Beeping
	rts
L_Beeping:
	rmb3	Timer_Flag

	bbr4	Clock_Flag,L_SerialBeep_Mode
	lda		Beep_Serial							; ��������ģʽ
	eor		#01B								; Beep_Serial��ת��һλ
	sta		Beep_Serial
	bra		L_Beep_Juge
L_SerialBeep_Mode:
	lda		Beep_Serial
	beq		L_NoBeep_Serial_Mode
	dec		Beep_Serial
L_Beep_Juge:
	bbr0	Beep_Serial,L_NoBeep_Serial_Mode
	PB2_PWM
	PWM_ON
	rts
L_NoBeep_Serial_Mode:
	PWM_OFF
	PB2_PB2_NOMS								; PB2ѡ��NMOS���1����©��
	smb2	PB
	rts




; ���ֹ���
L_LoudManage:
	bbr1	Clock_Flag,NoLouding				; �������ֱ�־λʱ�Ž�����
	bbr0	Clock_Flag,LoudHandle_Start			; ���ж��Ƿ�������Ӵ�����־
	bbs1	Time_Flag,LoudHandle_Start
NoLouding:
	rts
LoudHandle_Start:
	rmb1	Time_Flag

	nop											; �������ֵ����������ж�
	;lda		#8									; �������ֵ�����Ϊ8��4��
	;sta		Beep_Serial
	
LoudCounter_Juge:
	inc		Louding_Counter
	lda		Louding_Counter
	cmp		#60
	bcs		L_CloseLoud							; ���ּ�ʱ�ﵽ60S��ر�
	rts

L_CloseLoud:									; �������ر�����
	lda		#0
	sta		Louding_Counter
	PWM_OFF
	PB2_PB2_NOMS									; PB2ѡ��NMOS���1����©��
	smb2	PB

	rmb3	Timer_Switch						; �ر�21Hz��ʱ
	rmb3	Timer_Flag

	rmb1	Time_Flag
	rmb1	Clock_Flag							; ��λ����ģʽ�����ּ�ʱ1S
	rmb0	Clock_Flag							; ��λ���Ӵ�����־
	rts
