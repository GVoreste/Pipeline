library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;


entity HDU is
    port(
        i_branch: in std_logic;
        o_PC_stall: out std_logic;
        o_Fetch_reg_stall: out std_logic;
        o_Decode_reg_stall: out std_logic
    );
end entity;


architecture RTL of HDU is
begin
    -- o_PC_stall <= '1' when i_branch='1' else '0';
    o_Fetch_reg_stall <= '1' when i_branch='1' else '0';

end architecture RTL;