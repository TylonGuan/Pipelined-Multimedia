-------------------------------------------------------------------------------
--
-- Title       : Register_file
-- Design      : Project Midterm
-- Author      : Tyguan
-- Company     : Stony Brook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_midterm\Project Midterm\src\Register File.vhd
-- Generated   : Wed Nov 24 19:12:31 2021
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
--{entity {Register_file} architecture {Register_file_arch}}

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


entity Register_file is
	generic(
	
	REGISTER_INDEX : integer := 5;  --32 registers 
	DATA_WIDTH 	  : integer := 128 --of 128 bits
	
	);
	
	 port(
		 instr : in STD_LOGIC_VECTOR(24 downto 0);
		 write_enable : in STD_LOGIC;
		 rd	: in STD_LOGIC_VECTOR(127 downto 0); --data
		 clk : in STD_LOGIC;
		 
		 
		 --opcode : out STD_Logic_vector (10 downto 0);
		 rs1 : out STD_LOGIC_VECTOR(127 downto 0);
		 rs2 : out STD_LOGIC_VECTOR(127 downto 0);
		 rs3 : out STD_LOGIC_VECTOR(127 downto 0)
	     );
end Register_file;

--}} End of automatically maintained section

-- array of 4 5 bits for rd adress	
-- clock edge trigger for write, negative edge for read
architecture Register_file_arch of Register_file is	

--2^5 = 32 entries,        2^7 = 128bits data
constant MEMORY_DEPTH : integer := 2**REGISTER_INDEX;

type reg_memory is array (MEMORY_DEPTH-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0); 
signal reg_lookup : reg_memory;


type queue is array (2 downto 0) of STD_LOGIC_VECTOR(REGISTER_INDEX-1 downto 0);
signal rd_queue : queue;
-- [4:0] address

--signal rd_address : STD_LOGIC_VECTOR(4 downto 0) := instr(4 downto 0);

begin  
	
	update_queue: process(instr)
	variable rd_queue_var : queue := rd_queue;
	begin
		--shift my queue
		rd_queue_var(0) := rd_queue_var(1);
		rd_queue_var(1) := rd_queue_var(2);
		--rd_queue_var(2) := rd_queue_var(3);
				
		rd_queue_var(2) := instr(4 downto 0); --for some reason i cant use a variable... 
			
		rd_queue <= rd_queue_var;
	end process update_queue; --NOP to empty instructions

	Reg_write: process(clk)
	--variable rd_queue_var : queue := rd_queue;
	begin 		
	if (rising_edge(clk)) then --write	 
			if (write_enable = '1') then							 
				-- ? would <= work or would we need to change it to :=?
				-- <= applies at the end of process.	 
			
				reg_lookup(to_integer(unsigned(rd_queue(0)))) <= rd; 
				
				--shift my queue
--				rd_queue_var(0) := rd_queue_var(1);
--				rd_queue_var(1) := rd_queue_var(2);
--				rd_queue_var(2) := rd_queue_var(3);
				
			end if;
		
	end if;
	end process Reg_write;	
	
	Reg_read: process(clk) --decodes the instruction
	variable rs3_address : std_logic_vector(4 downto 0) := instr(19 downto 15);
	variable rs2_address : std_logic_vector(4 downto 0) := instr(14 downto 10);
	variable rs1_address : std_logic_vector(4 downto 0) := instr(9 downto 5);
	--variable rd_address : std_logic_vector(4 downto 0) := instr(4 downto 0);

	--cant assign variable to signal directly...
	--cannot create signal inside process...
	--variable rd_queue_var : queue := rd_queue;
	
	begin					 
		if (falling_edge(clk)) then	
			if (instr(24) = '0') then --li instruction
				rs2 <= 	 std_logic_vector(to_unsigned(to_integer(unsigned(instr(20 downto 5))), 128)); --imm 16
				rs1 <=   std_logic_vector(to_unsigned(to_integer(unsigned(instr(23 downto 21))), 128)); --load index
				
				rs3 <=   std_logic_vector(to_unsigned(0, 128));	--nothing
				
			elsif (instr(24) = '1') then
			rs3 <= reg_lookup(to_integer(unsigned(rs3_address)));								  
			rs2 <= reg_lookup(to_integer(unsigned(rs2_address)));
			rs1 <= reg_lookup(to_integer(unsigned(rs1_address)));
			
			
			
			end if;
			
			--add rd(address) into queue to align with this instruction
			--so that when the data comes back, rd and data can be together
			
			
			
		end if;	
	end process Reg_read;
end Register_file_arch;
