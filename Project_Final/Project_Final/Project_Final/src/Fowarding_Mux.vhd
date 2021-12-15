--ESE 345 Tylon Guan and Joseph Zappala

library IEEE;
use IEEE.std_logic_1164.all;

entity Fowarding_Mux is
	 port(	
	 
	 	 mux_control1 : in STD_LOGIC; --check if we need to replace rs1,2,3
		 mux_control2 : in STD_LOGIC;
		 mux_control3 : in STD_LOGIC;
	 
		 rs1 : in STD_LOGIC_VECTOR(127 downto 0);
		 rs2 : in STD_LOGIC_VECTOR(127 downto 0);
		 rs3 : in STD_LOGIC_VECTOR(127 downto 0); 
		 new_rData : in STD_LOGIC_VECTOR(127 downto 0);
		 
		 rs1_out : inout STD_LOGIC_VECTOR(127 downto 0);
		 rs2_out : inout STD_LOGIC_VECTOR(127 downto 0);
		 rs3_out : inout STD_LOGIC_VECTOR(127 downto 0);
		 
		 --Results File
		 mux_control1_out : out STD_LOGIC;
		 mux_control2_out : out STD_LOGIC;
		 mux_control3_out : out STD_LOGIC;
		 rs1_input_out : out STD_LOGIC_VECTOR(127 downto 0);
		 rs2_input_out : out STD_LOGIC_VECTOR(127 downto 0);
		 rs3_input_out : out STD_LOGIC_VECTOR(127 downto 0); 
		 new_rData_out : out STD_LOGIC_VECTOR(127 downto 0);
		 rs1_new_out : out STD_LOGIC_VECTOR(127 downto 0);
		 rs2_new_out : out STD_LOGIC_VECTOR(127 downto 0);
		 rs3_new_out : out STD_LOGIC_VECTOR(127 downto 0)
		 
		 
		 
--		 new_rs1 : out STD_LOGIC_VECTOR(127 downto 0);
--		 new_rs2 : out STD_LOGIC_VECTOR(127 downto 0);
--		 new_rs3 : out STD_LOGIC_VECTOR(127 downto 0);
		 
	     );
end Fowarding_Mux;

--}} End of automatically maintained section

architecture Fowarding_Mux_arch of Fowarding_Mux is
begin 

--Results File
mux_control1_out <= mux_control1;
mux_control2_out <= mux_control2;
mux_control3_out <= mux_control3;

rs1_input_out <= rs1;
rs2_input_out <= rs2;
rs3_input_out <= rs3;
new_rData_out <= new_rData;

rs1_new_out <= rs1_out;
rs2_new_out <= rs2_out;
rs3_new_out <= rs3_out;

	check_fowarding : process (mux_control1, mux_control2, mux_control3, rs1, rs2, rs3, new_rData)
	begin
		if mux_control1 = '1' then  --replace rs1 with new value
			--report "forward 1";
			rs1_out <= new_rData;
		else
			rs1_out <= rs1; --no replace new value.
		end if;
		
		if mux_control2 = '1' then  --replace rs2 with new value  
			--report "forward 2";
			rs2_out <= new_rData;
		else
			rs2_out <= rs2; --no replace new value.
		end if;
		
		if mux_control3 = '1' then  --replace rs2 with new value 
			--report "forward 3";
			rs3_out <= new_rData;
		else
			rs3_out <= rs3; --no replace new value.
		end if;
			
		
	end process check_fowarding;

end Fowarding_Mux_arch;
