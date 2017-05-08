----------------------------------------------------------------------------------
-- Project Name: ALU Control
--
-- Date: 11/22/2014
--
-- Project Description: This code implements the ALU Control module to select 
--								which operation the ALU should perform.
----------------------------------------------------------------------------------
-- Declaration of libraries used in this project
LIBRARY ieee;

-- Specify the packages used in this project
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Declaration of the entity ALU Control
ENTITY ALUcontrol IS 
	PORT(
		-- ALU CONTROL INPUTs
		
		-- Instruction read from instruction memory
		Instruction_ALUCTR : IN std_logic_vector(31 DOWNTO 0);
		
		-- Determine the operation to be performed by the ALU
		ALUop_ALUCTR : IN std_logic_vector(2 DOWNTO 0);	
		
		-- ALU CONTROL OUTPUTs 		      

		-- Tell the ALU the operation to be performed
		ALUfunct_ALUCTR : OUT std_logic_vector(2 DOWNTO 0) 
		);
	
END ALUcontrol;

-- Implementation of the Control module
ARCHITECTURE behav OF ALUcontrol IS
	
-- Funct field
SIGNAL Funct: std_logic_vector(5 DOWNTO 0);
	
BEGIN
	-- Extract from the instruction the funct field
	Funct <= Instruction_ALUCTR(5 DOWNTO 0);
	
	ALUfunct_ALUCTR <= "000" WHEN ALUop_ALUCTR = "000" ELSE
							 "000" WHEN ALUop_ALUCTR = "100" AND Funct = "100000" ELSE
							 "001" WHEN (ALUop_ALUCTR = "100" AND Funct = "100010") OR ALUop_ALUCTR = "001" ELSE
							 "010" WHEN ALUop_ALUCTR = "010" ELSE
							 "011" WHEN ALUop_ALUCTR = "011" ELSE
							 "000";
		
	
END behav;