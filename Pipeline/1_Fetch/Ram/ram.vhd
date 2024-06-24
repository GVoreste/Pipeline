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
  port (
    clk       : in  std_logic;
    i_we      : in  std_logic := '0';
    i_address : in  std_logic_vector(63 downto 0):= (others => '0');
    i_data    : in  std_logic_vector(31 downto 0):= (others => '0');
    o_data    : out std_logic_vector
  );
  constant RAM_SIZE: integer := 256;
  constant LAST_ADDR: unsigned(i_data'range) := to_unsigned(RAM_SIZE-1,i_data'length);
end entity sync_ram;

architecture RTL of sync_ram is

   type ram_type is array (0 to RAM_SIZE-1) of std_logic_vector(i_data'range);
   signal ram : ram_type := (
    0 to 3 => x"0000F000",
    4 to 7 => x"0000F004",
    8 to 11 => x"0000F008",
    12 to 15 => x"0000F00C",
    16 to 19 => x"0000F010",
    20 to 23 => x"0000F014",
    24 to 27 => x"0000F018",
    28 to 31 => x"0000F01C",
    32 to 35 => x"0000F020",
    36 to 39 => x"0000F024",
    40 to 49 => x"0000F028",
    others => x"00000000"
   );
   signal read_i_address : std_logic_vector(63 downto 0):= (others => '0');

begin
    -- Initialization: process(clk) is
    -- -- variable init: boolean := true;
    -- begin
    --   -- if init then 
    --   -- init := false;
    --   for i in 0 to to_integer(LAST_ADDR)
    --   loop

    --     -- ram(i) <= std_logic_vector(to_unsigned(i,i_data'length)); 
    --     ram(i) <= x"000000ff";
    --     report integer'image(i)&
    --            std_logic'image(ram(i)(15))&
    --            std_logic'image(ram(i)(14))&
    --            std_logic'image(ram(i)(13))&
    --            std_logic'image(ram(i)(12))&
    --            std_logic'image(ram(i)(11))&
    --            std_logic'image(ram(i)(10))&
    --            std_logic'image(ram(i)(11))&
    --            std_logic'image(ram(i)(10))&
    --            std_logic'image(ram(i)(9))&
    --            std_logic'image(ram(i)(8))&
    --            std_logic'image(ram(i)(7))&
    --            std_logic'image(ram(i)(6))&
    --            std_logic'image(ram(i)(5))&
    --            std_logic'image(ram(i)(4))&
    --            std_logic'image(ram(i)(3))&
    --            std_logic'image(ram(i)(2))&
    --            std_logic'image(ram(i)(1))&
    --            std_logic'image(ram(i)(0));
    --   end loop;
    --   -- end if;
    --   -- wait;
    -- end process;

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

    