-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : Project_Final
-- Author      : Tyguan
-- Company     : Stony Brook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_Final\Project_Final\Project_Final\compile\alu.vhd
-- Generated   : Fri Dec  3 03:16:11 2021
-- From        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_Final\Project_Final\Project_Final\src\alu.bde
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

entity alu is
  port(
       clk : in STD_LOGIC;
       rs1 : in STD_LOGIC_VECTOR(127 downto 0);
       rs2 : in STD_LOGIC_VECTOR(127 downto 0);
       rs3 : in STD_LOGIC_VECTOR(127 downto 0);
       rd_address_in : in STD_LOGIC_VECTOR(4 downto 0);
       opcode : in STD_LOGIC_VECTOR(9 downto 0);
       rd : inout STD_LOGIC_VECTOR(127 downto 0);
       rd_address_out : out STD_LOGIC_VECTOR(4 downto 0);
       write_enable : inout STD_LOGIC;
       rs1_out : out STD_LOGIC_VECTOR(127 downto 0);
       rs2_out : out STD_LOGIC_VECTOR(127 downto 0);
       rs3_out : out STD_LOGIC_VECTOR(127 downto 0);
       rd_address_input_out : out STD_LOGIC_VECTOR(4 downto 0);
       rd_data_out : out STD_LOGIC_VECTOR(127 downto 0);
       write_enable_out : out STD_LOGIC := '0'
  );
end alu;

architecture alu_arch of alu is

begin

---- Processes ----

alu_process : process (rs1,rs2,rs3,opcode,rd_address_in)
                         variable rdbuffer : STD_LOGIC_VECTOR(127 downto 0) := (others => '0');
                         variable OVF : STD_LOGIC := '0';
                         variable intVal : integer := 0;
                         variable intVal2 : integer := 0;
                         variable r16I : signed(15 downto 0) := (others => '0');
                         variable r16II : signed(15 downto 0) := (others => '0');
                         variable r16III : signed(16 downto 0) := (others => '0');
                         variable r32I : signed(31 downto 0) := (others => '0');
                         variable r32II : signed(31 downto 0) := (others => '0');
                         variable r32III : signed(32 downto 0) := (others => '0');
                         variable r64I : signed(63 downto 0) := (others => '0');
                         variable r64II : signed(63 downto 0) := (others => '0');
                         variable r64III : signed(64 downto 0) := (others => '0');
                         variable r128I : signed(128 downto 0) := (others => '0');
                       begin
                         if (((rs1(0) = '0' or rs1(0) = '1') and (rs2(0) = '0' or rs2(0) = '1') and (rs3(0) = '0' or rs3(0) = '1'))) then
                            rd_address_out <= rd_address_in;
                            rdbuffer := (others => '0');
                            if opcode(9) = '0' then
                               intVal := to_integer(unsigned(rs1(2 downto 0)));
                               intVal := intVal * 16;
                               rdbuffer := rs3;
                               rdbuffer((intVal + 15) downto intVal) := rs2(15 downto 0);
                               rd <= rdbuffer;
                               write_enable <= '1';
                            else 
                               if opcode(8) = '1' then
                                  case opcode(3 downto 0) is 
                                    when "0000" => 
                                       write_enable <= '0';
                                    when "0001" => 
                                       for i in 0 to 7 loop
                                           rdbuffer((i * 16 + 15) downto (i * 16)) := std_logic_vector(unsigned(rs1((i * 16 + 15) downto (i * 16))) + unsigned(rs2((i * 16 + 15) downto (i * 16))));
                                       end loop;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when "0010" => 
                                       for i in 0 to 7 loop
                                           intVal := to_integer(signed(rs1((i * 16 + 15) downto (i * 16))));
                                           intVal2 := to_integer(signed(rs2((i * 16 + 15) downto (i * 16))));
                                           intVal := intVal + intVal2;
                                           if (intVal > 32767) then
                                              rdbuffer((i * 16 + 15) downto (i * 16)) := x"7FFF";
                                           elsif (intVal < - 32768) then
                                              rdbuffer((i * 16 + 15) downto (i * 16)) := x"8000";
                                           else 
                                              rdbuffer((i * 16 + 15) downto (i * 16)) := STD_logic_vector(to_signed(intVal,16));
                                           end if;
                                       end loop;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when "0011" => 
                                       for i in 0 to 3 loop
                                           rdbuffer(i * 32 + 31 downto i * 32) := rs1(31 downto 0);
                                       end loop;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when "0100" => 
                                       for i in 0 to 7 loop
                                           intVal := to_integer(unsigned(rs1((i * 16 + 15) downto (i * 16))));
                                           intVal2 := to_integer(unsigned(rs2((i * 16 + 15) downto (i * 16))));
                                           intVal := intVal + intVal2;
                                           if (intVal > 65535) then
                                              rdbuffer((i * 16 + 15) downto (i * 16)) := x"0001";
                                           else 
                                              rdbuffer((i * 16 + 15) downto (i * 16)) := std_logic_vector(to_unsigned(0,16));
                                           end if;
                                       end loop;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when "0101" => 
                                       for i in 0 to 3 loop
                                           intVal := 0;
                                           for j in (i * 32 + 31) downto (i * 32) loop
                                               if (rs1(j) = '1') then
                                                  exit;
                                               end if;
                                               intVal := (intVal + 1);
                                           end loop;
                                           rdbuffer(i * 32 + 31 downto i * 32) := std_logic_vector(to_unsigned(intVal,32));
                                       end loop;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when "0110" => 
                                       for i in 0 to 3 loop
                                           intVal := to_integer(signed(rs1(i * 32 + 31 downto i * 32)));
                                           intVal2 := to_integer(signed(rs2(i * 32 + 31 downto i * 32)));
                                           if (intVal >= intVal2) then
                                              rdbuffer(i * 32 + 31 downto i * 32) := std_logic_vector(to_signed(intVal,32));
                                           else 
                                              rdbuffer(i * 32 + 31 downto i * 32) := std_logic_vector(to_signed(intVal2,32));
                                           end if;
                                       end loop;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when "0111" => 
                                       for i in 0 to 3 loop
                                           intVal := to_integer(signed(rs1(i * 32 + 31 downto i * 32)));
                                           intVal2 := to_integer(signed(rs2(i * 32 + 31 downto i * 32)));
                                           if (intVal <= intVal2) then
                                              rdbuffer(i * 32 + 31 downto i * 32) := std_logic_vector(to_signed(intVal,32));
                                           else 
                                              rdbuffer(i * 32 + 31 downto i * 32) := std_logic_vector(to_signed(intVal2,32));
                                           end if;
                                       end loop;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when "1000" => 
                                       for i in 0 to 3 loop
                                           intVal := to_integer(signed(rs1(i * 32 + 31 downto i * 32)));
                                           intVal2 := to_integer(signed(rs2(i * 32 + 31 downto i * 32)));
                                           if (intVal2 = 0) then
                                              intVal := 0;
                                           elsif (rs2(i * 32 + 31) = '1') then
                                              intVal := intVal * (- 1);
                                           end if;
                                           if (intVal > 2147483647) then
                                              rdbuffer(i * 32 + 31 downto i * 32) := x"7FFFFFFF";
                                           else 
                                              rdbuffer(i * 32 + 31 downto i * 32) := std_logic_vector(to_signed(intVal,32));
                                           end if;
                                       end loop;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when "1001" => 
                                       for i in 0 to 7 loop
                                           intVal := 0;
                                           for j in 15 downto 0 loop
                                               if (rs1(i * 16 + j) = '1') then
                                                  intVal := intVal + 1;
                                               end if;
                                           end loop;
                                           rdbuffer(i * 16 + 15 downto i * 16) := std_logic_vector(to_unsigned(intVal,16));
                                       end loop;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when "1010" => 
                                       intVal := to_integer(unsigned(rs2(6 downto 0)));
                                       if (intVal = 0) then
                                          rdbuffer := rs1;
                                       else 
                                          rdbuffer(127 downto 127 - intVal + 1) := rs1(intVal - 1 downto 0);
                                          rdbuffer(127 - intVal downto 0) := rs1(127 downto intVal);
                                       end if;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when "1011" => 
                                       for i in 0 to 3 loop
                                           intVal := to_integer(unsigned(rs2(i * 32 + 4 downto i * 32)));
                                           if (intVal = 0) then
                                              rdbuffer(i * 32 + 31 downto i * 32) := rs1(i * 32 + 31 downto i * 32);
                                           else 
                                              intVal2 := 32 - intVal;
                                              rdbuffer(i * 32 + 31 downto i * 32 + 31 - intVal + 1) := rs1(i * 32 + intVal - 1 downto i * 32);
                                              rdbuffer(i * 32 + 31 - intVal downto i * 32) := rs1(i * 32 + 31 downto i * 32 + intVal);
                                           end if;
                                       end loop;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when "1100" => 
                                       for i in 0 to 7 loop
                                           intVal := to_integer(unsigned(rs2(i * 16 + 3 downto i * 16)));
                                           if (intVal = 0) then
                                              rdbuffer(i * 16 + 15 downto i * 16) := rs1(i * 16 + 15 downto i * 16);
                                           else 
                                              intVal2 := 16 - intVal;
                                              rdbuffer(i * 16 + 15 downto i * 16 + intVal) := rs1(i * 16 + 15 - intVal downto i * 16);
                                              rdbuffer(i * 16 + intVal - 1 downto i * 16) := std_logic_vector(to_unsigned(0,intVal));
                                           end if;
                                       end loop;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when "1101" => 
                                       for i in 0 to 7 loop
                                           intVal := to_integer(unsigned(rs2(i * 16 + 15 downto i * 16)) - unsigned(rs1(i * 16 + 15 downto i * 16)));
                                           rdbuffer(i * 16 + 15 downto i * 16) := std_logic_vector(to_unsigned((intVal),16));
                                       end loop;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when "1110" => 
                                       for i in 0 to 7 loop
                                           intVal := to_integer(signed(rs1(i * 16 + 15 downto i * 16)));
                                           intVal2 := to_integer(signed(rs2(i * 16 + 15 downto i * 16)));
                                           intVal := intVal2 - intVal;
                                           if (intVal > 32767) then
                                              intVal := 32767;
                                           elsif (intVal < - 32768) then
                                              intVal := - 32768;
                                           end if;
                                           rdbuffer(i * 16 + 15 downto i * 16) := std_logic_vector(to_signed((intVal),16));
                                       end loop;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when "1111" => 
                                       rdbuffer := rs1 xor rs2;
                                       rd <= rdbuffer;
                                       write_enable <= '1';
                                    when others => 
                                       null;
                                  end case;
                               else 
                                  case opcode(7 downto 5) is 
                                    when "000" => 
                                       for i in 0 to 3 loop
                                           r16I := (signed(rs3(i * 32 + 15 downto i * 32)));
                                           r16II := (signed(rs2(i * 32 + 15 downto i * 32)));
                                           r32I := r16I * r16II;
                                           r32II := (signed(rs1(i * 32 + 31 downto i * 32)));
                                           r32III(31 downto 0) := r32I + r32II;
                                           if (r32III(31) = '0') then
                                              r32III(32) := '0';
                                           elsif (r32III(31) = '1') then
                                              r32III(32) := '1';
                                           end if;
                                           if (r32III(32) = '1' and (r32II(31) = '0' and r32I(31) = '0')) then
                                              r32III := '0' & x"7FFFFFFF";
                                           elsif (r32III(32) = '0' and r32II(31) = '1' and r32I(31) = '1') then
                                              r32III := '1' & x"80000000";
                                           end if;
                                           rdbuffer(i * 32 + 31 downto i * 32) := std_logic_vector(r32III(31 downto 0));
                                       end loop;
                                       rd <= rdbuffer;
                                    when "001" => 
                                       for i in 0 to 3 loop
                                           r16I := (signed(rs3(i * 32 + 31 downto i * 32 + 16)));
                                           r16II := (signed(rs2(i * 32 + 31 downto i * 32 + 16)));
                                           r32I := r16I * r16II;
                                           r32II := (signed(rs1(i * 32 + 31 downto i * 32)));
                                           r32III(31 downto 0) := r32I + r32II;
                                           if (r32III(31) = '0') then
                                              r32III(32) := '0';
                                           elsif (r32III(31) = '1') then
                                              r32III(32) := '1';
                                           end if;
                                           if (r32III(32) = '1' and (r32II(31) = '0' and r32I(31) = '0')) then
                                              r32III := '0' & x"7FFFFFFF";
                                           elsif (r32III(32) = '0' and (r32II(31) = '1' and r32I(31) = '1')) then
                                              r32III := '1' & x"80000000";
                                           end if;
                                           rdbuffer(i * 32 + 31 downto i * 32) := std_logic_vector(r32III(31 downto 0));
                                       end loop;
                                       rd <= rdbuffer;
                                    when "010" => 
                                       for i in 0 to 3 loop
                                           r16I := (signed(rs3(i * 32 + 15 downto i * 32)));
                                           r16II := (signed(rs2(i * 32 + 15 downto i * 32)));
                                           r32I := r16I * r16II;
                                           r32II := (signed(rs1(i * 32 + 31 downto i * 32)));
                                           r32III(31 downto 0) := r32II - r32I;
                                           if (r32III(31) = '0') then
                                              r32III(32) := '0';
                                           elsif (r32III(31) = '1') then
                                              r32III(32) := '1';
                                           end if;
                                           if (r32III(32) = '1' and (r32II(31) = '0' and r32I(31) = '1')) then
                                              r32III := '0' & x"7FFFFFFF";
                                           elsif (r32III(32) = '0' and (r32II(31) = '1' and r32I(31) = '0')) then
                                              r32III := '1' & x"80000000";
                                           end if;
                                           rdbuffer(i * 32 + 31 downto i * 32) := std_logic_vector(r32III(31 downto 0));
                                       end loop;
                                       rd <= rdbuffer;
                                    when "011" => 
                                       for i in 0 to 3 loop
                                           r16I := (signed(rs3(i * 32 + 31 downto i * 32 + 16)));
                                           r16II := (signed(rs2(i * 32 + 31 downto i * 32 + 16)));
                                           r32I := r16I * r16II;
                                           r32II := (signed(rs1(i * 32 + 31 downto i * 32)));
                                           r32III(31 downto 0) := r32II - r32I;
                                           if (r32III(31) = '0') then
                                              r32III(32) := '0';
                                           elsif (r32III(31) = '1') then
                                              r32III(32) := '1';
                                           end if;
                                           if (r32III(32) = '1' and (r32II(31) = '0' and r32I(31) = '1')) then
                                              r32III := '0' & x"7FFFFFFF";
                                           elsif (r32III(32) = '0' and (r32II(31) = '1' and r32I(31) = '0')) then
                                              r32III := '1' & x"80000000";
                                           end if;
                                           rdbuffer(i * 32 + 31 downto i * 32) := std_logic_vector(r32III(31 downto 0));
                                       end loop;
                                       rd <= rdbuffer;
                                    when "100" => 
                                       for i in 0 to 1 loop
                                           r32I := (signed(rs3(i * 64 + 31 downto i * 64)));
                                           r32II := (signed(rs2(i * 64 + 31 downto i * 64)));
                                           r64I := r32I * r32II;
                                           r64II := (signed(rs1(i * 64 + 63 downto i * 64)));
                                           r64III(63 downto 0) := r64II + r64I;
                                           if (r64III(63) = '0') then
                                              r64III(64) := '0';
                                           elsif (r64III(63) = '1') then
                                              r64III(64) := '1';
                                           end if;
                                           if (r64III(64) = '1' and (r64II(63) = '0' and r64I(63) = '0')) then
                                              r64III := '0' & x"7FFFFFFFFFFFFFFF";
                                           elsif (r64III(64) = '0' and (r64II(63) = '1' and r64I(63) = '1')) then
                                              r64III := '1' & x"8000000000000000";
                                           end if;
                                           rdbuffer(i * 64 + 63 downto i * 64) := std_logic_vector(r64III(63 downto 0));
                                       end loop;
                                       rd <= rdbuffer;
                                    when "101" => 
                                       for i in 0 to 1 loop
                                           r32I := (signed(rs3(i * 64 + 63 downto i * 64 + 32)));
                                           r32II := (signed(rs2(i * 64 + 63 downto i * 64 + 32)));
                                           r64I := r32I * r32II;
                                           r64II := (signed(rs1(i * 64 + 63 downto i * 64)));
                                           r64III(63 downto 0) := r64II + r64I;
                                           if (r64III(63) = '0') then
                                              r64III(64) := '0';
                                           elsif (r64III(63) = '1') then
                                              r64III(64) := '1';
                                           end if;
                                           if (r64III(64) = '1' and (r64II(63) = '0' and r64I(63) = '0')) then
                                              r64III := '0' & x"7FFFFFFFFFFFFFFF";
                                           elsif (r64III(64) = '0' and (r64II(63) = '1' and r64I(63) = '1')) then
                                              r64III := '1' & x"8000000000000000";
                                           end if;
                                           rdbuffer(i * 64 + 63 downto i * 64) := std_logic_vector(r64III(63 downto 0));
                                       end loop;
                                       rd <= rdbuffer;
                                    when "110" => 
                                       for i in 0 to 1 loop
                                           r32I := (signed(rs3(i * 64 + 31 downto i * 64)));
                                           r32II := (signed(rs2(i * 64 + 31 downto i * 64)));
                                           r64I := r32I * r32II;
                                           r64II := (signed(rs1(i * 64 + 63 downto i * 64)));
                                           r64III(63 downto 0) := r64II - r64I;
                                           if (r64III(63) = '0') then
                                              r64III(64) := '0';
                                           elsif (r64III(63) = '1') then
                                              r64III(64) := '1';
                                           end if;
                                           if (r64III(64) = '1' and (r64II(63) = '0' and r64I(63) = '1')) then
                                              r64III := '0' & x"7FFFFFFFFFFFFFFF";
                                           elsif (r64III(64) = '0' and (r64II(63) = '1' and r64I(63) = '0')) then
                                              r64III := '1' & x"8000000000000000";
                                           end if;
                                           rdbuffer(i * 64 + 63 downto i * 64) := std_logic_vector(r64III(63 downto 0));
                                       end loop;
                                       rd <= rdbuffer;
                                    when "111" => 
                                       for i in 0 to 1 loop
                                           r32I := (signed(rs3(i * 64 + 63 downto i * 64 + 32)));
                                           r32II := (signed(rs2(i * 64 + 63 downto i * 64 + 32)));
                                           r64I := r32I * r32II;
                                           r64II := (signed(rs1(i * 64 + 63 downto i * 64)));
                                           r64III(63 downto 0) := r64II - r64I;
                                           if (r64III(63) = '0') then
                                              r64III(64) := '0';
                                           elsif (r64III(63) = '1') then
                                              r64III(64) := '1';
                                           end if;
                                           if (r64III(64) = '1' and (r64II(63) = '0' and r64I(63) = '1')) then
                                              r64III := '0' & x"7FFFFFFFFFFFFFFF";
                                           elsif (r64III(64) = '0' and (r64II(63) = '1' and r64I(63) = '0')) then
                                              r64III := '1' & x"8000000000000000";
                                           end if;
                                           rdbuffer(i * 64 + 63 downto i * 64) := std_logic_vector(r64III(63 downto 0));
                                       end loop;
                                       rd <= rdbuffer;
                                    when others => 
                                       null;
                                  end case;
                                  write_enable <= '1';
                               end if;
                            end if;
                         end if;
                       end process;
                      

---- User Signal Assignments ----
rs1_out <= rs1;
rs2_out <= rs2;
rs3_out <= rs3;
rd_address_input_out <= rd_address_in;
rd_data_out <= rd;

----  Component instantiations  ----

write_enable_out <= write_enable;


end alu_arch;
