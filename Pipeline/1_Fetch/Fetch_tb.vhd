library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 


entity Fetch_tb is
end entity Fetch_tb;

architecture RTL of Fetch_tb is
    signal tb_clk : std_logic := '0';
    signal tb_next_instr: std_logic_vector(63 downto 0) := (others => '0');
    signal tb_branch_taken: std_logic := '0';
    signal tb_stall: std_logic := '0';
    signal tb_flush: std_logic := '0';
    constant clk_T : time := 10 ns;

    component Fetch
    port  ( 
        clk: in std_logic;
        i_flush: in std_logic;
        i_stall: in std_logic;
        i_branch_taken: in std_logic;
        i_next_instr: in std_logic_vector(63 downto 0);
        o_r_pc: out std_logic_vector(63 downto 0);
        o_r_instr: out std_logic_vector(31 downto 0)
    );
    end component Fetch;

begin
    CLK: process is
    begin
        wait for clk_T/2;
        tb_clk <= not tb_clk;
    end process CLK;

    STIMULUS_GEN: process is
    begin
        wait for clk_T/2;

        wait for clk_T*7;

        tb_stall <= '1';
        wait for clk_T;
        tb_stall <= '0';

        wait for clk_T*5;

        tb_next_instr <= std_logic_vector(to_unsigned(0,64));
        wait for clk_T;
        tb_branch_taken <= '1';
        wait for clk_T*5;
        tb_next_instr <= std_logic_vector(to_unsigned(50,64));
        wait for clk_T*5;
        tb_branch_taken <= '0';

        wait for clk_T*5;

        tb_branch_taken <= '1';
        tb_next_instr <= std_logic_vector(to_unsigned(0,64));
        wait for clk_T;
        tb_branch_taken <= '0';

        wait for clk_T*9;

        tb_flush <= '1';
        wait for clk_T;
        tb_flush <= '0';

        wait for clk_T;
    end process STIMULUS_GEN;

    Fetch_to_test: Fetch
    Port Map (
        clk => tb_clk,
        i_flush => tb_flush,
        i_stall => tb_stall,
        i_branch_taken => tb_branch_taken,
        i_next_instr => tb_next_instr,
        o_r_pc => open,
        o_r_instr => open
    );

end architecture RTL;