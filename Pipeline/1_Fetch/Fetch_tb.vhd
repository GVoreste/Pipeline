library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 


entity Fetch_tb is
end entity Fetch_tb;

architecture RTL of Fetch_tb is
    signal tb_clk : std_logic := '0';
    signal tb_nextInstr: std_logic_vector(63 downto 0) := (others => '0');
    signal tb_PCsrc: std_logic := '0';
    signal tb_PCstall: std_logic := '0';
    signal tb_reg_stall: std_logic := '0';
    signal o_PC: std_logic_vector(63 downto 0);
    signal o_instr: std_logic_vector(31 downto 0):= (others => '0');
    constant clk_T : time := 10 ns;

    component Fetch
    port  ( 
            clk:         in std_logic;
            i_nextInstr: in std_logic_vector(63 downto 0):= (others => '0');
            i_PCsrc: 	 in std_logic := '0';
            i_PCstall:   in std_logic := '0';
            i_reg_stall: in std_logic := '0';
            o_PC:        out std_logic_vector(63 downto 0):= (others => '0');
            o_instr:     out std_logic_vector(31 downto 0):= (others => '0')
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

        tb_reg_stall <= '1';
        wait for clk_T;
        tb_reg_stall <= '0';

        wait for clk_T*5;

        tb_nextInstr <= std_logic_vector(to_unsigned(0,64));
        wait for clk_T;
        tb_PCsrc <= '1';
        wait for clk_T*5;
        tb_nextInstr <= std_logic_vector(to_unsigned(50,64));
        wait for clk_T*5;
        tb_PCsrc <= '0';

        wait for clk_T*5;

        tb_PCsrc <= '1';
        tb_nextInstr <= std_logic_vector(to_unsigned(0,64));
        wait for clk_T;
        tb_PCsrc <= '0';

        wait for clk_T*9;

        tb_PCstall <= '1';
        wait for clk_T;
        tb_PCstall <= '0';

        wait for clk_T;
    end process STIMULUS_GEN;

    Fetch_to_test: Fetch
    Port Map (
        clk => tb_clk,
        i_nextInstr => tb_nextInstr,
        i_PCsrc => tb_PCsrc,
        i_PCstall => tb_PCstall,
        i_reg_stall => tb_reg_stall,
        o_PC => o_PC,
        o_instr => o_instr
    );

end architecture RTL;