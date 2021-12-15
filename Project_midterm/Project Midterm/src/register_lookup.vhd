library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_lookup is
generic
(
    ADDR_WIDTH : integer := 8;
    DATA_WIDTH : integer := 32
);
port
(
    clk         : in std_logic;
    reset_n     : in std_logic;

    write_addr  : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    read_addr   : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    write_data  : in std_logic_vector(DATA_WIDTH-1 downto 0);
    write_enable: in std_logic;

    read_data   : out std_logic_vector(DATA_WIDTH-1 downto 0)
);
end register_lookup;

architecture behavioral of register_lookup is

    constant MEMORY_DEPTH : integer := 2**ADDR_WIDTH;

    type reg_memory is array (MEMORY_DEPTH-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);

    signal my_reg_memory : reg_memory;

begin

    read_data <= my_reg_memory(to_integer(unsigned(read_addr)));

    process (clk)
    begin
        if (rising_edge(clk))
        then
            if (write_enable = '1')
            then
                my_reg_memory(to_integer(unsigned(write_addr))) <= write_data;
            end if;
        end if;
    end process;

end behavioral;
