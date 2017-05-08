----------------------------------------------------------------------------
-- Project Name: Arithmetic and Logic Unit (ALU)
--
-- Written by: Esdras Vitor Silva Pinto
-- Date: 11/09/2014
--
-- Project Description: This code implements a 32-bit ALU.
--								The ALU can perform the following operations
--								(1) Addition
--								(2) Subtraction
--								(3) AND
--								(4) OR
-- 								
-----------------------------------------------------------------------------
-- Declaration of libraries used in this project
LIBRARY ieee;

-- Specify the packages used in this project
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Declaration of the entity ALU
ENTITY ALU IS
	PORT(
		-- ALU's input	1.
		Input1_ALU : IN std_logic_vector(31 DOWNTO 0);
		
		 -- ALU's input 2.
		Input2_ALU : IN std_logic_vector(31 DOWNTO 0);
		
		-- Signal that determine the function that is to be performed
		ALUfunct_ALU : IN std_logic_vector(2 DOWNTO 0); 
		
		-- ALU's output.
		Output_ALU : OUT std_logic_vector(31 DOWNTO 0);
		
		-- Zero_ALU flag: It is set to one when the result of an operation is zero.
		Zero_ALU : OUT std_logic	
		);
END ALU;

-- Implementation of the ALU's behavior
ARCHITECTURE behav OF ALU IS
	-- Signal that contains the result of the operation executed by the ALU
	SIGNAL result : std_logic_vector(31 DOWNTO 0);
	
	BEGIN
		-- Evaluete the operation determined by the ALUfunct_ALU input.
		-- The functions that the ALU can execute have the following number:
		-- 000 - Addition
		-- 001 - Subtraction
		-- 010 - AND
		-- 011 - OR
	
		result <= std_logic_vector(signed(Input1_ALU) + signed(Input2_ALU)) WHEN ALUfunct_ALU = "000" ELSE
					 std_logic_vector(signed(Input1_ALU) - signed(Input2_ALU)) WHEN ALUfunct_ALU = "001" ELSE
					 Input1_ALU AND Input2_ALU WHEN ALUfunct_ALU = "010" ELSE
					 Input1_ALU OR Input2_ALU WHEN ALUfunct_ALU = "011" ELSE
					 (others => '0');
		
		-- Output the result of the operation
		Output_ALU <= result;
		
		-- If the result of the operation is Zero_ALU, then the Zero_ALU flag is set.
		Zero_ALU <= '1' WHEN result = x"00000000" ELSE
				  '0';	
		
	END behav;
	
		