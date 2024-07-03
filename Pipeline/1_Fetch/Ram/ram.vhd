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
    i_reg_stall: in  std_logic;
    i_flush:     in std_logic;
    i_we      : in  std_logic := '0';
    i_address : in  std_logic_vector(address_size-1 downto 0):= (others => '0');
    i_data    : in  std_logic_vector(data_size-1 downto 0):= (others => '0');
    o_data    : out std_logic_vector
  );
  constant RAM_SIZE: integer := 256;
  constant LAST_ADDR: unsigned(i_address'range) := to_unsigned(RAM_SIZE-1,i_address'length);
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


    -- 0  => x"00000000",
    -- 1 => B"0100000" & B"00010" & B"00001" & B"000" & B"00011" & B"0110011", -- SUB x2 - x1 => x3 = D - 5 = 8
    -- 2  => x"00000000",
    -- 3  => x"00000000",
    -- 4  => x"00000000",
    -- 5  => x"00000000",
    -- 6  => x"002" & B"00000" & B"101" & B"00001" & B"0000011", -- LD in x1
    -- 7  => x"00000000",
    -- 8  => x"00000000",
    -- 9  => x"00000000",
    -- 10 => x"00000000",
    -- 11  => x"008" & B"00000" & B"101" & B"00010" & B"0000011", -- LD in x2
    -- 12  => x"00000000",
    -- 13  => x"00000000",
    -- 14  => x"00000000",
    -- 15 => x"00000000",
    -- 16 => B"0100000" & B"00001" & B"00010" & B"000" & B"00011" & B"0110011", -- SUB x2 - x1 => x3 = D - 5 = 8
    -- others => x"00000000"

    -- 0  => x"00000000",
    -- 1  => x"006" & B"00000" & B"101" & B"00101" & B"0010011", -- ADDI 06,x0 => x5
    -- 2  => x"00000000",
    -- 3  => x"00000000",
    -- 4  => x"00000000",
    -- 5  => x"00000000",
    -- 6  => x"00A" & B"00101" & B"101" & B"00101" & B"0010011", -- ADDI 0A x5 => x5 
    -- 7  => x"00000000",
    -- 8  => x"00000000",
    -- 9  => x"00000000",
    -- 10 => x"00000000",
    -- 11  => B"1111111" & B"00101" & B"00101" & B"101" & B"11101" & B"0100011", -- SD x5 in x5 - 2
    -- 12  => x"00000000",
    -- 13  => x"00000000",
    -- 14  => x"00000000",
    -- 15 =>  x"00000000",
    -- 16 => x"00D" & B"00000" & B"101" & B"00111" & B"0000011", -- LD x0 + (x5-2) in x7
    -- others => x"00000000"

    -- 0  => x"00000000",
    -- 1  => x"006" & B"00000" & B"101" & B"00000" & B"0010011", -- ADDI 06, x0 => x0
    -- 2  => x"00000000",
    -- 3  => x"00000000",
    -- 4  => x"00000000",
    -- 5  => x"00000000",
    -- 6  => x"00F" & B"00000" & B"101" & B"11111" & B"0010011", -- ADDI 0F, x0 => x31 
    -- 7  => x"00000000",
    -- 8  => x"00000000",
    -- 9  => x"00000000",
    -- 10 => x"00000000",
    -- 11  => B"0000000" & B"11111" & B"00000" & B"101" & B"00100" & B"1100011", -- BEQ x31,x0 go - 010
    -- 12  => x"00000000",
    -- 13  => x"00000000",
    -- 14  => x"00000000",
    -- 15 =>  x"00000000",
    -- 16 => x"000" & B"11111" & B"101" & B"01010" & B"0000011", -- LD x31+0 in x10
    -- others => x"00000000"

    -- 0  => x"00000000",
    -- 1  => x"006" & B"00000" & B"111" & B"00011" & B"0010011", -- ADDI 06, x0 => x3
    -- 2  => x"00000000",
    -- 3  => x"00000000",
    -- 4  => x"00000000",
    -- 5  => x"00000000",
    -- 6  => x"006" & B"00000" & B"111" & B"00100" & B"0010011", -- ADDI 06, x0 => x4 
    -- 7  => x"00000000",
    -- 8  => x"00000000",
    -- 9  => x"00000000",
    -- 10 => x"00000000",
    -- --11  => B"1111111" & B"00000" & B"00100" & B"111" & B"11011" & B"1100011", -- BEQ x0,x4 go - 010

    -- -- 11  => B"1111111" & B"00011" & B"00100" & B"111" & B"11111" & B"1100011", -- BEQ x3,x4 go - 010
    -- -- 11  => B"0000000" & B"00011" & B"00100" & B"111" & B"00000" & B"1100011", -- BEQ x3,x4 go - 010
    --  11  => B"0000000" & B"00011" & B"00100" & B"111" & B"00010" & B"1100011", -- BEQ x3,x4 go - 010

    -- -- 11  => B"0000000" & B"00011" & B"00100" & B"111" & B"01010" & B"1100011", -- BEQ x3,x4 go - 010


    -- -- 11  => B"1111111" & B"00000" & B"00100" & B"101" & B"11011" & B"1100011", -- BGE x0,x4 go - 010

    -- --11  => B"1111111" & B"00100" & B"00000" & B"101" & B"11111" & B"1100011", -- BGE x4,x0 go - 010
    -- -- 11  => B"0000000" & B"00100" & B"00000" & B"101" & B"00000" & B"1100011", -- BGE x4,x0 go - 010
    -- -- 11  => B"0000000" & B"00100" & B"00000" & B"101" & B"00010" & B"1100011", -- BGE x4,x0 go - 010

    -- 12  => x"0FF" & B"00100" & B"111" & B"11111" & B"0010011", -- ADDI FF, x4 => x31 
    -- 13  => x"00000000",
    -- 14  => x"00000000",
    -- 15 =>  x"00000000",
    -- 16  => x"0AA" & B"00000" & B"111" & B"01111" & B"0010011", -- ADDI FF, x4 => x31 
    -- others => x"00000000"



    0  => x"00000000",
    1  => x"006" & B"00000" & B"101" & B"00001" & B"0010011", -- ADDI 06, x0 => x1
    2  => x"006" & B"00001" & B"101" & B"00010" & B"0010011", -- ADDI 06, x1 => x2
    3  => x"00000000",
    4  => x"00000000",
    5  => x"00000000",
    6  => x"006" & B"00000" & B"101" & B"00001" & B"0010011", -- ADDI 06, x0 => x1
    7  => x"00000000",
    8  => x"006" & B"00001" & B"101" & B"00010" & B"0010011", -- ADDI 06, x1 => x2
    9  => x"00000000",
    10 => x"00000000",
    11 => x"006" & B"00000" & B"101" & B"00001" & B"0010011", -- ADDI 06, x0 => x1
    12 => x"006" & B"00001" & B"101" & B"00001" & B"0010011", -- ADDI 06, x1 => x1
    13 => x"006" & B"00001" & B"101" & B"00010" & B"0010011", -- ADDI 06, x1 => x2
    14 => x"006" & B"00000" & B"101" & B"00100" & B"0010011", -- ADDI 06, x0 => x4
    15 =>  x"00000000",
    16 => x"000" & B"11111" & B"101" & B"01010" & B"0000011", -- LD x31+0 in x10
    others => x"00000000"



    -- 0  => x"00000000", --      nop               # START

    -- 1  => x"00000093", --      addi    x1,x0,0   # *array[0] = 0
    -- 2  => x"00c08113", --      addi    x2,x1,12  # (i+1) = N
    -- 3  => x"00000b63", --      beq     x0,x0,11  #             go .L2 (3+11)

    -- 4  => x"00128293", -- .L3  addi    x5,x5,1   # j++
    -- 5  => x"00228763", --      beq     x5,x2,7   # if j=(i+1)  go .L7 (5+7)

    -- 6  => x"0002b183", -- .L4  ld      x3,0(x5)  # a = array[j]
    -- 7  => x"0012b203", --      ld      x4,1(x5)  # b = array[j+1]
    -- 8  => x"00325463", --      bge     x4,x3,4   # if b >= a   go .L3 (8-4)    L'opcode e' uguale a beq, cambia func3
    -- 9  => x"0042b023", --      sd      x4,0(x5)  # array[j]   = b
    -- 10 => x"0032b0a3", --      sd      x3,1(x5)  # array[j+1] = a
    -- 11 => x"fe0009e3", --      beq     x0,x0,-7  #             go .L3 (11-7)

    -- 12 => x"fff10113", -- .L7  addi    x2,x2,-1  # (i+1)--
    -- 13 => x"00110363", --      beq     x2,x1,3   # if (i+1)=0  go .L5 (13+3)

    -- 14 => x"00008293", -- .L2  addi    x5,x1,0   # j = 0
    -- 15 => x"fe0007e3", --      beq     x0,x0,-9  #             go .L4 (15-9)

    -- 16 => x"00000063"  -- .L5  beq     x0,x0,0   # STOP
    -- others => x"00000000"



   );
   signal read_i_address : std_logic_vector(63 downto 0):= (others => '0');
   signal l_reg_stall: std_logic;
   signal l_flush: std_logic;
   signal l_data : std_logic_vector(31 downto 0);
begin
    l_flush <= i_flush;
    l_reg_stall <= i_reg_stall;
    RamProc: process(clk) is
    begin
        if rising_edge(clk) then
          --if l_reg_stall /= '1' then
          --  l_data <= ram(to_integer(unsigned(read_i_address)));
          --elsif l_flush = '1' then
            --l_data <= (others => '0');
          --end if;

          if l_flush /= '1' then
            l_data <= ram(to_integer(unsigned(read_i_address)));
          else
            l_data <= (others => '0');
          end if;



        end if;
    end process RamProc;
    o_data <= l_data; --when l_flush /= '1' else (others => '0');
    read_i_address <= i_address when unsigned(i_address) <= LAST_ADDR else std_logic_vector(LAST_ADDR);

end architecture RTL;

    