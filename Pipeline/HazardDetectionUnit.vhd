library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;


entity HDU is
    port(
        clk: in std_logic;
        i_branch: in std_logic;
        i_branch_taken: in std_logic;
        i_reg_A: in std_logic_vector(4 downto 0);
        i_reg_B: in std_logic_vector(4 downto 0);
        i_alu_src_imm: in std_logic;
        i_Execute_reg_w: in std_logic_vector(4 downto 0);
        i_Execute_reg_we: in std_logic;
        i_MemAccess_reg_w: in std_logic_vector(4 downto 0);
        i_MemAccess_reg_we: in std_logic;
        o_Fetch_stall: out std_logic;
        o_Fetch_flush: out std_logic;
        o_Decode_stall: out std_logic
    );
end entity;


architecture RTL of HDU is
    signal l_Fetch_stall: std_logic;
    signal r_Fetch_stall: std_logic;
begin
    process(clk) is
    begin
        if rising_edge(clk) then
        r_Fetch_stall <= l_Fetch_stall;
        end if;
    end process;
 

    --o_Fetch_reg_stall <= '1' when i_branch='1' and (i_taken='0' and i_untaken='0') else '0';
    --o_Fetch_flush <= '1' when i_taken='1' else '0';
    l_Fetch_stall <= '1' when i_branch='1' and r_Fetch_stall/='1' else '0';
    o_Fetch_stall <= l_Fetch_stall;
    --o_Decode_stall <= '1' when i_branch='1' else '0';
    o_Fetch_flush <= '0';
end architecture RTL;