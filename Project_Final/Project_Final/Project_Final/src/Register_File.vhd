--ESE 345 Tylon Guan and Joseph Zappala

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

library Project_Final;
use Project_Final.Reg_File_Mem_Type.all;


entity Register_file is
	generic(
	
	REGISTER_INDEX : integer := 5;  --32 registers 
	DATA_WIDTH 	  : integer := 128 --of 128 bits
	
	);
	
	port(
		 --reset : in STD_LOGIC;
		 instr : in STD_LOGIC_VECTOR(24 downto 0);
		 write_enable : in STD_LOGIC;
		 rd_address_WB : in STD_LOGIC_VECTOR(4 downto 0);
		 rd	: in STD_LOGIC_VECTOR(127 downto 0); --data
		 clk : in STD_LOGIC;
		 
		 --fowarding unit
		 instr_toFoward : out STD_LOGIC_VECTOR(24 downto 0);
		 rs1_address : out STD_LOGIC_VECTOR(4 downto 0);
		 rs2_address : out STD_LOGIC_VECTOR(4 downto 0);
		 rs3_address : out STD_LOGIC_VECTOR(4 downto 0);
		 --to be passed through alu
		 rd_address : out STD_LOGIC_VECTOR(4 downto 0);

		 --Results file
		 instr_out : out STD_LOGIC_VECTOR(24 downto 0);
		 opcode_out : out STD_Logic_vector (9 downto 0);
		 
		 write_enable_out : out STD_LOGIC;
		 rd_WB_out : out STD_LOGIC_VECTOR(127 downto 0);
		 rd_address_WB_out : out STD_LOGIC_VECTOR(4 downto 0);
		 
		 rs1_address_out : out STD_LOGIC_VECTOR(4 downto 0);
		 rs2_address_out : out STD_LOGIC_VECTOR(4 downto 0);
		 rs3_address_out : out STD_LOGIC_VECTOR(4 downto 0);
		 rd_address_out : out STD_LOGIC_VECTOR(4 downto 0);
		 
		 rs1_data_out : out STD_LOGIC_VECTOR(127 downto 0);
		 rs2_data_out : out STD_LOGIC_VECTOR(127 downto 0);
		 rs3_data_out : out STD_LOGIC_VECTOR(127 downto 0);
		 rd_data_out : out STD_LOGIC_VECTOR(127 downto 0);
		 --Results file
		 
		 --alu
		 opcode : out STD_Logic_vector (9 downto 0);
		 rs1 : inout STD_LOGIC_VECTOR(127 downto 0);
		 rs2 : inout STD_LOGIC_VECTOR(127 downto 0);
		 rs3 : inout STD_LOGIC_VECTOR(127 downto 0)
	     );
end Register_file;

--}} End of automatically maintained section

-- array of 4 5 bits for rd adress	
-- clock edge trigger for write, negative edge for read
architecture Register_file_arch of Register_file is	

--2^5 = 32 entries,        2^7 = 128bits data
constant MEMORY_DEPTH : integer := 2**REGISTER_INDEX;
constant all_zeros : std_logic_vector (127 downto 0) := (others => '0');

--type reg_memory is array (MEMORY_DEPTH-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0); 
signal reg_lookup : reg_memory := (others => all_zeros);



--type queue is array (2 downto 0) of STD_LOGIC_VECTOR(REGISTER_INDEX-1 downto 0);
--signal rd_queue : queue;
-- [4:0] address

--signal rd_address : STD_LOGIC_VECTOR(4 downto 0) := instr(4 downto 0);

begin  
	
--	update_queue: process(instr)
--	variable rd_queue_var : queue := rd_queue;
--	begin
--		--shift my queue
--		rd_queue_var(0) := rd_queue_var(1);
--		rd_queue_var(1) := rd_queue_var(2);
--		--rd_queue_var(2) := rd_queue_var(3);
--				
--		rd_queue_var(2) := instr(4 downto 0); --for some reason i cant use a variable... 
--			
--		rd_queue <= rd_queue_var;
--	end process update_queue; --NOP to empty instructions

--Results file
instr_out <= instr;
opcode_out <= instr (24 downto 15);
write_enable_out <= write_enable;
rd_WB_out <= rd;
rd_address_WB_out <= rd_address_WB;	
rs3_address_out <= instr(19 downto 15);
rs2_address_out <= instr(14 downto 10);
rs1_address_out <= instr(9 downto 5);
rd_address_out  <= instr(4 downto 0);


rs1_data_out <= rs1;
rs2_data_out <= rs2;
rs3_data_out <= rs3;
rd_data_out  <=	reg_lookup(to_integer(unsigned(instr(4 downto 0))));


--resett : process (reset)
--begin
--	if (reset = '1') then
--		report "RESET REGISTERS";
--		reg_lookup <= (others => (others =>'0'));
--	end if;	
--end process;

	Reg_write: process (rd_address_WB, rd, write_enable)
	--variable rd_queue_var : queue := rd_queue;
	begin 		
	--if (rising_edge(clk)) then --write	 
			if (write_enable = '1') then							 
				-- ? would <= work or would we need to change it to :=?
				-- <= applies at the end of process.	 
			 	--report "writing " & integer'image(to_integer(unsigned(rd))) & " to "  & integer'image(to_integer(unsigned(rd_address_WB)));
				reg_lookup(to_integer(unsigned(rd_address_WB))) <= rd; 
				--report "reg 0: " & integer'image(to_integer(unsigned(reg_lookup(0))));
				
				--reg_lookup(22) <= "10101011011010101010101011001010101010101010110011010101010101101010110110101010101010110010101010101010101100110101010101010010";
				--shift my queue
--				rd_queue_var(0) := rd_queue_var(1);
--				rd_queue_var(1) := rd_queue_var(2);
--				rd_queue_var(2) := rd_queue_var(3);
				
			end if;
	--end if;
	end process Reg_write;	
	
	Reg_read: process(clk) --decodes the instruction
	--variable rs3_addressv : std_logic_vector(4 downto 0) := instr(19 downto 15);
	--variable rs2_addressv : std_logic_vector(4 downto 0) := instr(14 downto 10);
	--variable rs1_addressv : std_logic_vector(4 downto 0) := instr(9 downto 5);
	--variable rd_addressv : std_logic_vector(4 downto 0) := instr(4 downto 0);

	--cant assign variable to signal directly...
	--cannot create signal inside process...
	--variable rd_queue_var : queue := rd_queue;
	
	begin					 
		if (falling_edge(clk)) then	
			if (instr(24) = '0') then --li instruction
				
				rs2 <= 	 std_logic_vector(to_unsigned(to_integer(unsigned(instr(20 downto 5))), 128)); --imm 16
				rs1 <=   std_logic_vector(to_unsigned(to_integer(unsigned(instr(23 downto 21))), 128)); --load index
				
				
				rs3 <=   reg_lookup(to_integer(unsigned(instr(4 downto 0))));	--rd's data
				
			rs3_address <= instr(4 downto 0);
			rs2_address <= instr(14 downto 10);
			rs1_address <= instr(9 downto 5);
			rd_address  <= instr(4 downto 0);
			opcode <= instr (24 downto 15);
				
				--report integer'image(to_integer(unsigned(rs2)));
			elsif (instr(24) = '1') then
				   
			rs3 <= reg_lookup(to_integer(unsigned(instr(19 downto 15))));
			--rs3 <=		 reg_lookup(3);
			rs2 <= reg_lookup(to_integer(unsigned(instr(14 downto 10))));
			rs1 <= reg_lookup(to_integer(unsigned(instr(9 downto 5))));
			
			rs3_address <= instr(19 downto 15);
			rs2_address <= instr(14 downto 10); -- this might cause fowarding to foward a value. This is beacuse 
												-- this might align to the output register address.. rd:(00000) ours rs2(00000) coincidence.
			rs1_address <= instr(9 downto 5);
			rd_address  <= instr(4 downto 0);
			opcode <= instr (24 downto 15);
			
			end if;
			instr_toFoward <= instr;
			
			
	
			
			--add rd(address) into queue to align with this instruction
			--so that when the data comes back, rd and data can be together
			
			--need to pass on all register address to foward_hazard
			--even if we update a register rs3 that is not being used, it won't affect output/data
			--and that value in rs3 will be written back anyways, so its just updated earlier.
			
		end if;
	end process Reg_read;
end Register_file_arch;
