--------------------------------------------------------------------------------------------------------
-- Project Name: Datapath
--
-- Date: 11/09/2014
--
-- Project Description: This code implements a reduced version of a single cycle MIPS ISA datapath.
--								This datapath supports the following instructions:
--								(1) Load (lw)
--								(2) store (sw)
--								(3) Add (add)
--								(4) subtract (sub)
--								(5) Branch on equal (beq)
--								(6) Branch on not equal (bne)
--								(7) Subtract immediate (subi)
--								(8) And immediate (andi)
--								(9) OR immediate (ori)
--
--------------------------------------------------------------------------------------------------------
-- Declaration of libraries used in this project
LIBRARY ieee;

-- Specify the packages used in this project
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Declaration of the entity Datapath
ENTITY Datapath IS
	PORT(
		-- DATAPATH INPUTs 		                                                                   
		-- Inform the datapath if the current instruction is branch on equal
		BranchOnEqual_DP : IN std_logic;

		-- Inform the datapath if the current instruction is branch on not equal
		BranchOnNotEqual_DP : IN std_logic;	
		
		-- Determine if the data to be written into register comes from memory or another register
		DataMem_DP : IN std_logic; 

		-- Enable writing into register file
		WriteRegEn_DP:	IN std_logic;
		
		-- Select the register destination: For R-type instructions, the destination is Rd,
		-- and for I-type, the destination is Rt.
		RegDest_DP : IN std_logic;			
												
		-- Select the source of the input2 of the ALU. This source can come from the
		-- immediate field or from the value given by Rt.		
		ALUsource_DP : IN std_logic;		
						
		-- Select the operation to be performed by the ALU
		ALUfunct_DP : IN std_logic_vector(2 DOWNTO 0); 
		
		-- Select if the immediate field will be signed extended or zero extended
		ExtenderCtr_DP : IN std_logic;					  

		-- Intruction read from instruction memory
		Instruction_DP : IN std_logic_vector(31 DOWNTO 0);
		
		-- Clock signal
		Clk_DP : IN std_logic;	
		
		-- Data read from data memory
		ReadDataMem_DP : IN std_logic_vector(31 DOWNTO 0);		
				
		-- DATAPATH OUTPUTs
		
		-- Result of an operation performed in the ALU
		ALUresult_DP : OUT std_logic_vector(31 DOWNTO 0);

		-- Data to be written into data memory
		ReadDataReg2_DP : OUT std_logic_vector(31 DOWNTO 0);
	
		-- Porgram counter(PC) output. It addresses the instruction memory	
		PCoutput_DP : OUT std_logic_vector(31 DOWNTO 0)	
		);
	
END Datapath;

-- Implementation of the datapath
ARCHITECTURE behav OF Datapath IS
		
	-- Declare a signal that supply the address of the next instruction for PC register.
	SIGNAL PCinput: std_logic_vector(31 DOWNTO 0);
	
	-- Declare a signal that contains the current value of PC register. It is used to address the
	-- instruction memory. The PC is initiated as 0.
	SIGNAL PCoutput: std_logic_vector(31 DOWNTO 0) := (others => '0');

	-- Declare a signal that represent the updated PC, that is, it contains PC + 1
	SIGNAL PCupdated : std_logic_vector(31 DOWNTO 0) := (others => '0');
	
	-- Signal that controls the PC source MUX: When '1', the PC source is PC + 1.
	-- Otherwise, the PC source is the adrress of the branch target.
	SIGNAL Branch : std_logic;
	
	-- Address of the branch target
	SIGNAL BranchAddr : std_logic_vector(31 DOWNTO 0);
	
	-- Immediate field of the instruction
	SIGNAL Immediate : std_logic_vector(15 DOWNTO 0);
	
	-- Immediate extended
	SIGNAL ImmExtended : std_logic_vector(31 DOWNTO 0);
	
	-- rs field of the instruction
	SIGNAL rs : std_logic_vector(4 DOWNTO 0);
	
	-- rt field of the instruction
	SIGNAL rt : std_logic_vector(4 DOWNTO 0);
	
	-- rd field of the instruction
	SIGNAL rd : std_logic_vector(4 DOWNTO 0);
		
	-- Register to be written in
	SIGNAL WriteRegister : std_logic_vector(4 DOWNTO 0);
	
	-- Data to be written in the selected register of register file
	SIGNAL WriteData: std_logic_vector(31 DOWNTO 0);
			
	-- Data read from register given by ReadRegister1
	SIGNAL ReadDataReg1: std_logic_vector(31 DOWNTO 0);
	
	-- Data read from register given by ReadRegister2
	SIGNAL ReadDataReg2: std_logic_vector(31 DOWNTO 0);
	
	-- ALU result
	SIGNAL ALUresult : std_logic_vector(31 DOWNTO 0);
	
	-- ALU input 2 source
	SIGNAL ALUinput2 : std_logic_vector(31 DOWNTO 0);
	
	-- Flag Zero of the ALU
	SIGNAL Zero : std_logic;
		
	-- Register File
	COMPONENT RegisterFile
		PORT(
			-- Select one register to be read.
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
	END COMPONENT;
	
	-- ALU 
	COMPONENT ALU
	PORT(
		-- ALU's input	1.
		Input1_ALU : IN std_logic_vector(31 DOWNTO 0);
		-- ALU's input 2.	
		Input2_ALU : IN std_logic_vector(31 DOWNTO 0);
		-- Signal that determ the function that is to be performed
		ALUfunct_ALU : IN std_logic_vector(2 DOWNTO 0);
		 -- ALU's output.
		Output_ALU : OUT std_logic_vector(31 DOWNTO 0); 
		-- Zero_ALU flag: It is set to one when the result of an operation is Zero_ALU.
		Zero_ALU : OUT std_logic	
	);
	END COMPONENT;
	
	BEGIN
		
		-- Connect the Register File to the datapath
		RegFile: RegisterFile
		PORT MAP(
			ReadRegister1_RF => rs,
			ReadRegister2_RF => rt,
			WriteRegister_RF => WriteRegister,
			WriteData_RF => WriteData,
			WriteEnable_RF	=> WriteRegEn_DP,
			Clk_RF => Clk_DP,
			ReadData1_RF => ReadDataReg1,
			ReadData2_RF => ReadDataReg2
		);
		
		-- Connect the ALU to the datapath
		Arithimect_and_logic_unit: ALU
		PORT MAP(
			Input1_ALU => ReadDataReg1,
			Input2_ALU => ALUinput2,
			ALUfunct_ALU => ALUfunct_DP,
			Output_ALU => ALUresult,
			Zero_ALU => Zero
		);
		
		-- Extract from the instruction the Immediate field
		Immediate <= Instruction_DP(15 DOWNTO 0);
		
		-- Extract from the instruction the rs field
		rs <= Instruction_DP(25 DOWNTO 21);
		
		-- Extract from the instruction the rt field
		rt <= Instruction_DP(20 DOWNTO 16);
		
		-- Extract from the instruction the rd field
		rd <= Instruction_DP(15 DOWNTO 11);		
		
		---------------------------------------------------------------------
		-- Implementation of the PC register
		---------------------------------------------------------------------
		PC_REGISTER: PROCESS(Clk_DP)
		BEGIN
			IF(Clk_DP'EVENT AND Clk_DP = '1') THEN
				PCoutput <= PCinput;	
			ELSE
				PCoutput <= PCoutput;
			END IF;
		END PROCESS;
		
		-- Update the PC by adding 1 to it.
		PCupdated <= std_logic_vector(unsigned(PCoutput) + 1);
		
		-- Hook up output of the PC register to the corresponding output 
		-- of the datapath.
		PCoutput_DP <= PCoutput;
		
		-----------------------------------------------------------------------
		-- Implementation of the extender: Extend the immediate field 
		--	of the instruction.
		-- If ExtenderCtr is '0', the immediate field is zero extended.
		-- If ExtenderCtr is '1', the immediate field is signed extended.
		------------------------------------------------------------------------
		ImmExtended(15 DOWNTO 0) <= Immediate;
		ImmExtended(31 DOWNTO 16) <= x"0000" WHEN ExtenderCtr_DP = '0' ELSE
											  x"0000" WHEN ExtenderCtr_DP = '1' AND Immediate(15) = '0' ELSE
											  x"FFFF";											  
		
		-------------------------------------------------------------------------
		-- Implementation of ADD_Branch: It Calculates the branch target address 
		-- by address PC + 4 to the displacement received in immediate field 
		-- signal extended.
		-------------------------------------------------------------------------
		BranchAddr <= std_logic_vector(unsigned(ImmExtended) + unsigned(PCupdated));		
		
		-------------------------------------------------------------------------
		-- Implementation of MUX_PCSource:
		-- The MUX_PCSource is responsible to determine if the next 
		-- value of PC will be either PC + 4 (PC Updated) or the address 
		-- of the branch target
		--------------------------------------------------------------------------
		PCinput <= PCupdated WHEN Branch = '0' ELSE
					  BranchAddr;
		
		--------------------------------------------------------------------------
		-- Implementation of the MUX_RegDest
		-- This MUX selects if the source of the register number to be 
		-- written into register file comes from the rd or rt field 
		-- of the instruction.It is controled by RegDest_DP input.
		--  If RegDest_DP = 1, the register destination if rt.
		-- Otherwise, the register destination is rd.
		---------------------------------------------------------------------------
		WriteRegister <= rt WHEN RegDest_DP = '1' ELSE
							  rd;
		
		-----------------------------------------------------------------------------
		-- Implementation of the Branch logic
		-----------------------------------------------------------------------------
		Branch <= '1' WHEN (Zero = '1' AND BranchOnEqual_DP = '1') OR (Zero = '0' AND BranchOnNotEqual_DP = '1') ELSE
					 '0';
					 
		-------------------------------------------------------------------------------------
		-- Implementation of the MUC_ALUSource
		-- This MUX steers either the extended immediate or the content of the register given
		-- by rt to the ALU input 2.
		--------------------------------------------------------------------------------------
		ALUinput2 <= ReadDataReg2 WHEN ALUsource_DP = '0' ELSE
						 ImmExtended;
						 
		-- Output the result of the ALU
		ALUresult_DP <= ALUresult;
		
		-- Output the data read from port 2 of the register
		ReadDataReg2_DP <= ReadDataReg2;
						 
		-------------------------------------------------------------------------------
		-- Implementation of the MUX_WriteRegData
		-- This MUX selects the data to be written into the register file.
		-- The data can come from either the data memory of the result output of the ALU
		--------------------------------------------------------------------------------
		WriteData <= ALUresult WHEN DataMem_DP = '0' ELSE

						ReadDataMem_DP;
						
	END behav;

		
