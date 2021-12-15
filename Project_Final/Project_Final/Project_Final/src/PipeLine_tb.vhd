--ESE 345 Tylon Guan and Joseph Zappala

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use STD.textio.all; 
use ieee.std_logic_textio.all; 

library Project_Final;
use Project_Final.Reg_File_Mem_Type.all;
use Project_final.all;

ENTITY pipeline_tb IS
END pipeline_tb;

ARCHITECTURE behav OF pipeline_tb IS 
	
file file_input : text;
  
	--Register file
	alias regArray is << signal .pipeline_tb.fsp.ID_WB_Stage.reg_lookup : reg_memory>>;
    
    signal instruction : std_logic_vector(24 downto 0);
    
    type loaded_instructions is array (64 downto 0) of std_logic_vector(24 downto 0);
    signal load_ins : loaded_instructions := (others => "1100000000000000000000000");
    signal loaded_to : boolean := false;
    signal runnable : boolean := false;
    
	signal clock : std_logic := '0';
	signal load_clock: std_logic := '0';
    
	signal counting_loads : integer := 0; 
	signal clock_counter : integer := 0;
	
	--for fsp (Four Stage Pipeline)
	--IF STAGE
	signal IF_PC_out :  STD_LOGIC_VECTOR(5 downto 0);
	signal IF_instr_out :  STD_LOGIC_VECTOR(24 downto 0);
	
	--ID STAGE
	signal ID_instr_out :  STD_LOGIC_VECTOR(24 downto 0);
	signal ID_opcode_out :  STD_Logic_vector (9 downto 0);
	signal ID_write_enable_out : STD_LOGIC;
	signal ID_rd_WB_out : STD_LOGIC_VECTOR(127 downto 0);
	signal ID_rd_address_WB_out : STD_LOGIC_VECTOR(4 downto 0);
	signal ID_rs1_address_out : STD_LOGIC_VECTOR(4 downto 0);
	signal ID_rs2_address_out : STD_LOGIC_VECTOR(4 downto 0);
	signal ID_rs3_address_out : STD_LOGIC_VECTOR(4 downto 0);
	signal ID_rd_address_out : STD_LOGIC_VECTOR(4 downto 0);
	signal ID_rs1_data_out : STD_LOGIC_VECTOR(127 downto 0);
	signal ID_rs2_data_out : STD_LOGIC_VECTOR(127 downto 0);
	signal ID_rs3_data_out : STD_LOGIC_VECTOR(127 downto 0);
	signal ID_rd_data_out : STD_LOGIC_VECTOR(127 downto 0);

	signal EX_rs1_out : STD_LOGIC_VECTOR(127 downto 0);
	signal EX_rs2_out : STD_LOGIC_VECTOR(127 downto 0);
	signal EX_rs3_out : STD_LOGIC_VECTOR(127 downto 0);
	signal EX_rd_address_input_out : STD_LOGIC_VECTOR(4 downto 0);
	signal EX_rd_data_out : STD_LOGIC_VECTOR(127 downto 0);
	signal EX_write_enable_out : STD_LOGIC := '0';
	
	signal FW_mux_control1_out : STD_LOGIC := '0';
	signal FW_mux_control2_out : STD_LOGIC := '0';
	signal FW_mux_control3_out : STD_LOGIC := '0';
	signal FW_new_rData_out : STD_LOGIC_VECTOR(127 downto 0);
	
	signal FM_mux_control1_out : STD_LOGIC;
	signal FM_mux_control2_out : STD_LOGIC;
	signal FM_mux_control3_out : STD_LOGIC;
	signal FM_rs1_input_out : STD_LOGIC_VECTOR(127 downto 0);
	signal FM_rs2_input_out : STD_LOGIC_VECTOR(127 downto 0);
	signal FM_rs3_input_out : STD_LOGIC_VECTOR(127 downto 0); 
	signal FM_new_rData_out : STD_LOGIC_VECTOR(127 downto 0);
	signal FM_rs1_new_out : STD_LOGIC_VECTOR(127 downto 0);
	signal FM_rs2_new_out : STD_LOGIC_VECTOR(127 downto 0);
	signal FM_rs3_new_out : STD_LOGIC_VECTOR(127 downto 0); 
	
	signal output : STD_LOGIC_VECTOR(127 downto 0);
	signal write_enable : STD_LOGIC;
	
	signal tb_end : STD_LOGIC := '0';
    
BEGIN
	fsp : entity Four_Stage_Pipeline
    port map(  
	
		clk => clock,
		if_load_clock => load_clock,
	 	load_instr_row_input => instruction,
	 	output => output,
		 write_enable => write_enable,
    	
        IF_PC_out=> IF_PC_out,
		IF_instr_out =>	IF_instr_out,
		
		--ID_reset => ID_reset,
		ID_instr_out=> ID_instr_out,
		ID_opcode_out=>	 ID_opcode_out,
		ID_write_enable_out => ID_write_enable_out,
		ID_rd_WB_out =>	ID_rd_WB_out,
		ID_rd_address_WB_out => ID_rd_address_WB_out,
		ID_rs1_address_out => ID_rs1_address_out,
		ID_rs2_address_out => ID_rs2_address_out,
		ID_rs3_address_out => ID_rs3_address_out,
		ID_rd_address_out =>  ID_rd_address_out,
		ID_rs1_data_out => ID_rs1_data_out,
		ID_rs2_data_out => ID_rs2_data_out,
		ID_rs3_data_out => ID_rs3_data_out,
		ID_rd_data_out => ID_rd_data_out,
		
		EX_rs1_out => EX_rs1_out,
		EX_rs2_out => EX_rs2_out,
		EX_rs3_out => EX_rs3_out,
		EX_rd_address_input_out => EX_rd_address_input_out,
		EX_rd_data_out => EX_rd_data_out,
		EX_write_enable_out => EX_write_enable_out,
		
		FW_mux_control1_out =>	FW_mux_control1_out,
		FW_mux_control2_out =>	FW_mux_control2_out,
		FW_mux_control3_out => FW_mux_control3_out,
		FW_new_rData_out =>	 FW_new_rData_out,
		
		FM_mux_control1_out =>FM_mux_control1_out,	 
		FM_mux_control2_out =>	FM_mux_control2_out,
		FM_mux_control3_out => FM_mux_control3_out,
		FM_rs1_input_out =>	  FM_rs1_input_out,
		FM_rs2_input_out =>FM_rs2_input_out,
		FM_rs3_input_out =>FM_rs3_input_out,
		FM_new_rData_out =>	 FM_new_rData_out,
		FM_rs1_new_out =>  FM_rs1_new_out,
		FM_rs2_new_out =>	FM_rs2_new_out,
		FM_rs3_new_out =>	 FM_rs3_new_out
		--Results File
       
    );
   	
	read_from_file : process
		variable line_input : line;
		variable line_to_vector : std_logic_vector(24 downto 0);
        variable index : integer;
    begin		
		--ID_reset <= '0';
		--wait for 5 ns;
		--ID_reset <= '1';
    	index := 0;
    	file_open(file_input, "outputFile.txt",  read_mode);
		--file_open(result_file, "results.txt",  write_mode);
        while not endfile(file_input) loop
          	readline(file_input, line_input);
        	read(line_input, line_to_vector);
			
			--writeline(result_file, output_line);
			
			
         	-- Pass the line to IF
           	load_ins(index) <= line_to_vector;
			index := index + 1;
          --wait for 5 ns;
    	end loop;
    loaded_to <= true;
    file_close(file_input);
	--file_close(result_file);
	wait;
   	end process;
    
    load_to_if : process (load_clock) 
    variable counter : integer := 0;
    begin
    if counting_loads <= 64 then 
      if loaded_to then
    
		  instruction <= load_ins(counter);
		  counter := counter +1;
          counting_loads <= counter;

      end if;
    	
	elsif counting_loads = 65 then 
		runnable <= true;  
		counting_loads <= counting_loads + 1;
	end if;
	
    end process;
    
    clock_update : process
		
		variable output_line : line; 
		file write_file : text;
		variable line_v  : line;
		variable openfile : integer := 0;
    	begin	
		if runnable then

			if openfile = 0 then 
				file_open(write_file, "results.txt",  write_mode);
				openfile := 1;
			end if;
	        
	    	clock <= not clock;
	    	wait for 10 ns;	
			if (clock = '0' and clock_counter <= 128) then
				clock_counter <= clock_counter + 1;
			
			 write(line_v, "Clock: ");
			 write(line_v, clock_counter);
			 writeline(write_file, line_v);
			 
			 write(line_v, "IF: ");
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "PC: ");
			 hwrite(line_v, IF_PC_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "Instruction: ");
			 write(line_v, IF_instr_out);
			 writeline(write_file, line_v);  
			 
			 write(line_v, "ID: ");
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "Instruction: ");
			 hwrite(line_v, ID_instr_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "Opcode: ");
			 hwrite(line_v, ID_opcode_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "Write Enable: ");
			 write(line_v, ID_write_enable_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RD Write Back: ");
			 hwrite(line_v, ID_rd_WB_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RD Write Back Address: ");
			 hwrite(line_v, ID_rd_address_WB_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RS1 Address: ");
			 hwrite(line_v, ID_rs1_address_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RS2 Address: ");
			 hwrite(line_v, ID_rs2_address_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RS3 Address: ");
			 hwrite(line_v, ID_rs3_address_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RD Address: ");
			 hwrite(line_v, ID_rd_address_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RS1 Data: ");
			 hwrite(line_v, ID_rs1_data_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RS2 Data: ");
			 hwrite(line_v, ID_rs2_data_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RS3 Data: ");
			 hwrite(line_v, ID_rs3_data_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 write(line_v, "RD Data: ");
			 hwrite(line_v, ID_rd_data_out);
			 writeline(write_file, line_v);
			 
			 write(line_v, "EX: ");
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RS1 Data: ");
			 hwrite(line_v, EX_rs1_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RS2 Data: ");
			 hwrite(line_v, EX_rs2_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RS3 data: ");
			 hwrite(line_v, EX_rs3_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RD Address: ");
			 hwrite(line_v, EX_rd_address_input_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RD Data: ");
			 hwrite(line_v, EX_rd_data_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "Write Enable: ");
			 write(line_v, EX_write_enable_out);
			 writeline(write_file, line_v);
			 
			 write(line_v, "FW: ");
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "Mux Control 1: ");
			 write(line_v, FW_mux_control1_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "Mux Control 2: ");
			 write(line_v, FW_mux_control2_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "Mux Control 3: ");
			 write(line_v, FW_mux_control3_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "Forwarded Register: ");
			 hwrite(line_v, FW_new_rData_out);
			 writeline(write_file, line_v);
			 
			 write(line_v, "FM: ");
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "Mux Control 1: ");
			 write(line_v, FM_mux_control1_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "Mux Control 2: ");
			 write(line_v, FM_mux_control2_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "Mux Control 3: ");
			 write(line_v, FM_mux_control3_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RS1 Input: ");
			 hwrite(line_v, FM_rs1_input_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RS2 Input: ");
			 hwrite(line_v, FM_rs2_input_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "RS3 Input: ");
			 hwrite(line_v, FM_rs3_input_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "Forwarded Register: ");
			 hwrite(line_v, FM_new_rData_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "New RS1: ");
			 hwrite(line_v, FM_rs1_new_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "New RS2: ");
			 hwrite(line_v, FM_rs2_new_out);
			 writeline(write_file, line_v);
			 write(line_v, HT);
			 
			 write(line_v, "New RS3: ");
			 hwrite(line_v, FM_rs3_new_out);
			 writeline(write_file, line_v);
			 
			 write(line_v, " ");  --new line
			 writeline(write_file, line_v);
			 
			 write(line_v, "ALU Output: ");
			 hwrite(line_v, output);
			 writeline(write_file, line_v);
			 
			 write(line_v, "Write_enable: ");
			 write(line_v, write_enable);
			 writeline(write_file, line_v);
			 
			 write(line_v, "Register File (31 downto 0): ");  --new line
			 writeline(write_file, line_v);
			 
			 for i in 31 downto 0 loop 
				 if (i < 10) then
				 	write(line_v, "Register("&to_string(integer(i))&"):  ");
					hwrite(line_v, regArray(i));
			 		writeline(write_file, line_v); 
				 else
					write(line_v, "Register("&to_string(integer(i))&"): ");
					hwrite(line_v, regArray(i));
			 		writeline(write_file, line_v); 
				end if;
				 
			 end loop;
			 
			 write(line_v, "================================================================================================");
			 writeline(write_file, line_v);	
 
			end if;

			-- start 32 plus cpi * i
			if clock_counter > 128 then
				file_close(write_file);
				tb_end <= '1';
				 
			end if;
		
		else 
			load_clock <= not load_clock;
	    	wait for 10 ns;
		end if;
		
    end process;
	
	check_result : process (tb_end)		
		  variable line_input     : line;	 
		
		variable line_to_vector : std_logic_vector(127 downto 0);
        variable index : integer;
	begin  
		if (tb_end = '1') then 
		index := 31;
    	file_open(file_input, "Register_File_Report.txt",  read_mode);
        while not endfile(file_input) loop
          	readline(file_input, line_input);
        	hread(line_input, line_to_vector);
			
         	-- Pass the line to IF
           	assert regArray(index) = line_to_vector 
			   report "Fail at register: " &integer'image(index) severity warning; 
			
			index := index - 1;
    	end loop;  
		
    file_close(file_input);	
	report "END OF TB";
	std.env.stop; 
	
	end if;
	end process;
	
	
end behav; 

