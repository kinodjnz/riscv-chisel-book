## This file is a general .xdc for the Arty A7-35 Rev. D and Rev. E
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
#set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clock]
#create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clock]
#
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports clock]

create_generated_clock -name user_design_clk [get_pins dram/clkgen/inst/mmcm_adv_inst/CLKOUT0]
set_clock_groups -asynchronous -group user_design_clk

## Switches
#set_property -dict { PACKAGE_PIN A8    IOSTANDARD LVCMOS33 } [get_ports { sw[0] }]; #IO_L12N_T1_MRCC_16 Sch=sw[0]
#set_property -dict { PACKAGE_PIN C11   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]; #IO_L13P_T2_MRCC_16 Sch=sw[1]
#set_property -dict { PACKAGE_PIN C10   IOSTANDARD LVCMOS33 } [get_ports { sw[2] }]; #IO_L13N_T2_MRCC_16 Sch=sw[2]
#set_property -dict { PACKAGE_PIN A10   IOSTANDARD LVCMOS33 } [get_ports { sw[3] }]; #IO_L14P_T2_SRCC_16 Sch=sw[3]

## RGB LEDs
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports {gpio_out[4]}]
set_property -dict {PACKAGE_PIN F6 IOSTANDARD LVCMOS33} [get_ports {gpio_out[5]}]
set_property -dict {PACKAGE_PIN G6 IOSTANDARD LVCMOS33} [get_ports {gpio_out[6]}]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports {gpio_out[7]}]
#set_property -dict { PACKAGE_PIN J4    IOSTANDARD LVCMOS33 } [get_ports { led1_g }]; #IO_L21P_T3_DQS_35 Sch=led1_g
#set_property -dict { PACKAGE_PIN G3    IOSTANDARD LVCMOS33 } [get_ports { led1_r }]; #IO_L20N_T3_35 Sch=led1_r
#set_property -dict { PACKAGE_PIN H4    IOSTANDARD LVCMOS33 } [get_ports { led2_b }]; #IO_L21N_T3_DQS_35 Sch=led2_b
#set_property -dict { PACKAGE_PIN J2    IOSTANDARD LVCMOS33 } [get_ports { led2_g }]; #IO_L22N_T3_35 Sch=led2_g
#set_property -dict { PACKAGE_PIN J3    IOSTANDARD LVCMOS33 } [get_ports { led2_r }]; #IO_L22P_T3_35 Sch=led2_r
#set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { led3_b }]; #IO_L23P_T3_35 Sch=led3_b
#set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { led3_g }]; #IO_L24P_T3_35 Sch=led3_g
#set_property -dict { PACKAGE_PIN K1    IOSTANDARD LVCMOS33 } [get_ports { led3_r }]; #IO_L23N_T3_35 Sch=led3_r

## LEDs
set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports {gpio_out[0]}]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {gpio_out[1]}]
set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33} [get_ports {gpio_out[2]}]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {gpio_out[3]}]

## Buttons
#set_property -dict { PACKAGE_PIN D9    IOSTANDARD LVCMOS33 } [get_ports { btn[0] }]; #IO_L6N_T0_VREF_16 Sch=btn[0]
#set_property -dict { PACKAGE_PIN C9    IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]; #IO_L11P_T1_SRCC_16 Sch=btn[1]
#set_property -dict { PACKAGE_PIN B9    IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]; #IO_L11N_T1_SRCC_16 Sch=btn[2]
#set_property -dict { PACKAGE_PIN B8    IOSTANDARD LVCMOS33 } [get_ports { btn[3] }]; #IO_L12P_T1_MRCC_16 Sch=btn[3]

## Pmod Header JA
set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS33} [get_ports {sdc_dat[3]}]
set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports sdc_cmd]
set_property -dict {PACKAGE_PIN A11 IOSTANDARD LVCMOS33} [get_ports {sdc_dat[0]}]
set_property -dict {PACKAGE_PIN D12 IOSTANDARD LVCMOS33} [get_ports sdc_clk]
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS33} [get_ports {sdc_dat[1]}]
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports {sdc_dat[2]}]
#set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports {gpio_out[6]}]
#set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {gpio_out[7]}]

## Pmod Header JB
#set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports { jb[0] }]; #IO_L11P_T1_SRCC_15 Sch=jb_p[1]
#set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { jb[1] }]; #IO_L11N_T1_SRCC_15 Sch=jb_n[1]
#set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { jb[2] }]; #IO_L12P_T1_MRCC_15 Sch=jb_p[2]
#set_property -dict { PACKAGE_PIN C15   IOSTANDARD LVCMOS33 } [get_ports { jb[3] }]; #IO_L12N_T1_MRCC_15 Sch=jb_n[2]
#set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { jb[4] }]; #IO_L23P_T3_FOE_B_15 Sch=jb_p[3]
#set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { jb[5] }]; #IO_L23N_T3_FWE_B_15 Sch=jb_n[3]
#set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { jb[6] }]; #IO_L24P_T3_RS1_15 Sch=jb_p[4]
#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { jb[7] }]; #IO_L24N_T3_RS0_15 Sch=jb_n[4]

## Pmod Header JC
#set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { jc[0] }]; #IO_L20P_T3_A08_D24_14 Sch=jc_p[1]
#set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { jc[1] }]; #IO_L20N_T3_A07_D23_14 Sch=jc_n[1]
#set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { jc[2] }]; #IO_L21P_T3_DQS_14 Sch=jc_p[2]
#set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { jc[3] }]; #IO_L21N_T3_DQS_A06_D22_14 Sch=jc_n[2]
#set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { jc[4] }]; #IO_L22P_T3_A05_D21_14 Sch=jc_p[3]
#set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { jc[5] }]; #IO_L22N_T3_A04_D20_14 Sch=jc_n[3]
#set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { jc[6] }]; #IO_L23P_T3_A03_D19_14 Sch=jc_p[4]
#set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { jc[7] }]; #IO_L23N_T3_A02_D18_14 Sch=jc_n[4]

## Pmod Header JD
#set_property -dict { PACKAGE_PIN D4    IOSTANDARD LVCMOS33 } [get_ports { jd[0] }]; #IO_L11N_T1_SRCC_35 Sch=jd[1]
#set_property -dict { PACKAGE_PIN D3    IOSTANDARD LVCMOS33 } [get_ports { jd[1] }]; #IO_L12N_T1_MRCC_35 Sch=jd[2]
#set_property -dict { PACKAGE_PIN F4    IOSTANDARD LVCMOS33 } [get_ports { jd[2] }]; #IO_L13P_T2_MRCC_35 Sch=jd[3]
#set_property -dict { PACKAGE_PIN F3    IOSTANDARD LVCMOS33 } [get_ports { jd[3] }]; #IO_L13N_T2_MRCC_35 Sch=jd[4]
#set_property -dict { PACKAGE_PIN E2    IOSTANDARD LVCMOS33 } [get_ports { jd[4] }]; #IO_L14P_T2_SRCC_35 Sch=jd[7]
#set_property -dict { PACKAGE_PIN D2    IOSTANDARD LVCMOS33 } [get_ports { jd[5] }]; #IO_L14N_T2_SRCC_35 Sch=jd[8]
#set_property -dict { PACKAGE_PIN H2    IOSTANDARD LVCMOS33 } [get_ports { jd[6] }]; #IO_L15P_T2_DQS_35 Sch=jd[9]
#set_property -dict { PACKAGE_PIN G2    IOSTANDARD LVCMOS33 } [get_ports { jd[7] }]; #IO_L15N_T2_DQS_35 Sch=jd[10]

## USB-UART Interface
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS33} [get_ports uart_tx]
set_property -dict {PACKAGE_PIN A9 IOSTANDARD LVCMOS33} [get_ports uart_rx]

## ChipKit Outer Digital Header
#set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { ck_io0  }]; #IO_L16P_T2_CSI_B_14          Sch=ck_io[0]
#set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { ck_io1  }]; #IO_L18P_T2_A12_D28_14        Sch=ck_io[1]
#set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { ck_io2  }]; #IO_L8N_T1_D12_14             Sch=ck_io[2]
#set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { ck_io3  }]; #IO_L19P_T3_A10_D26_14        Sch=ck_io[3]
#set_property -dict { PACKAGE_PIN R12   IOSTANDARD LVCMOS33 } [get_ports { ck_io4  }]; #IO_L5P_T0_D06_14             Sch=ck_io[4]
#set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { ck_io5  }]; #IO_L14P_T2_SRCC_14           Sch=ck_io[5]
#set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { ck_io6  }]; #IO_L14N_T2_SRCC_14           Sch=ck_io[6]
#set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { ck_io7  }]; #IO_L15N_T2_DQS_DOUT_CSO_B_14 Sch=ck_io[7]
#set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { ck_io8  }]; #IO_L11P_T1_SRCC_14           Sch=ck_io[8]
#set_property -dict { PACKAGE_PIN M16   IOSTANDARD LVCMOS33 } [get_ports { ck_io9  }]; #IO_L10P_T1_D14_14            Sch=ck_io[9]
#set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { ck_io10 }]; #IO_L18N_T2_A11_D27_14        Sch=ck_io[10]
#set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { ck_io11 }]; #IO_L17N_T2_A13_D29_14        Sch=ck_io[11]
#set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { ck_io12 }]; #IO_L12N_T1_MRCC_14           Sch=ck_io[12]
#set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { ck_io13 }]; #IO_L12P_T1_MRCC_14           Sch=ck_io[13]

## ChipKit Inner Digital Header
#set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { ck_io26 }]; #IO_L19N_T3_A09_D25_VREF_14 	Sch=ck_io[26]
#set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { ck_io27 }]; #IO_L16N_T2_A15_D31_14 		Sch=ck_io[27]
#set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { ck_io28 }]; #IO_L6N_T0_D08_VREF_14 		Sch=ck_io[28]
#set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { ck_io29 }]; #IO_25_14 		 			Sch=ck_io[29]
#set_property -dict { PACKAGE_PIN R11   IOSTANDARD LVCMOS33 } [get_ports { ck_io30 }]; #IO_0_14  		 			Sch=ck_io[30]
#set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { ck_io31 }]; #IO_L5N_T0_D07_14 			Sch=ck_io[31]
#set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { ck_io32 }]; #IO_L13N_T2_MRCC_14 			Sch=ck_io[32]
#set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { ck_io33 }]; #IO_L13P_T2_MRCC_14 			Sch=ck_io[33]
#set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { ck_io34 }]; #IO_L15P_T2_DQS_RDWR_B_14 	Sch=ck_io[34]
#set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { ck_io35 }]; #IO_L11N_T1_SRCC_14 			Sch=ck_io[35]
#set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { ck_io36 }]; #IO_L8P_T1_D11_14 			Sch=ck_io[36]
#set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { ck_io37 }]; #IO_L17P_T2_A14_D30_14 		Sch=ck_io[37]
#set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { ck_io38 }]; #IO_L7N_T1_D10_14 			Sch=ck_io[38]
#set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { ck_io39 }]; #IO_L7P_T1_D09_14 			Sch=ck_io[39]
#set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { ck_io40 }]; #IO_L9N_T1_DQS_D13_14 		Sch=ck_io[40]
#set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { ck_io41 }]; #IO_L9P_T1_DQS_14 			Sch=ck_io[41]

## ChipKit Outer Analog Header - as Single-Ended Analog Inputs
## NOTE: These ports can be used as single-ended analog inputs with voltages from 0-3.3V (ChipKit analog pins A0-A5) or as digital I/O.
## WARNING: Do not use both sets of constraints at the same time!
## NOTE: The following constraints should be used with the XADC IP core when using these ports as analog inputs.
#set_property -dict { PACKAGE_PIN C5    IOSTANDARD LVCMOS33 } [get_ports { vaux4_n  }]; #IO_L1N_T0_AD4N_35 		Sch=ck_an_n[0]	ChipKit pin=A0
#set_property -dict { PACKAGE_PIN C6    IOSTANDARD LVCMOS33 } [get_ports { vaux4_p  }]; #IO_L1P_T0_AD4P_35 		Sch=ck_an_p[0]	ChipKit pin=A0
#set_property -dict { PACKAGE_PIN A5    IOSTANDARD LVCMOS33 } [get_ports { vaux5_n  }]; #IO_L3N_T0_DQS_AD5N_35 	Sch=ck_an_n[1]	ChipKit pin=A1
#set_property -dict { PACKAGE_PIN A6    IOSTANDARD LVCMOS33 } [get_ports { vaux5_p  }]; #IO_L3P_T0_DQS_AD5P_35 	Sch=ck_an_p[1]	ChipKit pin=A1
#set_property -dict { PACKAGE_PIN B4    IOSTANDARD LVCMOS33 } [get_ports { vaux6_n  }]; #IO_L7N_T1_AD6N_35 		Sch=ck_an_n[2]	ChipKit pin=A2
#set_property -dict { PACKAGE_PIN C4    IOSTANDARD LVCMOS33 } [get_ports { vaux6_p  }]; #IO_L7P_T1_AD6P_35 		Sch=ck_an_p[2]	ChipKit pin=A2
#set_property -dict { PACKAGE_PIN A1    IOSTANDARD LVCMOS33 } [get_ports { vaux7_n  }]; #IO_L9N_T1_DQS_AD7N_35 	Sch=ck_an_n[3]	ChipKit pin=A3
#set_property -dict { PACKAGE_PIN B1    IOSTANDARD LVCMOS33 } [get_ports { vaux7_p  }]; #IO_L9P_T1_DQS_AD7P_35 	Sch=ck_an_p[3]	ChipKit pin=A3
#set_property -dict { PACKAGE_PIN B2    IOSTANDARD LVCMOS33 } [get_ports { vaux15_n }]; #IO_L10N_T1_AD15N_35 	Sch=ck_an_n[4]	ChipKit pin=A4
#set_property -dict { PACKAGE_PIN B3    IOSTANDARD LVCMOS33 } [get_ports { vaux15_p }]; #IO_L10P_T1_AD15P_35 	Sch=ck_an_p[4]	ChipKit pin=A4
#set_property -dict { PACKAGE_PIN C14   IOSTANDARD LVCMOS33 } [get_ports { vaux0_n  }]; #IO_L1N_T0_AD0N_15 		Sch=ck_an_n[5]	ChipKit pin=A5
#set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports { vaux0_p  }]; #IO_L1P_T0_AD0P_15 		Sch=ck_an_p[5]	ChipKit pin=A5
## ChipKit Outer Analog Header - as Digital I/O
## NOTE: the following constraints should be used when using these ports as digital I/O.
#set_property -dict { PACKAGE_PIN F5    IOSTANDARD LVCMOS33 } [get_ports { ck_a0 }]; #IO_0_35           	Sch=ck_a[0]		ChipKit pin=A0
#set_property -dict { PACKAGE_PIN D8    IOSTANDARD LVCMOS33 } [get_ports { ck_a1 }]; #IO_L4P_T0_35      	Sch=ck_a[1]		ChipKit pin=A1
#set_property -dict { PACKAGE_PIN C7    IOSTANDARD LVCMOS33 } [get_ports { ck_a2 }]; #IO_L4N_T0_35      	Sch=ck_a[2]		ChipKit pin=A2
#set_property -dict { PACKAGE_PIN E7    IOSTANDARD LVCMOS33 } [get_ports { ck_a3 }]; #IO_L6P_T0_35      	Sch=ck_a[3]		ChipKit pin=A3
#set_property -dict { PACKAGE_PIN D7    IOSTANDARD LVCMOS33 } [get_ports { ck_a4 }]; #IO_L6N_T0_VREF_35 	Sch=ck_a[4]		ChipKit pin=A4
#set_property -dict { PACKAGE_PIN D5    IOSTANDARD LVCMOS33 } [get_ports { ck_a5 }]; #IO_L11P_T1_SRCC_35	Sch=ck_a[5]		ChipKit pin=A5

## ChipKit Inner Analog Header - as Differential Analog Inputs
## NOTE: These ports can be used as differential analog inputs with voltages from 0-1.0V (ChipKit Analog pins A6-A11) or as digital I/O.
## WARNING: Do not use both sets of constraints at the same time!
## NOTE: The following constraints should be used with the XADC core when using these ports as analog inputs.
#set_property -dict { PACKAGE_PIN B7    IOSTANDARD LVCMOS33 } [get_ports { vaux12_p }]; #IO_L2P_T0_AD12P_35	Sch=ad_p[12]	ChipKit pin=A6
#set_property -dict { PACKAGE_PIN B6    IOSTANDARD LVCMOS33 } [get_ports { vaux12_n }]; #IO_L2N_T0_AD12N_35	Sch=ad_n[12]	ChipKit pin=A7
#set_property -dict { PACKAGE_PIN E6    IOSTANDARD LVCMOS33 } [get_ports { vaux13_p }]; #IO_L5P_T0_AD13P_35	Sch=ad_p[13]	ChipKit pin=A8
#set_property -dict { PACKAGE_PIN E5    IOSTANDARD LVCMOS33 } [get_ports { vaux13_n }]; #IO_L5N_T0_AD13N_35	Sch=ad_n[13]	ChipKit pin=A9
#set_property -dict { PACKAGE_PIN A4    IOSTANDARD LVCMOS33 } [get_ports { vaux14_p }]; #IO_L8P_T1_AD14P_35	Sch=ad_p[14]	ChipKit pin=A10
#set_property -dict { PACKAGE_PIN A3    IOSTANDARD LVCMOS33 } [get_ports { vaux14_n }]; #IO_L8N_T1_AD14N_35	Sch=ad_n[14]	ChipKit pin=A11
## ChipKit Inner Analog Header - as Digital I/O
## NOTE: the following constraints should be used when using the inner analog header ports as digital I/O.
#set_property -dict { PACKAGE_PIN B7    IOSTANDARD LVCMOS33 } [get_ports { ck_io20 }]; #IO_L2P_T0_AD12P_35	Sch=ad_p[12]	ChipKit pin=A6
#set_property -dict { PACKAGE_PIN B6    IOSTANDARD LVCMOS33 } [get_ports { ck_io21 }]; #IO_L2N_T0_AD12N_35	Sch=ad_n[12]	ChipKit pin=A7
#set_property -dict { PACKAGE_PIN E6    IOSTANDARD LVCMOS33 } [get_ports { ck_io22 }]; #IO_L5P_T0_AD13P_35	Sch=ad_p[13]	ChipKit pin=A8
#set_property -dict { PACKAGE_PIN E5    IOSTANDARD LVCMOS33 } [get_ports { ck_io23 }]; #IO_L5N_T0_AD13N_35	Sch=ad_n[13]	ChipKit pin=A9
#set_property -dict { PACKAGE_PIN A4    IOSTANDARD LVCMOS33 } [get_ports { ck_io24 }]; #IO_L8P_T1_AD14P_35	Sch=ad_p[14]	ChipKit pin=A10
#set_property -dict { PACKAGE_PIN A3    IOSTANDARD LVCMOS33 } [get_ports { ck_io25 }]; #IO_L8N_T1_AD14N_35	Sch=ad_n[14]	ChipKit pin=A11

## ChipKit SPI
#set_property -dict { PACKAGE_PIN G1    IOSTANDARD LVCMOS33 } [get_ports { ck_miso }]; #IO_L17N_T2_35 Sch=ck_miso
#set_property -dict { PACKAGE_PIN H1    IOSTANDARD LVCMOS33 } [get_ports { ck_mosi }]; #IO_L17P_T2_35 Sch=ck_mosi
#set_property -dict { PACKAGE_PIN F1    IOSTANDARD LVCMOS33 } [get_ports { ck_sck }]; #IO_L18P_T2_35 Sch=ck_sck
#set_property -dict { PACKAGE_PIN C1    IOSTANDARD LVCMOS33 } [get_ports { ck_ss }]; #IO_L16N_T2_35 Sch=ck_ss

## ChipKit I2C
#set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { ck_scl }]; #IO_L4P_T0_D04_14 Sch=ck_scl
#set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { ck_sda }]; #IO_L4N_T0_D05_14 Sch=ck_sda
#set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVCMOS33 } [get_ports { scl_pup }]; #IO_L9N_T1_DQS_AD3N_15 Sch=scl_pup
#set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVCMOS33 } [get_ports { sda_pup }]; #IO_L9P_T1_DQS_AD3P_15 Sch=sda_pup

## Misc. ChipKit Ports
#set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { ck_ioa }]; #IO_L10N_T1_D15_14 Sch=ck_ioa
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports resetn]

## SMSC Ethernet PHY
#set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVCMOS33 } [get_ports { eth_col }]; #IO_L16N_T2_A27_15 Sch=eth_col
#set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { eth_crs }]; #IO_L15N_T2_DQS_ADV_B_15 Sch=eth_crs
#set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { eth_mdc }]; #IO_L14N_T2_SRCC_15 Sch=eth_mdc
#set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { eth_mdio }]; #IO_L17P_T2_A26_15 Sch=eth_mdio
#set_property -dict { PACKAGE_PIN G18   IOSTANDARD LVCMOS33 } [get_ports { eth_ref_clk }]; #IO_L22P_T3_A17_15 Sch=eth_ref_clk
#set_property -dict { PACKAGE_PIN C16   IOSTANDARD LVCMOS33 } [get_ports { eth_rstn }]; #IO_L20P_T3_A20_15 Sch=eth_rstn
#set_property -dict { PACKAGE_PIN F15   IOSTANDARD LVCMOS33 } [get_ports { eth_rx_clk }]; #IO_L14P_T2_SRCC_15 Sch=eth_rx_clk
#set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { eth_rx_dv }]; #IO_L13N_T2_MRCC_15 Sch=eth_rx_dv
#set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[0] }]; #IO_L21N_T3_DQS_A18_15 Sch=eth_rxd[0]
#set_property -dict { PACKAGE_PIN E17   IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[1] }]; #IO_L16P_T2_A28_15 Sch=eth_rxd[1]
#set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[2] }]; #IO_L21P_T3_DQS_15 Sch=eth_rxd[2]
#set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[3] }]; #IO_L18N_T2_A23_15 Sch=eth_rxd[3]
#set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports { eth_rxerr }]; #IO_L20N_T3_A19_15 Sch=eth_rxerr
#set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { eth_tx_clk }]; #IO_L13P_T2_MRCC_15 Sch=eth_tx_clk
#set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { eth_tx_en }]; #IO_L19N_T3_A21_VREF_15 Sch=eth_tx_en
#set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { eth_txd[0] }]; #IO_L15P_T2_DQS_15 Sch=eth_txd[0]
#set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { eth_txd[1] }]; #IO_L19P_T3_A22_15 Sch=eth_txd[1]
#set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { eth_txd[2] }]; #IO_L17N_T2_A25_15 Sch=eth_txd[2]
#set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { eth_txd[3] }]; #IO_L18P_T2_A24_15 Sch=eth_txd[3]

## Quad SPI Flash
#set_property -dict { PACKAGE_PIN L13   IOSTANDARD LVCMOS33 } [get_ports { qspi_cs }]; #IO_L6P_T0_FCS_B_14 Sch=qspi_cs
#set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[0] }]; #IO_L1P_T0_D00_MOSI_14 Sch=qspi_dq[0]
#set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[1] }]; #IO_L1N_T0_D01_DIN_14 Sch=qspi_dq[1]
#set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[2] }]; #IO_L2P_T0_D02_14 Sch=qspi_dq[2]
#set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[3] }]; #IO_L2N_T0_D03_14 Sch=qspi_dq[3]

## Power Measurements
#set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS33     } [get_ports { vsnsvu_n }]; #IO_L7N_T1_AD2N_15 Sch=ad_n[2]
#set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVCMOS33     } [get_ports { vsnsvu_p }]; #IO_L7P_T1_AD2P_15 Sch=ad_p[2]
#set_property -dict { PACKAGE_PIN B12   IOSTANDARD LVCMOS33     } [get_ports { vsns5v0_n }]; #IO_L3N_T0_DQS_AD1N_15 Sch=ad_n[1]
#set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33     } [get_ports { vsns5v0_p }]; #IO_L3P_T0_DQS_AD1P_15 Sch=ad_p[1]
#set_property -dict { PACKAGE_PIN F14   IOSTANDARD LVCMOS33     } [get_ports { isns5v0_n }]; #IO_L5N_T0_AD9N_15 Sch=ad_n[9]
#set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVCMOS33     } [get_ports { isns5v0_p }]; #IO_L5P_T0_AD9P_15 Sch=ad_p[9]
#set_property -dict { PACKAGE_PIN A16   IOSTANDARD LVCMOS33     } [get_ports { isns0v95_n }]; #IO_L8N_T1_AD10N_15 Sch=ad_n[10]
#set_property -dict { PACKAGE_PIN A15   IOSTANDARD LVCMOS33     } [get_ports { isns0v95_p }]; #IO_L8P_T1_AD10P_15 Sch=ad_p[10]

set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 2 [current_design]








connect_debug_port u_ila_0/clk [get_nets [list clock_IBUF_BUFG]]
connect_debug_port dbg_hub/clk [get_nets clock_IBUF_BUFG]



connect_debug_port u_ila_0/probe6 [get_nets [list {io_debugSignals_dram_rdata[0]} {io_debugSignals_dram_rdata[1]} {io_debugSignals_dram_rdata[2]} {io_debugSignals_dram_rdata[3]} {io_debugSignals_dram_rdata[4]} {io_debugSignals_dram_rdata[5]} {io_debugSignals_dram_rdata[6]} {io_debugSignals_dram_rdata[7]} {io_debugSignals_dram_rdata[8]} {io_debugSignals_dram_rdata[9]} {io_debugSignals_dram_rdata[10]} {io_debugSignals_dram_rdata[11]} {io_debugSignals_dram_rdata[12]} {io_debugSignals_dram_rdata[13]} {io_debugSignals_dram_rdata[14]} {io_debugSignals_dram_rdata[15]} {io_debugSignals_dram_rdata[16]} {io_debugSignals_dram_rdata[17]} {io_debugSignals_dram_rdata[18]} {io_debugSignals_dram_rdata[19]} {io_debugSignals_dram_rdata[20]} {io_debugSignals_dram_rdata[21]} {io_debugSignals_dram_rdata[22]} {io_debugSignals_dram_rdata[23]} {io_debugSignals_dram_rdata[24]} {io_debugSignals_dram_rdata[25]} {io_debugSignals_dram_rdata[26]} {io_debugSignals_dram_rdata[27]} {io_debugSignals_dram_rdata[28]} {io_debugSignals_dram_rdata[29]} {io_debugSignals_dram_rdata[30]} {io_debugSignals_dram_rdata[31]} {io_debugSignals_dram_rdata[32]} {io_debugSignals_dram_rdata[33]} {io_debugSignals_dram_rdata[34]} {io_debugSignals_dram_rdata[35]} {io_debugSignals_dram_rdata[36]} {io_debugSignals_dram_rdata[37]} {io_debugSignals_dram_rdata[38]} {io_debugSignals_dram_rdata[39]} {io_debugSignals_dram_rdata[40]} {io_debugSignals_dram_rdata[41]} {io_debugSignals_dram_rdata[42]} {io_debugSignals_dram_rdata[43]} {io_debugSignals_dram_rdata[44]} {io_debugSignals_dram_rdata[45]} {io_debugSignals_dram_rdata[46]} {io_debugSignals_dram_rdata[47]} {io_debugSignals_dram_rdata[48]} {io_debugSignals_dram_rdata[49]} {io_debugSignals_dram_rdata[50]} {io_debugSignals_dram_rdata[51]} {io_debugSignals_dram_rdata[52]} {io_debugSignals_dram_rdata[53]} {io_debugSignals_dram_rdata[54]} {io_debugSignals_dram_rdata[55]} {io_debugSignals_dram_rdata[56]} {io_debugSignals_dram_rdata[57]} {io_debugSignals_dram_rdata[58]} {io_debugSignals_dram_rdata[59]} {io_debugSignals_dram_rdata[60]} {io_debugSignals_dram_rdata[61]} {io_debugSignals_dram_rdata[62]} {io_debugSignals_dram_rdata[63]} {io_debugSignals_dram_rdata[64]} {io_debugSignals_dram_rdata[65]} {io_debugSignals_dram_rdata[66]} {io_debugSignals_dram_rdata[67]} {io_debugSignals_dram_rdata[68]} {io_debugSignals_dram_rdata[69]} {io_debugSignals_dram_rdata[70]} {io_debugSignals_dram_rdata[71]} {io_debugSignals_dram_rdata[72]} {io_debugSignals_dram_rdata[73]} {io_debugSignals_dram_rdata[74]} {io_debugSignals_dram_rdata[75]} {io_debugSignals_dram_rdata[76]} {io_debugSignals_dram_rdata[77]} {io_debugSignals_dram_rdata[78]} {io_debugSignals_dram_rdata[79]} {io_debugSignals_dram_rdata[80]} {io_debugSignals_dram_rdata[81]} {io_debugSignals_dram_rdata[82]} {io_debugSignals_dram_rdata[83]} {io_debugSignals_dram_rdata[84]} {io_debugSignals_dram_rdata[85]} {io_debugSignals_dram_rdata[86]} {io_debugSignals_dram_rdata[87]} {io_debugSignals_dram_rdata[88]} {io_debugSignals_dram_rdata[89]} {io_debugSignals_dram_rdata[90]} {io_debugSignals_dram_rdata[91]} {io_debugSignals_dram_rdata[92]} {io_debugSignals_dram_rdata[93]} {io_debugSignals_dram_rdata[94]} {io_debugSignals_dram_rdata[95]} {io_debugSignals_dram_rdata[96]} {io_debugSignals_dram_rdata[97]} {io_debugSignals_dram_rdata[98]} {io_debugSignals_dram_rdata[99]} {io_debugSignals_dram_rdata[100]} {io_debugSignals_dram_rdata[101]} {io_debugSignals_dram_rdata[102]} {io_debugSignals_dram_rdata[103]} {io_debugSignals_dram_rdata[104]} {io_debugSignals_dram_rdata[105]} {io_debugSignals_dram_rdata[106]} {io_debugSignals_dram_rdata[107]} {io_debugSignals_dram_rdata[108]} {io_debugSignals_dram_rdata[109]} {io_debugSignals_dram_rdata[110]} {io_debugSignals_dram_rdata[111]} {io_debugSignals_dram_rdata[112]} {io_debugSignals_dram_rdata[113]} {io_debugSignals_dram_rdata[114]} {io_debugSignals_dram_rdata[115]} {io_debugSignals_dram_rdata[116]} {io_debugSignals_dram_rdata[117]} {io_debugSignals_dram_rdata[118]} {io_debugSignals_dram_rdata[119]} {io_debugSignals_dram_rdata[120]} {io_debugSignals_dram_rdata[121]} {io_debugSignals_dram_rdata[122]} {io_debugSignals_dram_rdata[123]} {io_debugSignals_dram_rdata[124]} {io_debugSignals_dram_rdata[125]} {io_debugSignals_dram_rdata[126]} {io_debugSignals_dram_rdata[127]}]]






connect_debug_port u_ila_0/probe4 [get_nets [list {io_debugSignals_sram2_wdata[0]} {io_debugSignals_sram2_wdata[1]} {io_debugSignals_sram2_wdata[2]} {io_debugSignals_sram2_wdata[3]} {io_debugSignals_sram2_wdata[4]} {io_debugSignals_sram2_wdata[5]} {io_debugSignals_sram2_wdata[6]} {io_debugSignals_sram2_wdata[7]} {io_debugSignals_sram2_wdata[8]} {io_debugSignals_sram2_wdata[9]} {io_debugSignals_sram2_wdata[10]} {io_debugSignals_sram2_wdata[11]} {io_debugSignals_sram2_wdata[12]} {io_debugSignals_sram2_wdata[13]} {io_debugSignals_sram2_wdata[14]} {io_debugSignals_sram2_wdata[15]} {io_debugSignals_sram2_wdata[16]} {io_debugSignals_sram2_wdata[17]} {io_debugSignals_sram2_wdata[18]} {io_debugSignals_sram2_wdata[19]} {io_debugSignals_sram2_wdata[20]} {io_debugSignals_sram2_wdata[21]} {io_debugSignals_sram2_wdata[22]} {io_debugSignals_sram2_wdata[23]} {io_debugSignals_sram2_wdata[24]} {io_debugSignals_sram2_wdata[25]} {io_debugSignals_sram2_wdata[26]} {io_debugSignals_sram2_wdata[27]} {io_debugSignals_sram2_wdata[28]} {io_debugSignals_sram2_wdata[29]} {io_debugSignals_sram2_wdata[30]} {io_debugSignals_sram2_wdata[31]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list {io_debugSignals_sram2_rdata[0]} {io_debugSignals_sram2_rdata[1]} {io_debugSignals_sram2_rdata[2]} {io_debugSignals_sram2_rdata[3]} {io_debugSignals_sram2_rdata[4]} {io_debugSignals_sram2_rdata[5]} {io_debugSignals_sram2_rdata[6]} {io_debugSignals_sram2_rdata[7]} {io_debugSignals_sram2_rdata[8]} {io_debugSignals_sram2_rdata[9]} {io_debugSignals_sram2_rdata[10]} {io_debugSignals_sram2_rdata[11]} {io_debugSignals_sram2_rdata[12]} {io_debugSignals_sram2_rdata[13]} {io_debugSignals_sram2_rdata[14]} {io_debugSignals_sram2_rdata[15]} {io_debugSignals_sram2_rdata[16]} {io_debugSignals_sram2_rdata[17]} {io_debugSignals_sram2_rdata[18]} {io_debugSignals_sram2_rdata[19]} {io_debugSignals_sram2_rdata[20]} {io_debugSignals_sram2_rdata[21]} {io_debugSignals_sram2_rdata[22]} {io_debugSignals_sram2_rdata[23]} {io_debugSignals_sram2_rdata[24]} {io_debugSignals_sram2_rdata[25]} {io_debugSignals_sram2_rdata[26]} {io_debugSignals_sram2_rdata[27]} {io_debugSignals_sram2_rdata[28]} {io_debugSignals_sram2_rdata[29]} {io_debugSignals_sram2_rdata[30]} {io_debugSignals_sram2_rdata[31]}]]
connect_debug_port u_ila_0/probe8 [get_nets [list {io_debugSignals_sram1_wdata[0]} {io_debugSignals_sram1_wdata[1]} {io_debugSignals_sram1_wdata[2]} {io_debugSignals_sram1_wdata[3]} {io_debugSignals_sram1_wdata[4]} {io_debugSignals_sram1_wdata[5]} {io_debugSignals_sram1_wdata[6]} {io_debugSignals_sram1_wdata[7]} {io_debugSignals_sram1_wdata[8]} {io_debugSignals_sram1_wdata[9]} {io_debugSignals_sram1_wdata[10]} {io_debugSignals_sram1_wdata[11]} {io_debugSignals_sram1_wdata[12]} {io_debugSignals_sram1_wdata[13]} {io_debugSignals_sram1_wdata[14]} {io_debugSignals_sram1_wdata[15]} {io_debugSignals_sram1_wdata[16]} {io_debugSignals_sram1_wdata[17]} {io_debugSignals_sram1_wdata[18]} {io_debugSignals_sram1_wdata[19]} {io_debugSignals_sram1_wdata[20]} {io_debugSignals_sram1_wdata[21]} {io_debugSignals_sram1_wdata[22]} {io_debugSignals_sram1_wdata[23]} {io_debugSignals_sram1_wdata[24]} {io_debugSignals_sram1_wdata[25]} {io_debugSignals_sram1_wdata[26]} {io_debugSignals_sram1_wdata[27]} {io_debugSignals_sram1_wdata[28]} {io_debugSignals_sram1_wdata[29]} {io_debugSignals_sram1_wdata[30]} {io_debugSignals_sram1_wdata[31]}]]
connect_debug_port u_ila_0/probe9 [get_nets [list {io_debugSignals_sram1_rdata[0]} {io_debugSignals_sram1_rdata[1]} {io_debugSignals_sram1_rdata[2]} {io_debugSignals_sram1_rdata[3]} {io_debugSignals_sram1_rdata[4]} {io_debugSignals_sram1_rdata[5]} {io_debugSignals_sram1_rdata[6]} {io_debugSignals_sram1_rdata[7]} {io_debugSignals_sram1_rdata[8]} {io_debugSignals_sram1_rdata[9]} {io_debugSignals_sram1_rdata[10]} {io_debugSignals_sram1_rdata[11]} {io_debugSignals_sram1_rdata[12]} {io_debugSignals_sram1_rdata[13]} {io_debugSignals_sram1_rdata[14]} {io_debugSignals_sram1_rdata[15]} {io_debugSignals_sram1_rdata[16]} {io_debugSignals_sram1_rdata[17]} {io_debugSignals_sram1_rdata[18]} {io_debugSignals_sram1_rdata[19]} {io_debugSignals_sram1_rdata[20]} {io_debugSignals_sram1_rdata[21]} {io_debugSignals_sram1_rdata[22]} {io_debugSignals_sram1_rdata[23]} {io_debugSignals_sram1_rdata[24]} {io_debugSignals_sram1_rdata[25]} {io_debugSignals_sram1_rdata[26]} {io_debugSignals_sram1_rdata[27]} {io_debugSignals_sram1_rdata[28]} {io_debugSignals_sram1_rdata[29]} {io_debugSignals_sram1_rdata[30]} {io_debugSignals_sram1_rdata[31]} {io_debugSignals_sram1_rdata[32]}]]






connect_debug_port u_ila_0/probe10 [get_nets [list {io_debugSignals_core_ra[0]} {io_debugSignals_core_ra[1]} {io_debugSignals_core_ra[2]} {io_debugSignals_core_ra[3]} {io_debugSignals_core_ra[4]} {io_debugSignals_core_ra[5]} {io_debugSignals_core_ra[6]} {io_debugSignals_core_ra[7]} {io_debugSignals_core_ra[8]} {io_debugSignals_core_ra[9]} {io_debugSignals_core_ra[10]} {io_debugSignals_core_ra[11]} {io_debugSignals_core_ra[12]} {io_debugSignals_core_ra[13]} {io_debugSignals_core_ra[14]} {io_debugSignals_core_ra[15]} {io_debugSignals_core_ra[16]} {io_debugSignals_core_ra[17]} {io_debugSignals_core_ra[18]} {io_debugSignals_core_ra[19]} {io_debugSignals_core_ra[20]} {io_debugSignals_core_ra[21]} {io_debugSignals_core_ra[22]} {io_debugSignals_core_ra[23]} {io_debugSignals_core_ra[24]} {io_debugSignals_core_ra[25]} {io_debugSignals_core_ra[26]} {io_debugSignals_core_ra[27]} {io_debugSignals_core_ra[28]} {io_debugSignals_core_ra[29]} {io_debugSignals_core_ra[30]} {io_debugSignals_core_ra[31]}]]


connect_debug_port u_ila_0/probe1 [get_nets [list {io_debugSignals_core_a1[0]} {io_debugSignals_core_a1[1]} {io_debugSignals_core_a1[2]} {io_debugSignals_core_a1[3]} {io_debugSignals_core_a1[4]} {io_debugSignals_core_a1[5]} {io_debugSignals_core_a1[6]} {io_debugSignals_core_a1[7]} {io_debugSignals_core_a1[8]} {io_debugSignals_core_a1[9]} {io_debugSignals_core_a1[10]} {io_debugSignals_core_a1[11]} {io_debugSignals_core_a1[12]} {io_debugSignals_core_a1[13]} {io_debugSignals_core_a1[14]} {io_debugSignals_core_a1[15]} {io_debugSignals_core_a1[16]} {io_debugSignals_core_a1[17]} {io_debugSignals_core_a1[18]} {io_debugSignals_core_a1[19]} {io_debugSignals_core_a1[20]} {io_debugSignals_core_a1[21]} {io_debugSignals_core_a1[22]} {io_debugSignals_core_a1[23]} {io_debugSignals_core_a1[24]} {io_debugSignals_core_a1[25]} {io_debugSignals_core_a1[26]} {io_debugSignals_core_a1[27]} {io_debugSignals_core_a1[28]} {io_debugSignals_core_a1[29]} {io_debugSignals_core_a1[30]} {io_debugSignals_core_a1[31]}]]

connect_debug_port u_ila_0/probe10 [get_nets [list {io_debugSignals_core_id_reg_inst[0]} {io_debugSignals_core_id_reg_inst[1]} {io_debugSignals_core_id_reg_inst[2]} {io_debugSignals_core_id_reg_inst[3]} {io_debugSignals_core_id_reg_inst[4]} {io_debugSignals_core_id_reg_inst[5]} {io_debugSignals_core_id_reg_inst[6]} {io_debugSignals_core_id_reg_inst[7]} {io_debugSignals_core_id_reg_inst[8]} {io_debugSignals_core_id_reg_inst[9]} {io_debugSignals_core_id_reg_inst[10]} {io_debugSignals_core_id_reg_inst[11]} {io_debugSignals_core_id_reg_inst[12]} {io_debugSignals_core_id_reg_inst[13]} {io_debugSignals_core_id_reg_inst[14]} {io_debugSignals_core_id_reg_inst[15]} {io_debugSignals_core_id_reg_inst[16]} {io_debugSignals_core_id_reg_inst[17]} {io_debugSignals_core_id_reg_inst[18]} {io_debugSignals_core_id_reg_inst[19]} {io_debugSignals_core_id_reg_inst[20]} {io_debugSignals_core_id_reg_inst[21]} {io_debugSignals_core_id_reg_inst[22]} {io_debugSignals_core_id_reg_inst[23]} {io_debugSignals_core_id_reg_inst[24]} {io_debugSignals_core_id_reg_inst[25]} {io_debugSignals_core_id_reg_inst[26]} {io_debugSignals_core_id_reg_inst[27]} {io_debugSignals_core_id_reg_inst[28]} {io_debugSignals_core_id_reg_inst[29]} {io_debugSignals_core_id_reg_inst[30]} {io_debugSignals_core_id_reg_inst[31]}]]

connect_debug_port u_ila_0/probe3 [get_nets [list {io_debugSignals_sram2_we[0]} {io_debugSignals_sram2_we[1]} {io_debugSignals_sram2_we[2]} {io_debugSignals_sram2_we[3]} {io_debugSignals_sram2_we[4]} {io_debugSignals_sram2_we[5]} {io_debugSignals_sram2_we[6]} {io_debugSignals_sram2_we[7]} {io_debugSignals_sram2_we[8]} {io_debugSignals_sram2_we[9]} {io_debugSignals_sram2_we[10]} {io_debugSignals_sram2_we[11]} {io_debugSignals_sram2_we[12]} {io_debugSignals_sram2_we[13]} {io_debugSignals_sram2_we[14]} {io_debugSignals_sram2_we[15]} {io_debugSignals_sram2_we[16]} {io_debugSignals_sram2_we[17]} {io_debugSignals_sram2_we[18]} {io_debugSignals_sram2_we[19]} {io_debugSignals_sram2_we[20]} {io_debugSignals_sram2_we[21]} {io_debugSignals_sram2_we[22]} {io_debugSignals_sram2_we[23]} {io_debugSignals_sram2_we[24]} {io_debugSignals_sram2_we[25]} {io_debugSignals_sram2_we[26]} {io_debugSignals_sram2_we[27]} {io_debugSignals_sram2_we[28]} {io_debugSignals_sram2_we[29]} {io_debugSignals_sram2_we[30]} {io_debugSignals_sram2_we[31]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {io_debugSignals_sram2_addr[0]} {io_debugSignals_sram2_addr[1]} {io_debugSignals_sram2_addr[2]} {io_debugSignals_sram2_addr[3]} {io_debugSignals_sram2_addr[4]} {io_debugSignals_sram2_addr[5]} {io_debugSignals_sram2_addr[6]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list {io_debugSignals_sram1_we[0]} {io_debugSignals_sram1_we[1]} {io_debugSignals_sram1_we[2]} {io_debugSignals_sram1_we[3]} {io_debugSignals_sram1_we[4]} {io_debugSignals_sram1_we[5]} {io_debugSignals_sram1_we[6]} {io_debugSignals_sram1_we[7]} {io_debugSignals_sram1_we[8]} {io_debugSignals_sram1_we[9]} {io_debugSignals_sram1_we[10]} {io_debugSignals_sram1_we[11]} {io_debugSignals_sram1_we[12]} {io_debugSignals_sram1_we[13]} {io_debugSignals_sram1_we[14]} {io_debugSignals_sram1_we[15]} {io_debugSignals_sram1_we[16]} {io_debugSignals_sram1_we[17]} {io_debugSignals_sram1_we[18]} {io_debugSignals_sram1_we[19]} {io_debugSignals_sram1_we[20]} {io_debugSignals_sram1_we[21]} {io_debugSignals_sram1_we[22]} {io_debugSignals_sram1_we[23]} {io_debugSignals_sram1_we[24]} {io_debugSignals_sram1_we[25]} {io_debugSignals_sram1_we[26]} {io_debugSignals_sram1_we[27]} {io_debugSignals_sram1_we[28]} {io_debugSignals_sram1_we[29]} {io_debugSignals_sram1_we[30]} {io_debugSignals_sram1_we[31]}]]
connect_debug_port u_ila_0/probe6 [get_nets [list {io_debugSignals_sram1_addr[0]} {io_debugSignals_sram1_addr[1]} {io_debugSignals_sram1_addr[2]} {io_debugSignals_sram1_addr[3]} {io_debugSignals_sram1_addr[4]} {io_debugSignals_sram1_addr[5]} {io_debugSignals_sram1_addr[6]}]]
connect_debug_port u_ila_0/probe11 [get_nets [list {io_debugSignals_core_instret[0]} {io_debugSignals_core_instret[1]} {io_debugSignals_core_instret[2]} {io_debugSignals_core_instret[3]} {io_debugSignals_core_instret[4]} {io_debugSignals_core_instret[5]} {io_debugSignals_core_instret[6]} {io_debugSignals_core_instret[7]} {io_debugSignals_core_instret[8]} {io_debugSignals_core_instret[9]} {io_debugSignals_core_instret[10]} {io_debugSignals_core_instret[11]} {io_debugSignals_core_instret[12]} {io_debugSignals_core_instret[13]} {io_debugSignals_core_instret[14]} {io_debugSignals_core_instret[15]} {io_debugSignals_core_instret[16]} {io_debugSignals_core_instret[17]} {io_debugSignals_core_instret[18]} {io_debugSignals_core_instret[19]} {io_debugSignals_core_instret[20]} {io_debugSignals_core_instret[21]} {io_debugSignals_core_instret[22]} {io_debugSignals_core_instret[23]} {io_debugSignals_core_instret[24]} {io_debugSignals_core_instret[25]} {io_debugSignals_core_instret[26]} {io_debugSignals_core_instret[27]} {io_debugSignals_core_instret[28]} {io_debugSignals_core_instret[29]} {io_debugSignals_core_instret[30]} {io_debugSignals_core_instret[31]}]]
connect_debug_port u_ila_0/probe28 [get_nets [list io_debugSignals_sram1_en]]
connect_debug_port u_ila_0/probe29 [get_nets [list io_debugSignals_sram2_en]]

connect_debug_port u_ila_0/probe19 [get_nets [list io_debugSignals_sdc_clk]]

connect_debug_port u_ila_0/probe19 [get_nets [list io_debugSignals_sdc_cmd_out]]
connect_debug_port u_ila_0/probe20 [get_nets [list io_debugSignals_sdc_cmd_wrt]]
connect_debug_port u_ila_0/probe21 [get_nets [list io_debugSignals_sdc_res_in]]
connect_debug_port u_ila_0/probe22 [get_nets [list io_debugSignals_sdc_rx_dat_index]]

connect_debug_port u_ila_0/probe1 [get_nets [list {io_debugSignals_raddr[0]} {io_debugSignals_raddr[1]} {io_debugSignals_raddr[2]} {io_debugSignals_raddr[3]} {io_debugSignals_raddr[4]} {io_debugSignals_raddr[5]} {io_debugSignals_raddr[6]} {io_debugSignals_raddr[7]} {io_debugSignals_raddr[8]} {io_debugSignals_raddr[9]} {io_debugSignals_raddr[10]} {io_debugSignals_raddr[11]} {io_debugSignals_raddr[12]} {io_debugSignals_raddr[13]} {io_debugSignals_raddr[14]} {io_debugSignals_raddr[15]} {io_debugSignals_raddr[16]} {io_debugSignals_raddr[17]} {io_debugSignals_raddr[18]} {io_debugSignals_raddr[19]} {io_debugSignals_raddr[20]} {io_debugSignals_raddr[21]} {io_debugSignals_raddr[22]} {io_debugSignals_raddr[23]} {io_debugSignals_raddr[24]} {io_debugSignals_raddr[25]} {io_debugSignals_raddr[26]} {io_debugSignals_raddr[27]} {io_debugSignals_raddr[28]} {io_debugSignals_raddr[29]} {io_debugSignals_raddr[30]} {io_debugSignals_raddr[31]}]]
connect_debug_port u_ila_0/probe7 [get_nets [list {io_debugSignals_waddr[0]} {io_debugSignals_waddr[1]} {io_debugSignals_waddr[2]} {io_debugSignals_waddr[3]} {io_debugSignals_waddr[4]} {io_debugSignals_waddr[5]} {io_debugSignals_waddr[6]} {io_debugSignals_waddr[7]} {io_debugSignals_waddr[8]} {io_debugSignals_waddr[9]} {io_debugSignals_waddr[10]} {io_debugSignals_waddr[11]} {io_debugSignals_waddr[12]} {io_debugSignals_waddr[13]} {io_debugSignals_waddr[14]} {io_debugSignals_waddr[15]} {io_debugSignals_waddr[16]} {io_debugSignals_waddr[17]} {io_debugSignals_waddr[18]} {io_debugSignals_waddr[19]} {io_debugSignals_waddr[20]} {io_debugSignals_waddr[21]} {io_debugSignals_waddr[22]} {io_debugSignals_waddr[23]} {io_debugSignals_waddr[24]} {io_debugSignals_waddr[25]} {io_debugSignals_waddr[26]} {io_debugSignals_waddr[27]} {io_debugSignals_waddr[28]} {io_debugSignals_waddr[29]} {io_debugSignals_waddr[30]} {io_debugSignals_waddr[31]}]]
connect_debug_port u_ila_0/probe15 [get_nets [list io_debugSignals_dram_busy]]
connect_debug_port u_ila_0/probe16 [get_nets [list io_debugSignals_dram_init_calib_complete]]
connect_debug_port u_ila_0/probe17 [get_nets [list io_debugSignals_dram_rdata_valid]]
connect_debug_port u_ila_0/probe18 [get_nets [list io_debugSignals_dram_ren]]

connect_debug_port u_ila_0/probe0 [get_nets [list {io_debugSignals_sdc_rx_dat_index[0]} {io_debugSignals_sdc_rx_dat_index[1]} {io_debugSignals_sdc_rx_dat_index[2]} {io_debugSignals_sdc_rx_dat_index[3]} {io_debugSignals_sdc_rx_dat_index[4]} {io_debugSignals_sdc_rx_dat_index[5]} {io_debugSignals_sdc_rx_dat_index[6]} {io_debugSignals_sdc_rx_dat_index[7]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {io_debugSignals_sdc_dat_in[0]} {io_debugSignals_sdc_dat_in[1]} {io_debugSignals_sdc_dat_in[2]} {io_debugSignals_sdc_dat_in[3]}]]

connect_debug_port u_ila_0/probe0 [get_nets [list {io_debugSignals_wstrb[0]} {io_debugSignals_wstrb[1]} {io_debugSignals_wstrb[2]} {io_debugSignals_wstrb[3]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {io_debugSignals_wdata[0]} {io_debugSignals_wdata[1]} {io_debugSignals_wdata[2]} {io_debugSignals_wdata[3]} {io_debugSignals_wdata[4]} {io_debugSignals_wdata[5]} {io_debugSignals_wdata[6]} {io_debugSignals_wdata[7]} {io_debugSignals_wdata[8]} {io_debugSignals_wdata[9]} {io_debugSignals_wdata[10]} {io_debugSignals_wdata[11]} {io_debugSignals_wdata[12]} {io_debugSignals_wdata[13]} {io_debugSignals_wdata[14]} {io_debugSignals_wdata[15]} {io_debugSignals_wdata[16]} {io_debugSignals_wdata[17]} {io_debugSignals_wdata[18]} {io_debugSignals_wdata[19]} {io_debugSignals_wdata[20]} {io_debugSignals_wdata[21]} {io_debugSignals_wdata[22]} {io_debugSignals_wdata[23]} {io_debugSignals_wdata[24]} {io_debugSignals_wdata[25]} {io_debugSignals_wdata[26]} {io_debugSignals_wdata[27]} {io_debugSignals_wdata[28]} {io_debugSignals_wdata[29]} {io_debugSignals_wdata[30]} {io_debugSignals_wdata[31]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list {io_debugSignals_rwaddr[0]} {io_debugSignals_rwaddr[1]} {io_debugSignals_rwaddr[2]} {io_debugSignals_rwaddr[3]} {io_debugSignals_rwaddr[4]} {io_debugSignals_rwaddr[5]} {io_debugSignals_rwaddr[6]} {io_debugSignals_rwaddr[7]} {io_debugSignals_rwaddr[8]} {io_debugSignals_rwaddr[9]} {io_debugSignals_rwaddr[10]} {io_debugSignals_rwaddr[11]} {io_debugSignals_rwaddr[12]} {io_debugSignals_rwaddr[13]} {io_debugSignals_rwaddr[14]} {io_debugSignals_rwaddr[15]} {io_debugSignals_rwaddr[16]} {io_debugSignals_rwaddr[17]} {io_debugSignals_rwaddr[18]} {io_debugSignals_rwaddr[19]} {io_debugSignals_rwaddr[20]} {io_debugSignals_rwaddr[21]} {io_debugSignals_rwaddr[22]} {io_debugSignals_rwaddr[23]} {io_debugSignals_rwaddr[24]} {io_debugSignals_rwaddr[25]} {io_debugSignals_rwaddr[26]} {io_debugSignals_rwaddr[27]} {io_debugSignals_rwaddr[28]} {io_debugSignals_rwaddr[29]} {io_debugSignals_rwaddr[30]} {io_debugSignals_rwaddr[31]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {io_debugSignals_core_mem_reg_csr_addr[0]} {io_debugSignals_core_mem_reg_csr_addr[1]} {io_debugSignals_core_mem_reg_csr_addr[2]} {io_debugSignals_core_mem_reg_csr_addr[3]} {io_debugSignals_core_mem_reg_csr_addr[4]} {io_debugSignals_core_mem_reg_csr_addr[5]} {io_debugSignals_core_mem_reg_csr_addr[6]} {io_debugSignals_core_mem_reg_csr_addr[7]} {io_debugSignals_core_mem_reg_csr_addr[8]} {io_debugSignals_core_mem_reg_csr_addr[9]} {io_debugSignals_core_mem_reg_csr_addr[10]} {io_debugSignals_core_mem_reg_csr_addr[11]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {io_debugSignals_rdata[0]} {io_debugSignals_rdata[1]} {io_debugSignals_rdata[2]} {io_debugSignals_rdata[3]} {io_debugSignals_rdata[4]} {io_debugSignals_rdata[5]} {io_debugSignals_rdata[6]} {io_debugSignals_rdata[7]} {io_debugSignals_rdata[8]} {io_debugSignals_rdata[9]} {io_debugSignals_rdata[10]} {io_debugSignals_rdata[11]} {io_debugSignals_rdata[12]} {io_debugSignals_rdata[13]} {io_debugSignals_rdata[14]} {io_debugSignals_rdata[15]} {io_debugSignals_rdata[16]} {io_debugSignals_rdata[17]} {io_debugSignals_rdata[18]} {io_debugSignals_rdata[19]} {io_debugSignals_rdata[20]} {io_debugSignals_rdata[21]} {io_debugSignals_rdata[22]} {io_debugSignals_rdata[23]} {io_debugSignals_rdata[24]} {io_debugSignals_rdata[25]} {io_debugSignals_rdata[26]} {io_debugSignals_rdata[27]} {io_debugSignals_rdata[28]} {io_debugSignals_rdata[29]} {io_debugSignals_rdata[30]} {io_debugSignals_rdata[31]}]]
connect_debug_port u_ila_0/probe5 [get_nets [list {io_debugSignals_core_mem_reg_pc[0]} {io_debugSignals_core_mem_reg_pc[1]} {io_debugSignals_core_mem_reg_pc[2]} {io_debugSignals_core_mem_reg_pc[3]} {io_debugSignals_core_mem_reg_pc[4]} {io_debugSignals_core_mem_reg_pc[5]} {io_debugSignals_core_mem_reg_pc[6]} {io_debugSignals_core_mem_reg_pc[7]} {io_debugSignals_core_mem_reg_pc[8]} {io_debugSignals_core_mem_reg_pc[9]} {io_debugSignals_core_mem_reg_pc[10]} {io_debugSignals_core_mem_reg_pc[11]} {io_debugSignals_core_mem_reg_pc[12]} {io_debugSignals_core_mem_reg_pc[13]} {io_debugSignals_core_mem_reg_pc[14]} {io_debugSignals_core_mem_reg_pc[15]} {io_debugSignals_core_mem_reg_pc[16]} {io_debugSignals_core_mem_reg_pc[17]} {io_debugSignals_core_mem_reg_pc[18]} {io_debugSignals_core_mem_reg_pc[19]} {io_debugSignals_core_mem_reg_pc[20]} {io_debugSignals_core_mem_reg_pc[21]} {io_debugSignals_core_mem_reg_pc[22]} {io_debugSignals_core_mem_reg_pc[23]} {io_debugSignals_core_mem_reg_pc[24]} {io_debugSignals_core_mem_reg_pc[25]} {io_debugSignals_core_mem_reg_pc[26]} {io_debugSignals_core_mem_reg_pc[27]} {io_debugSignals_core_mem_reg_pc[28]} {io_debugSignals_core_mem_reg_pc[29]} {io_debugSignals_core_mem_reg_pc[30]} {io_debugSignals_core_mem_reg_pc[31]}]]
connect_debug_port u_ila_0/probe6 [get_nets [list {io_debugSignals_core_cycle_counter[0]} {io_debugSignals_core_cycle_counter[1]} {io_debugSignals_core_cycle_counter[2]} {io_debugSignals_core_cycle_counter[3]} {io_debugSignals_core_cycle_counter[4]} {io_debugSignals_core_cycle_counter[5]} {io_debugSignals_core_cycle_counter[6]} {io_debugSignals_core_cycle_counter[7]} {io_debugSignals_core_cycle_counter[8]} {io_debugSignals_core_cycle_counter[9]} {io_debugSignals_core_cycle_counter[10]} {io_debugSignals_core_cycle_counter[11]} {io_debugSignals_core_cycle_counter[12]} {io_debugSignals_core_cycle_counter[13]} {io_debugSignals_core_cycle_counter[14]} {io_debugSignals_core_cycle_counter[15]} {io_debugSignals_core_cycle_counter[16]} {io_debugSignals_core_cycle_counter[17]} {io_debugSignals_core_cycle_counter[18]} {io_debugSignals_core_cycle_counter[19]} {io_debugSignals_core_cycle_counter[20]} {io_debugSignals_core_cycle_counter[21]} {io_debugSignals_core_cycle_counter[22]} {io_debugSignals_core_cycle_counter[23]} {io_debugSignals_core_cycle_counter[24]} {io_debugSignals_core_cycle_counter[25]} {io_debugSignals_core_cycle_counter[26]} {io_debugSignals_core_cycle_counter[27]} {io_debugSignals_core_cycle_counter[28]} {io_debugSignals_core_cycle_counter[29]} {io_debugSignals_core_cycle_counter[30]} {io_debugSignals_core_cycle_counter[31]} {io_debugSignals_core_cycle_counter[32]} {io_debugSignals_core_cycle_counter[33]} {io_debugSignals_core_cycle_counter[34]} {io_debugSignals_core_cycle_counter[35]} {io_debugSignals_core_cycle_counter[36]} {io_debugSignals_core_cycle_counter[37]} {io_debugSignals_core_cycle_counter[38]} {io_debugSignals_core_cycle_counter[39]} {io_debugSignals_core_cycle_counter[40]} {io_debugSignals_core_cycle_counter[41]} {io_debugSignals_core_cycle_counter[42]} {io_debugSignals_core_cycle_counter[43]} {io_debugSignals_core_cycle_counter[44]} {io_debugSignals_core_cycle_counter[45]} {io_debugSignals_core_cycle_counter[46]} {io_debugSignals_core_cycle_counter[47]}]]
connect_debug_port u_ila_0/probe7 [get_nets [list {io_debugSignals_core_id_pc[0]} {io_debugSignals_core_id_pc[1]} {io_debugSignals_core_id_pc[2]} {io_debugSignals_core_id_pc[3]} {io_debugSignals_core_id_pc[4]} {io_debugSignals_core_id_pc[5]} {io_debugSignals_core_id_pc[6]} {io_debugSignals_core_id_pc[7]} {io_debugSignals_core_id_pc[8]} {io_debugSignals_core_id_pc[9]} {io_debugSignals_core_id_pc[10]} {io_debugSignals_core_id_pc[11]} {io_debugSignals_core_id_pc[12]} {io_debugSignals_core_id_pc[13]} {io_debugSignals_core_id_pc[14]} {io_debugSignals_core_id_pc[15]} {io_debugSignals_core_id_pc[16]} {io_debugSignals_core_id_pc[17]} {io_debugSignals_core_id_pc[18]} {io_debugSignals_core_id_pc[19]} {io_debugSignals_core_id_pc[20]} {io_debugSignals_core_id_pc[21]} {io_debugSignals_core_id_pc[22]} {io_debugSignals_core_id_pc[23]} {io_debugSignals_core_id_pc[24]} {io_debugSignals_core_id_pc[25]} {io_debugSignals_core_id_pc[26]} {io_debugSignals_core_id_pc[27]} {io_debugSignals_core_id_pc[28]} {io_debugSignals_core_id_pc[29]} {io_debugSignals_core_id_pc[30]} {io_debugSignals_core_id_pc[31]}]]
connect_debug_port u_ila_0/probe8 [get_nets [list {io_debugSignals_core_id_inst[0]} {io_debugSignals_core_id_inst[1]} {io_debugSignals_core_id_inst[2]} {io_debugSignals_core_id_inst[3]} {io_debugSignals_core_id_inst[4]} {io_debugSignals_core_id_inst[5]} {io_debugSignals_core_id_inst[6]} {io_debugSignals_core_id_inst[7]} {io_debugSignals_core_id_inst[8]} {io_debugSignals_core_id_inst[9]} {io_debugSignals_core_id_inst[10]} {io_debugSignals_core_id_inst[11]} {io_debugSignals_core_id_inst[12]} {io_debugSignals_core_id_inst[13]} {io_debugSignals_core_id_inst[14]} {io_debugSignals_core_id_inst[15]} {io_debugSignals_core_id_inst[16]} {io_debugSignals_core_id_inst[17]} {io_debugSignals_core_id_inst[18]} {io_debugSignals_core_id_inst[19]} {io_debugSignals_core_id_inst[20]} {io_debugSignals_core_id_inst[21]} {io_debugSignals_core_id_inst[22]} {io_debugSignals_core_id_inst[23]} {io_debugSignals_core_id_inst[24]} {io_debugSignals_core_id_inst[25]} {io_debugSignals_core_id_inst[26]} {io_debugSignals_core_id_inst[27]} {io_debugSignals_core_id_inst[28]} {io_debugSignals_core_id_inst[29]} {io_debugSignals_core_id_inst[30]} {io_debugSignals_core_id_inst[31]}]]
connect_debug_port u_ila_0/probe9 [get_nets [list {io_debugSignals_core_csr_rdata[0]} {io_debugSignals_core_csr_rdata[1]} {io_debugSignals_core_csr_rdata[2]} {io_debugSignals_core_csr_rdata[3]} {io_debugSignals_core_csr_rdata[4]} {io_debugSignals_core_csr_rdata[5]} {io_debugSignals_core_csr_rdata[6]} {io_debugSignals_core_csr_rdata[7]} {io_debugSignals_core_csr_rdata[8]} {io_debugSignals_core_csr_rdata[9]} {io_debugSignals_core_csr_rdata[10]} {io_debugSignals_core_csr_rdata[11]} {io_debugSignals_core_csr_rdata[12]} {io_debugSignals_core_csr_rdata[13]} {io_debugSignals_core_csr_rdata[14]} {io_debugSignals_core_csr_rdata[15]} {io_debugSignals_core_csr_rdata[16]} {io_debugSignals_core_csr_rdata[17]} {io_debugSignals_core_csr_rdata[18]} {io_debugSignals_core_csr_rdata[19]} {io_debugSignals_core_csr_rdata[20]} {io_debugSignals_core_csr_rdata[21]} {io_debugSignals_core_csr_rdata[22]} {io_debugSignals_core_csr_rdata[23]} {io_debugSignals_core_csr_rdata[24]} {io_debugSignals_core_csr_rdata[25]} {io_debugSignals_core_csr_rdata[26]} {io_debugSignals_core_csr_rdata[27]} {io_debugSignals_core_csr_rdata[28]} {io_debugSignals_core_csr_rdata[29]} {io_debugSignals_core_csr_rdata[30]} {io_debugSignals_core_csr_rdata[31]}]]
connect_debug_port u_ila_0/probe10 [get_nets [list io_debugSignals_core_me_intr]]
connect_debug_port u_ila_0/probe11 [get_nets [list io_debugSignals_core_mem_is_valid_inst]]
connect_debug_port u_ila_0/probe12 [get_nets [list io_debugSignals_ren]]
connect_debug_port u_ila_0/probe13 [get_nets [list io_debugSignals_rvalid]]
connect_debug_port u_ila_0/probe14 [get_nets [list io_debugSignals_wen]]
connect_debug_port u_ila_0/probe15 [get_nets [list io_debugSignals_wready]]


connect_debug_port u_ila_0/probe4 [get_nets [list {io_debugSignals_core_mem_reg_csr_addr[0]} {io_debugSignals_core_mem_reg_csr_addr[1]} {io_debugSignals_core_mem_reg_csr_addr[2]} {io_debugSignals_core_mem_reg_csr_addr[3]} {io_debugSignals_core_mem_reg_csr_addr[4]} {io_debugSignals_core_mem_reg_csr_addr[5]} {io_debugSignals_core_mem_reg_csr_addr[6]} {io_debugSignals_core_mem_reg_csr_addr[7]} {io_debugSignals_core_mem_reg_csr_addr[8]} {io_debugSignals_core_mem_reg_csr_addr[9]} {io_debugSignals_core_mem_reg_csr_addr[10]} {io_debugSignals_core_mem_reg_csr_addr[11]}]]
connect_debug_port u_ila_0/probe9 [get_nets [list {io_debugSignals_core_csr_rdata[0]} {io_debugSignals_core_csr_rdata[1]} {io_debugSignals_core_csr_rdata[2]} {io_debugSignals_core_csr_rdata[3]} {io_debugSignals_core_csr_rdata[4]} {io_debugSignals_core_csr_rdata[5]} {io_debugSignals_core_csr_rdata[6]} {io_debugSignals_core_csr_rdata[7]} {io_debugSignals_core_csr_rdata[8]} {io_debugSignals_core_csr_rdata[9]} {io_debugSignals_core_csr_rdata[10]} {io_debugSignals_core_csr_rdata[11]} {io_debugSignals_core_csr_rdata[12]} {io_debugSignals_core_csr_rdata[13]} {io_debugSignals_core_csr_rdata[14]} {io_debugSignals_core_csr_rdata[15]} {io_debugSignals_core_csr_rdata[16]} {io_debugSignals_core_csr_rdata[17]} {io_debugSignals_core_csr_rdata[18]} {io_debugSignals_core_csr_rdata[19]} {io_debugSignals_core_csr_rdata[20]} {io_debugSignals_core_csr_rdata[21]} {io_debugSignals_core_csr_rdata[22]} {io_debugSignals_core_csr_rdata[23]} {io_debugSignals_core_csr_rdata[24]} {io_debugSignals_core_csr_rdata[25]} {io_debugSignals_core_csr_rdata[26]} {io_debugSignals_core_csr_rdata[27]} {io_debugSignals_core_csr_rdata[28]} {io_debugSignals_core_csr_rdata[29]} {io_debugSignals_core_csr_rdata[30]} {io_debugSignals_core_csr_rdata[31]}]]


connect_debug_port u_ila_0/probe0 [get_nets [list {io_debugSignals_sdc_sdbuf_wdata1[0]} {io_debugSignals_sdc_sdbuf_wdata1[1]} {io_debugSignals_sdc_sdbuf_wdata1[2]} {io_debugSignals_sdc_sdbuf_wdata1[3]} {io_debugSignals_sdc_sdbuf_wdata1[4]} {io_debugSignals_sdc_sdbuf_wdata1[5]} {io_debugSignals_sdc_sdbuf_wdata1[6]} {io_debugSignals_sdc_sdbuf_wdata1[7]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {io_debugSignals_sdc_sdbuf_addr2[0]} {io_debugSignals_sdc_sdbuf_addr2[1]} {io_debugSignals_sdc_sdbuf_addr2[2]} {io_debugSignals_sdc_sdbuf_addr2[3]} {io_debugSignals_sdc_sdbuf_addr2[4]} {io_debugSignals_sdc_sdbuf_addr2[5]} {io_debugSignals_sdc_sdbuf_addr2[6]} {io_debugSignals_sdc_sdbuf_addr2[7]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {io_debugSignals_sdc_sdbuf_addr1[0]} {io_debugSignals_sdc_sdbuf_addr1[1]} {io_debugSignals_sdc_sdbuf_addr1[2]} {io_debugSignals_sdc_sdbuf_addr1[3]} {io_debugSignals_sdc_sdbuf_addr1[4]} {io_debugSignals_sdc_sdbuf_addr1[5]} {io_debugSignals_sdc_sdbuf_addr1[6]} {io_debugSignals_sdc_sdbuf_addr1[7]}]]
connect_debug_port u_ila_0/probe15 [get_nets [list io_debugSignals_sdc_sdbuf_ren1]]
connect_debug_port u_ila_0/probe16 [get_nets [list io_debugSignals_sdc_sdbuf_ren2]]
connect_debug_port u_ila_0/probe17 [get_nets [list io_debugSignals_sdc_sdbuf_wen1]]
connect_debug_port u_ila_0/probe18 [get_nets [list io_debugSignals_sdc_sdbuf_wen2]]


connect_debug_port u_ila_0/probe0 [get_nets [list {io_debugSignals_sdc_sdbuf_wdata1[0]} {io_debugSignals_sdc_sdbuf_wdata1[1]} {io_debugSignals_sdc_sdbuf_wdata1[2]} {io_debugSignals_sdc_sdbuf_wdata1[3]} {io_debugSignals_sdc_sdbuf_wdata1[4]} {io_debugSignals_sdc_sdbuf_wdata1[5]} {io_debugSignals_sdc_sdbuf_wdata1[6]} {io_debugSignals_sdc_sdbuf_wdata1[7]}]]
connect_debug_port u_ila_0/probe3 [get_nets [list {io_debugSignals_sdc_sdbuf_addr2[0]} {io_debugSignals_sdc_sdbuf_addr2[1]} {io_debugSignals_sdc_sdbuf_addr2[2]} {io_debugSignals_sdc_sdbuf_addr2[3]} {io_debugSignals_sdc_sdbuf_addr2[4]} {io_debugSignals_sdc_sdbuf_addr2[5]} {io_debugSignals_sdc_sdbuf_addr2[6]} {io_debugSignals_sdc_sdbuf_addr2[7]}]]
connect_debug_port u_ila_0/probe4 [get_nets [list {io_debugSignals_sdc_sdbuf_addr1[0]} {io_debugSignals_sdc_sdbuf_addr1[1]} {io_debugSignals_sdc_sdbuf_addr1[2]} {io_debugSignals_sdc_sdbuf_addr1[3]} {io_debugSignals_sdc_sdbuf_addr1[4]} {io_debugSignals_sdc_sdbuf_addr1[5]} {io_debugSignals_sdc_sdbuf_addr1[6]} {io_debugSignals_sdc_sdbuf_addr1[7]}]]
connect_debug_port u_ila_0/probe15 [get_nets [list io_debugSignals_sdc_sdbuf_ren1]]
connect_debug_port u_ila_0/probe16 [get_nets [list io_debugSignals_sdc_sdbuf_ren2]]
connect_debug_port u_ila_0/probe17 [get_nets [list io_debugSignals_sdc_sdbuf_wen1]]
connect_debug_port u_ila_0/probe18 [get_nets [list io_debugSignals_sdc_sdbuf_wen2]]


connect_debug_port u_ila_0/probe3 [get_nets [list {io_debugSignals_core_mem_reg_pc[0]} {io_debugSignals_core_mem_reg_pc[1]} {io_debugSignals_core_mem_reg_pc[2]} {io_debugSignals_core_mem_reg_pc[3]} {io_debugSignals_core_mem_reg_pc[4]} {io_debugSignals_core_mem_reg_pc[5]} {io_debugSignals_core_mem_reg_pc[6]} {io_debugSignals_core_mem_reg_pc[7]} {io_debugSignals_core_mem_reg_pc[8]} {io_debugSignals_core_mem_reg_pc[9]} {io_debugSignals_core_mem_reg_pc[10]} {io_debugSignals_core_mem_reg_pc[11]} {io_debugSignals_core_mem_reg_pc[12]} {io_debugSignals_core_mem_reg_pc[13]} {io_debugSignals_core_mem_reg_pc[14]} {io_debugSignals_core_mem_reg_pc[15]} {io_debugSignals_core_mem_reg_pc[16]} {io_debugSignals_core_mem_reg_pc[17]} {io_debugSignals_core_mem_reg_pc[18]} {io_debugSignals_core_mem_reg_pc[19]} {io_debugSignals_core_mem_reg_pc[20]} {io_debugSignals_core_mem_reg_pc[21]} {io_debugSignals_core_mem_reg_pc[22]} {io_debugSignals_core_mem_reg_pc[23]} {io_debugSignals_core_mem_reg_pc[24]} {io_debugSignals_core_mem_reg_pc[25]} {io_debugSignals_core_mem_reg_pc[26]} {io_debugSignals_core_mem_reg_pc[27]} {io_debugSignals_core_mem_reg_pc[28]} {io_debugSignals_core_mem_reg_pc[29]} {io_debugSignals_core_mem_reg_pc[30]} {io_debugSignals_core_mem_reg_pc[31]}]]
connect_debug_port u_ila_0/probe12 [get_nets [list io_debugSignals_core_mem_is_valid_inst]]

connect_debug_port u_ila_0/probe5 [get_nets [list {io_debugSignals_rdata[0]} {io_debugSignals_rdata[1]} {io_debugSignals_rdata[2]} {io_debugSignals_rdata[3]} {io_debugSignals_rdata[4]} {io_debugSignals_rdata[5]} {io_debugSignals_rdata[6]} {io_debugSignals_rdata[7]} {io_debugSignals_rdata[8]} {io_debugSignals_rdata[9]} {io_debugSignals_rdata[10]} {io_debugSignals_rdata[11]} {io_debugSignals_rdata[12]} {io_debugSignals_rdata[13]} {io_debugSignals_rdata[14]} {io_debugSignals_rdata[15]} {io_debugSignals_rdata[16]} {io_debugSignals_rdata[17]} {io_debugSignals_rdata[18]} {io_debugSignals_rdata[19]} {io_debugSignals_rdata[20]} {io_debugSignals_rdata[21]} {io_debugSignals_rdata[22]} {io_debugSignals_rdata[23]} {io_debugSignals_rdata[24]} {io_debugSignals_rdata[25]} {io_debugSignals_rdata[26]} {io_debugSignals_rdata[27]} {io_debugSignals_rdata[28]} {io_debugSignals_rdata[29]} {io_debugSignals_rdata[30]} {io_debugSignals_rdata[31]}]]
connect_debug_port u_ila_0/probe15 [get_nets [list io_debugSignals_rvalid]]


connect_debug_port u_ila_0/probe6 [get_nets [list {io_debugSignals_rwaddr[0]} {io_debugSignals_rwaddr[1]} {io_debugSignals_rwaddr[2]} {io_debugSignals_rwaddr[3]} {io_debugSignals_rwaddr[4]} {io_debugSignals_rwaddr[5]} {io_debugSignals_rwaddr[6]} {io_debugSignals_rwaddr[7]} {io_debugSignals_rwaddr[8]} {io_debugSignals_rwaddr[9]} {io_debugSignals_rwaddr[10]} {io_debugSignals_rwaddr[11]} {io_debugSignals_rwaddr[12]} {io_debugSignals_rwaddr[13]} {io_debugSignals_rwaddr[14]} {io_debugSignals_rwaddr[15]} {io_debugSignals_rwaddr[16]} {io_debugSignals_rwaddr[17]} {io_debugSignals_rwaddr[18]} {io_debugSignals_rwaddr[19]} {io_debugSignals_rwaddr[20]} {io_debugSignals_rwaddr[21]} {io_debugSignals_rwaddr[22]} {io_debugSignals_rwaddr[23]} {io_debugSignals_rwaddr[24]} {io_debugSignals_rwaddr[25]} {io_debugSignals_rwaddr[26]} {io_debugSignals_rwaddr[27]} {io_debugSignals_rwaddr[28]} {io_debugSignals_rwaddr[29]} {io_debugSignals_rwaddr[30]} {io_debugSignals_rwaddr[31]}]]







connect_debug_port u_ila_0/probe7 [get_nets [list {io_debugSignals_core_ic_state[0]} {io_debugSignals_core_ic_state[1]} {io_debugSignals_core_ic_state[2]}]]
connect_debug_port u_ila_0/probe12 [get_nets [list {io_debugSignals_core_if2_reg_bp_taken_pc[1]} {io_debugSignals_core_if2_reg_bp_taken_pc[2]} {io_debugSignals_core_if2_reg_bp_taken_pc[3]} {io_debugSignals_core_if2_reg_bp_taken_pc[4]} {io_debugSignals_core_if2_reg_bp_taken_pc[5]} {io_debugSignals_core_if2_reg_bp_taken_pc[6]} {io_debugSignals_core_if2_reg_bp_taken_pc[7]} {io_debugSignals_core_if2_reg_bp_taken_pc[8]} {io_debugSignals_core_if2_reg_bp_taken_pc[9]} {io_debugSignals_core_if2_reg_bp_taken_pc[10]} {io_debugSignals_core_if2_reg_bp_taken_pc[11]} {io_debugSignals_core_if2_reg_bp_taken_pc[12]} {io_debugSignals_core_if2_reg_bp_taken_pc[13]} {io_debugSignals_core_if2_reg_bp_taken_pc[14]} {io_debugSignals_core_if2_reg_bp_taken_pc[15]} {io_debugSignals_core_if2_reg_bp_taken_pc[16]} {io_debugSignals_core_if2_reg_bp_taken_pc[17]} {io_debugSignals_core_if2_reg_bp_taken_pc[18]} {io_debugSignals_core_if2_reg_bp_taken_pc[19]} {io_debugSignals_core_if2_reg_bp_taken_pc[20]} {io_debugSignals_core_if2_reg_bp_taken_pc[21]} {io_debugSignals_core_if2_reg_bp_taken_pc[22]} {io_debugSignals_core_if2_reg_bp_taken_pc[23]} {io_debugSignals_core_if2_reg_bp_taken_pc[24]} {io_debugSignals_core_if2_reg_bp_taken_pc[25]} {io_debugSignals_core_if2_reg_bp_taken_pc[26]} {io_debugSignals_core_if2_reg_bp_taken_pc[27]} {io_debugSignals_core_if2_reg_bp_taken_pc[28]} {io_debugSignals_core_if2_reg_bp_taken_pc[29]} {io_debugSignals_core_if2_reg_bp_taken_pc[30]} {io_debugSignals_core_if2_reg_bp_taken_pc[31]}]]



connect_debug_port u_ila_0/probe6 [get_nets [list {io_debugSignals_core_btb_up_pc[0]} {io_debugSignals_core_btb_up_pc[1]} {io_debugSignals_core_btb_up_pc[2]} {io_debugSignals_core_btb_up_pc[3]} {io_debugSignals_core_btb_up_pc[4]} {io_debugSignals_core_btb_up_pc[5]} {io_debugSignals_core_btb_up_pc[6]} {io_debugSignals_core_btb_up_pc[7]} {io_debugSignals_core_btb_up_pc[8]} {io_debugSignals_core_btb_up_pc[9]} {io_debugSignals_core_btb_up_pc[10]} {io_debugSignals_core_btb_up_pc[11]} {io_debugSignals_core_btb_up_pc[12]} {io_debugSignals_core_btb_up_pc[13]} {io_debugSignals_core_btb_up_pc[14]} {io_debugSignals_core_btb_up_pc[15]} {io_debugSignals_core_btb_up_pc[16]} {io_debugSignals_core_btb_up_pc[17]} {io_debugSignals_core_btb_up_pc[18]} {io_debugSignals_core_btb_up_pc[19]} {io_debugSignals_core_btb_up_pc[20]} {io_debugSignals_core_btb_up_pc[21]} {io_debugSignals_core_btb_up_pc[22]} {io_debugSignals_core_btb_up_pc[23]} {io_debugSignals_core_btb_up_pc[24]} {io_debugSignals_core_btb_up_pc[25]} {io_debugSignals_core_btb_up_pc[26]} {io_debugSignals_core_btb_up_pc[27]} {io_debugSignals_core_btb_up_pc[28]} {io_debugSignals_core_btb_up_pc[29]} {io_debugSignals_core_btb_up_pc[30]} {io_debugSignals_core_btb_up_pc[31]}]]
connect_debug_port u_ila_0/probe14 [get_nets [list io_debugSignals_core_btb_up_en]]

connect_debug_port u_ila_0/probe0 [get_nets [list {io_debugSignals_core_btb_lu_pc[0]} {io_debugSignals_core_btb_lu_pc[1]} {io_debugSignals_core_btb_lu_pc[2]} {io_debugSignals_core_btb_lu_pc[3]} {io_debugSignals_core_btb_lu_pc[4]} {io_debugSignals_core_btb_lu_pc[5]} {io_debugSignals_core_btb_lu_pc[6]} {io_debugSignals_core_btb_lu_pc[7]} {io_debugSignals_core_btb_lu_pc[8]} {io_debugSignals_core_btb_lu_pc[9]} {io_debugSignals_core_btb_lu_pc[10]} {io_debugSignals_core_btb_lu_pc[11]} {io_debugSignals_core_btb_lu_pc[12]} {io_debugSignals_core_btb_lu_pc[13]} {io_debugSignals_core_btb_lu_pc[14]} {io_debugSignals_core_btb_lu_pc[15]} {io_debugSignals_core_btb_lu_pc[16]} {io_debugSignals_core_btb_lu_pc[17]} {io_debugSignals_core_btb_lu_pc[18]} {io_debugSignals_core_btb_lu_pc[19]} {io_debugSignals_core_btb_lu_pc[20]} {io_debugSignals_core_btb_lu_pc[21]} {io_debugSignals_core_btb_lu_pc[22]} {io_debugSignals_core_btb_lu_pc[23]} {io_debugSignals_core_btb_lu_pc[24]} {io_debugSignals_core_btb_lu_pc[25]} {io_debugSignals_core_btb_lu_pc[26]} {io_debugSignals_core_btb_lu_pc[27]} {io_debugSignals_core_btb_lu_pc[28]} {io_debugSignals_core_btb_lu_pc[29]} {io_debugSignals_core_btb_lu_pc[30]} {io_debugSignals_core_btb_lu_pc[31]}]]

connect_debug_port u_ila_0/probe15 [get_nets [list io_debugSignals_core_if2_reg_bp_taken]]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list dram/clkgen/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {io_debugSignals_core_ex2_reg_pc[0]} {io_debugSignals_core_ex2_reg_pc[1]} {io_debugSignals_core_ex2_reg_pc[2]} {io_debugSignals_core_ex2_reg_pc[3]} {io_debugSignals_core_ex2_reg_pc[4]} {io_debugSignals_core_ex2_reg_pc[5]} {io_debugSignals_core_ex2_reg_pc[6]} {io_debugSignals_core_ex2_reg_pc[7]} {io_debugSignals_core_ex2_reg_pc[8]} {io_debugSignals_core_ex2_reg_pc[9]} {io_debugSignals_core_ex2_reg_pc[10]} {io_debugSignals_core_ex2_reg_pc[11]} {io_debugSignals_core_ex2_reg_pc[12]} {io_debugSignals_core_ex2_reg_pc[13]} {io_debugSignals_core_ex2_reg_pc[14]} {io_debugSignals_core_ex2_reg_pc[15]} {io_debugSignals_core_ex2_reg_pc[16]} {io_debugSignals_core_ex2_reg_pc[17]} {io_debugSignals_core_ex2_reg_pc[18]} {io_debugSignals_core_ex2_reg_pc[19]} {io_debugSignals_core_ex2_reg_pc[20]} {io_debugSignals_core_ex2_reg_pc[21]} {io_debugSignals_core_ex2_reg_pc[22]} {io_debugSignals_core_ex2_reg_pc[23]} {io_debugSignals_core_ex2_reg_pc[24]} {io_debugSignals_core_ex2_reg_pc[25]} {io_debugSignals_core_ex2_reg_pc[26]} {io_debugSignals_core_ex2_reg_pc[27]} {io_debugSignals_core_ex2_reg_pc[28]} {io_debugSignals_core_ex2_reg_pc[29]} {io_debugSignals_core_ex2_reg_pc[30]} {io_debugSignals_core_ex2_reg_pc[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 3 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {io_debugSignals_core_ic_state[0]} {io_debugSignals_core_ic_state[1]} {io_debugSignals_core_ic_state[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 48 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {io_debugSignals_core_cycle_counter[0]} {io_debugSignals_core_cycle_counter[1]} {io_debugSignals_core_cycle_counter[2]} {io_debugSignals_core_cycle_counter[3]} {io_debugSignals_core_cycle_counter[4]} {io_debugSignals_core_cycle_counter[5]} {io_debugSignals_core_cycle_counter[6]} {io_debugSignals_core_cycle_counter[7]} {io_debugSignals_core_cycle_counter[8]} {io_debugSignals_core_cycle_counter[9]} {io_debugSignals_core_cycle_counter[10]} {io_debugSignals_core_cycle_counter[11]} {io_debugSignals_core_cycle_counter[12]} {io_debugSignals_core_cycle_counter[13]} {io_debugSignals_core_cycle_counter[14]} {io_debugSignals_core_cycle_counter[15]} {io_debugSignals_core_cycle_counter[16]} {io_debugSignals_core_cycle_counter[17]} {io_debugSignals_core_cycle_counter[18]} {io_debugSignals_core_cycle_counter[19]} {io_debugSignals_core_cycle_counter[20]} {io_debugSignals_core_cycle_counter[21]} {io_debugSignals_core_cycle_counter[22]} {io_debugSignals_core_cycle_counter[23]} {io_debugSignals_core_cycle_counter[24]} {io_debugSignals_core_cycle_counter[25]} {io_debugSignals_core_cycle_counter[26]} {io_debugSignals_core_cycle_counter[27]} {io_debugSignals_core_cycle_counter[28]} {io_debugSignals_core_cycle_counter[29]} {io_debugSignals_core_cycle_counter[30]} {io_debugSignals_core_cycle_counter[31]} {io_debugSignals_core_cycle_counter[32]} {io_debugSignals_core_cycle_counter[33]} {io_debugSignals_core_cycle_counter[34]} {io_debugSignals_core_cycle_counter[35]} {io_debugSignals_core_cycle_counter[36]} {io_debugSignals_core_cycle_counter[37]} {io_debugSignals_core_cycle_counter[38]} {io_debugSignals_core_cycle_counter[39]} {io_debugSignals_core_cycle_counter[40]} {io_debugSignals_core_cycle_counter[41]} {io_debugSignals_core_cycle_counter[42]} {io_debugSignals_core_cycle_counter[43]} {io_debugSignals_core_cycle_counter[44]} {io_debugSignals_core_cycle_counter[45]} {io_debugSignals_core_cycle_counter[46]} {io_debugSignals_core_cycle_counter[47]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {io_debugSignals_core_id_inst[0]} {io_debugSignals_core_id_inst[1]} {io_debugSignals_core_id_inst[2]} {io_debugSignals_core_id_inst[3]} {io_debugSignals_core_id_inst[4]} {io_debugSignals_core_id_inst[5]} {io_debugSignals_core_id_inst[6]} {io_debugSignals_core_id_inst[7]} {io_debugSignals_core_id_inst[8]} {io_debugSignals_core_id_inst[9]} {io_debugSignals_core_id_inst[10]} {io_debugSignals_core_id_inst[11]} {io_debugSignals_core_id_inst[12]} {io_debugSignals_core_id_inst[13]} {io_debugSignals_core_id_inst[14]} {io_debugSignals_core_id_inst[15]} {io_debugSignals_core_id_inst[16]} {io_debugSignals_core_id_inst[17]} {io_debugSignals_core_id_inst[18]} {io_debugSignals_core_id_inst[19]} {io_debugSignals_core_id_inst[20]} {io_debugSignals_core_id_inst[21]} {io_debugSignals_core_id_inst[22]} {io_debugSignals_core_id_inst[23]} {io_debugSignals_core_id_inst[24]} {io_debugSignals_core_id_inst[25]} {io_debugSignals_core_id_inst[26]} {io_debugSignals_core_id_inst[27]} {io_debugSignals_core_id_inst[28]} {io_debugSignals_core_id_inst[29]} {io_debugSignals_core_id_inst[30]} {io_debugSignals_core_id_inst[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {io_debugSignals_core_id_pc[0]} {io_debugSignals_core_id_pc[1]} {io_debugSignals_core_id_pc[2]} {io_debugSignals_core_id_pc[3]} {io_debugSignals_core_id_pc[4]} {io_debugSignals_core_id_pc[5]} {io_debugSignals_core_id_pc[6]} {io_debugSignals_core_id_pc[7]} {io_debugSignals_core_id_pc[8]} {io_debugSignals_core_id_pc[9]} {io_debugSignals_core_id_pc[10]} {io_debugSignals_core_id_pc[11]} {io_debugSignals_core_id_pc[12]} {io_debugSignals_core_id_pc[13]} {io_debugSignals_core_id_pc[14]} {io_debugSignals_core_id_pc[15]} {io_debugSignals_core_id_pc[16]} {io_debugSignals_core_id_pc[17]} {io_debugSignals_core_id_pc[18]} {io_debugSignals_core_id_pc[19]} {io_debugSignals_core_id_pc[20]} {io_debugSignals_core_id_pc[21]} {io_debugSignals_core_id_pc[22]} {io_debugSignals_core_id_pc[23]} {io_debugSignals_core_id_pc[24]} {io_debugSignals_core_id_pc[25]} {io_debugSignals_core_id_pc[26]} {io_debugSignals_core_id_pc[27]} {io_debugSignals_core_id_pc[28]} {io_debugSignals_core_id_pc[29]} {io_debugSignals_core_id_pc[30]} {io_debugSignals_core_id_pc[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {io_debugSignals_core_mem3_rdata[0]} {io_debugSignals_core_mem3_rdata[1]} {io_debugSignals_core_mem3_rdata[2]} {io_debugSignals_core_mem3_rdata[3]} {io_debugSignals_core_mem3_rdata[4]} {io_debugSignals_core_mem3_rdata[5]} {io_debugSignals_core_mem3_rdata[6]} {io_debugSignals_core_mem3_rdata[7]} {io_debugSignals_core_mem3_rdata[8]} {io_debugSignals_core_mem3_rdata[9]} {io_debugSignals_core_mem3_rdata[10]} {io_debugSignals_core_mem3_rdata[11]} {io_debugSignals_core_mem3_rdata[12]} {io_debugSignals_core_mem3_rdata[13]} {io_debugSignals_core_mem3_rdata[14]} {io_debugSignals_core_mem3_rdata[15]} {io_debugSignals_core_mem3_rdata[16]} {io_debugSignals_core_mem3_rdata[17]} {io_debugSignals_core_mem3_rdata[18]} {io_debugSignals_core_mem3_rdata[19]} {io_debugSignals_core_mem3_rdata[20]} {io_debugSignals_core_mem3_rdata[21]} {io_debugSignals_core_mem3_rdata[22]} {io_debugSignals_core_mem3_rdata[23]} {io_debugSignals_core_mem3_rdata[24]} {io_debugSignals_core_mem3_rdata[25]} {io_debugSignals_core_mem3_rdata[26]} {io_debugSignals_core_mem3_rdata[27]} {io_debugSignals_core_mem3_rdata[28]} {io_debugSignals_core_mem3_rdata[29]} {io_debugSignals_core_mem3_rdata[30]} {io_debugSignals_core_mem3_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {io_debugSignals_core_rwaddr[0]} {io_debugSignals_core_rwaddr[1]} {io_debugSignals_core_rwaddr[2]} {io_debugSignals_core_rwaddr[3]} {io_debugSignals_core_rwaddr[4]} {io_debugSignals_core_rwaddr[5]} {io_debugSignals_core_rwaddr[6]} {io_debugSignals_core_rwaddr[7]} {io_debugSignals_core_rwaddr[8]} {io_debugSignals_core_rwaddr[9]} {io_debugSignals_core_rwaddr[10]} {io_debugSignals_core_rwaddr[11]} {io_debugSignals_core_rwaddr[12]} {io_debugSignals_core_rwaddr[13]} {io_debugSignals_core_rwaddr[14]} {io_debugSignals_core_rwaddr[15]} {io_debugSignals_core_rwaddr[16]} {io_debugSignals_core_rwaddr[17]} {io_debugSignals_core_rwaddr[18]} {io_debugSignals_core_rwaddr[19]} {io_debugSignals_core_rwaddr[20]} {io_debugSignals_core_rwaddr[21]} {io_debugSignals_core_rwaddr[22]} {io_debugSignals_core_rwaddr[23]} {io_debugSignals_core_rwaddr[24]} {io_debugSignals_core_rwaddr[25]} {io_debugSignals_core_rwaddr[26]} {io_debugSignals_core_rwaddr[27]} {io_debugSignals_core_rwaddr[28]} {io_debugSignals_core_rwaddr[29]} {io_debugSignals_core_rwaddr[30]} {io_debugSignals_core_rwaddr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 3 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {io_debugSignals_mem_dram_state[0]} {io_debugSignals_mem_dram_state[1]} {io_debugSignals_mem_dram_state[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {io_debugSignals_wdata[0]} {io_debugSignals_wdata[1]} {io_debugSignals_wdata[2]} {io_debugSignals_wdata[3]} {io_debugSignals_wdata[4]} {io_debugSignals_wdata[5]} {io_debugSignals_wdata[6]} {io_debugSignals_wdata[7]} {io_debugSignals_wdata[8]} {io_debugSignals_wdata[9]} {io_debugSignals_wdata[10]} {io_debugSignals_wdata[11]} {io_debugSignals_wdata[12]} {io_debugSignals_wdata[13]} {io_debugSignals_wdata[14]} {io_debugSignals_wdata[15]} {io_debugSignals_wdata[16]} {io_debugSignals_wdata[17]} {io_debugSignals_wdata[18]} {io_debugSignals_wdata[19]} {io_debugSignals_wdata[20]} {io_debugSignals_wdata[21]} {io_debugSignals_wdata[22]} {io_debugSignals_wdata[23]} {io_debugSignals_wdata[24]} {io_debugSignals_wdata[25]} {io_debugSignals_wdata[26]} {io_debugSignals_wdata[27]} {io_debugSignals_wdata[28]} {io_debugSignals_wdata[29]} {io_debugSignals_wdata[30]} {io_debugSignals_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 16 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {io_debugSignals_mem_imem_addr[0]} {io_debugSignals_mem_imem_addr[1]} {io_debugSignals_mem_imem_addr[2]} {io_debugSignals_mem_imem_addr[3]} {io_debugSignals_mem_imem_addr[4]} {io_debugSignals_mem_imem_addr[5]} {io_debugSignals_mem_imem_addr[6]} {io_debugSignals_mem_imem_addr[7]} {io_debugSignals_mem_imem_addr[8]} {io_debugSignals_mem_imem_addr[9]} {io_debugSignals_mem_imem_addr[10]} {io_debugSignals_mem_imem_addr[11]} {io_debugSignals_mem_imem_addr[12]} {io_debugSignals_mem_imem_addr[13]} {io_debugSignals_mem_imem_addr[14]} {io_debugSignals_mem_imem_addr[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 3 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {io_debugSignals_mem_icache_state[0]} {io_debugSignals_mem_icache_state[1]} {io_debugSignals_mem_icache_state[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 4 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {io_debugSignals_wstrb[0]} {io_debugSignals_wstrb[1]} {io_debugSignals_wstrb[2]} {io_debugSignals_wstrb[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list io_debugSignals_core_ex2_is_valid_inst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list io_debugSignals_core_ex2_reg_is_br]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list io_debugSignals_core_id_reg_bp_taken]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list io_debugSignals_core_id_reg_is_bp_fail]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list io_debugSignals_core_me_intr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list io_debugSignals_core_mem3_rvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list io_debugSignals_core_mt_intr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list io_debugSignals_core_trap]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list io_debugSignals_ren]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list io_debugSignals_wen]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list io_debugSignals_wready]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
