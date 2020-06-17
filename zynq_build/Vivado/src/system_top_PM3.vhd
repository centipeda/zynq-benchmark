---------------------------------------------------------------------------------------------------
-- Project          : Mars ZX2 Reference Design
-- File description : Top Level
-- File name        : system_top_PM3.vhd
-- Author           : Gian Koeppel
---------------------------------------------------------------------------------------------------
-- Copyright (c) 2017 by Enclustra GmbH, Switzerland. All rights are reserved. 
-- Unauthorized duplication of this document, in whole or in part, by any means is prohibited
-- without the prior written permission of Enclustra GmbH, Switzerland.
-- 
-- Although Enclustra GmbH believes that the information included in this publication is correct
-- as of the date of publication, Enclustra GmbH reserves the right to make changes at any time
-- without notice.
-- 
-- All information in this document may only be published by Enclustra GmbH, Switzerland.
---------------------------------------------------------------------------------------------------
-- Description:
-- This is a top-level file for Mars ZX2 Reference Design
--    
---------------------------------------------------------------------------------------------------
-- File history:
--
-- Version | Date       | Author           | Remarks
-- ------------------------------------------------------------------------------------------------
-- 1.0     | 07.05.2015 | G. Koeppel       | First version generated for bring-up
-- 2.0     | 20.10.2017 | D. Ungureanu     | Consistency checks
-- 3.0     | 08.12.2017 | D. Duerner       | Add blinking LED
--
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- libraries
---------------------------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library unisim;
	use unisim.vcomponents.all;

entity system_top is
	port (
		DDR_addr			: inout std_logic_vector ( 14 downto 0 );
		DDR_ba				: inout std_logic_vector ( 2 downto 0 );
		DDR_cas_n			: inout std_logic;
		DDR_ck_n			: inout std_logic;
		DDR_ck_p			: inout std_logic;
		DDR_cke				: inout std_logic;
		DDR_cs_n			: inout std_logic;
		DDR_dm				: inout std_logic_vector ( 3 downto 0 );
		DDR_dq				: inout std_logic_vector ( 31 downto 0 );
		DDR_dqs_n			: inout std_logic_vector ( 3 downto 0 );
		DDR_dqs_p			: inout std_logic_vector ( 3 downto 0 );
		DDR_odt				: inout std_logic;
		DDR_ras_n			: inout std_logic;
		DDR_reset_n			: inout std_logic;
		DDR_we_n			: inout std_logic;
		
		FIXED_IO_ddr_vrn	: inout std_logic;
		FIXED_IO_ddr_vrp	: inout std_logic;
		FIXED_IO_mio		: inout std_logic_vector ( 53 downto 0 );
		FIXED_IO_ps_clk		: inout std_logic;
		FIXED_IO_ps_porb	: inout std_logic;
		FIXED_IO_ps_srstb	: inout std_logic;
		
		UART0_TX			: out 	std_logic; 
		UART0_RX 			: in 	std_logic;

		Led_N 				: out	std_logic_vector(3 downto 0);
		--------------------------------------------------
		-- Mars PM3 specific signals
		--------------------------------------------------
		
		-------------------------------------------------------------------------------------------
		-- fmc lpc connector
		-------------------------------------------------------------------------------------------

		FMC_CLK0_M2C_N		: in	std_logic;
		FMC_CLK0_M2C_P		: in	std_logic;
		FMC_CLK1_M2C_N		: in	std_logic;
		FMC_CLK1_M2C_P		: in	std_logic;
		FMC_LA00_CC_N		: inout	std_logic;
		FMC_LA00_CC_P		: inout	std_logic;
		FMC_LA01_CC_N		: inout	std_logic;
		FMC_LA01_CC_P		: inout	std_logic;
		FMC_LA02_N			: inout	std_logic;
		FMC_LA02_P			: inout	std_logic;
		FMC_LA03_N			: inout	std_logic;
		FMC_LA03_P			: inout	std_logic;
		FMC_LA04_N			: inout	std_logic;
		FMC_LA04_P			: inout	std_logic;
		FMC_LA05_N			: inout	std_logic;
		FMC_LA05_P			: inout	std_logic;
		FMC_LA06_N			: inout	std_logic;
		FMC_LA06_P			: inout	std_logic;
		FMC_LA07_N			: inout	std_logic;
		FMC_LA07_P			: inout	std_logic;
		FMC_LA08_N			: inout	std_logic;
		FMC_LA08_P			: inout	std_logic;
		FMC_LA09_N			: inout	std_logic;
		FMC_LA09_P			: inout	std_logic;
		FMC_LA10_N			: inout	std_logic;
		FMC_LA10_P			: inout	std_logic;
		FMC_LA11_N			: inout	std_logic;
		FMC_LA11_P			: inout	std_logic;
		FMC_LA12_N			: inout	std_logic;
		FMC_LA12_P			: inout	std_logic;
		FMC_LA13_N			: inout	std_logic;
		FMC_LA13_P			: inout	std_logic;
		FMC_LA14_N			: inout	std_logic;
		FMC_LA14_P			: inout	std_logic;
		FMC_LA15_N			: inout	std_logic;
		FMC_LA15_P			: inout	std_logic;
		FMC_LA16_N			: inout	std_logic;
		FMC_LA16_P			: inout	std_logic;
		FMC_LA17_CC_N		: inout	std_logic;
		FMC_LA17_CC_P		: inout	std_logic;
		FMC_LA18_CC_N		: inout	std_logic;
		FMC_LA18_CC_P		: inout	std_logic;
		FMC_LA19_N			: inout	std_logic;
		FMC_LA19_P			: inout	std_logic;
		FMC_LA20_N			: inout	std_logic;
		FMC_LA20_P			: inout	std_logic;
		FMC_LA21_N			: inout	std_logic;
		FMC_LA21_P			: inout	std_logic;
		FMC_LA22_N			: inout	std_logic;
		FMC_LA22_P			: inout	std_logic;
		FMC_LA23_N			: inout	std_logic;
		FMC_LA23_P			: inout	std_logic;
		FMC_LA24_N			: inout	std_logic;
		FMC_LA24_P			: inout	std_logic;
		FMC_LA25_N			: inout	std_logic;
		FMC_LA25_P			: inout	std_logic;
		FMC_LA26_N			: inout	std_logic;
		FMC_LA26_P			: inout	std_logic;
		FMC_LA27_N			: inout	std_logic;
		FMC_LA27_P			: inout	std_logic;
		FMC_LA28_N			: inout	std_logic;
		FMC_LA28_P			: inout	std_logic;
		FMC_LA29_N			: inout	std_logic;
		FMC_LA29_P			: inout	std_logic;
		FMC_LA30_N			: inout	std_logic;
		FMC_LA30_P			: inout	std_logic;
		FMC_LA31_N			: inout	std_logic;
		FMC_LA31_P			: inout	std_logic;
		FMC_LA32_N			: inout	std_logic;
		FMC_LA32_P			: inout	std_logic;
		FMC_LA33_N			: inout	std_logic;
		FMC_LA33_P			: inout	std_logic;
	
        -------------------------------------------------------------------------------------------
		-- ez-usb fx3 interface
		-------------------------------------------------------------------------------------------
		-- Some signals are available only on XC7Z020

		FX3_A1				: out	std_logic;
		FX3_CLK				: in	std_logic;
--		FX3_DQ0				: inout	std_logic;
--		FX3_DQ1_SDD3		: inout	std_logic;
		FX3_DQ10			: inout	std_logic;
		FX3_DQ11			: inout	std_logic;
		FX3_DQ12			: inout	std_logic;
		FX3_DQ13			: inout	std_logic;
		FX3_DQ14			: inout	std_logic;
		FX3_DQ15			: inout	std_logic;
--		FX3_DQ2				: inout	std_logic;
--		FX3_DQ3_SDD2		: inout	std_logic;
--		FX3_DQ4				: inout	std_logic;
--		FX3_DQ5				: inout	std_logic;
--		FX3_DQ6				: inout	std_logic;
--		FX3_DQ7				: inout	std_logic;
		FX3_DQ8				: inout	std_logic;
		FX3_DQ9				: inout	std_logic;
		FX3_FLAGA			: in	std_logic;
		FX3_FLAGB			: in	std_logic;
--		FX3_PKTEND_SDD1_N	: out	std_logic;
--		FX3_SLOE_SDD0_N		: out	std_logic;
--		FX3_SLRD_SDCLK_N	: out	std_logic;
--		FX3_SLWR_SDCMD_N	: out	std_logic;
		
        -------------------------------------------------------------------------------------------
		-- hdmi connector
		-------------------------------------------------------------------------------------------

		PCIE_PER0_N			: in	std_logic;
		PCIE_PER0_P			: in	std_logic;
		PCIE_PER1_N			: in	std_logic;
		PCIE_PER1_P			: in	std_logic;
		PCIE_PET0_N			: out	std_logic;
		PCIE_PET0_P			: out	std_logic;
		PCIE_PET1_N			: out	std_logic;
		PCIE_PET1_P			: out	std_logic;
		PCIE_REFCLK_N		: in	std_logic;
		PCIE_REFCLK_P		: in	std_logic
		
		
	);
end system_top;

architecture structure of system_top is

	component MarsZX2 is
		port (
			DDR_cas_n 			: inout STD_LOGIC;
			DDR_cke 			: inout STD_LOGIC;
			DDR_ck_n 			: inout STD_LOGIC;
			DDR_ck_p 			: inout STD_LOGIC;
			DDR_cs_n 			: inout STD_LOGIC;
			DDR_reset_n 		: inout STD_LOGIC;
			DDR_odt 			: inout STD_LOGIC;
			DDR_ras_n 			: inout STD_LOGIC;
			DDR_we_n 			: inout STD_LOGIC;
			DDR_ba 				: inout STD_LOGIC_VECTOR ( 2 downto 0 );
			DDR_addr 			: inout STD_LOGIC_VECTOR ( 14 downto 0 );
			DDR_dm 				: inout STD_LOGIC_VECTOR ( 3 downto 0 );
			DDR_dq 				: inout STD_LOGIC_VECTOR ( 31 downto 0 );
			DDR_dqs_n 			: inout STD_LOGIC_VECTOR ( 3 downto 0 );
			DDR_dqs_p 			: inout STD_LOGIC_VECTOR ( 3 downto 0 );
			FIXED_IO_mio 		: inout STD_LOGIC_VECTOR ( 53 downto 0 );
			FIXED_IO_ddr_vrn 	: inout STD_LOGIC;
			FIXED_IO_ddr_vrp 	: inout STD_LOGIC;
			FIXED_IO_ps_srstb 	: inout STD_LOGIC;
			FIXED_IO_ps_clk 	: inout STD_LOGIC;
			FIXED_IO_ps_porb 	: inout STD_LOGIC;
			SDIO0_CDN           : in  STD_LOGIC;
			SDIO0_WP            : in  STD_LOGIC;
			gpio_rtl_tri_o 		: out STD_LOGIC_VECTOR ( 7 downto 0 );
			UART_0_txd 			: out STD_LOGIC;
			UART_0_rxd 			: in STD_LOGIC;
			FCLK_CLK1 			: out STD_LOGIC
		);
	end component MarsZX2;
  

	signal IIC_0_sda_i 		: std_logic;
	signal IIC_0_sda_o 		: std_logic;
	signal IIC_0_sda_t 		: std_logic;
	signal IIC_0_scl_i 		: std_logic;
	signal IIC_0_scl_o 		: std_logic;
	signal IIC_0_scl_t 		: std_logic;

	signal Clk				: std_logic;
	signal Rst				: std_logic := '0';
	signal Rst_N 			: std_logic := '1';
	signal ETH_RST			: std_logic := '0';
	
	signal RstCnt			: unsigned (15 downto 0) := (others => '0'); -- 1ms reset for Ethernet PHY
	
	signal LedCount			: unsigned (23 downto 0);
	signal GPIO				: std_logic_vector (7 downto 0);

	signal SDIO0_CDN_s      : std_logic := '0';
	signal SDIO0_WP_s       : std_logic := '1';
	
begin


	------------------------------------------------------------------------------------------------
	--	Processing System
	------------------------------------------------------------------------------------------------

	i_system : MarsZX2
		port map (
			DDR_addr			=> DDR_addr,
			DDR_ba				=> DDR_ba,
			DDR_cas_n			=> DDR_cas_n,
			DDR_ck_n			=> DDR_ck_n,
			DDR_ck_p			=> DDR_ck_p,
			DDR_cke				=> DDR_cke,
			DDR_cs_n			=> DDR_cs_n,
			DDR_dm				=> DDR_dm,
			DDR_dq				=> DDR_dq,
			DDR_dqs_n			=> DDR_dqs_n,
			DDR_dqs_p			=> DDR_dqs_p,
			DDR_odt				=> DDR_odt,
			DDR_ras_n			=> DDR_ras_n,
			DDR_reset_n			=> DDR_reset_n,
			DDR_we_n			=> DDR_we_n,
			FCLK_CLK1			=> Clk,
			FIXED_IO_ddr_vrn	=> FIXED_IO_ddr_vrn,
			FIXED_IO_ddr_vrp	=> FIXED_IO_ddr_vrp,
			FIXED_IO_mio		=> FIXED_IO_mio,
			FIXED_IO_ps_clk		=> FIXED_IO_ps_clk,
			FIXED_IO_ps_porb	=> FIXED_IO_ps_porb,
			FIXED_IO_ps_srstb	=> FIXED_IO_ps_srstb,
			UART_0_rxd			=> UART0_RX,
			UART_0_txd			=> UART0_TX,
			SDIO0_CDN           => SDIO0_CDN_s,
			SDIO0_WP            => SDIO0_WP_s, 
			gpio_rtl_tri_o		=> GPIO
		);

	------------------------------------------------------------------------------------------------
	--	Clock and Reset
	------------------------------------------------------------------------------------------------ 
	   
	--  reset 1ms reset for Ethernet PHY
   	process (Clk)
   	begin
		if rising_edge (Clk) then
   			if (not RstCnt) = 0 then
   				Rst			<= '0';
   			else
   				Rst			<= '1';
   				RstCnt		<= RstCnt + 1;
	   		end if;
   		end if;
   	end process;
    
	------------------------------------------------------------------------------------------------
	-- Blinking LED counter & LED assignment
	------------------------------------------------------------------------------------------------
   
    process (Clk)
    begin
    	if rising_edge (Clk) then
    		if Rst = '1' then
    			LedCount	<= (others => '0');
    		else
    			LedCount <= LedCount + 1;
    		end if;
    	end if;
    end process;
    
    Led_N(0) <= not LedCount(LedCount'HIGH);
    Led_N(1) <= not LedCount(LedCount'HIGH-1); -- 2 times faster
    Led_N(2) <= not GPIO(1);
    Led_N(3) <= not GPIO(0);


	------------------------------------------------------------------------------------------------
	-- Unused pins are set to high impedance in the constraints
	------------------------------------------------------------------------------------------------
end architecture structure;


