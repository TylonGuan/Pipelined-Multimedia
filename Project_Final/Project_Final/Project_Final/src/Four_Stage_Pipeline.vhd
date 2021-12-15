--ESE 345 Tylon Guan and Joseph Zappala
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

library Project_Final;
use Project_Final.all;

entity Four_Stage_Pipeline is
	generic(
	
	REGISTER_INDEX : integer := 5;  --32 registers
	DATA_WIDTH 	  : integer := 128;  --of 128 bits
	INSTR_INDEX : integer := 6;     --2^6 = 64 instructions
	INSTR_WIDTH   : integer := 25   --of 25 bit wide 
	
	);
	
	port(
	
	--Results File
	IF_PC_out : out STD_LOGIC_VECTOR(5 downto 0);
	IF_instr_out : out STD_LOGIC_VECTOR(24 downto 0);
	
	--ID_reset : STD_LOGIC;
	ID_instr_out : out STD_LOGIC_VECTOR(24 downto 0);
	ID_opcode_out : out STD_Logic_vector (9 downto 0);
	ID_write_enable_out : out STD_LOGIC;
	ID_rd_WB_out : out STD_LOGIC_VECTOR(127 downto 0);
	ID_rd_address_WB_out : out STD_LOGIC_VECTOR(4 downto 0);
	ID_rs1_address_out : out STD_LOGIC_VECTOR(4 downto 0);
	ID_rs2_address_out : out STD_LOGIC_VECTOR(4 downto 0);
	ID_rs3_address_out : out STD_LOGIC_VECTOR(4 downto 0);
	ID_rd_address_out : out STD_LOGIC_VECTOR(4 downto 0);
	ID_rs1_data_out : out STD_LOGIC_VECTOR(127 downto 0);
	ID_rs2_data_out : out STD_LOGIC_VECTOR(127 downto 0);
	ID_rs3_data_out : out STD_LOGIC_VECTOR(127 downto 0);
	ID_rd_data_out : out STD_LOGIC_VECTOR(127 downto 0);

	EX_rs1_out : out STD_LOGIC_VECTOR(127 downto 0);
	EX_rs2_out : out STD_LOGIC_VECTOR(127 downto 0);
	EX_rs3_out : out STD_LOGIC_VECTOR(127 downto 0);
	EX_rd_address_input_out : out STD_LOGIC_VECTOR(4 downto 0);
	EX_rd_data_out : out STD_LOGIC_VECTOR(127 downto 0);
	EX_write_enable_out : out STD_LOGIC;
	
	FW_mux_control1_out : out STD_LOGIC;
	FW_mux_control2_out : out STD_LOGIC;
	FW_mux_control3_out : out STD_LOGIC;
	FW_new_rData_out : out STD_LOGIC_VECTOR(127 downto 0);
	
	FM_mux_control1_out : out STD_LOGIC;
	FM_mux_control2_out : out STD_LOGIC;
	FM_mux_control3_out : out STD_LOGIC;
	FM_rs1_input_out : out STD_LOGIC_VECTOR(127 downto 0);
	FM_rs2_input_out : out STD_LOGIC_VECTOR(127 downto 0);
	FM_rs3_input_out : out STD_LOGIC_VECTOR(127 downto 0); 
	FM_new_rData_out : out STD_LOGIC_VECTOR(127 downto 0);
	FM_rs1_new_out : out STD_LOGIC_VECTOR(127 downto 0);
	FM_rs2_new_out : out STD_LOGIC_VECTOR(127 downto 0);
	FM_rs3_new_out : out STD_LOGIC_VECTOR(127 downto 0);
	
	
	--Results File
	
	
	clk : in STD_LOGIC;
	if_load_clock : in STD_LOGIC;
	 load_instr_row_input : in STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0);
	 write_enable : out STD_LOGIC;
	 output : out STD_LOGIC_VECTOR(127 downto 0)
	     );
end Four_Stage_Pipeline;

--}} End of automatically maintained section

architecture Four_Stage_Pipeline_arch of Four_Stage_Pipeline is
signal output_instr : std_logic_vector (24 downto 0); 
signal output_instr_buff : std_logic_vector (24 downto 0);
signal our_opcode : std_logic_vector(9 downto 0);
signal our_opcode_buff : std_logic_vector(9 downto 0);

signal RF_output_rs1  : std_logic_vector (127 downto 0);
signal RF_output_rs2 : std_logic_vector (127 downto 0);
signal RF_output_rs3 : std_logic_vector (127 downto 0);
signal RF_output_rs1_buff  : std_logic_vector (127 downto 0);
signal RF_output_rs2_buff : std_logic_vector (127 downto 0);
signal RF_output_rs3_buff : std_logic_vector (127 downto 0);

signal RF_output_rs1_adrs : std_logic_vector (4 downto 0);
signal RF_output_rs2_adrs : std_logic_vector (4 downto 0);
signal RF_output_rs3_adrs : std_logic_vector (4 downto 0);
signal RF_output_rd_adrs : std_logic_vector (4 downto 0);
signal RF_output_rs1_adrs_buff : std_logic_vector (4 downto 0);
signal RF_output_rs2_adrs_buff : std_logic_vector (4 downto 0);
signal RF_output_rs3_adrs_buff : std_logic_vector (4 downto 0);
signal RF_output_rd_adrs_buff : std_logic_vector (4 downto 0);
signal RF_instr_toFoward : std_logic_vector (24 downto 0); --from IF/ID to ID
signal RF_instr_toFoward_buff : std_logic_vector (24 downto 0); --ID/EX to EX
signal RF_instr_toFoward_buff2 : std_logic_vector (24 downto 0); -- ID/EX to WB/foward for next instr


--signal FW_output_rs1  : std_logic_vector (127 downto 0);
--signal FW_output_rs2 : std_logic_vector (127 downto 0);
--signal FW_output_rs3 : std_logic_vector (127 downto 0);

signal MUX_output_rs1  : std_logic_vector (127 downto 0);
signal MUX_output_rs2 : std_logic_vector (127 downto 0);
signal MUX_output_rs3 : std_logic_vector (127 downto 0);

signal ALU_output_rd : std_logic_vector (127 downto 0);
signal ALU_output_rd_buff : std_logic_vector (127 downto 0);
signal ALU_output_rd_adrs : std_logic_vector (4 downto 0);
signal ALU_output_rd_adrs_buff : std_logic_vector (4 downto 0);

signal FW_output_rd : std_logic_vector (127 downto 0);

signal write_enable_RF : std_logic;
signal write_enable_RF_buff : std_logic;

signal output_buff :  std_logic_vector (127 downto 0);

signal mux_control1_temp : std_logic;
signal mux_control2_temp : std_logic;
signal mux_control3_temp : std_logic;



begin
	IF_Stage : entity Instr_buffer port map (
		clk => clk, 								--their clk to our clk
		load_clock => if_load_clock,
		load_instr_row => load_instr_row_input,
		instr => output_instr,
		
		--RF
		PC_out => IF_PC_out,
		instr_out => IF_instr_out
		
		);	
		
	IF_ID_reg : process(clk)
	begin
		if (rising_edge(clk))then
			 output_instr_buff <= output_instr;
		end if;
	end process;
		
		
	ID_WB_Stage : entity Register_File port map (
		instr => output_instr_buff,
		clk => clk,
		--reset => ID_reset,
		
		--from WB
		write_enable => write_enable_RF_buff,
		rd_address_WB => ALU_output_rd_adrs_buff,
		rd => ALU_output_rd_buff,
		
		instr_toFoward => RF_instr_toFoward,
		rs1_address => RF_output_rs1_adrs,
		rs2_address => RF_output_rs2_adrs,
		rs3_address => RF_output_rs3_adrs,
		rd_address => RF_output_rd_adrs,
		
		opcode => our_opcode,
		rs1 => RF_output_rs1,
		rs2 => RF_output_rs2,
		rs3 => RF_output_rs3,
		
		--RF
		instr_out => ID_instr_out, 
		opcode_out => ID_opcode_out,
		 
		write_enable_out => ID_write_enable_out,
		rd_WB_out => ID_rd_WB_out,
		rd_address_WB_out => ID_rd_address_WB_out,
		
		rs1_address_out => ID_rs1_address_out,
		rs2_address_out => ID_rs2_address_out,
		rs3_address_out => ID_rs3_address_out,
		rd_address_out =>  ID_rd_address_out,
		rs1_data_out => ID_rs1_data_out,
		rs2_data_out => ID_rs2_data_out,
		rs3_data_out => ID_rs3_data_out,	
		rd_data_out => ID_rd_data_out
		);
		
	ID_EX_reg : process(clk)
	begin
		if (rising_edge(clk))then
			--alu
			our_opcode_buff <= our_opcode;
			RF_output_rs1_buff <= RF_output_rs1;
			RF_output_rs2_buff <= RF_output_rs2;
			RF_output_rs3_buff <= RF_output_rs3;
			
			RF_output_rd_adrs_buff <= RF_output_rd_adrs;
			
			
			--fowarding unit (check these inputs with ex/wb's rd)
			RF_instr_toFoward_buff <= RF_instr_toFoward;
			RF_output_rs1_adrs_buff <= RF_output_rs1_adrs;
			RF_output_rs2_adrs_buff <= RF_output_rs2_adrs;
			RF_output_rs3_adrs_buff <= RF_output_rs3_adrs;
			
			
		end if;
	end process;
		
	EX_Stage : entity alu port map (
		clk => clk,
		rs1 => MUX_output_rs1,
		rs2 => MUX_output_rs2,
		rs3 => MUX_output_rs3,
		rd_address_in => RF_output_rd_adrs_buff,
		
		opcode => our_opcode_buff,
		
		write_enable => write_enable_RF, ---
		rd_address_out => ALU_output_rd_adrs,--
		rd => ALU_output_rd,--

		--RF
		rs1_out => EX_rs1_out,
		rs2_out => EX_rs2_out,
		rs3_out => EX_rs3_out,
		rd_address_input_out => EX_rd_address_input_out,
		rd_data_out => EX_rd_data_out,
		write_enable_out => EX_write_enable_out
		);
		
		
	Foward_Unit : entity Fowarding_unit port map(
		instr => RF_instr_toFoward_buff,
		ex_wb_rd_data => ALU_output_rd_buff,
		ex_wb_rd => ALU_output_rd_adrs_buff,
		
		write_enable => write_enable_RF_buff,
		
		id_ex_rs1 => RF_output_rs1_adrs_buff,

	 
	    id_ex_rs2 => RF_output_rs2_adrs_buff,

	 
	    id_ex_rs3 => RF_output_rs3_adrs_buff,
	 					   
	    mux_control1 => mux_control1_temp,
	    mux_control2 => mux_control2_temp,
	    mux_control3 => mux_control3_temp,
	 
	    new_rData => FW_output_rd,
		
		--RF
		mux_control1_out => FW_mux_control1_out, 
		mux_control2_out => FW_mux_control2_out, 
		mux_control3_out => FW_mux_control3_out,
		new_rData_out => FW_new_rData_out
		);
		
	Foward_Mux : entity Fowarding_mux port map (
		 mux_control1 => mux_control1_temp, 
		 mux_control2 => mux_control2_temp,
		 mux_control3 => mux_control3_temp,
		 
		 
		rs1 => RF_output_rs1_buff,
		rs2 => RF_output_rs2_buff,
		rs3 => RF_output_rs3_buff,
		new_rData => FW_output_rd,	
		
		rs1_out => MUX_output_rs1, --
		rs2_out => MUX_output_rs2,--
		rs3_out => MUX_output_rs3,--
		
		--RF
		mux_control1_out => FM_mux_control1_out,
		mux_control2_out => FM_mux_control2_out,
		mux_control3_out => FM_mux_control3_out,
		rs1_input_out => FM_rs1_input_out,
		rs2_input_out => FM_rs2_input_out,
		rs3_input_out => FM_rs3_input_out,
		new_rData_out => FM_new_rData_out,
		rs1_new_out => FM_rs1_new_out,
		rs2_new_out => FM_rs2_new_out,
		rs3_new_out => FM_rs3_new_out
		
		);
		
		EX_WB_reg : process (clk)
		begin  
		if (rising_edge(clk)) then
			--RF_instr_toFoward_buff2 <= RF_instr_toFoward_buff;
			write_enable_RF_buff <= write_enable_RF;
			ALU_output_rd_adrs_buff <= ALU_output_rd_adrs;
			ALU_output_rd_buff <= ALU_output_rd;
		end if;
		--output_buff <= ALU_output_rd;
		
		end process;
		
		
		write_enable <= write_enable_RF_buff;
		output <= ALU_output_rd_buff;
		
		
		

end Four_Stage_Pipeline_arch;
