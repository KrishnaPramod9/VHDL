---------------------------------------------------------------------------------------------------
-- Project Name: Test bench of the Microcomputer module #1
--
-- Date: 11/09/2014
-- Project Description: This code tests the microcomputer module.
--								It tests the instructions sw,add,sub, and subi
---------------------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Testbench_Microcomputer_1 IS
END Testbench_Microcomputer_1;

ARCHITECTURE TestMicrocomputer OF Testbench_Microcomputer_1 IS

SIGNAL WriteAddressIM : std_logic_vector(11 DOWNTO 0);
SIGNAL WriteInstructionIM: std_logic_vector(31 DOWNTO 0); 
SIGNAL WriteEnableIM : std_logic;	
SIGNAL ClkIM : std_logic;	
SIGNAL Clk : std_logic;	                          
SIGNAL ReadData2DM : std_logic_vector(31 DOWNTO 0);
SIGNAL Address2DM : std_logic_vector(11 DOWNTO 0);				

	COMPONENT Microcomputer
	PORT(
		-- Inputs to write into the instruction memory
		WriteAddressIM_MC : IN std_logic_vector(11 DOWNTO 0); -- Instruction	Memory's address lines for write operation
		WriteInstructionIM_MC: IN std_logic_vector(31 DOWNTO 0); -- Instruction Memory's data line for write operation
		WriteEnableIM_MC : IN std_logic;	-- Write enable signal. When '1', the write operation is enabled.
		ClkIM_MC : IN std_logic;	-- Clock signal. Sensitive at rising edge.
		
		-- Clock signal of the Microcomputer. Sensitive at rising edge.
		Clk_MC : IN std_logic;	
		
		-- Outputs that are used to read the data memory. They are provided for test purporse. 		                                PURPOSE                                   
		ReadData2DM_MC : OUT std_logic_vector(31 DOWNTO 0);	-- Data Memory's data line of PORT 2
		Address2DM_MC : IN std_logic_vector(11 DOWNTO 0) -- Data Memory's address lines of PORT 2
		);
	END COMPONENT;
	
	BEGIN
		-- Connect the Test bench module with the ALU module
		dut: Microcomputer
		PORT MAP(
			WriteAddressIM_MC => WriteAddressIM,
			WriteInstructionIM_MC => WriteInstructionIM,
			WriteEnableIM_MC => WriteEnableIM,
			ClkIM_MC => ClkIM,
			Clk_MC => Clk,                         
			ReadData2DM_MC => ReadData2DM, 
			Address2DM_MC => Address2DM
		);
		
		-- Start of the simulation
		stimulus: PROCESS
		BEGIN
		
			----------------- Start of instruction test ----------------------
		
			WriteEnableIM <= '1';	-- Enable writing operation
			ClkIM <= '0';
			Clk <= '0';
		
			-- Write the instruction subi $s2,$0,-3
			WriteAddressIM <= x"000";
			WriteInstructionIM <= x"B812FFFD";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction sw $s2,10($s2)
			WriteAddressIM <= x"001";
			WriteInstructionIM <= x"AE52000A";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction subi $s3,$0,-5
			WriteAddressIM <= x"002";
			WriteInstructionIM <= x"B813FFFB";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction sw $s3,11($s2)
			WriteAddressIM <= x"003";
			WriteInstructionIM <= x"AE53000B";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction add $s4,$s3,$s2
			WriteAddressIM <= x"004";
			WriteInstructionIM <= x"0272A020";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction sw $s4,0($0)
			WriteAddressIM <= x"005";
			WriteInstructionIM <= x"AC140000";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction sub $s5,$s3,$s2
			WriteAddressIM <= x"006";
			WriteInstructionIM <= x"0272A822";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction sw $s5,0($0)
			WriteAddressIM <= x"007";
			WriteInstructionIM <= x"AC150000";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction subi $t3,$0,-10
			WriteAddressIM <= x"008";
			WriteInstructionIM <= x"B80BFFF6";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';

			-- Write the instruction sw $s4,200($t3)
			WriteAddressIM <= x"009";
			WriteInstructionIM <= x"AD7400C8";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction sw $s5,201($t3)
			WriteAddressIM <= x"00A";
			WriteInstructionIM <= x"AD7500C9";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			
			WriteEnableIM <= '0';	-- Disable writing operation
			Address2DM <= x"00D";	-- Read the address 0xD of data memory
			
			-- Generate clocks
			WAIT FOR 50 ns;
			Clk <= '1';			
			WAIT FOR 50 ns;
			Clk <= '0';
			WAIT FOR 50 ns;
			Clk <= '1';	
			Address2DM <= x"00D";	-- Read the address 0xE of data memory		
			WAIT FOR 50 ns;
			Clk <= '0';
			WAIT FOR 50 ns;
			Clk <= '1';	
			WAIT FOR 50 ns;
			Clk <= '0';
			WAIT FOR 50 ns;
			Clk <= '1';	
			Address2DM <= x"00E";	-- Read the address 0xE of data memory		
			WAIT FOR 50 ns;
			Clk <= '0';
			WAIT FOR 50 ns;
			Clk <= '1';		
			WAIT FOR 50 ns;
			Clk <= '0';
			WAIT FOR 50 ns;
			Clk <= '1';
			Address2DM <= x"000";	-- Read the address 0x0 of data memory				
			WAIT FOR 50 ns;
			Clk <= '0';
			WAIT FOR 50 ns;
			Clk <= '1';			
			WAIT FOR 50 ns;
			Clk <= '0';
			WAIT FOR 50 ns;
			Clk <= '1';				
			WAIT FOR 50 ns;
			Clk <= '0';			
			WAIT FOR 50 ns;
			Clk <= '1';			
			WAIT FOR 50 ns;
			Clk <= '0';
			WAIT FOR 50 ns;
			Clk <= '1';			
			WAIT FOR 50 ns;
			Clk <= '0';
			WAIT FOR 50 ns;
			Clk <= '1';			
			WAIT FOR 50 ns;
			Clk <= '0';
			WAIT FOR 50 ns;
			Clk <= '1';			
			WAIT FOR 50 ns;
			Clk <= '0';
			
			Address2DM <= x"0D2";	-- Read the address 0xD2 of data memory
			WAIT FOR 100 ns;
			Address2DM <= x"0D3";	-- Read the address 0xD2 of data memory
			
			-------------------- End of Instruction Test -------------------
			WAIT;
			
		END PROCESS stimulus;
END TestMicrocomputer;
		
		
		
		
		
		
	
	

