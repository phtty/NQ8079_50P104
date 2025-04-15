I_DivIRQ_Handler:
	nop										; δʹ��DIV�ж�
	jmp		L_EndIrq


I_Timer0IRQ_Handler:
	nop										; δʹ��Tim0�ж�
	jmp		L_EndIrq


I_Timer1IRQ_Handler:
	nop										; δʹ��Tim1�ж�
	jmp		L_EndIrq


I_Timer2IRQ_Handler:						; Tim2������ʱ
	smb1	Timer_Flag						; 2Hz��־
	smb1	Symbol_Flag

L_1Hz_Juge:
	inc		Counter_1Hz
	lda		Counter_1Hz						; 1Hz����
	cmp		#2
	bcc		Timer2IRQ_Exit
	lda		#0
	sta		Counter_1Hz
	smb0	Timer_Flag
	smb0	Symbol_Flag
	smb4	Backlight_Flag

	lda		#$07
	ora		Time_Flag
	sta		Time_Flag						; ��ʱ��ʱ�������ʱ�������ж�
Timer2IRQ_Exit:
	jmp		L_EndIrq


I_PaIRQ_Handler:
	rmb4	SYSCLK							; ���Ѻ�ص���ģʽ
	smb0	Key_Flag						; ����ɨ��
	smb1	Key_Flag						; �״δ�����Ҫ����
	rmb2	Key_Flag						; ������µ��½��ص��������ӱ�־λ
	rmb4	Timer_Flag						; ��42Hz��־λ

	smb6	IER
	rmb4	IER
	smb4	Timer_Switch					; �򿪿�Ӷ�ʱ����ʱ�ر�PA�ж�

	nop										; ��ʼɨ�谴����PA����Ϊ�����PC����Ϊ����

	jmp		L_EndIrq


I_LcdIRQ_Handler:							; ����ɨ�裬�����������Ӽ��
	bbr4	Timer_Switch,L_21Hz_Juge		; 42Hz��������
	smb4	Timer_Flag						; 42Hz��־

L_21Hz_Juge:
	bbr3	Timer_Switch,L_4Hz_Juge			; 16Hz��������
	inc		Counter_21Hz
	lda		Counter_21Hz
	cmp		#2
	bcc		L_4Hz_Juge
	lda		#0
	sta		Counter_21Hz
	smb3	Timer_Flag						; 21Hz��־

L_4Hz_Juge:
	bbr2	Timer_Switch,LcdIRQ_Exit		; 4Hz��������
	inc		Counter_4Hz
	lda		Counter_4Hz
	cmp		#4
	bcc		LcdIRQ_Exit
	lda		#0
	sta		Counter_4Hz
	smb2	Timer_Flag						; 4Hz��־

LcdIRQ_Exit:
	jmp		L_EndIrq
