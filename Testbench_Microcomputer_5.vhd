-------------------------------------------------------------------------
-- Project Name: Test bench of the Microcomputer module
--
-- Date: 11/09/2014
-- Project Description: This code tests the microcomputer module.
--								It tests the branch on not equal instruction
-------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Testbench_Microcomputer_5 IS
END Testbench_Microcomputer_5;

ARCHITECTURE TestMicrocomputer OF Testbench_Microcomputer_5 IS

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
		
			-- Write the instruction ori $s0,$0,0x000A
			WriteAddressIM <= x"000";
			WriteInstructionIM <= x"3410000A";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction ori $s1,$0,0x000B
			WriteAddressIM <= x"001";
			WriteInstructionIM <= x"3411000B";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction bne $s0,$s1,7
			WriteAddressIM <= x"002";
			WriteInstructionIM <= x"16300007";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction andi $s2,$0,0x0000
			WriteAddressIM <= x"003";
			WriteInstructionIM <= x"30120000";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction beq $0,$0,6
			WriteAddressIM <= x"004";
			WriteInstructionIM <= x"10000006";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction ori $s2,$0,0x0001
			WriteAddressIM <= x"00A";
			WriteInstructionIM <= x"34120001";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			-- Write the instruction sw $s2,100($0)
			WriteAddressIM <= x"00B";
			WriteInstructionIM <= x"AC120064";
			WAIT FOR 50 ns;
			ClkIM <= '1';			
			WAIT FOR 50 ns;
			ClkIM <= '0';
			
			WriteEnableIM <= '0';	-- Disable writing operation
			
			-- Generate clocks
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
			WAIT FOR 50 ns;
			Clk <= '1';			
			WAIT FOR 50 ns;
			Clk <= '0';
			WAIT FOR 50 ns;
			Clk <= '1';			
			WAIT FOR 50 ns;
			Clk <= '0';
			
			Address2DM <= x"064";	-- Read the address 0x64 of data memory
			
			-------------------- End of Instruction Test -------------------
			WAIT;
			
		END PROCESS stimulus;
END TestMicrocomputer;
		
		
		
		
		
		
	
	

