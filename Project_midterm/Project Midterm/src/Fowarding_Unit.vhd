-------------------------------------------------------------------------------
--
-- Title       : fowarding_unit
-- Design      : Project Midterm
-- Author      : Tyguan
-- Company     : Stony Brook
--
-------------------------------------------------------------------------------
--
-- File        : C:\Users\Tyguan\Desktop\ESE 345\Project\Project_midterm\Project Midterm\src\Fowarding_Unit.vhd
-- Generated   : Sat Nov 27 21:09:25 2021
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
--{entity {fowarding_unit} architecture {fowarding_unit_arch}}

library IEEE;
use IEEE.std_logic_1164.all;

entity fowarding_unit is
	port(												   
		 ex_wb_rd_data : in STD_LOGIC_VECTOR(127 downto 0);
		 ex_wb_rd : in STD_LOGIC_VECTOR(24 downto 0); 
		 
		 id_ex_rs1 : in STD_LOGIC_VECTOR(24 downto 0);
		 id_ex_rs1_data: in STD_LOGIC_VECTOR(127 downto 0);
		 
		 id_ex_rs2 : in STD_LOGIC_VECTOR(24 downto 0);
		 id_ex_rs2_data: in STD_LOGIC_VECTOR(127 downto 0);
		 
		 id_ex_rs3 : in STD_LOGIC_VECTOR(24 downto 0);
		 id_ex_rs3_data: in STD_LOGIC_VECTOR(127 downto 0);
		 
		 mux_control : out STD_LOGIC;
		 foward_rs1 : out STD_LOGIC_VECTOR(127 downto 0);
		 foward_rs2 : out STD_LOGIC_VECTOR(127 downto 0);
		 foward_rs3 : out STD_LOGIC_VECTOR(127 downto 0)
		 
	     );
end fowarding_unit;

--}} End of automatically maintained section

architecture fowarding_unit_arch of fowarding_unit is
begin
	
	check_reg_output : process (ex_wb_rd_data) --check if this data is valid/need fowarding
		begin
			if (ex_wb_rd = id_ex_rs1) then	
				foward_rs1 <= ex_wb_rd_data;
				foward_rs2 <= id_ex_rs2_data;
				foward_rs3 <= id_ex_rs3_data;
				mux_control <= '1';
				
			elsif (ex_wb_rd = id_ex_rs2) then
				foward_rs1 <= id_ex_rs1_data;
				foward_rs2 <= ex_wb_rd_data;
				foward_rs3 <= id_ex_rs3_data;
				mux_control <= '1';	 
				
			elsif (ex_wb_rd = id_ex_rs3) then
				foward_rs1 <= id_ex_rs1_data;
				foward_rs2 <= id_ex_rs2_data;
				foward_rs3 <= ex_wb_rd_data; 
				mux_control <= '1';
			else
				foward_rs1 <= id_ex_rs1_data;
				foward_rs2 <= id_ex_rs2_data;
				foward_rs3 <= id_ex_rs3_data;
				mux_control <= '0';
			end if;
			
		end process check_reg_output;

end fowarding_unit_arch;
