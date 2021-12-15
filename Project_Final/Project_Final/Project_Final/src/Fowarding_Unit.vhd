--ESE 345 Tylon Guan and Joseph Zappala

library IEEE;
use IEEE.std_logic_1164.all;

entity fowarding_unit is
	port(
		 Instr : in STD_LOGIC_VECTOR(24 downto 0);
		 ex_wb_rd_data : in STD_LOGIC_VECTOR(127 downto 0); --alu
		 ex_wb_rd : in STD_LOGIC_VECTOR(4 downto 0); 		--instr? nah just keep passing it
		 
		 id_ex_rs1 : in STD_LOGIC_VECTOR(4 downto 0);
		 --id_ex_rs1_data: in STD_LOGIC_VECTOR(127 downto 0);
		 
		 id_ex_rs2 : in STD_LOGIC_VECTOR(4 downto 0);
		 --id_ex_rs2_data: in STD_LOGIC_VECTOR(127 downto 0);
		 
		 id_ex_rs3 : in STD_LOGIC_VECTOR(4 downto 0);
		 --id_ex_rs3_data: in STD_LOGIC_VECTOR(127 downto 0);
		 
		 write_enable : in STD_LOGIC;
		 mux_control1 : inout STD_LOGIC := '0'; --check if we need to replace rs1,2,3
		 mux_control2 : inout STD_LOGIC := '0';
		 mux_control3 : inout STD_LOGIC := '0';
		 
		 new_rData : out STD_LOGIC_VECTOR(127 downto 0);
		 -- foward_rs1 : inout STD_LOGIC_VECTOR(127 downto 0);
		 -- foward_rs2 : inout STD_LOGIC_VECTOR(127 downto 0);
		 -- foward_rs3 : inout STD_LOGIC_VECTOR(127 downto 0);
		 
		 --Results File (configured with inout)
		 mux_control1_out : out STD_LOGIC;
		 mux_control2_out : out STD_LOGIC;
		 mux_control3_out : out STD_LOGIC;
		 new_rData_out : out STD_LOGIC_VECTOR(127 downto 0)
		 
	     );
end fowarding_unit;

--}} End of automatically maintained section
architecture fowarding_unit_arch of fowarding_unit is
begin
mux_control1_out <= mux_control1;
mux_control2_out <= mux_control2;
mux_control3_out <= mux_control3;
new_rData_out <= ex_wb_rd_data;

	check_reg_output : process (ex_wb_rd_data, write_enable, ex_wb_rd) --check if this data is valid/need fowarding
	constant all_U : std_logic_vector (127 downto 0) := (others => 'U');
	begin	
		--report "processing forwarding decision";
			--if rd doesnt exist yet, or any register is null then skip
			--if ((not ex_wb_rd(0) = '0' or  not ex_wb_rd(0) = '1') or (not id_ex_rs1(0) ='0' or not id_ex_rs1(0) ='1') or 
--				(not id_ex_rs2(0) = '0' or not id_ex_rs2(0) = '1') or (not id_ex_rs3(0) = '0' or not id_ex_rs3(0) = '1')) then
--				mux_control1 <= '0';
--				mux_control2 <= '1';
--				mux_control3 <= '0';
--			else 
				
	--check if rd same as r21
				if (ex_wb_rd = id_ex_rs1 and write_enable = '1' and instr(24) = '1') then	
					--foward_rs1 <= ex_wb_rd_data;
					mux_control1 <= '1';
				else
					--foward_rs1 <= id_ex_rs1_data;
					mux_control1 <= '0';
				end if;
				
				--check if rd same as rs2
				if (ex_wb_rd = id_ex_rs2 and write_enable = '1' and instr(24) = '1') then	
					--foward_rs2 <= ex_wb_rd_data;
					mux_control2 <= '1';
				else
					--foward_rs2 <= id_ex_rs2_data;
					mux_control2 <= '0';
				end if;	 
					
				--check if rd same as rs3
				if (ex_wb_rd = id_ex_rs3 and write_enable = '1') then --fowards even on li instruction	
					--foward_rs3 <= ex_wb_rd_data;
					mux_control3 <= '1';
				else
					--foward_rs3 <= id_ex_rs3_data;
					mux_control3 <= '0';
				end if;	
			--end if;
			new_rData <= ex_wb_rd_data;
		end process check_reg_output;

end fowarding_unit_arch;
