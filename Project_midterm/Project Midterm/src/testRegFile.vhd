-------------------------------------------------------------------------------
--
-- Title       : testRegFile
-- Design      : Project Midterm
-- Author      : Tyguan
-- Company     : Stony Brook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_midterm\Project Midterm\src\testRegFile.vhd
-- Generated   : Wed Nov 24 22:30:43 2021
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
--{entity {testRegFile} architecture {testRegFile_Arch}}

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity testRegFile is
end testRegFile;

--}} End of automatically maintained section

architecture testRegFile_Arch of testRegFile is	
--inputs
signal instr_tb : std_logic_vector(24 downto 0);
signal write_enable_tb : std_logic;
signal rd_tb : std_logic_vector(127 downto 0);
signal clk : std_logic := '0'; 

--outputs
signal rs1_tb : std_logic_vector(127 downto 0);
signal rs2_tb : std_logic_vector(127 downto 0);
signal rs3_tb : std_logic_vector(127 downto 0);



begin 
	uut : entity Register_File
		port map (instr => instr_tb,
		write_enable => write_enable_tb,
		rd => rd_tb,
		clk => clk,
		
		rs1	=> rs1_tb,
		rs2 => rs2_tb,
		rs3 => rs3_tb);
		
	clock : process	
	constant t : time := 25 ns;
	begin		
		
		
		instr_tb        <= "0000000000000000000100001"; --li 1
		write_enable_tb <= '0';
		rd_tb           <= x"000000408F107BC537E28EFB16B08D78";--garbage
		  wait for t;
		clk <= not clk;
		wait for t;
		clk <= not clk;
		wait for t;
		
		instr_tb        <= "0000000000000000001000010"; --li  2
		write_enable_tb <= '0';
		rd_tb           <= x"000000408F107BC537E28EFB16B08D78";--garbage
		
		clk <= not clk;
		wait for t;
		clk <= not clk;
		wait for t;
		
		instr_tb        <= "0000000000000000001100011"; --li 3
		write_enable_tb <= '0';
		rd_tb           <= x"000000408F107BC537E28EFB16B08D78";--garbage
		
		clk <= not clk;
		wait for t;
		clk <= not clk;
		wait for t;
		
		instr_tb        <= "0000000000000000010000100"; --li 4
		write_enable_tb <= '1';
		rd_tb           <= x"00000000000000000000000000000001";--from instr1
		
		clk <= not clk;
		wait for t;
		clk <= not clk;
		wait for t;
		
		instr_tb        <= "0000000000000000010100101"; --li 5
		write_enable_tb <= '1';
		rd_tb           <= x"00000000000000000000000000000002";--from instr2
		
		clk <= not clk;
		wait for t;
		clk <= not clk;
		wait for t;
		
		
		instr_tb        <= b"0_000_0000000000000110_00110"; --li 6
		write_enable_tb <= '1';
		rd_tb           <= x"00000000000000000000000000000003";--from instr3
		
		clk <= not clk;
		wait for t;
		clk <= not clk;
		wait for t;
			
		report "END OF TB_Reglookup";
        std.env.stop;
	end process clock;

	
end testRegFile_Arch;
