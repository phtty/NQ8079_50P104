F_Time_Run:
	bbs0	Time_Flag,L_TimeRun_Add					; �м�ʱ1S��־�Ž�����
	rts
L_TimeRun_Add:
	rmb0	Time_Flag								; ����S��־

	inc		R_Time_Sec
	lda		R_Time_Sec
	cmp		#60
	bcs		L_TimeSec_Overflow						; �������ӽ�λ
	rts
L_TimeSec_Overflow:
	lda		#0
	sta		R_Time_Sec
	inc		R_Time_Min
	jsr		L_SnoozeManage							; ÿ�η��Ӹ����ж�һ��̰˯
	lda		R_Time_Min
	cmp		#60
	bcs		L_TimeMin_Overflow						; ����Сʱ��λ
	jsr		L_DisTime_Min							; ˢ�·�����ʾ
	rts
L_TimeMin_Overflow:
	lda		#0
	sta		R_Time_Min
	inc		R_Time_Hour
	lda		R_Time_Hour
	cmp		#24
	bcc		L_TimeRun_Exit
	lda		#0
	sta		R_Time_Hour								; �������λ
L_TimeRun_Exit:
	jsr		F_Display_Time							; ��շ��ӣ���ʾСʱ
	rts
	