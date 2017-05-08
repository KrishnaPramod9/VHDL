----------------------------------------------------------------------------------
-- Project Name: RegisterFile
--
-- Written by: Esdras Vitor Silva Pinto (CW/ID = A20339120)
-- Date: 10/09/2014
--
-- Project Description: This code implements a register file that is 
--								comprised of 32 registers.
--								Each register is 32-bit wide.								
-----------------------------------------------------------------------------------
-- Declaration of libraries used in this project
LIBRARY ieee;

-- Specify the packages used in this project
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RegisterFile IS
	PORT(
		-- Select one register to be read
		ReadRegister1_RF : IN std_logic_vector(4 DOWNTO 0);

		-- Select another register to be read.
		ReadRegister2_RF : IN std_logic_vector(4 DOWNTO 0);
	
		-- Select the register to write in.	
		WriteRegister_RF : IN std_logic_vector(4 DOWNTO 0);
		
		-- Supply the data to be written in the selected register.
		WriteData_RF: IN std_logic_vector(31 DOWNTO 0);
	
		-- WriteEn: When 1, the write process is allowed.	
		WriteEnable_RF	: IN std_logic;
	
		-- Clock signal.
		Clk_RF		: IN std_logic;
		
		-- Data read from one of the registers selected	
		ReadData1_RF: OUT std_logic_vector(31 DOWNTO 0);
		
		-- Data read from another register selected
		ReadData2_RF: OUT std_logic_vector(31 DOWNTO 0) 
		);
END RegisterFile;

ARCHITECTURE behav OF RegisterFile IS
	-- Define a type called reg_32_of_32_bit which is made up 
	-- of 32 32-bits registers.
	TYPE reg_32_of_32_bit IS ARRAY (0 TO 31) OF std_logic_vector(31 DOWNTO 0);
	SIGNAL Reg : reg_32_of_32_bit := (others=> (others=>'0'));
	
	BEGIN
		-- Output the contents of the selected registers 
		ReadData1_RF <= Reg(to_integer(unsigned(ReadRegister1_RF)));
		ReadData2_RF <= Reg(to_integer(unsigned(ReadRegister2_RF)));
		
		-- Write the data supplied by WriteData_RF input in the selected register on
		-- the edge border of the clock signal if the write process is enabled. 
		Write_into_register:PROCESS(Clk_RF)
		BEGIN
			IF(Clk_RF = '1' AND WriteEnable_RF = '1') THEN
				Reg(to_integer(unsigned(WriteRegister_RF))) <= WriteData_RF;
			END IF;
		END PROCESS;
	END behav;
	
		