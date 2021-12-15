-- ALU Main
-- Tylon Guan ID: 112759081
-- Joseph Zappala ID: 112771339
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is 
	port(
    	rs1 : in STD_LOGIC_VECTOR(127 downto 0);
        rs2 : in STD_LOGIC_VECTOR(127 downto 0);
        rs3 : in STD_LOGIC_VECTOR(127 downto 0); 
		--instruction : in STD_LOGIC_VECTOR(24 downto 0);
        opcode : in STD_LOGIC_VECTOR(9 downto 0);  --[24:15] of instruction
        
        rd : out STD_LOGIC_VECTOR(127 downto 0)	   -- to the WB/OUTPUT stage
    );
end alu;

architecture alu_arch of alu is 

	begin
    
    alu_process: process (rs1, rs2, rs3, opcode)
		--variable rs2buffer : STD_LOGIC_VECTOR(127 downto 0);
    	variable rdbuffer : STD_LOGIC_VECTOR(127 downto 0);--rdbuff
        variable OVF : STD_LOGIC := '0'; 
		--variable unsignedValue : unsigned(16 downto 0) := "0";
		--variable signedValue : signed := -247; 
		variable intVal : integer := 0;
		variable intVal2 : integer := 0;
		
		variable r16I : signed (15 downto 0) := (others => '0');
		variable r16II : signed (15 downto 0) := (others => '0');
		variable r16III : signed (16 downto 0) := (others => '0'); --extra bit for addition
		
		variable r32I : signed (31 downto 0) := (others => '0');  --can be used for 16x16
		variable r32II : signed (31 downto 0) := (others => '0');
		variable r32III : signed (32 downto 0) := (others => '0'); --extra bit for addition
			
		variable r64I : signed (63 downto 0) := (others => '0');  --can be used for 32x32
		variable r64II : signed (63 downto 0) := (others => '0');
		variable r64III : signed (64 downto 0) := (others => '0'); --extra bit for addition
		
		variable r128I : signed (128 downto 0) := (others => '0'); -- for 64x64
		
		
		begin
		
		if opcode(9) = '0' then
			-- li - load immideiete
			-- Load a 16-bit Immediate value from the [20:5] instruction field into the 16-bit field specified by
				--the li field [23:21] of the 128-bit register rd.
			-- ex: li [23:21] = "000" that means its the 16 bits from index 0 of rd[15:0] of its 128 bits
			-- ex: li [23:21] = "111" that means its the 16 bits of index 7 of rd[127:114] of its 128 bits	
			
			--ASSUMPTION: We will have the correct rd selected already and put into out output (for all instructions too)
			
--			intVal := to_integer(unsigned(instruction(23 downto 21))); -- Load index
--			intVal := intVal * 16; --index 0, 16, 32 ... 112
--			
--			rdbuffer((intVal+15) downto intVal) := instruction(20 downto 5); -- Load immediate (no need to convert to integer)
--			
--			rd <= rdbuffer;	
			
			--V2: load index is in rs1, imm is in rs2, and correctly choosen rd
			intVal := to_integer(unsigned(rs1(2 downto 0))); -- Load index
			intVal := intVal * 16; --index 0, 16, 32 ... 112
			
			rdbuffer((intVal+15) downto intVal) := rs2(15 downto 0); -- Load immediate (no need to convert to integer)
			
			rd <= rdbuffer;	
			
  		else
        	if opcode(8) = '1' then -- R3-Instruction Format 
				
            	case opcode(3 downto 0) is 	
                  when "0000" => --NOP
                  	null;
                  
                  when "0001" => --AH add halfword --overflow will just roll over.
                  	--add two respective 16bits and store into respective 16bits of rd
                    --rdbuffer(127 downto 112 ) := rs1(127 downto 112 ) + rs2(127 downto 112 );
                  	--for loop every 8 from 127 to 0 and if we encounter overflow
                  	for i in 0 to 7 loop
                    	 rdbuffer((i*16+15) downto (i*16)) := std_logic_vector(
							unsigned(rs1((i*16+15) downto (i*16))) + unsigned(rs2((i*16+15) downto (i*16)))
						);		
						--
       					--if ( (rs1(i*16+15) = '1' and rs2(i*16+15) = '1') or 
--                        	 (rdbuffer(i*16+15) = '0' and rs2(i*16+15) = '1') or
--                             (rdbuffer(i*16+15) = '0' and rs1(i*16+15) = '1') ) then overflow
--                             OVF := '1';  I dont see much of a purpose for this now since we are editing it immediately
--						end if;
                    end loop;	  
					rd <= rdbuffer;
                  
                  when "0010" => --AHS: add halfword saturated (where we would cap off at the saturated value)(signed)
				  	for i in 0 to 7 loop --need to fix for signed... have a if for underflow, and another for overflow so that we can directly assign saturated value
                    	 intVal := to_integer(signed(rs1((i*16+15) downto (i*16))));
						 intVal2 := to_integer(signed(rs2((i*16+15) downto(i*16))));
						 
						 intVal := intVal+intVal2;
						--rdbuffer((i*16+15) downto (i*16))
						if (intVal > 32767) then
							rdbuffer((i*16+15) downto (i*16)) := x"7FFF";
						elsif (intVal < -32768) then 
							rdbuffer((i*16+15) downto (i*16)) := x"8000";
						else
							rdbuffer((i*16+15) downto (i*16)) := STD_logic_vector(to_signed(intVal, 16));
						end if;
                    end loop;
                  	rd <= rdbuffer;
					  
                  when "0011" => --BCW: broadcast word
				  	for i in 0 to 3 loop --output rs1 32 bits (4 of them)
						rdbuffer(i*32+31 downto i*32) := rs1(31 downto 0);
					end loop;
					rd <= rdbuffer;
					  
                  when "0100" => --CGH: carry generate halfword
                  	for i in 0 to 7 loop --if overflow then set rd16bit 0000...001
						intVal := to_integer(unsigned(rs1((i*16+15) downto (i*16))));
						intVal2 := to_integer(unsigned(rs2((i*16+15) downto(i*16))));
						 
						intVal := intVal+intVal2;
						
						if (intVal > 65535) then
							rdbuffer((i*16+15) downto (i*16)) := x"0001";
						else
							rdbuffer((i*16+15) downto (i*16)) := std_logic_vector(to_unsigned(0, 16));
						end if;
					end loop;
					rd <= rdbuffer;		   
					
                  when "0101" => --CLZ: count leading zeros in words
				  	for i in 0 to 3 loop --output rs1 32 bits (4 of them)
					  intVal := 0;
					  for j in (i*32+31) downto (i*32) loop
							if (rs1(j) = '1') then exit;
							end if;
							intVal := (intVal + 1);
						end loop;
					  rdbuffer(i*32+31 downto i*32) := std_logic_vector(to_unsigned(intVal, 32));
					end loop;
					
					rd <= rdbuffer;
					
                  when "0110" => --MAX: max signed word
                  	for i in 0 to 3 loop --output rs1 32 bits (4 of them)
					  intVal := to_integer(signed(rs1(i*32+31 downto i*32)));
					  intVal2 := to_integer(signed(rs2(i*32+31 downto i*32)));
					  if (intVal >= intVal2) then 
						  rdbuffer(i*32+31 downto i*32) := std_logic_vector(to_signed(intVal, 32));
					  else
						  rdbuffer(i*32+31 downto i*32) := std_logic_vector(to_signed(intVal2, 32));
					  end if;
					end loop;
					rd <= rdbuffer; 
					
                  when "0111" => --MIN: min signed word
				  	for i in 0 to 3 loop --output rs1 32 bits (4 of them)
					  intVal := to_integer(signed(rs1(i*32+31 downto i*32)));
					  intVal2 := to_integer(signed(rs2(i*32+31 downto i*32)));
					  if (intVal <= intVal2) then 
						  rdbuffer(i*32+31 downto i*32) := std_logic_vector(to_signed(intVal, 32));
					  else
						  rdbuffer(i*32+31 downto i*32) := std_logic_vector(to_signed(intVal2, 32));
					  end if;
					end loop;
					rd <= rdbuffer;
					
                  when "1000" => --MSGN: multiply sign
				  	for i in 0 to 3 loop
						intVal := to_integer(signed(rs1(i*32+31 downto i*32)));
						intVal2 := to_integer(signed(rs2(i*32+31 downto i*32)));
						
						if (intVal2 = 0) then intVal := 0;
						elsif (rs2(i*32+31) = '1') then intVal := intVal*(-1);
						end if;
						if (intVal > 2147483647) then 
							rdbuffer(i*32+31 downto i*32) := x"7FFFFFFF";
						else
							rdbuffer(i*32+31 downto i*32) := std_logic_vector(to_signed(intVal, 32));
						end if;
					end loop;
					rd <= rdbuffer;	 
					
                  when "1001" => --POPCNTH: count ones in halfwords
					
				  for i in 0 to 7 loop --if overflow then set rd16bit 0000...001
					  intVal := 0;
						for j in (15) downto (0) loop 
							if (rs1(i*16+j) = '1') then intVal := intVal+1;
								end if;
						end loop;
						rdbuffer(i*16+15 downto i*16) := std_logic_vector(to_unsigned(intVal,16));
					end loop;
					rd <= rdbuffer;	
					
                  when "1010" => --ROT: rotate bits right
				  --Rotate amount is LSB 6 to 0 of rs2. rotate from right into left for rs1
					  intVal := to_integer(unsigned(rs2(6 downto 0))); --the amount of right that is shifted out
					  
					  
					  if (intVal = 0) then 
							rdbuffer := rs1;
						else
					  
					  --intVal2 := 128-intVal; --the amount left in rs1 that is not shifted out. (not used)
					  
					  --rdbuffer(127 downto 127-8+1) := rs1(8-1 downto 0);--Note: shifting bits is index 0
					  --rdbuffer(127-8 downto 0) := rs1(127 downto 8);
					  rdbuffer(127 downto 127-intVal+1) := rs1(intVal-1 downto 0);--Note: shifting bits is index 0
					  rdbuffer(127-intVal downto 0) := rs1(127 downto intVal);
					  
					  --report "intVal: " & integer'image(intVal);
					  --report "SHIFTED: " & integer'image(to_integer(signed(rs1(intVal-1 downto 0))));
					  --report "NONsHIFTED: " & integer'image(to_integer(signed(rs1(127 downto intVal))));
					  
					  
					  end if;

						rd <= rdbuffer;

                  when "1011" => --ROTW: rotate bits in word
				  --same as before but to each 32bits (4 in total)
				  	for i in 0 to 3 loop
						intVal := to_integer(unsigned(rs2(i*32+4 downto i*32)));
						
						if (intVal = 0) then 
							rdbuffer(i*32+31 downto i*32) := rs1(i*32+31 downto i*32);
						else
						
						intVal2 := 32-intVal; --(not used)
						--edge case is shifting 31 (all except msb)
						rdbuffer(i*32+31 downto i*32+31-intVal+1) := rs1(i*32+intVal-1 downto i*32);
						rdbuffer(i*32+31-intVal downto i*32) := rs1(i*32+31 downto i*32+intVal);
						end if;
						
					end loop;
					rd <= rdbuffer;
                  	
                  when "1100" => --SHLHI: shift left halfword immediate
				  --rs2 is immediate 5, located in the same position in the instruction register(yet to be created).
				  
                  	for i in 0 to 7 loop --if overflow then set rd16bit 0000...001
						intVal := to_integer(unsigned(rs2(i*16+3 downto i*16)));
						
						if (intVal = 0) then 
							rdbuffer(i*16+15 downto i*16) := rs1(i*16+15 downto i*16);
						else
						
						intVal2 := 16-intVal; --notused
						
						rdbuffer(i*16+15 downto i*16+intVal) := rs1(i*16+15-intVal downto i*16);
						rdbuffer(i*16+intVal-1 downto i*16) := std_logic_vector(to_unsigned(0, intVal));
						--rdbuffer(i*16+15 downto i*16+15-intVal+1) := rs1(i*16+intVal-1 downto i*16);
						--rdbuffer(i*16+15-intVal downto i*16) := rs1(i*16+15 downto i*16+intVal);
						end if;
						
						
					end loop;
					rd <= rdbuffer;
                  
				  when "1101" => --SFH: subtract from halfword (rd = rs2 - rs1)
				  	for i in 0 to 7 loop --if overflow then set rd16bit 0000...001
						intVal := to_integer(
							unsigned(rs2(i*16+15 downto i*16)) - unsigned(rs1(i*16+15 downto i*16))
						);    --maybe auto rollover?
--						intVal := to_integer(unsigned(rs1(i*16+15 downto i*16)));
--						intVal2 := to_integer(unsigned(rs2(i*16+15 downto i*16)));
						
--						intVal := intVal2 - intVal;
--						
--						if (intVal > 32767) then intVal := intVal - 32767; --rollover
--							elsif (intVal < -32768) then intVal := intVal + 32767;
						
						rdbuffer(i*16+15 downto i*16) := std_logic_vector(to_unsigned((intVal),16));
					end loop;
					rd <= rdbuffer;

                  when "1110" => --SFHS: subtract from halfword saturated (rd = rs2 - rs1)
				  	for i in 0 to 7 loop --if overflow then set rd16bit to max negative or postive
						intVal := to_integer(signed(rs1(i*16+15 downto i*16)));
						intVal2 := to_integer(signed(rs2(i*16+15 downto i*16)));
						
						intVal := intVal2 - intVal;
						
						if (intVal > 32767) then intVal := 32767;
						elsif (intVal < -32768) then intVal := -32768; --else is nonOverFlows
						end if;
						
						rdbuffer(i*16+15 downto i*16) := std_logic_vector(to_signed((intVal),16));
					end loop;
					rd <= rdbuffer;
				  	
                  		
                  when "1111" => --XOR: bitwise logical exclusive-or
				  	rdbuffer := rs1 xor rs2; --hmm maybe.
				  	rd <= rdbuffer;	 
					  
                  when others => null;
                  end case;
                  
                  --if (OVF = '1') then 
--                  	OVF := '0'; --do something about it overflowing
--                  end if;	
-- ------------------------------------------------------------------------------------------------------------------- 
            else -- Multiply-Add and Multiply-Subtract R4-Instruction Format
            	case opcode(7 downto 5) is 
                  when "000" => --Signed Integer Multiply-Add Low with Saturation	 
				  
				  --for each 32 pair, take the lower 16 and multiply (rs3,rs2). 
				  --Then add product & rs1 32 and store in rd
				  	for i in 0 to 3 loop
						r16I := (signed(rs3(i*32+15 downto i*32))); --rs3 lower 16
						r16II := (signed(rs2(i*32+15 downto i*32))); --rs2 lower 16
						
						r32I := r16I * r16II; --multiply lower 16 = 32 produc
						
						--added product32 with rs1 32field
						r32II := (signed(rs1( i*32+31 downto i*32)));
						r32III(31 downto 0) := r32I + r32II;
						
						--report "PRINTING! ->>>   " & integer'image(to_integer(r32III(32 downto 32)));
						
						if (r32III(31) = '0') then r32III(32) := '0'; --sign extend
						elsif (r32III(31) = '1') then r32III(32) := '1';
						end if;						   
						
--						report "PRINTING ->>>   " & integer'image(to_integer(r16I));
--						report "PRINTING2 ->>>   " & integer'image(to_integer(r16II));
--						report "PRINTING3 ->>>   " & integer'image(to_integer(r32I));
--						report "PRINTING4 ->>>   " & integer'image(to_integer(r32II));
--						report "PRINTING5 ->>>   " & integer'image(to_integer(r32III(31 downto 0)));
--						report "PRINTING6 ->>>   " & integer'image(to_integer(r32III));
						--report "PRINTING! ->>>   " & integer'image(to_integer(r32III(32 downto 32)));
						
						--check saturation
						if (r32III(32) = '1' and (r32II(31) = '0' and r32I(31) = '0'))
							then r32III := '0' & x"7FFFFFFF"; --overflow
						elsif (r32III(32) = '0' and r32II(31) = '1' and r32I(31) = '1') 
							then r32III := '1' & x"80000000"; --underflow  
						else
						end if;
--						report "PRINTING6 ->>>   " & integer'image(to_integer(r32I(31 downto 31)));
--						report "PRINTING6 ->>>   " & integer'image(to_integer(r32II(31 downto 31))); 
						
						
						rdbuffer(i*32+31 downto i*32) := std_logic_vector(r32III(31 downto 0)); 
						
					end loop; 
					rd <= rdbuffer; 
					
                  when "001" => --Signed Integer Multiply-Add High with Saturation:
				  
				  --for each 32 pair, take the lower 16 and multiply (rs3,rs2). 
				  --Then add product & rs1 32 and store in rd
				  	for i in 0 to 3 loop
						r16I := (signed(rs3(i*32+31 downto i*32+16))); --rs3 high 16
						r16II := (signed(rs2(i*32+31 downto i*32+16))); --rs2 high 16
						
						r32I := r16I * r16II; --multiply lower 16 = 32 produc
						
						--added product32 with rs1 32field
						r32II := (signed(rs1( i*32+31 downto i*32)));
						r32III(31 downto 0) := r32I + r32II;
						
						if (r32III(31) = '0') then r32III(32) := '0'; --sign extend
						elsif (r32III(31) = '1') then r32III(32) := '1';
						end if;
						
						
						--check saturation
						if (r32III(32) = '1' and (r32II(31) = '0' and r32I(31) = '0'))
							then r32III := '0' & x"7FFFFFFF"; --overflow
						elsif (r32III(32) = '0' and (r32II(31) = '1' and r32I(31) = '1')) 
							then r32III := '1' & x"80000000"; --underflow 
						end if;

						rdbuffer(i*32+31 downto i*32) := std_logic_vector(r32III(31 downto 0)); 
						
					end loop; 
					rd <= rdbuffer;
				  
                  when "010" => --Signed Integer Multiply-Subtract Low with Saturation
				  
				  	--for each 32 pair, take the lower 16 and multiply (rs3,rs2). 
				  --Then sub product & rs1 32 and store in rd
				  	for i in 0 to 3 loop
						r16I := (signed(rs3(i*32+15 downto i*32))); --rs3 lower 16
						r16II := (signed(rs2(i*32+15 downto i*32))); --rs2 lower 16
						
						r32I := r16I * r16II; --multiply lower 16 = 32 produc
						
						--added product32 with rs1 32field
						r32II := (signed(rs1( i*32+31 downto i*32)));
						r32III(31 downto 0) := r32II - r32I;
						
						if (r32III(31) = '0') then r32III(32) := '0'; --sign extend
						elsif (r32III(31) = '1') then r32III(32) := '1';
						end if;
						
						
						--check saturation
						if (r32III(32) = '1' and (r32II(31) = '0' and r32I(31) = '1'))
							then r32III := '0' & x"7FFFFFFF"; --overflow
						elsif (r32III(32) = '0' and (r32II(31) = '1' and r32I(31) = '0')) 
							then r32III := '1' & x"80000000"; --underflow 
						end if;

						rdbuffer(i*32+31 downto i*32) := std_logic_vector(r32III(31 downto 0)); 
						
					end loop; 
					rd <= rdbuffer;
				  
                  when "011" => --Signed Integer Multiply-Subtract High with Saturation
				  
				  --for each 32 pair, take the high 16 and multiply (rs3,rs2). 
				  --Then sub product & rs1 32 and store in rd
				  	for i in 0 to 3 loop
						r16I := (signed(rs3(i*32+31 downto i*32+16))); --rs3 high 16
						r16II := (signed(rs2(i*32+31 downto i*32+16))); --rs2 high 16
						
						r32I := r16I * r16II; --multiply high 16 = 32 produc
						
						--subtract product32 with rs1 32field
						r32II := (signed(rs1( i*32+31 downto i*32)));
						r32III(31 downto 0) := r32II - r32I;
						
						if (r32III(31) = '0') then r32III(32) := '0'; --sign extend
						elsif (r32III(31) = '1') then r32III(32) := '1';
						end if;
						
						
						--check saturation
						if (r32III(32) = '1' and (r32II(31) = '0' and r32I(31) = '1'))
							then r32III := '0' & x"7FFFFFFF"; --overflow
						elsif (r32III(32) = '0' and (r32II(31) = '1' and r32I(31) = '0')) 
							then r32III := '1' & x"80000000"; --underflow 
						end if;

						rdbuffer(i*32+31 downto i*32) := std_logic_vector(r32III(31 downto 0)); 
						
					end loop; 
					rd <= rdbuffer;
				  
                  when "100" => --Signed Long Integer Multiply-Add Low with Saturation
				  
				  --for each 64 pair, take the lower 32 and multiply (rs3,rs2). 
				  --Then add product & rs1 32 and store in rd
				  	for i in 0 to 1 loop
						r32I := (signed(rs3(i*64+31 downto i*64))); --rs3 lower 32
						r32II := (signed(rs2(i*64+31 downto i*64))); --rs2 lower 32
						
						r64I := r32I * r32II; --multiply lower 32	= 64 product	   r32II
																			  --CANNOT PRINT 64 BIT VALUES
						 
						--report "r32I :" & integer'image(to_integer(r32I));
						--report "r32II :" & integer'image(to_integer(r32II));
						--report "r64I.1 :" & integer'image(to_integer(r64I(31 downto 0)));
						--report "r64I.2 :" & integer'image(to_integer(r64I(63 downto 32)));
																			  
						--added product64 with rs1 32field
						r64II := (signed(rs1( i*64+63 downto i*64)));
						r64III(63 downto 0) := r64II + r64I;
						
						
						
						if (r64III(63) = '0') then r64III(64) := '0'; --sign extend
						elsif (r64III(63) = '1') then r64III(64) := '1';
						end if;	   
						

		
						
						--check saturation
						if (r64III(64) = '1' and (r64II(63) = '0' and r64I(63) = '0'))
							then r64III := '0' & x"7FFFFFFFFFFFFFFF" ; --overflow
						elsif (r64III(64) = '0' and (r64II(63) = '1' and r64I(63) = '1')) 
							then r64III := '1' & x"8000000000000000"; --underflow 
						end if;	 
						
						--report "r64III.1 :" & integer'image(to_integer(r64III(31 downto 0)));
						--report "r64III.2 :" & integer'image(to_integer(r64III(63 downto 32)));
						--report "r64III.3 :" & integer'image(to_integer(r64III(64 downto 64)));

						rdbuffer(i*64+63 downto i*64) := std_logic_vector(r64III(63 downto 0)); 
						
					end loop; 
					rd <= rdbuffer;
				  
                  when "101" => --Signed Long Integer Multiply-Add High with Saturation
                  
				  --for each 64 pair, take the higher 32 and multiply (rs3,rs2). 
				  --Then add product & rs1 32 and store in rd
				  	for i in 0 to 1 loop
						r32I := (signed(rs3(i*64+63 downto i*64+32))); --rs3 higher 32
						r32II := (signed(rs2(i*64+63 downto i*64+32))); --rs2 higher 32
						
						r64I := r32I * r32II; --multiply higher 32	= 64 product	  
						
						
						--report "r64III :" & integer'image(to_integer(r64III));
						
						--added product64 with rs1 64field
						r64II := (signed(rs1( i*64+63 downto i*64)));
						r64III(63 downto 0) := r64II + r64I; 
						
						if (r64III(63) = '0') then r64III(64) := '0'; --sign extend
						elsif (r64III(63) = '1') then r64III(64) := '1';
						end if;
						
						
						--check saturation
						if (r64III(64) = '1' and (r64II(63) = '0' and r64I(63) = '0'))
							then r64III := '0' & x"7FFFFFFFFFFFFFFF" ; --overflow
						elsif (r64III(64) = '0' and (r64II(63) = '1' and r64I(63) = '1')) 
							then r64III := '1' & x"8000000000000000"; --underflow 
						end if;	  
						
						
					    

						rdbuffer(i*64+63 downto i*64) := std_logic_vector(r64III(63 downto 0)); 
						
					end loop; 
					rd <= rdbuffer;
				  
                  when "110" => --Signed Long Integer Multiply-Subtract Low with Saturation
				  
				  --for each 64 pair, take the lower 32 and multiply (rs3,rs2). 
				  --Then add product & rs1 32 and store in rd
				  	for i in 0 to 1 loop
						r32I := (signed(rs3(i*64+31 downto i*64))); --rs3 lower 32
						r32II := (signed(rs2(i*64+31 downto i*64))); --rs2 lower 32
						
						r64I := r32I * r32II; --multiply higher 32	= 64 product	  
						
						--sub product64 with rs1 64field
						r64II := (signed(rs1( i*64+63 downto i*64)));
						r64III(63 downto 0) := r64II - r64I; 
						
						if (r64III(63) = '0') then r64III(64) := '0'; --sign extend
						elsif (r64III(63) = '1') then r64III(64) := '1';
						end if;
						
						--check saturation
						if (r64III(64) = '1' and (r64II(63) = '0' and r64I(63) = '1'))
							then r64III := '0' & x"7FFFFFFFFFFFFFFF" ; --overflow
						elsif (r64III(64) = '0' and (r64II(63) = '1' and r64I(63) = '0')) 
							then r64III := '1' & x"8000000000000000"; --underflow 
						end if;

						rdbuffer(i*64+63 downto i*64) := std_logic_vector(r64III(63 downto 0)); 
						
					end loop; 
					rd <= rdbuffer;
				  
                  when "111" => --Signed Long Integer Multiply-Subtract High with Saturation
                  
				  	--for each 64 pair, take the lower 32 and multiply (rs3,rs2). 
				  --Then add product & rs1 32 and store in rd
				  	for i in 0 to 1 loop
						r32I := (signed(rs3(i*64+63 downto i*64+32))); --rs3 high 32
						r32II := (signed(rs2(i*64+63 downto i*64+32))); --rs2 high 32
						
						r64I := r32I * r32II; --multiply higher 32	= 64 product	  
						
						--report "r32I :" & integer'image(to_integer(r32I));
						--report "r32II :" & integer'image(to_integer(r32II));
						--report "r64I.1 :" & integer'image(to_integer(r64I(31 downto 0)));
						--report "r64I.2 :" & integer'image(to_integer(r64I(63 downto 32)));
						
						--sub product64 with rs1 64field
						r64II := (signed(rs1( i*64+63 downto i*64)));
						r64III(63 downto 0) := r64II - r64I; 
						
						if (r64III(63) = '0') then r64III(64) := '0'; --sign extend
						elsif (r64III(63) = '1') then r64III(64) := '1';
						end if;
						
						--report "BEFORE SATUARATION :";
						--report "r64III.1 :" & integer'image(to_integer(r64III(31 downto 0)));
						--report "r64III.2 :" & integer'image(to_integer(r64III(63 downto 32)));
						--report "r64III.3 :" & integer'image(to_integer(r64III(64 downto 64)));
						
						--check saturation
						if (r64III(64) = '1' and (r64II(63) = '0' and r64I(63) = '1'))
							then r64III := '0' & x"7FFFFFFFFFFFFFFF" ; --overflow
						elsif (r64III(64) = '0' and (r64II(63) = '1' and r64I(63) = '0')) 
							then r64III := '1' & x"8000000000000000"; --underflow 
						end if;
						
						--report "r64III.1 :" & integer'image(to_integer(r64III(31 downto 0)));
						--report "r64III.2 :" & integer'image(to_integer(r64III(63 downto 32)));
						--report "r64III.3 :" & integer'image(to_integer(r64III(64 downto 64)));
						
						rdbuffer(i*64+63 downto i*64) := std_logic_vector(r64III(63 downto 0)); 
						
					end loop; 
					rd <= rdbuffer;
				  
				  when others => null;

                end case;
            end if;
		end if; 
--        rd<=rdbuffer;
    end process alu_process;
    
    
    
    
    
    
end alu_arch;

