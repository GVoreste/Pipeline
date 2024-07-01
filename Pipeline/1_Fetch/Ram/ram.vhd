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
  generic(
    address_size: Natural := 64;
    data_size: Natural := 32
  );
  port (
    clk       : in  std_logic;
    i_we      : in  std_logic := '0';
    i_address : in  std_logic_vector(address_size-1 downto 0):= (others => '0');
    i_data    : in  std_logic_vector(data_size-1 downto 0):= (others => '0');
    o_data    : out std_logic_vector
  );
  constant RAM_SIZE: integer := 256;
  constant LAST_ADDR: unsigned(i_data'range) := to_unsigned(RAM_SIZE-1,i_data'length);
end entity sync_ram;

architecture RTL of sync_ram is

   type ram_type is array (0 to RAM_SIZE-1) of std_logic_vector(i_data'range);
   signal ram : ram_type := (
    -- 0 to 3 => x"0000F000",
    -- 4 to 7 => x"0000F004",
    -- 8 to 11 => x"0000F008",
    -- 12 to 15 => x"0000F00C",
    -- 16 to 19 => x"0000F010",
    -- 20 to 23 => x"0000F014",
    -- 24 to 27 => x"0000F018",
    -- 28 to 31 => x"0000F01C",
    -- 32 to 35 => x"0000F020",
    -- 36 to 39 => x"0000F024",
    -- 40 to 49 => x"0000F028",
    0  => x"00000000",
    1  => x"002" & B"00000" & B"101" & B"00001" & B"0000011", -- LD in x1
    2  => x"00000000",
    3  => x"00000000",
    4  => x"00000000",
    5  => x"00000000",
    6  => x"008" & B"00000" & B"101" & B"00010" & B"0000011", -- LD in x2
    7  => x"00000000",
    8  => x"00000000",
    9  => x"00000000",
    10 => x"00000000",
    11 => B"0100000" & B"00010" & B"00001" & B"000" & B"00011" & B"0110011", -- SUB x2 - x1 => x3 = D - 5 = 8
    others => x"00000000"


    -- 1  => x"00058593", -- addi    a1,a1,360 # 11168 <array>  to change imm
    -- 2  => x"06058613", -- addi    a2,a1,96
    -- 3  => x"02c0006f", -- j       10158 <main+0x38>     to change imm (POSSO CAMBIARLO IN BEQ)
    -- 4  => x"00878793", -- addi    a5,a5,8
    -- 5  => x"00c78e63", -- beq     a5,a2,10150 <main+0x30> to change imm
    -- 6  => x"0007b703", -- ld      a4,0(a5)
    -- 7  => x"0087b683", -- ld      a3,8(a5)
    -- 8  => x"fee6d8e3", -- bge     a3,a4,10130 <main+0x10> to change imm L'opcode e' uguale a beq, cambia func3
    -- 9  => x"00d7b023", -- sd      a3,0(a5)
    -- 10 => x"00e7b423", -- sd      a4,8(a5)
    -- 11 => x"fe5ff06f", -- j       10130 <main+0x10> to change imm
    -- 12 => x"ff860613", -- addi    a2,a2,-8
    -- 13 => x"00b60663", -- beq     a2,a1,10160 <main+0x40> to change imm
    -- 14 => x"00058793", -- j       10138 <main+0x18> mv      a5,a1
    -- 15 => x"fddff06f", -- to change imm
    -- others => x"00000000"



   );
   signal read_i_address : std_logic_vector(63 downto 0):= (others => '0');

begin
    RamProc: process(clk) is
    variable address: std_logic_vector(i_address'range);
    begin
        if rising_edge(clk) then
            if unsigned(i_address) > LAST_ADDR then 
              address := std_logic_vector(LAST_ADDR);
            else
              address := i_address;
            end if;
            
            if i_we = '1' then
              ram(to_integer(unsigned(address))) <= i_data;
            end if;
            read_i_address <= address;
        end if;
    end process RamProc;

    o_data <= ram(to_integer(unsigned(read_i_address)));

end architecture RTL;

    