-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : Project_Final
-- Author      : Tyguan
-- Company     : Stony Brook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_Final\Project_Final\Project_Final\compile\fowarding_unit.vhd
-- Generated   : Fri Dec  3 03:16:18 2021
-- From        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_Final\Project_Final\Project_Final\src\fowarding_unit.bde
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

entity fowarding_unit is
  port(
       Instr : in STD_LOGIC_VECTOR(24 downto 0);
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
end fowarding_unit;

architecture fowarding_unit_arch of fowarding_unit is

begin

---- Processes ----

check_reg_output : process (ex_wb_rd_data,write_enable,ex_wb_rd)
                         constant all_U : std_logic_vector(127 downto 0) := (others => 'U');
                       begin
                         if (ex_wb_rd = id_ex_rs1 and write_enable = '1' and instr(24) = '1') then
                            mux_control1 <= '1';
                         else 
                            mux_control1 <= '0';
                         end if;
                         if (ex_wb_rd = id_ex_rs2 and write_enable = '1' and instr(24) = '1') then
                            mux_control2 <= '1';
                         else 
                            mux_control2 <= '0';
                         end if;
                         if (ex_wb_rd = id_ex_rs3 and write_enable = '1') then
                            mux_control3 <= '1';
                         else 
                            mux_control3 <= '0';
                         end if;
                         new_rData <= ex_wb_rd_data;
                       end process;
                      

---- User Signal Assignments ----
new_rData_out <= ex_wb_rd_data;

----  Component instantiations  ----

mux_control1_out <= mux_control1;

mux_control2_out <= mux_control2;

mux_control3_out <= mux_control3;


end fowarding_unit_arch;
