-------------------------------------------------------------------------------
--
-- Title       : Reg_File_Mem_Type
-- Design      : Project_Final
-- Author      : Tyguan
-- Company     : Stony Brook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_Final\Project_Final\Project_Final\src\Reg_File_Mem_Type.vhd
-- Generated   : Thu Dec  2 22:28:18 2021
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {Reg_File_Mem_Type} architecture {Reg_File_Mem_Type}}

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
	
package Reg_File_Mem_Type is
	type reg_memory is array (31 downto 0) of std_logic_vector(127 downto 0); 
--	signal reg_lookup : reg_memory := (others => all_zeros);
end Reg_File_Mem_Type;
