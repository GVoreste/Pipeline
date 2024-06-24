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
    clk   : in  std_logic;
    i_we      : in  std_logic;
    i_address : in  std_logic_vector;
    i_data    : in  std_logic_vector;
    o_data    : out std_logic_vector
  );
end entity sync_ram;

architecture RTL of sync_ram is

   type ram_type is array (0 to (2**i_address'length)-1) of std_logic_vector(i_data'range);
   signal ram : ram_type;
   signal read_i_address : std_logic_vector(i_address'range);

begin

    RamProc: process(clk) is
    begin
        if rising_edge(clk) then
            if i_we = '1' then
            ram(to_integer(unsigned(i_address))) <= i_data;
            end if;
            read_i_address <= i_address;
        end if;
    end process RamProc;

    o_data <= ram(to_integer(unsigned(read_i_address)));

end architecture RTL;

    