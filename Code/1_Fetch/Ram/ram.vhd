-- Simple generic RAM Model
--
-- +-----------------------------+
-- |    Copyright 2008 DOULOS    |
-- |   designer :  JK            |
-- +-----------------------------+

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity sync_ram is
  generic (
    address_size : natural := 64;
    data_size : natural := 32
  );
  port (
    clk : in std_logic;
    i_address : in std_logic_vector(63 downto 0);
    o_r_data : out std_logic_vector(31 downto 0)
  );
  constant RAM_SIZE : integer := 256;
  constant LAST_ADDR : unsigned(i_address'range) := to_unsigned(RAM_SIZE - 1, i_address'length);
end entity sync_ram;

architecture RTL of sync_ram is

  type ram_type is array (0 to RAM_SIZE - 1) of std_logic_vector(o_r_data'range);
  signal ram : ram_type := (
    0 => x"00000000", --      nop
    -- READ MEMORY
    1 => x"00003003",
    2 => x"00103003",
    3 => x"00203003",
    4 => x"00303003",
    5 => x"00403003",
    6 => x"00503003",
    7 => x"00603003",
    8 => x"00703003",
    9 => x"00803003",
    10 => x"00903003",
    11 => x"00A03003",
    12 => x"00B03003",
    13 to 20 => x"00000000", -- nop               # START
    -------------------------------------------------------------------------------------- BUBBLE SORT
    21 => x"00000093", --      addi    x1,x0,0   # *array[0] = 0
    22 => x"00b08113", --      addi    x2,x1,11  # i = N-1
    23 => x"00000b63", --      beq     x0,x0,11  #             go .L2 (23+11)

    24 => x"00128293", -- .L3  addi    x5,x5,1   # j++
    25 => x"00228763", --      beq     x5,x2,7   # if j=i      go .L7 (25+7)

    26 => x"0002b183", -- .L4  ld      x3,0(x5)  # a = array[j]
    27 => x"0012b203", --      ld      x4,1(x5)  # b = array[j+1]
    28 => x"fe325ce3", --      bge     x4,x3,-4  # if b >= a   go .L3 (28-4)
    29 => x"0042b023", --      sd      x4,0(x5)  # array[j]   = b
    30 => x"0032b0a3", --      sd      x3,1(x5)  # array[j+1] = a
    31 => x"fe0009e3", --      beq     x0,x0,-7  #             go .L3 (31-7)

    32 => x"fff10113", -- .L7  addi    x2,x2,-1  # i--
    33 => x"00110363", --      beq     x2,x1,3   # if i=0      go .L5 (33+3)

    34 => x"00008293", -- .L2  addi    x5,x1,0   # j = 0
    35 => x"fe0007e3", --      beq     x0,x0,-9  #             go .L4 (35-9)
    ----------------------------------------------------------------------------------------------------
    36 to 49 => x"00000000", -- nop               # END
    -- READ MEMORY
    50 => x"00003003",
    51 => x"00103003",
    52 => x"00203003",
    53 => x"00303003",
    54 => x"00403003",
    55 => x"00503003",
    56 => x"00603003",
    57 => x"00703003",
    58 => x"00803003",
    59 => x"00903003",
    60 => x"00A03003",
    61 => x"00B03003",
    62 to 69 => x"00000000", -- nop
    70 => x"00000063",       --      beq     x0,x0,0   # STOP
    others => (others => 'U')
  );
  signal l_address : std_logic_vector(63 downto 0);
  signal r_data : std_logic_vector(31 downto 0);
begin
  RamProc : process (clk) is
  begin
    if rising_edge(clk) then
        r_data <= ram(to_integer(unsigned(l_address)));
    end if;
  end process RamProc;
  o_r_data <= r_data;
  l_address <= i_address when unsigned(i_address) <= LAST_ADDR else
               std_logic_vector(LAST_ADDR);

end architecture RTL;