-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : Project_Final
-- Author      : Tyguan
-- Company     : Stony Brook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_Final\Project_Final\Project_Final\compile\Fowarding_Mux.vhd
-- Generated   : Fri Dec  3 03:16:17 2021
-- From        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_Final\Project_Final\Project_Final\src\Fowarding_Mux.bde
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

entity Fowarding_Mux is
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
end Fowarding_Mux;

architecture Fowarding_Mux_arch of Fowarding_Mux is

begin

---- Processes ----

check_fowarding : process (mux_control1,mux_control2,mux_control3,rs1,rs2,rs3,new_rData)
                       begin
                         if mux_control1 = '1' then
                            rs1_out <= new_rData;
                         else 
                            rs1_out <= rs1;
                         end if;
                         if mux_control2 = '1' then
                            rs2_out <= new_rData;
                         else 
                            rs2_out <= rs2;
                         end if;
                         if mux_control3 = '1' then
                            rs3_out <= new_rData;
                         else 
                            rs3_out <= rs3;
                         end if;
                       end process;
                      

---- User Signal Assignments ----
rs1_input_out <= rs1;
rs2_input_out <= rs2;
rs3_input_out <= rs3;
new_rData_out <= new_rData;
rs1_new_out <= rs1_out;
rs2_new_out <= rs2_out;
rs3_new_out <= rs3_out;

----  Component instantiations  ----

mux_control1_out <= mux_control1;

mux_control2_out <= mux_control2;

mux_control3_out <= mux_control3;


end Fowarding_Mux_arch;
