-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : Project_Final
-- Author      : Tyguan
-- Company     : Stony Brook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_Final\Project_Final\Project_Final\compile\Instr_buffer.vhd
-- Generated   : Fri Dec  3 03:16:19 2021
-- From        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_Final\Project_Final\Project_Final\src\Instr_buffer.bde
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

entity Instr_buffer is
  generic(
       INSTR_INDEX : integer := 6;
       INSTR_WIDTH : integer := 25
  );
  port(
       load_instr_row : in STD_LOGIC_VECTOR(INSTR_WIDTH - 1 downto 0);
       clk : in STD_LOGIC;
       load_clock : in STD_LOGIC;
       instr : inout STD_LOGIC_VECTOR(24 downto 0);
       PC_out : out STD_LOGIC_VECTOR(5 downto 0);
       instr_out : out STD_LOGIC_VECTOR(24 downto 0)
  );
end Instr_buffer;

architecture Instr_buffer_arch of Instr_buffer is

---- Architecture declarations -----
constant MEMORY_DEPTH : integer := 2 ** INSTR_INDEX;
constant all_U : std_logic_vector(24 downto 0) := (others => 'U');
--Added by Active-HDL. Do not change code inside this section.
type instr_memeory is array (MEMORY_DEPTH - 1 downto 0) of STD_LOGIC_VECTOR(INSTR_WIDTH - 1 downto 0);
--End of extra code.


---- Signal declarations used on the diagram ----

signal instr_lookup : instr_memeory := (others => ("1100000000000000000000000"));
signal PC : UNSIGNED(5 downto 0) := "000000";

begin

---- Processes ----

fetch_instr : process (clk)
                         variable prog_counter : integer := to_integer(unsigned(PC));
                       begin
                         if (rising_edge(clk)) then
                            PC_out <= std_logic_vector(to_unsigned(prog_counter,6));
                            instr <= instr_lookup(prog_counter);
                            if (prog_counter < 63) then
                               prog_counter := prog_counter + 1;
                            end if;
                            PC <= to_unsigned((prog_counter),6);
                         end if;
                       end process;
                      

load_table : process (load_clock)
                         variable count : integer := 0;
                       begin
                         if (count < 64 and (load_instr_row(0) = '0' or load_instr_row(0) = '1')) then
                            instr_lookup(count) <= load_instr_row;
                            count := count + 1;
                         end if;
                       end process;
                      

---- User Signal Assignments ----
instr_out <= instr;

end Instr_buffer_arch;
