library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 


entity pc_tb is
end entity pc_tb;

architecture RTL of pc_tb is
    signal tb_clk : std_logic := '0';
    signal tb_nextInstr: std_logic_vector(63 downto 0) ;
    signal tb_PCsrc: std_logic;
    signal tb_PCstall: std_logic;
    signal tb_reg_stall: std_logic;
    constant clk_T : time := 10 ns;

    component PC
    port  ( clk:         in std_logic;
            i_reg_stall: 	 in std_logic;
            i_nextInstr: in std_logic_vector(63 downto 0);
            i_PCsrc: 	 in std_logic;
            i_PCstall:   in std_logic;
            o_pc:        out std_logic_vector(63 downto 0);
            o_l_pc:        out std_logic_vector(63 downto 0)
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
        --wait for 0.1 ns;
        wait for clk_T/2;
        tb_PCstall <= '0';
        tb_reg_stall <= '0';
        tb_PCsrc <= '0';

        wait for clk_T*3;

        tb_PCstall <= '1';
        wait for clk_T*3;
        tb_PCstall <= '0';

        wait for clk_T*3;

        tb_reg_stall <= '1';
        wait for clk_T*3;
        tb_reg_stall <= '0';

        wait for clk_T*3;

        tb_PCsrc <= '1';
        tb_nextInstr <= x"00ff00aa00f00a00";
        wait for clk_T*2;
        tb_PCsrc <= '0';

        wait for clk_T*10;

        tb_PCsrc <= '1';
        tb_nextInstr <= x"00000000000000A0";
        wait for clk_T;
        tb_PCsrc <= '0';

        wait for clk_T*4;

        tb_PCstall <= '1';
        wait for clk_T;
        tb_PCstall <= '0';


        wait for clk_T*4;

        tb_reg_stall <= '1';
        wait for clk_T;
        tb_reg_stall <= '0';

        wait for clk_T*4;

        tb_PCstall <= '1';
        wait for clk_T;
        tb_reg_stall <= '1';
        tb_PCstall <= '0';
        wait for clk_T;
        tb_reg_stall <= '0';

        wait for clk_T*4;

        tb_reg_stall <= '1';
        wait for clk_T;
        tb_reg_stall <= '0';
        tb_PCstall <= '1';
        wait for clk_T;
        tb_PCstall <= '0';

        wait for clk_T*4;

        tb_reg_stall <= '1';
        tb_PCstall <= '1';
        wait for clk_T;
        tb_reg_stall <= '0';
        tb_PCstall <= '0';

        wait for clk_T*4;

        tb_PCsrc <= '1';
        tb_PCstall <= '1';
        tb_nextInstr <= x"00000000000000A0";
        wait for clk_T;
        tb_PCstall <= '0';
        tb_PCsrc <= '0';

        wait for clk_T*10;

        tb_PCsrc <= '1';
        tb_nextInstr <= (others => '0');
        wait for clk_T*100;
    end process STIMULUS_GEN;

    pc_to_test: pc
    Port Map (
        clk => tb_clk,
        i_reg_stall => tb_reg_stall,
        i_nextInstr => tb_nextInstr,
        i_PCsrc => tb_PCsrc,
        i_PCstall => tb_PCstall,
        o_pc => open,
        o_l_pc => open
    );

end architecture RTL;