--------------------------------------------------------------------------------
-- Project Name: Data Memory
--
-- Date: 11/09/2014
--
-- Project Description: This code implements a data memory for MIPS architecture.
--								This memory has 512 locations of 32 bits, and it has
--								two port. 
--								The PORT 1 is destined to the connection with the MIPS 
--								datapath, and this port allows both writing and reading 
--								operations. On the other hand, the PORT 2 is provided 
-- 							only for debug and validation purpose, and it allows us
--								only read the memory.
--								
---------------------------------------------------------------------------------
-- Declaration of libraries used in this project
LIBRARY ieee;

-- Specify the packages used in this project
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Declaration of the entity InstructionMemory
ENTITY DataMemory IS
	PORT(
		-- Memory's address lines of PORT 1
		Address1_DM : IN std_logic_vector(11 DOWNTO 0);
		
		-- Memory's data lines of PORT 1
		WriteData1_DM: IN std_logic_vector(31 DOWNTO 0);
		
		-- Write enable signal. When '1', the writing operation is enabled.	
		WriteEnable1_DM : IN std_logic;	
		
		-- Read enable signal of PORT 1. 
		-- When '1', the reading operation is enabled.
		ReadEnable1_DM : IN std_logic;
	
		-- Memory's address lines of PORT 2
		Address2_DM : IN std_logic_vector(11 DOWNTO 0); 
		
		-- Clock signal. Sensitive at rising edge
		Clk_DM : IN std_logic;	
		
		-- Memory's data line of PORT 1
		ReadData1_DM : OUT std_logic_vector(31 DOWNTO 0);
	
		-- Memory's data line of PORT 2	
		ReadData2_DM : OUT std_logic_vector(31 DOWNTO 0)	
	);
END DataMemory;

-- Implementation of the InstructionMemory entity's behavior
ARCHITECTURE behav OF DataMemory IS

	-- Define a type called mem_512_of_32_bit which is a 512x32 memory
	TYPE mem_512_of_32_bit IS ARRAY (0 TO 511) OF std_logic_vector(31 DOWNTO 0);
	
	-- Declare a 512x32 memory to be used as data memory
	SIGNAL DataMem : mem_512_of_32_bit;
		
	BEGIN			
		-- Write into the memory at PORT 1
		Write_Into_Memory_PORT_1:
		PROCESS(Clk_DM)
			BEGIN
				-- If all the requirements for the write are met (Positive edge 
				-- of clock and WriteEnable1_DM active), the data given by the 
				-- WriteData1_DM input is stored into address given by Address1_DM input. 
				IF(Clk_DM'EVENT AND Clk_DM = '1' AND WriteEnable1_DM = '1') THEN
					DataMem(to_integer(unsigned(Address1_DM))) <= WriteData1_DM;
				END IF;
			END PROCESS;
			
		-- Output the content of the address given by the Address1_DM input
		-- in the case where the reading operation is enable. Otherwise, 
		-- it outputs high impedance.
		ReadData1_DM <= DataMem(to_integer(unsigned(Address1_DM))) WHEN ReadEnable1_DM = '1' ELSE
							(others => 'Z');
				
		-- Output the content of the address given by the Address2_DM input			
		ReadData2_DM <= DataMem(to_integer(unsigned(Address2_DM)));
							
	END behav;
		