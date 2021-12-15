-------------------------------------------------------------------------------
--
-- Title       : Four_Stage_Pipeline
-- Design      : Project Midterm
-- Author      : Tyguan
-- Company     : Stony Brook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_midterm\Project Midterm\src\Four_Stage_Pipeline.vhd
-- Generated   : Sun Nov 28 21:28:01 2021
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
--{entity {Four_Stage_Pipeline} architecture {Four_Stage_Pipeline_arch}}

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity Four_Stage_Pipeline is
	generic(
	
	REGISTER_INDEX : integer := 5;  --32 registers
	DATA_WIDTH 	  : integer := 128;  --of 128 bits
	INSTR_INDEX : integer := 6;     --2^6 = 64 instructions
	INSTR_WIDTH   : integer := 25   --of 25 bit wide 
	
	);
	
	 port(
	 clk : in STD_LOGIC;
	 load_instr_row_input : in STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0);
	 
	 output : out STD_LOGIC_VECTOR(127 downto 0)
	     );
end Four_Stage_Pipeline;

--}} End of automatically maintained section

architecture Four_Stage_Pipeline_arch of Four_Stage_Pipeline is
begin
	IF_Stage : entity Instr_buffer port map (
		clk => clk, 								--their clk to our clk
		load_instr_row => load_instr_row_input
		
		);

end Four_Stage_Pipeline_arch;
