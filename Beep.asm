F_BeepManage:
	jsr		L_LoudManage
	bbs3	Timer_Flag,L_Beeping
	rts
L_Beeping:
	rmb3	Timer_Flag

	bbr3	Clock_Flag,L_SerialBeep_Mode
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
	PB2_PB2_NOMS								; PB2ѡ��NMOS���0����©��
	rmb2	PB
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

	lda		Louding_Counter						; �������ֵ������ж��켸��
	cmp		#10
	bcs		No_LoudLevel_1
	rmb3	Clock_Flag							; �л�����������ģʽ
	lda		#2
	sta		Beep_Serial							; ǰ10S��1��
	bra		LoudCounter_Juge
No_LoudLevel_1:
	cmp		#20
	bcs		No_LoudLevel_2
	lda		#4
	sta		Beep_Serial							; 10S~20S��2��
	bra		LoudCounter_Juge
No_LoudLevel_2:
	cmp		#30
	bcs		No_LoudLevel_3
	lda		#8
	sta		Beep_Serial							; 20S~30S��4��
	bra		LoudCounter_Juge
No_LoudLevel_3:
	smb3	Clock_Flag							; 30S�Ժ��л�����������ģʽ
LoudCounter_Juge:
	lda		Louding_Counter
	cmp		#60
	bcs		Louding_Overflow					; ���ּ�ʱ�ﵽ60S��ر�
	inc		Louding_Counter
	rts
Louding_Overflow:
	jsr		F_DisZz
	bbr0	Sys_Status_Flag,L_CloseLoud			
	rmb6	IER
	rmb3	Timer_Switch

L_CloseLoud:									; �������ر�����
	lda		#0
	sta		Louding_Counter
	PWM_OFF
	PB2_PB2_NOMS								; PB2ѡ��NMOS���1����©��
	smb2	PB

	rmb3	Timer_Switch						; �ر�21Hz��ʱ
	rmb3	Timer_Flag

	rmb1	Time_Flag
	rmb1	Clock_Flag							; ��λ����ģʽ�����ּ�ʱ1S
	rmb0	Clock_Flag							; ��λ���Ӵ�����־
	rmb3	Clock_Flag							; ��λ�������ֱ�־
	rts
