; �����ж�
F_Alarm_Handler:
	bbr2	Time_Flag,Alarm_NoJuge				; ÿSֻ��1�������ж�
	rmb2	Time_Flag
	lda		Alarm_Switch
	bne		Is_Alarm_Trigger					; û���κ����ӿ����򲻻��ж������Ƿ񴥷�
Alarm_NoJuge:
	rts

; �����趨ֵ��ʱ���ַ��ϵ�ǰʱ�䣬���������Ӵ�����־λ
Is_Alarm_Trigger:
	lda		Alarm_Switch
	and		#001B
	beq		L_Alarm_NoMatch					; ���������û�п������򲻻��ж���
	lda		R_Time_Hour
	cmp		R_Alarm_Hour
	beq		L_Alarm_HourMatch
L_Alarm_NoMatch:
	rts

L_Alarm_HourMatch:
	lda		R_Time_Min
	cmp		R_Alarm_Min
	beq		L_Alarm_MinMatch
	rts

L_Alarm_MinMatch:
	lda		R_Time_Sec
	cmp		#00
	bne		Alarm_SecNoMatch
	jmp		L_Alarm_Match_Handle
Alarm_SecNoMatch:
	rts


; ȷ�����Ӵ�����Ĵ���
L_Alarm_Match_Handle:
	smb0	Clock_Flag							; ͬʱ����Сʱ�ͷ��ӵ�ƥ�䣬�������Ӵ���
	smb1	Clock_Flag							; ��������ģʽ

	smb6	IER									; ����LCD�ж�
	smb1	Time_Flag
	smb3	Timer_Switch						; ����21Hz���������ʱ
	lda		#0
	sta		Counter_21Hz
	sta		Louding_Counter

	rts




; ̰˯���ֵĴ���
L_SnoozeManage:
	bbs2	Clock_Flag,Snooze_Handle
	rts
Snooze_Handle:
	lda		R_Snooze_Time
	beq		SnoozeAlarm_Trigger
	dec		R_Snooze_Time
	rts
SnoozeAlarm_Trigger:
	lda		#7
	sta		R_Snooze_Time
	rmb2	Clock_Flag
	jmp		L_Alarm_Match_Handle




; X���̣�AΪ����
L_A_Div_3:
	ldx		#0
L_A_Div_3_Start:
	cmp		#3
	bcc		L_A_Div_3_Over
	sec
	sbc		#3
	inx
	bra		L_A_Div_3_Start
L_A_Div_3_Over:
	rts


; ��A����Xλ
L_A_LeftShift_XBit:
	sta		P_Temp
Shift_Start:
	txa
	beq		Shift_End
	lda		P_Temp
	clc
	rol		P_Temp
	dex
	bra		Shift_Start
Shift_End:
	lda		P_Temp
	rts
