---------------------------------------------------------------------------------
-- Project Name: Control Unit
--
-- Date: 11/22/2014
--
-- Project Description: This code implements the control module to be used on 
--								a single cycle cicle MIPS ISA datapath.
--								The control's job is to set the control signals 
--								depending on the Opcode.
----------------------------------------------------------------------------------
-- Declaration of libraries used in this project
LIBRARY ieee;

-- Specify the packages used in this project
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Declaration of the entity Control
ENTITY Control IS
	PORT(
		-- CONTROL INPUTs
		
		-- Instruction read from instruction memory
		Instruction_CTR : IN std_logic_vector(31 DOWNTO 0);		
		
		-- CONTROL OUTPUTs 

		-- Inform the datapath if the current instruction is branch on equal
		BranchOnEqual_CTR : OUT std_logic;

		-- Inform the datapath if the current instruction is branch on not equal
		BranchOnNotEqual_CTR : OUT std_logic;
	
		-- Determine if the data to be written into register comes from memory or another register
		DataMem_CTR : OUT std_logic;

		-- Enable writing into register file
		WriteRegEn_CTR:	OUT std_logic;
		
		-- Select the register destination: For R-type instructions, the destination is Rd,
		-- and for I-type, the destination is Rt.
		RegDest_CTR : OUT std_logic;	

		-- Select the source of the input2 of the ALU. This source can come from the
		-- immediate field or from the value given by Rt.		
		ALUsource_CTR : OUT std_logic;		
				
		-- Enable reding from data memory
		ReadDataMemEn_CTR : OUT std_logic;
	
		-- Enable writing to data memory
		WriteDataMemEn_CTR : OUT std_logic;	
		
		-- Determine the operation to be performed by the ALU
		ALUop_CTR : OUT std_logic_vector(2 DOWNTO 0);
	
		-- Select if the immediate field will be signed extended or zero extended
		ExtenderCtr_CTR : OUT std_logic						
		);
	
END Control;

-- Implementation of the Control module
ARCHITECTURE behav OF Control IS
	
-- Opcode field
SIGNAL Op: std_logic_vector(5 DOWNTO 0);
	
BEGIN
	-- Extract from the instruction the opcode field
	Op <= Instruction_CTR(31 DOWNTO 26);
		
	-- Signal BranchOnEqual
	BranchOnEqual_CTR <= '1' WHEN Op = "000100" ELSE
								'0';
								
	-- Signal BranchOnNotEqual
	BranchOnNotEqual_CTR <= '1' WHEN Op = "000101" ELSE
									'0';
								
	-- Signal DataMem
	DataMem_CTR <= '1' WHEN Op = "100011" ELSE
						'0';
								
	-- Signal ReadDataMemEn
	ReadDataMemEn_CTR <= '1' WHEN Op = "100011" ELSE
								'0';
								
	-- Signal WriteDataMemEn
	WriteDataMemEn_CTR <= '1' WHEN Op = "101011" ELSE
								 '0';
								
	-- Signal WriteRegEn							
	WriteRegEn_CTR <= '0' WHEN ((Op = "101011") OR (Op = "000100") OR (Op = "000101")) ELSE
							'1';

	-- Signal RegDest
	RegDest_CTR <= '0' WHEN Op = "000000" ELSE
						'1';
						
	-- Signal ALUsource
	ALUsource_CTR <= '0' WHEN ((OP = "000000") OR (Op = "000100") OR (Op = "000101")) ELSE
						  '1';
	
	-- Signal ALUop
	ALUop_CTR <= "000" WHEN ((Op = "100011") OR (Op = "101011")) ELSE
					 "100" WHEN Op = "000000" ELSE
					 "010" WHEN Op = "001100" ELSE
					 "011" WHEN Op = "001101" ELSE
					 "001" WHEN ((Op = "000100") OR (Op = "000101") OR (Op = "101110")) ELSE
					 "000";
				
	-- Signal ExtenderCtr
	ExtenderCtr_CTR <= '0' WHEN Op = "001100" OR Op = "001101" ELSE
							 '1';
	
END behav;