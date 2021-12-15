--ESE 345 Tylon Guan and Joseph Zappala

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instr_buffer is
	generic(
	
	INSTR_INDEX  : integer := 6; --2^6 = 64 instructions
	INSTR_WIDTH  : integer := 25 -- of 25 bit wide 
	
	);
	
	port(
	 
	---PC : in STD_LOGIC_VECTOR(5 downto 0); --include within (no j/branch instr)
	load_instr_row : in STD_LOGIC_VECTOR(INSTR_WIDTH-1 downto 0);
	clk : in STD_LOGIC;
	load_clock : in STD_LOGIC;
	instr : inout STD_LOGIC_VECTOR(24 downto 0);
	
	--Results file
	PC_out : out STD_LOGIC_VECTOR(5 downto 0);
	instr_out : out STD_LOGIC_VECTOR(24 downto 0)

	     );
end Instr_buffer;

--}} End of automatically maintained section

architecture Instr_buffer_arch of Instr_buffer is
signal PC : UNSIGNED(5 downto 0) := "000000"; --initalize with value of 0

constant MEMORY_DEPTH : integer := 2**INSTR_INDEX;
type instr_memeory is array (MEMORY_DEPTH-1 downto 0) of std_logic_vector(INSTR_WIDTH-1 downto 0);
signal instr_lookup : instr_memeory := (others => ("1100000000000000000000000"));
constant all_U : std_logic_vector (24 downto 0) := (others => 'U');
--signal counter : integer := 0; --just to load in the instructions.

begin 

instr_out <= instr;

load_table : process(load_clock)
variable count : integer := 0;
	begin
		if (count < 64 and (load_instr_row(0) = '0' or load_instr_row(0) = '1')) then
			instr_lookup(count) <= load_instr_row;
			count := count + 1; --value should only be between (0 to 63);
		end if;
		
		
	end process load_table; --hard coded to load 64 rows of instructions only
	
	fetch_instr : process (clk)
	variable prog_counter : integer := to_integer(unsigned(PC));
	begin
		if (rising_edge(clk)) then
		PC_out <= std_logic_vector(to_unsigned(prog_counter, 6));
		instr <= instr_lookup(prog_counter);
		--instr_out <= instr_lookup(to_integer(unsigned(PC)));
		if (prog_counter < 63) then
			prog_counter := prog_counter+1;
		end if;
		
		
			  		
		PC <= to_unsigned((prog_counter), 6);				
		
		--result file
		
		--PC_out <= std_logic_vector(to_unsigned((prog_counter), 6));
	
		end if;
	end process fetch_instr;
	 
	
	
end Instr_buffer_arch;
