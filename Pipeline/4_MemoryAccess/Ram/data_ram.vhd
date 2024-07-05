-- Simple generic RAM Model
--
-- +-----------------------------+
-- |    Copyright 2008 DOULOS    |
-- |   designer :  JK            |
-- +-----------------------------+

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity sync_data_ram is
  port (
    clk : in std_logic;
    i_we : in std_logic;
    i_re : in std_logic;
    i_address : in std_logic_vector(63 downto 0);
    i_data_mem : in std_logic_vector(63 downto 0);
    o_r_data : out std_logic_vector
  );
  constant RAM_SIZE : integer := 256;
  constant LAST_ADDR : unsigned(i_data_mem'range) := to_unsigned(RAM_SIZE - 1, i_data_mem'length);
end entity sync_data_ram;

architecture RTL of sync_data_ram is

  type ram_type is array (0 to RAM_SIZE - 1) of std_logic_vector(i_data_mem'range);
  signal ram : ram_type := (
    0 => x"0000000000000002",
    1 => x"0000000000000003",
    2 => x"0000000000000005",
    3 => x"000000000000000B",
    4 => x"FFFFFFFFFFFFFFFF",
    5 => x"0000000000000004",
    6 => x"0000000000000005",
    7 => x"0000000000000001",
    8 => x"000000000000000D",
    9 => x"FFFFFFFFFFFFFFFB",
    10 => x"0000000000000000",
    11 => x"0000000000000002",
    others => x"0000000000000000"
  );
  signal read_i_address : std_logic_vector(63 downto 0) := (others => '0');

begin
  RamProc : process (clk) is
    variable address : std_logic_vector(i_address'range);
  begin
    if rising_edge(clk) then
      if unsigned(i_address) > LAST_ADDR then
        address := std_logic_vector(LAST_ADDR);
      else
        address := i_address;
      end if;

      if i_we = '1' then
        ram(to_integer(unsigned(address))) <= i_data_mem;
      end if;
      if i_re = '1' then
        o_r_data <= ram(to_integer(unsigned(address)));
      end if;
    end if;
  end process RamProc;

end architecture RTL;