-------------------------------------------------------------------------------
--
-- Title       : Instr_buffer
-- Design      : Project Midterm
-- Author      : Tyguan
-- Company     : Stony Brook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_midterm\Project Midterm\src\Instr_buffer.vhd
-- Generated   : Thu Nov 25 18:32:10 2021
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
--{entity {Instr_buffer} architecture {Instr_buffer_arch}}

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instr_buffer is
	generic(
	
	INSTR_INDEX : integer := 6; --2^6 = 64 instructions
	INSTR_WIDTH   : integer := 25 -- of 25 bit wide 
	
	);
	
	port(
	 
	---PC : in STD_LOGIC_VECTOR(5 downto 0); --include within (no j/branch instr)
	load_instr_row : in STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0);
	clk : in STD_LOGIC;
	 
	 
	 instr : out STD_LOGIC_VECTOR(24 downto 0)
	     );
end Instr_buffer;

--}} End of automatically maintained section

architecture Instr_buffer_arch of Instr_buffer is
signal PC : UNSIGNED(5 downto 0);

constant MEMORY_DEPTH : integer := 2**INSTR_INDEX;
type instr_memeory is array (MEMORY_DEPTH-1 downto 0) of std_logic_vector(INSTR_WIDTH-1 downto 0);
signal instr_lookup : instr_memeory;

signal counter : integer := 0;

begin 
	
	load_table : process(load_instr_row)
	begin
		instr_lookup(counter) <= load_instr_row;
		counter <= counter + 1;
	end process load_table; --hard coded to load 64 rows of instructions only
	
	fetch_instr : process (clk)
	begin
		instr <= instr_lookup(to_integer(unsigned(PC)));
		PC <= PC+1;
	end process fetch_instr;
	 
	
	
end Instr_buffer_arch;
