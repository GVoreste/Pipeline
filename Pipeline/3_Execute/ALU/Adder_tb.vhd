library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 

entity Adder_tb is
end entity Adder_tb;

architecture RTL of Adder_tb is
    signal tb_clk : std_logic := '0';
    signal tb_operand_A:      std_logic_vector(63 downto 0):= (others => '0');
    signal tb_operand_B: 	  std_logic_vector(63 downto 0):= (others => '0');
    signal tb_sub: std_logic := '0';
    constant clk_T : time := 10 ns;

    component Adder 
        port (
               i_operand_A:     in std_logic_vector(63 downto 0):= (others => '0');
               i_operand_B: 	in std_logic_vector(63 downto 0):= (others => '0');
               i_sub:           in std_logic := '0';
               o_res:           out std_logic_vector(63 downto 0):= (others => '0')
               );
    end component Adder;
begin
    CLK: process is
    begin
        wait for clk_T/2;
        tb_clk <= not tb_clk;
    end process CLK;

    STIMULUS_GEN: process is
    begin
        wait for clk_T/2;
        -- ADD
        tb_sub <= '0';
        tb_operand_A <= x"AAAA00000000AAAA";
        tb_operand_B <= x"AAAA00000000AAAA";
        -- 5554000000015554
        wait for clk_T;
        tb_operand_A <= x"FFFFFFFFFFFFFFFF";
        tb_operand_B <= x"FFFFFFFFFFFFFFFF";
        -- FFFFFFFFFFFFFFFE
        wait for clk_T;
        tb_operand_A <= x"AAAAAAAAAAAAAAAA";
        tb_operand_B <= x"5555555555555555";
        -- FFFFFFFFFFFFFFFF
        wait for clk_T;
        tb_operand_A <= x"5555000000005555";
        tb_operand_B <= x"5555000000005555";
        -- AAAA00000000AAAA
        wait for clk_T;
        tb_operand_A <= x"FFFFFFFFFFFFFFFF";
        tb_operand_B <= x"0000000000000001";
        -- 0000000000000000
        wait for clk_T;
        tb_operand_A <= x"3333666666663333";
        tb_operand_B <= x"6666333333336666";
        -- 9999999999999999
        wait for clk_T;
        tb_operand_A <= x"0123456789ABCDEF";
        tb_operand_B <= x"0000000000000000";
        -- 0123456789ABCDEF
        wait for clk_T;
        tb_operand_A <= x"0000000000000000";
        tb_operand_B <= x"FEDCBA9876543210";
        -- FEDCBA9876543210
        wait for clk_T;
        tb_operand_A <= x"0123456789ABCDEF";
        tb_operand_B <= x"FEDCBA9876543210";
        -- FFFFFFFFFFFFFFFF
        wait for clk_T;
        tb_operand_A <= x"0000000000000000";
        tb_operand_B <= x"0000000000000000";
        -- 0000000000000000
        wait for 3*clk_T;
        -- SUB
        tb_sub <= '1';
        tb_operand_A <= x"AAAA00000000AAAA";
        tb_operand_B <= x"AAAA00000000AAAA";
        -- 0000000000000000
        wait for clk_T;
        tb_operand_A <= x"FFFFFFFFFFFFFFFF";
        tb_operand_B <= x"FFFFFFFFFFFFFFFF";
        -- 0000000000000000
        wait for clk_T;
        tb_operand_A <= x"AAAAAAAAAAAAAAAA";
        tb_operand_B <= x"5555555555555555";
        -- 5555555555555555
        wait for clk_T;
        tb_operand_A <= x"5555000000005555";
        tb_operand_B <= x"5555000000005555";
        -- 0000000000000000
        wait for clk_T;
        tb_operand_A <= x"FFFFFFFFFFFFFFFF";
        tb_operand_B <= x"0000000000000001";
        -- FFFFFFFFFFFFFFFE
        wait for clk_T;
        tb_operand_A <= x"3333666666663333";
        tb_operand_B <= x"6666333333336666";
        -- CCCD33333332CCCD
        wait for clk_T;
        tb_operand_A <= x"0123456789ABCDEF";
        tb_operand_B <= x"0000000000000000";
        -- 0123456789ABCDEF
        wait for clk_T;
        tb_operand_A <= x"0000000000000000";
        tb_operand_B <= x"FEDCBA9876543210";
        -- 0123456789ABCDF0
        wait for clk_T;
        tb_operand_A <= x"0123456789ABCDEF";
        tb_operand_B <= x"FEDCBA9876543210";
        -- 02468ACF13579BDF
        wait for clk_T;
        tb_operand_A <= x"0000000000000000";
        tb_operand_B <= x"0000000000000000";
        -- 0000000000000000
        wait;
    end process STIMULUS_GEN;

    Adder_file_to_test: Adder
    Port Map (
        i_operand_A  => tb_operand_A,
        i_operand_B  => tb_operand_B,
        i_sub => tb_sub,
        o_res => open
    );
end architecture RTL;



