library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;


entity HDU is
    port(
        -- clk: in std_logic := '0';
        o_PC_stall: out std_logic := 0;
        o_Fetch_reg_stall: out std_logic := 0;
        o_Decode_reg_stall: out std_logic := 0;
    );
end entity;
