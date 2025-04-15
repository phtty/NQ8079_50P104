;==========================================================================================================================================
.PAGE0
;==========================================================================================================================================
.ORG					00h
;------------------------------------------------------------------------------------------------------------------------------------------
PA			.equ		01H
;------------------------------------------------------------------------------------------------------------------------------------------
PA_WAKE		.equ		02H
;------------------------------------------------------------------------------------------------------------------------------------------
PA_DIR		.equ		04H
;------------------------------------------------------------------------------------------------------------------------------------------
PB			.equ		05H
;------------------------------------------------------------------------------------------------------------------------------------------
PB_TYPE		.equ		06H
;------------------------------------------------------------------------------------------------------------------------------------------
PC			.equ		07H
;------------------------------------------------------------------------------------------------------------------------------------------
PC_DIR		.equ		08H
;------------------------------------------------------------------------------------------------------------------------------------------
PC_SEG		.equ		09H
C_PD74S								=			$80
C_PD30S								=			$40
C_PC76S								=			$20
C_PC54S								=			$10
C_PC3S								=			$08
C_PC2S								=			$04
C_PC1S								=			$02
C_PC0S								=			$01
;------------------------------------------------------------------------------------------------------------------------------------------
PD			.equ		0AH
;------------------------------------------------------------------------------------------------------------------------------------------
PD_DIR		.equ		0BH
;------------------------------------------------------------------------------------------------------------------------------------------
PADF0		.equ		0CH
C_IROS								=			$40
C_IRS1								=			$20
C_IRS0								=			$08
C_PA7S								=			$04
C_PB3S								=			$02
C_PB2S								=			$01
;------------------------------------------------------------------------------------------------------------------------------------------
PADF1		.equ		0DH
C_T000_Fsub							=			$00
C_T000_Fosc_128						=			$01
C_ELM_F4K_C							=			$00
C_ELM_F16K_C						=			$40
C_ELM_F128K_C						=			$80
C_ELM_F4M_2							=			$C0  
C_ELT_EL							=			$00
C_ELT_ELM							=			$20
;------------------------------------------------------------------------------------------------------------------------------------------
IER			.equ		0EH
C_LCDI								=			$40
C_INTX								=			$20
C_PAI								=			$10
C_TMR2I								=			$08
C_TMR1I								=			$04
C_TMR0I								=			$02
C_DIVI								=			$01
;------------------------------------------------------------------------------------------------------------------------------------------
IFR			.equ		0FH
C_LCDF								=			$40
C_INTXF								=			$20
C_PAF								=			$10
C_TMR2F								=			$08
C_TMR1F								=			$04
C_TMR0F								=			$02
C_DIVF								=			$01
;------------------------------------------------------------------------------------------------------------------------------------------
TMR0		.equ		10H
;------------------------------------------------------------------------------------------------------------------------------------------
TMR1		.equ		12H
;------------------------------------------------------------------------------------------------------------------------------------------
TMR2		.equ		14H
;------------------------------------------------------------------------------------------------------------------------------------------
TMRC		.equ		16H
C_AUD_OFF							=			$7F
C_AUDON								=			$80
C_T0I_1								=			$40
C_LCDOFF							=			$EF
C_LCDON								=			$10
C_TMR2ON							=			$04
C_TMR1ON							=			$02
C_TMR0ON							=			$01
;------------------------------------------------------------------------------------------------------------------------------------------
TMCLK		.equ		17H
C_TMR1_TMR0							=			$00
C_TMR1_Fsub_64						=			$04
C_TMR1_Fosc_32						=			$08
C_TMR1_Fosc_4						=			$0C
C_TMR0_Fsub							=			$00
C_TMR0_Fosc							=			$01
C_TMR0_Fosc_32						=			$02
C_TMR0_T0I							=			$03
;------------------------------------------------------------------------------------------------------------------------------------------
DIVC		.equ		18H
C_Asynchronous						=			$00
C_SyncWithDIV						=			$40
C_DIVC_Fsub_4						=			$00
C_DIVC_Fsub_2						=			$01
C_DIVC_Fsub_64						=			$02
C_DIVC_Fsub_32						=			$03
C_DIVC_Fsub_128						=			$20
C_ELS								=			$10
C_TONE_Fsub_16_1_2					=			$00
C_TONE_TMR0_2						=			$04
C_TONE_Logic_Low					=			$08
C_TONE_Logic_High					=			$0C
C_TONE_Fsub_16_3_4					=			$80
C_TONE_Fsub_8						=			$84
;------------------------------------------------------------------------------------------------------------------------------------------
LCD_CTRL	.equ		19H
C_BIS_R_1_3							=			$00
C_BIS_R_1_4							=			$04
C_BIS_R_1_2							=			$0C
C_BIS_C_1_2							=			$00
C_BIS_C_1_3_V30						=			$08
C_BIS_C_1_3_V45						=			$04
C_HIS_Strongest						=			$00
C_HIS_Weak							=			$01
C_HIS_Normal						=			$02
C_HIS_Strong						=			$03
;------------------------------------------------------------------------------------------------------------------------------------------
LCD_COM		.equ		1AH
C_BIT_R								=			$00
C_BIT_C								=			$80
C_ENCH_Enable						=			$40
C_ENCH_Disable						=			$00
C_LCDIS_Rate_2						=			$00
C_LCDIS_Rate						=			$20
C_COM_2_42_38						=			$01
C_COM_3_41_37						=			$02
C_COM_4_40_36						=			$03
C_COM_5_39_35						=			$04
C_COM_6_38_34						=			$05
C_COM_7_37_33						=			$06
C_COM_8_36_32						=			$07
C_COM_3_29							=			$00
C_COM_4_28							=			$01
C_COM_5_27  						=			$02
C_COM_6_26							=			$03
C_COM_3_21							=			$00
;------------------------------------------------------------------------------------------------------------------------------------------
WDTC		.equ		1CH
C_WDT_TO							=			$10
C_WDT_EN							=			$08
C_WDT_DIS							=			$00
C_CLR_WDT							=			$04
C_WDT_Fsub_128						=			$00
C_WDT_DIV							=			$01
C_WDT_TMR1							=			$02
C_WDT_LCDS							=			$03
;------------------------------------------------------------------------------------------------------------------------------------------
SYSCLK		.equ		1DH
C_FcpuS_Fext						=			$80
C_FcpuS_Fsys						=			$00
C_RSC_Fosc_1						=			$00
C_RSC_Fosc_2						=			$10
C_RSC_Fosc_4						=			$20
C_RSC_Fosc_8						=			$30
C_Fext_Xtal							=			$00
C_Fext_BR35K						=			$08
C_Fosc_OFF							=			$00
C_Fosc_ON							=			$04
C_Fext_OFF							=			$00
C_Fext_ON							=			$02
C_Fext_Weak							=			$00
C_Fext_Strong						=			$01
;------------------------------------------------------------------------------------------------------------------------------------------
HALT		.equ		1EH
;------------------------------------------------------------------------------------------------------------------------------------------
AUD0		.equ		1FH
;------------------------------------------------------------------------------------------------------------------------------------------
AUDCR		.equ		20H
C_AUD_Bypass						=			$00
C_AUD_TMR0							=			$20
C_PWM_X								=			$00
C_PWM_VP							=			$04
C_PWM_MS6							=			$10
C_PWM_M0_M1							=			$14
C_BP_M0_M1							=			$02
;------------------------------------------------------------------------------------------------------------------------------------------
FRAME		.equ		21H
;------------------------------------------------------------------------------------------------------------------------------------------
MF			.equ		2FH
MF0			.equ		2FH
;------------------------------------------------------------------------------------------------------------------------------------------
SPCR		.equ		32H
C_SPII								=			$80
C_SPE_EN							=			$40
C_SPE_DIS							=			$00
C_DORD_MSB							=			$00
C_DORD_LSB							=			$20
C_MSTR_Slave 						=			$00
C_MSTR_Master 						=			$10
C_CPOL_LowIdle						=			$00
C_CPOL_HighIdle						=			$80
C_CPHA_LeadEdge						=			$00
C_CPHA_TrailEdge					=			$40
C_SPIR_Fosc_2_1						=			$00
C_SPIR_Fosc_8_4						=			$01
C_SPIR_Fosc_32_16					=			$02
C_SPIR_Fosc_64_32					=			$03
;------------------------------------------------------------------------------------------------------------------------------------------
SPSR		.equ		33H
C_SPIF								=			$80
C_WCOL								=			$40
C_MSSBD								=			$08
C_SPI2X_Fosc_2_8_32_64				=			$00
C_SPI2X_Fosc_1_4_16_32				=			$01
;------------------------------------------------------------------------------------------------------------------------------------------
SPDR		.equ		34H
;------------------------------------------------------------------------------------------------------------------------------------------
PAK			.equ		3AH
;------------------------------------------------------------------------------------------------------------------------------------------
PBK			.equ		3BH
C_KSEN_DIS							=			$00
C_KSEN_EN							=			$80
C_KSPW_4Fsub						=			$00
C_KSPW_8Fsub						=			$04
C_KSPW_16Fsub						=			$08
C_KSPW_32Fsub						=			$0C
C_KSPON_1Scan						=			$00
C_KSPON_2Scan						=			$01
C_KSPON_3Scan						=			$02
;------------------------------------------------------------------------------------------------------------------------------------------
PCK			.equ		3CH
;------------------------------------------------------------------------------------------------------------------------------------------
LVC			.equ		3DH  
C_ENLVD_DIS							=			$00
C_ENLVD_EN							=			$80
C_LVDS_230							=			$00
C_LVDS_250							=			$20
C_LVDS_270							=			$40
C_LVDF_VDD_H_LVD					=			$00            
C_LVDF_VDD_L_LVD					=			$10
C_LVRF_software						=			$00
C_LVRF_VDD_L_Vlvr					=			$80
;------------------------------------------------------------------------------------------------------------------------------------------
FUSE		.equ		3EH
FUSE0		.equ		3EH
FUSE1		.equ		4EH
;------------------------------------------------------------------------------------------------------------------------------------------
PD_SEG		.equ		5CH
C_PD7S								=			$80
C_PD6S								=			$40
C_PD5S								=			$20
C_PD4S								=			$10
C_PD3S								=			$08
C_PD2S								=			$04
C_PD1S								=			$02
C_PD0S								=			$01
;------------------------------------------------------------------------------------------------------------------------------------------
RFCC0		.equ		5DH
RFCC1		.equ		5EH
;------------------------------------------------------------------------------------------------------------------------------------------
RFCR		.equ		5EH
C_RFCS_ON_RS0						=			$10
C_RFCS_ON_CTRT0						=			$20
C_RFCS_ON_RT01						=			$30
C_RFCS_ON_RS1RT0					=			$40
C_RFCS_ON_CS1RT01					=			$50
C_RFCS_ON_CSRT0						=			$60
C_RFCS_ON_CSRT0_RS0					=			$90
C_RFCS_ON_CSRT0_CTRT0				=			$A0
C_RFCS_ON_CSRT0_RT01				=			$B0
C_RFCS_ON_CSRT0_RS1RT0				=			$C0
C_RFCS_ON_CSRT0_CS1RT01				=			$D0
C_RFCS_ON_RS0_CTRT0					=			$E0
C_RFCS_OFF_RS1RT0					=			$10
C_RFCS_OFF_CS1RT01					=			$20
C_RFCS_OFF_RT01						=			$30
C_RFCS_OFF_RS1RT0_CS1RT01			=			$90
C_RFCS_OFF_RT01_CS1RT01				=			$A0
C_RFC01_1ST							=			$00
C_RFC01_2ND							=			$08
C_RFCM_ShortRC						=			$00
C_RFCM_LongRC						=			$04
C_RFCI								=			$02
C_RFCF								=			$01
;------------------------------------------------------------------------------------------------------------------------------------------
MF1			.equ		5FH
;------------------------------------------------------------------------------------------------------------------------------------------
C_RST_SEL							=			$80
C_VOLT_V30							=			$40
C_PY_SEL							=			$40
C_ROM1								=			$20
C_ROM0								=			$10
C_PAIM								=			$08
C_ACT								=			$04
C_OMS0								=			$01
C_PB32IS							=			$40
C_PROTB								=			$01
C_OMS_BR							=			$01
;------------------------------------------------------------------------------------------------------------------------------------------
.ENDS
;==========================================================================================================================================
