library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 


entity pc_tb is
end entity pc_tb;

architecture RTL of pc_tb is
    signal tb_clk : std_logic := '0';
    signal tb_next_instr: std_logic_vector(63 downto 0) ;
    signal tb_branch_taken: std_logic;
    signal tb_stall: std_logic;
    constant clk_T : time := 10 ns;

    component PC
    port  ( 
            clk: in std_logic;
            i_stall: in std_logic;
            i_next_instr: in std_logic_vector(63 downto 0);
            i_branch_taken: in std_logic;
            o_r_pc: out std_logic_vector(63 downto 0);
            o_l_pc: out std_logic_vector(63 downto 0)
          );
    end component PC;

begin
    CLK: process is
    begin
        wait for clk_T/2;
        tb_clk <= not tb_clk;
    end process CLK;

    STIMULUS_GEN: process is
    begin

        wait for clk_T/2;
        tb_stall <= '0';
        tb_branch_taken <= '0';

        wait for clk_T*3;

        tb_stall <= '1';
        wait for clk_T;
        tb_stall <= '0';

        wait for clk_T*3;

        tb_branch_taken <= '1';
        tb_next_instr <= x"00ff00aa00f00a00";
        wait for clk_T*2;
        tb_branch_taken <= '0';

        wait for clk_T*10;

        tb_branch_taken <= '1';
        tb_next_instr <= x"00000000000000A0";
        wait for clk_T;
        tb_branch_taken <= '0';

        wait for clk_T*4;

        tb_branch_taken <= '1';
        tb_next_instr <= x"00000000000000A0";
        wait for clk_T;
        tb_branch_taken <= '0';

        wait for clk_T*10;

        tb_branch_taken <= '1';
        tb_next_instr <= (others => '0');
        wait for clk_T*100;
    end process STIMULUS_GEN;

    pc_to_test: pc
    Port Map (
        clk => tb_clk,
        i_stall => tb_stall,
        i_next_instr => tb_next_instr,
        i_branch_taken => tb_branch_taken,
        o_r_pc => open,
        o_l_pc => open
    );

end architecture RTL;