F_Time_Run:
	bbs0	Time_Flag,L_TimeRun_Add					; �м�ʱ1S��־�Ž�����
	rts
L_TimeRun_Add:
	rmb0	Time_Flag								; ����S��־

	inc		R_Time_Sec
	lda		R_Time_Sec
	cmp		#60
	bcc		L_Time_SecRun_Exit						; δ�������ӽ�λ
	lda		#0
	sta		R_Time_Sec
	jsr		L_SnoozeManage							; ÿ�η��Ӹ����ж�һ��̰˯
	inc		R_Time_Min
	lda		R_Time_Min
	cmp		#60
	bcc		L_Time_SecRun_Exit						; δ����Сʱ��λ
	lda		#0
	sta		R_Time_Min
	inc		R_Time_Hour
	lda		R_Time_Hour
	cmp		#24
	bcc		L_Time_SecRun_Exit						; δ�������λ
	lda		#0
	sta		R_Time_Hour
L_Time_SecRun_Exit:
	rts
