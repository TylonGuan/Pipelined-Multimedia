-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : Project_Final
-- Author      : Tyguan
-- Company     : Stony Brook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_Final\Project_Final\Project_Final\compile\Register_file.vhd
-- Generated   : Fri Dec  3 03:16:20 2021
-- From        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_Final\Project_Final\Project_Final\src\Register_file.bde
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
library project_final;
use project_final.Reg_File_Mem_Type.all;

entity Register_file is
  generic(
       REGISTER_INDEX : integer := 5;
       DATA_WIDTH : integer := 128
  );
  port(
       instr : in STD_LOGIC_VECTOR(24 downto 0);
       write_enable : in STD_LOGIC;
       rd_address_WB : in STD_LOGIC_VECTOR(4 downto 0);
       rd : in STD_LOGIC_VECTOR(127 downto 0);
       clk : in STD_LOGIC;
       instr_toFoward : out STD_LOGIC_VECTOR(24 downto 0);
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
end Register_file;

architecture Register_file_arch of Register_file is

---- Architecture declarations -----
constant MEMORY_DEPTH : integer := 2 ** REGISTER_INDEX;
constant all_zeros : std_logic_vector(127 downto 0) := (others => '0');



---- Signal declarations used on the diagram ----

signal reg_lookup : reg_memory := (others => all_zeros);

begin

---- Processes ----

Reg_read : process (clk)
                       begin
                         if (falling_edge(clk)) then
                            if (instr(24) = '0') then
                               rs2 <= std_logic_vector(to_unsigned(to_integer(unsigned(instr(20 downto 5))),128));
                               rs1 <= std_logic_vector(to_unsigned(to_integer(unsigned(instr(23 downto 21))),128));
                               rs3 <= reg_lookup(to_integer(unsigned(instr(4 downto 0))));
                               rs3_address <= instr(4 downto 0);
                               rs2_address <= instr(14 downto 10);
                               rs1_address <= instr(9 downto 5);
                               rd_address <= instr(4 downto 0);
                               opcode <= instr(24 downto 15);
                            elsif (instr(24) = '1') then
                               rs3 <= reg_lookup(to_integer(unsigned(instr(19 downto 15))));
                               rs2 <= reg_lookup(to_integer(unsigned(instr(14 downto 10))));
                               rs1 <= reg_lookup(to_integer(unsigned(instr(9 downto 5))));
                               rs3_address <= instr(19 downto 15);
                               rs2_address <= instr(14 downto 10);
                               rs1_address <= instr(9 downto 5);
                               rd_address <= instr(4 downto 0);
                               opcode <= instr(24 downto 15);
                            end if;
                            instr_toFoward <= instr;
                         end if;
                       end process;
                      

Reg_write : process (rd_address_WB,rd,write_enable)
                       begin
                         if (write_enable = '1') then
                            reg_lookup(to_integer(unsigned(rd_address_WB))) <= rd;
                         end if;
                       end process;
                      

---- User Signal Assignments ----
instr_out <= instr;
opcode_out <= instr(24 downto 15);
rd_WB_out <= rd;
rd_address_WB_out <= rd_address_WB;
rs3_address_out <= instr(19 downto 15);
rs2_address_out <= instr(14 downto 10);
rs1_address_out <= instr(9 downto 5);
rd_address_out <= instr(4 downto 0);
rs1_data_out <= rs1;
rs2_data_out <= rs2;
rs3_data_out <= rs3;
rd_data_out <= reg_lookup(to_integer(unsigned(instr(4 downto 0))));

----  Component instantiations  ----

write_enable_out <= write_enable;


end Register_file_arch;
