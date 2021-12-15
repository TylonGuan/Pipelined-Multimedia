-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : Project_Final
-- Author      : Tyguan
-- Company     : Stony Brook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_Final\Project_Final\Project_Final\compile\Four_Stage_Pipeline.vhd
-- Generated   : Fri Dec  3 03:16:15 2021
-- From        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_Final\Project_Final\Project_Final\src\Four_Stage_Pipeline.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity Four_Stage_Pipeline is
  generic(
       REGISTER_INDEX : integer := 5;
       DATA_WIDTH : integer := 128;
       INSTR_INDEX : integer := 6;
       INSTR_WIDTH : integer := 25
  );
  port(
       IF_PC_out : out STD_LOGIC_VECTOR(5 downto 0);
       IF_instr_out : out STD_LOGIC_VECTOR(24 downto 0);
       ID_instr_out : out STD_LOGIC_VECTOR(24 downto 0);
       ID_opcode_out : out STD_LOGIC_VECTOR(9 downto 0);
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
       clk : in STD_LOGIC;
       if_load_clock : in STD_LOGIC;
       load_instr_row_input : in STD_LOGIC_VECTOR(INSTR_WIDTH - 1 downto 0);
       write_enable : out STD_LOGIC;
       output : out STD_LOGIC_VECTOR(127 downto 0)
  );
end Four_Stage_Pipeline;

architecture Four_Stage_Pipeline_arch of Four_Stage_Pipeline is

---- Component declarations -----

component alu
  port(
       clk : in STD_LOGIC;
       rs1 : in STD_LOGIC_VECTOR(127 downto 0);
       rs2 : in STD_LOGIC_VECTOR(127 downto 0);
       rs3 : in STD_LOGIC_VECTOR(127 downto 0);
       rd_address_in : in STD_LOGIC_VECTOR(4 downto 0);
       opcode : in STD_LOGIC_VECTOR(9 downto 0);
       rd : inout STD_LOGIC_VECTOR(127 downto 0);
       rd_address_out : out STD_LOGIC_VECTOR(4 downto 0);
       write_enable : inout STD_LOGIC;
       rs1_out : out STD_LOGIC_VECTOR(127 downto 0);
       rs2_out : out STD_LOGIC_VECTOR(127 downto 0);
       rs3_out : out STD_LOGIC_VECTOR(127 downto 0);
       rd_address_input_out : out STD_LOGIC_VECTOR(4 downto 0);
       rd_data_out : out STD_LOGIC_VECTOR(127 downto 0);
       write_enable_out : out STD_LOGIC := '0'
  );
end component;
component Fowarding_Mux
  port(
       mux_control1 : in STD_LOGIC;
       mux_control2 : in STD_LOGIC;
       mux_control3 : in STD_LOGIC;
       rs1 : in STD_LOGIC_VECTOR(127 downto 0);
       rs2 : in STD_LOGIC_VECTOR(127 downto 0);
       rs3 : in STD_LOGIC_VECTOR(127 downto 0);
       new_rData : in STD_LOGIC_VECTOR(127 downto 0);
       rs1_out : inout STD_LOGIC_VECTOR(127 downto 0);
       rs2_out : inout STD_LOGIC_VECTOR(127 downto 0);
       rs3_out : inout STD_LOGIC_VECTOR(127 downto 0);
       mux_control1_out : out STD_LOGIC;
       mux_control2_out : out STD_LOGIC;
       mux_control3_out : out STD_LOGIC;
       rs1_input_out : out STD_LOGIC_VECTOR(127 downto 0);
       rs2_input_out : out STD_LOGIC_VECTOR(127 downto 0);
       rs3_input_out : out STD_LOGIC_VECTOR(127 downto 0);
       new_rData_out : out STD_LOGIC_VECTOR(127 downto 0);
       rs1_new_out : out STD_LOGIC_VECTOR(127 downto 0);
       rs2_new_out : out STD_LOGIC_VECTOR(127 downto 0);
       rs3_new_out : out STD_LOGIC_VECTOR(127 downto 0)
  );
end component;
component fowarding_unit
  port(
       ex_wb_rd_data : in STD_LOGIC_VECTOR(127 downto 0);
       ex_wb_rd : in STD_LOGIC_VECTOR(4 downto 0);
       id_ex_rs1 : in STD_LOGIC_VECTOR(4 downto 0);
       id_ex_rs2 : in STD_LOGIC_VECTOR(4 downto 0);
       id_ex_rs3 : in STD_LOGIC_VECTOR(4 downto 0);
       write_enable : in STD_LOGIC;
       mux_control1 : inout STD_LOGIC := '0';
       mux_control2 : inout STD_LOGIC := '0';
       mux_control3 : inout STD_LOGIC := '0';
       new_rData : out STD_LOGIC_VECTOR(127 downto 0);
       mux_control1_out : out STD_LOGIC;
       mux_control2_out : out STD_LOGIC;
       mux_control3_out : out STD_LOGIC;
       new_rData_out : out STD_LOGIC_VECTOR(127 downto 0)
  );
end component;
component Instr_buffer
  generic(
       INSTR_INDEX : INTEGER := 6;
       INSTR_WIDTH : INTEGER := 25
  );
  port(
       load_instr_row : in STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0);
       clk : in STD_LOGIC;
       instr : inout STD_LOGIC_VECTOR(24 downto 0);
       PC_out : out STD_LOGIC_VECTOR(5 downto 0);
       instr_out : out STD_LOGIC_VECTOR(24 downto 0)
  );
end component;
component Register_file
  generic(
       REGISTER_INDEX : INTEGER := 5;
       DATA_WIDTH : INTEGER := 128
  );
  port(
       reset : in STD_LOGIC;
       instr : in STD_LOGIC_VECTOR(24 downto 0);
       write_enable : in STD_LOGIC;
       rd_address_WB : in STD_LOGIC_VECTOR(4 downto 0);
       rd : in STD_LOGIC_VECTOR(127 downto 0);
       clk : in STD_LOGIC;
       rs1_address : out STD_LOGIC_VECTOR(4 downto 0);
       rs2_address : out STD_LOGIC_VECTOR(4 downto 0);
       rs3_address : out STD_LOGIC_VECTOR(4 downto 0);
       rd_address : out STD_LOGIC_VECTOR(4 downto 0);
       instr_out : out STD_LOGIC_VECTOR(24 downto 0);
       opcode_out : out STD_LOGIC_VECTOR(9 downto 0);
       write_enable_out : out STD_LOGIC;
       rd_WB_out : out STD_LOGIC_VECTOR(127 downto 0);
       rd_address_WB_out : out STD_LOGIC_VECTOR(4 downto 0);
       rs1_address_out : out STD_LOGIC_VECTOR(4 downto 0);
       rs2_address_out : out STD_LOGIC_VECTOR(4 downto 0);
       rs3_address_out : out STD_LOGIC_VECTOR(4 downto 0);
       rd_address_out : out STD_LOGIC_VECTOR(4 downto 0);
       rs1_data_out : out STD_LOGIC_VECTOR(127 downto 0);
       rs2_data_out : out STD_LOGIC_VECTOR(127 downto 0);
       rs3_data_out : out STD_LOGIC_VECTOR(127 downto 0);
       rd_data_out : out STD_LOGIC_VECTOR(127 downto 0);
       opcode : out STD_LOGIC_VECTOR(9 downto 0);
       rs1 : inout STD_LOGIC_VECTOR(127 downto 0);
       rs2 : inout STD_LOGIC_VECTOR(127 downto 0);
       rs3 : inout STD_LOGIC_VECTOR(127 downto 0)
  );
end component;

----     Constants     -----
constant DANGLING_INPUT_CONSTANT : STD_LOGIC := 'Z';

---- Signal declarations used on the diagram ----

signal mux_control1_temp : STD_LOGIC;
signal mux_control2_temp : STD_LOGIC;
signal mux_control3_temp : STD_LOGIC;
signal write_enable_RF : STD_LOGIC;
signal write_enable_RF_buff : STD_LOGIC;
signal ALU_output_rd : STD_LOGIC_VECTOR(127 downto 0);
signal ALU_output_rd_adrs : STD_LOGIC_VECTOR(4 downto 0);
signal ALU_output_rd_adrs_buff : STD_LOGIC_VECTOR(4 downto 0);
signal ALU_output_rd_buff : STD_LOGIC_VECTOR(127 downto 0);
signal FW_output_rd : STD_LOGIC_VECTOR(127 downto 0);
signal MUX_output_rs1 : STD_LOGIC_VECTOR(127 downto 0);
signal MUX_output_rs2 : STD_LOGIC_VECTOR(127 downto 0);
signal MUX_output_rs3 : STD_LOGIC_VECTOR(127 downto 0);
signal our_opcode : STD_LOGIC_VECTOR(9 downto 0);
signal our_opcode_buff : STD_LOGIC_VECTOR(9 downto 0);
signal output_buff : STD_LOGIC_VECTOR(127 downto 0);
signal output_instr : STD_LOGIC_VECTOR(24 downto 0);
signal output_instr_buff : STD_LOGIC_VECTOR(24 downto 0);
signal RF_instr_toFoward : STD_LOGIC_VECTOR(24 downto 0);
signal RF_instr_toFoward_buff : STD_LOGIC_VECTOR(24 downto 0);
signal RF_instr_toFoward_buff2 : STD_LOGIC_VECTOR(24 downto 0);
signal RF_output_rd_adrs : STD_LOGIC_VECTOR(4 downto 0);
signal RF_output_rd_adrs_buff : STD_LOGIC_VECTOR(4 downto 0);
signal RF_output_rs1 : STD_LOGIC_VECTOR(127 downto 0);
signal RF_output_rs1_adrs : STD_LOGIC_VECTOR(4 downto 0);
signal RF_output_rs1_adrs_buff : STD_LOGIC_VECTOR(4 downto 0);
signal RF_output_rs1_buff : STD_LOGIC_VECTOR(127 downto 0);
signal RF_output_rs2 : STD_LOGIC_VECTOR(127 downto 0);
signal RF_output_rs2_adrs : STD_LOGIC_VECTOR(4 downto 0);
signal RF_output_rs2_adrs_buff : STD_LOGIC_VECTOR(4 downto 0);
signal RF_output_rs2_buff : STD_LOGIC_VECTOR(127 downto 0);
signal RF_output_rs3 : STD_LOGIC_VECTOR(127 downto 0);
signal RF_output_rs3_adrs : STD_LOGIC_VECTOR(4 downto 0);
signal RF_output_rs3_adrs_buff : STD_LOGIC_VECTOR(4 downto 0);
signal RF_output_rs3_buff : STD_LOGIC_VECTOR(127 downto 0);

---- Declaration for Dangling input ----
signal Dangling_Input_Signal : STD_LOGIC;

begin

---- Processes ----

EX_WB_reg : process (clk)
                       begin
                         if (rising_edge(clk)) then
                            write_enable_RF_buff <= write_enable_RF;
                            ALU_output_rd_adrs_buff <= ALU_output_rd_adrs;
                            ALU_output_rd_buff <= ALU_output_rd;
                         end if;
                       end process;
                      

ID_EX_reg : process (clk)
                       begin
                         if (rising_edge(clk)) then
                            our_opcode_buff <= our_opcode;
                            RF_output_rs1_buff <= RF_output_rs1;
                            RF_output_rs2_buff <= RF_output_rs2;
                            RF_output_rs3_buff <= RF_output_rs3;
                            RF_output_rd_adrs_buff <= RF_output_rd_adrs;
                            RF_instr_toFoward_buff <= RF_instr_toFoward;
                            RF_output_rs1_adrs_buff <= RF_output_rs1_adrs;
                            RF_output_rs2_adrs_buff <= RF_output_rs2_adrs;
                            RF_output_rs3_adrs_buff <= RF_output_rs3_adrs;
                         end if;
                       end process;
                      

IF_ID_reg : process (clk)
                       begin
                         if (rising_edge(clk)) then
                            output_instr_buff <= output_instr;
                         end if;
                       end process;
                      

----  Component instantiations  ----

EX_Stage : alu
  port map(
       clk => clk,
       rs1 => MUX_output_rs1,
       rs2 => MUX_output_rs2,
       rs3 => MUX_output_rs3,
       rd_address_in => RF_output_rd_adrs_buff,
       opcode => our_opcode_buff,
       rd => ALU_output_rd,
       rd_address_out => ALU_output_rd_adrs,
       write_enable => write_enable_RF,
       rs1_out => EX_rs1_out,
       rs2_out => EX_rs2_out,
       rs3_out => EX_rs3_out,
       rd_address_input_out => EX_rd_address_input_out,
       rd_data_out => EX_rd_data_out,
       write_enable_out => EX_write_enable_out
  );

Foward_Mux : Fowarding_Mux
  port map(
       mux_control1 => mux_control1_temp,
       mux_control2 => mux_control2_temp,
       mux_control3 => mux_control3_temp,
       rs1 => RF_output_rs1_buff,
       rs2 => RF_output_rs2_buff,
       rs3 => RF_output_rs3_buff,
       new_rData => FW_output_rd,
       rs1_out => MUX_output_rs1,
       rs2_out => MUX_output_rs2,
       rs3_out => MUX_output_rs3,
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

Foward_Unit : fowarding_unit
  port map(
       ex_wb_rd_data => ALU_output_rd_buff,
       ex_wb_rd => ALU_output_rd_adrs_buff,
       id_ex_rs1 => RF_output_rs1_adrs_buff,
       id_ex_rs2 => RF_output_rs2_adrs_buff,
       id_ex_rs3 => RF_output_rs3_adrs_buff,
       write_enable => write_enable_RF_buff,
       mux_control1 => mux_control1_temp,
       mux_control2 => mux_control2_temp,
       mux_control3 => mux_control3_temp,
       new_rData => FW_output_rd,
       mux_control1_out => FW_mux_control1_out,
       mux_control2_out => FW_mux_control2_out,
       mux_control3_out => FW_mux_control3_out,
       new_rData_out => FW_new_rData_out
  );

ID_WB_Stage : Register_file
  port map(
       reset => Dangling_Input_Signal,
       instr => output_instr_buff,
       write_enable => write_enable_RF_buff,
       rd_address_WB => ALU_output_rd_adrs_buff,
       rd => ALU_output_rd_buff,
       clk => clk,
       rs1_address => RF_output_rs1_adrs,
       rs2_address => RF_output_rs2_adrs,
       rs3_address => RF_output_rs3_adrs,
       rd_address => RF_output_rd_adrs,
       instr_out => ID_instr_out,
       opcode_out => ID_opcode_out,
       write_enable_out => ID_write_enable_out,
       rd_WB_out => ID_rd_WB_out,
       rd_address_WB_out => ID_rd_address_WB_out,
       rs1_address_out => ID_rs1_address_out,
       rs2_address_out => ID_rs2_address_out,
       rs3_address_out => ID_rs3_address_out,
       rd_address_out => ID_rd_address_out,
       rs1_data_out => ID_rs1_data_out,
       rs2_data_out => ID_rs2_data_out,
       rs3_data_out => ID_rs3_data_out,
       rd_data_out => ID_rd_data_out,
       opcode => our_opcode,
       rs1 => RF_output_rs1,
       rs2 => RF_output_rs2,
       rs3 => RF_output_rs3
  );

IF_Stage : Instr_buffer
  port map(
       load_instr_row => load_instr_row_input(INSTR_WIDTH - 1 downto 0),
       clk => clk,
       instr => output_instr,
       PC_out => IF_PC_out,
       instr_out => IF_instr_out
  );


---- Terminal assignment ----

    -- Output\buffer terminals
	output <= ALU_output_rd_buff;
	write_enable <= write_enable_RF_buff;


---- Dangling input signal assignment ----

Dangling_Input_Signal <= DANGLING_INPUT_CONSTANT;

end Four_Stage_Pipeline_arch;
