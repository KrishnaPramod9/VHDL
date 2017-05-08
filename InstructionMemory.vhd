----------------------------------------------------------------------------------------
-- Project Name: InstructionMemory
--
-- Date: 11/08/2014
--
-- Project Description: This code implements an instruction memory for MIPS architecture.
--								This memory has 512 locations of 32 bits.
-----------------------------------------------------------------------------------------
-- Declaration of libraries used in this project
LIBRARY ieee;

-- Specify the packages used in this project
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Declaration of the entity InstructionMemory
ENTITY InstructionMemory IS
	PORT(
		-- Memory's address lines for read operation
		Address_IM : IN std_logic_vector(11 DOWNTO 0);
		
		-- Memory's address lines for write operation	
		WriteAddress_IM: IN std_logic_vector(11 DOWNTO 0);
		
		-- Memory's data line for write operation	
		WriteInstruction_IM: IN std_logic_vector(31 DOWNTO 0);
		
		-- Write enable signal. When '1', the write operation is enabled.
		WriteEnable_IM : IN std_logic;
		
		-- Clock signal. Sensitive at rising edge
		Clk_IM : IN std_logic;	
		
		-- Memory's data line for read operation
		Instruction_IM  : OUT std_logic_vector(31 DOWNTO 0)	
	);
END InstructionMemory;

-- Implementation of the InstructionMemory entity's behavior
ARCHITECTURE behav OF InstructionMemory IS

	-- Define a type called mem_512_of_32_bit which is a 512x32 memory
	TYPE mem_512_of_32_bit IS ARRAY (0 TO 511) OF std_logic_vector(31 DOWNTO 0);
	
	-- Declare a 512x32 memory to be used as instruction memory
	SIGNAL InstMem : mem_512_of_32_bit;
		
	BEGIN			
		-- Write an instruction into the memory
		Write_Into_Memory:
		PROCESS(CLK_IM)
			BEGIN
				-- If all the requirements for writing are met (Positive edge of clock and
				-- WriteEnable active), the data given by the WriteInstruction_IM input 
				-- is stored into address given by WriteAddress_IM input.
				IF(Clk_IM'EVENT AND Clk_IM = '1' AND WriteEnable_IM = '1') THEN
					InstMem(to_integer(unsigned(WriteAddress_IM))) <= WriteInstruction_IM;
				END IF;
			END PROCESS;
			
		-- Output the contents of the address given by Address_IM input.
		Instruction_IM <= InstMem(to_integer(unsigned(Address_IM)));
		
	END behav;
		