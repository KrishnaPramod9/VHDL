--------------------------------------------------------------------------------
-- Project Name: Microcomputer
--
-- Date: 11/23/2014
--
-- Project Description: This code implements a MIPS based microcomputer.
--								The CPU of the microcomputer is simple version 
--								of the single cycle MIPS.
--								Additionally, it has two independent memories, 
--								one to store instruction and another to store data.
--------------------------------------------------------------------------------
-- Declaration of libraries used in this project
LIBRARY ieee;

-- Specify the packages used in this project
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Declaration of the entity microcomputer
ENTITY Microcomputer IS
	PORT(
	
		-- Inputs to write into the instruction memory
		
		-- Instruction	Memory's address lines for write operation
		WriteAddressIM_MC : IN std_logic_vector(11 DOWNTO 0); 
		
		-- Instruction Memory's data line for write operation
		WriteInstructionIM_MC: IN std_logic_vector(31 DOWNTO 0);
	
		-- Write enable signal. When '1', the write operation is enabled.
		WriteEnableIM_MC : IN std_logic;	
		
		-- Clock signal. Sensitive at rising edge.
		ClkIM_MC : IN std_logic;	
		
		-- Clock signal of the Microcomputer. Sensitive at rising edge.
		Clk_MC : IN std_logic;	
		
		-- Outputs that are used to read the data memory. They are provided for test purporse. 		                                PURPOSE                                   
		
		-- Data Memory's data line of PORT 2
		ReadData2DM_MC : OUT std_logic_vector(31 DOWNTO 0);	
		
		-- Data Memory's address lines of PORT 2
		Address2DM_MC : IN std_logic_vector(11 DOWNTO 0) 
		);
	
END Microcomputer;

-- Implementation of the Microcomputer
ARCHITECTURE behav OF Microcomputer IS

SIGNAL Instruction : std_logic_vector(31 DOWNTO 0);              
SIGNAL BranchOnEqual : std_logic;		
SIGNAL BranchOnNotEqual : std_logic;	
SIGNAL DataMem : std_logic; 			
SIGNAL WriteRegEn : std_logic;		
SIGNAL RegDest : std_logic;																					
SIGNAL ALUsource : std_logic;															
SIGNAL ReadDataMemEn : std_logic;	
SIGNAL WriteDataMemEn : std_logic;
SIGNAL ALUop : std_logic_vector(2 DOWNTO 0);	
SIGNAL ExtenderCtr : std_logic;	
SIGNAL ALUfunct : std_logic_vector(2 DOWNTO 0);
SIGNAL Clk : std_logic;
SIGNAL ReadDataMem : std_logic_vector(31 DOWNTO 0);
SIGNAL ALUresult : std_logic_vector(31 DOWNTO 0);
SIGNAL ReadDataReg2 : std_logic_vector(31 DOWNTO 0);
SIGNAL PCoutput : std_logic_vector(31 DOWNTO 0);
	
	-- Control Module
	COMPONENT Control
	PORT(
		-- CONTROL INPUTs
		
		-- Instruction read from instruction memory
		Instruction_CTR : IN std_logic_vector(31 DOWNTO 0);	
		
		-- CONTROL OUTPUTs 

		-- Inform the datapath if the current instruction is branch on equal
		BranchOnEqual_CTR : OUT std_logic;

		-- Inform the datapath if the current instruction is branch on equal
		BranchOnNotEqual_CTR : OUT std_logic;	
		
		-- Inform the datapath if the current instruction is branch on not equal
		DataMem_CTR : OUT std_logic;

		-- Determine if the data to be written into register comes from memory or another register
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
	END COMPONENT;
	
	-- ALU Control Module
	COMPONENT ALUcontrol
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
	END COMPONENT;
	
	-- Datapath Module
	COMPONENT Datapath
	PORT(                              
		BranchOnEqual_DP : IN std_logic;	
		BranchOnNotEqual_DP : IN std_logic;	
		DataMem_DP : IN std_logic; 
		WriteRegEn_DP:	IN std_logic;	
		RegDest_DP : IN std_logic;												
		ALUsource_DP : IN std_logic;
		ALUfunct_DP : IN std_logic_vector(2 DOWNTO 0);
		Instruction_DP : IN std_logic_vector(31 DOWNTO 0);
		ExtenderCtr_DP : IN std_logic;
		Clk_DP : IN std_logic;
		ReadDataMem_DP : IN std_logic_vector(31 DOWNTO 0);			
		ALUresult_DP : OUT std_logic_vector(31 DOWNTO 0);
		ReadDataReg2_DP : OUT std_logic_vector(31 DOWNTO 0);
		PCoutput_DP : OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;
	
	-- Data Memory Module
	COMPONENT DataMemory
	PORT(
		-- Memory's address lines of PORT 1
		Address1_DM : IN std_logic_vector(11 DOWNTO 0);	
		
		-- Memory's data lines of PORT 1
		WriteData1_DM: IN std_logic_vector(31 DOWNTO 0);
	
		-- Write enable signal. When '1', the writing operation is enabled.
		WriteEnable1_DM : IN std_logic;	
		
		-- Read enable signal of PORT 1. When '1', the reading operation is enabled.
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
	END COMPONENT;
	
	-- Instruction Memory
	COMPONENT InstructionMemory
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
	END COMPONENT;
	
	BEGIN	
		-- Connect the microcomputer clock to the clock of the internal module
		Clk <= Clk_MC;
		
		-- Connect the control to the microcomputer module
		Control_module: Control
		PORT MAP(
			Instruction_CTR => Instruction,              
			BranchOnEqual_CTR => BranchOnEqual,		
			BranchOnNotEqual_CTR => BranchOnNotEqual,	
			DataMem_CTR => DataMem, 			
			WriteRegEn_CTR => WriteRegEn,		
			RegDest_CTR => RegDest,																					
			ALUsource_CTR => ALUsource,															
			ReadDataMemEn_CTR => ReadDataMemEn,	
			WriteDataMemEn_CTR => WriteDataMemEn,
			ALUop_CTR => ALUop,	
			ExtenderCtr_CTR => ExtenderCtr	
		);

		-- Connect the ALU control module to the microcomputer module
		ALUcontrol_module: ALUcontrol
		PORT MAP(
			Instruction_ALUCTR => Instruction,
			ALUop_ALUCTR => ALUop,
			ALUfunct_ALUCTR => ALUfunct
		);

		-- Connect the Datapath module to the microcomputer module
		Datapath_module: Datapath
		PORT MAP(	                                                
			BranchOnEqual_DP => BranchOnEqual,
			BranchOnNotEqual_DP => BranchOnNotEqual,
			DataMem_DP => DataMem, 
			WriteRegEn_DP => WriteRegEn,
			RegDest_DP => RegDest,
			ALUsource_DP => ALUsource,
			ALUfunct_DP => ALUfunct,
			ExtenderCtr_DP => ExtenderCtr,
			Instruction_DP => Instruction,
			Clk_DP => Clk,
			ReadDataMem_DP => ReadDataMem,		
			ALUresult_DP => ALUresult,
			ReadDataReg2_DP => ReadDataReg2,
			PCoutput_DP => PCoutput
		);
		
		-- Connect the Data Memory module to the microcomputer module
		DataMemory_module: DataMemory
		PORT MAP(
			Address1_DM => ALUresult(11 DOWNTO 0),
			WriteData1_DM => ReadDatareg2,
			WriteEnable1_DM => WriteDataMemEn,
			ReadEnable1_DM => ReadDataMemEn,
			Address2_DM => Address2DM_MC,
			Clk_DM => Clk,
			ReadData1_DM => ReadDataMem,
			ReadData2_DM => ReadData2DM_MC
		);
		
		-- Connect the Instruction Memory module to the microcomputer module
		Instruction_module: InstructionMemory
		PORT MAP(
			Address_IM => PCoutput(11 DOWNTO 0),
			WriteAddress_IM => WriteAddressIM_MC,
			WriteInstruction_IM => WriteInstructionIM_MC,
			WriteEnable_IM => WriteEnableIM_MC,
			Clk_IM => ClkIM_MC,
			Instruction_IM => Instruction
		);
		
	END behav;


