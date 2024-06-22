library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 


entity pc_tb is
end entity pc_tb;

architecture RTL of pc_tb is
    signal tb_clk : std_logic := '0';
    signal tb_nextInstr: std_logic_vector(63 downto 0) := (others => '0');
    signal tb_PCsrc: std_logic := '0';
    signal o_pc: std_logic_vector(63 downto 0);
    constant clk_T : time := 10 ns;

    component PC
    port  ( clk:         in std_logic;
            i_nextInstr: in std_logic_vector(63 downto 0):= (others => '0');
            i_PCsrc: 	in std_logic := '0';
            o_pc:        out std_logic_vector(63 downto 0)
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
        wait for clk_T*10+clk_T/4;
        tb_PCsrc <= '1';
        wait for clk_T*3;
        tb_nextInstr <= x"00ff00aa00f00a00";
        wait for clk_T*2;
        tb_PCsrc <= '0';
        wait for clk_T*10-clk_T/4;
        tb_PCsrc <= '1';
        tb_nextInstr <= (others => '0');
        wait for clk_T*100;
    end process STIMULUS_GEN;

    pc_to_test: pc
    Port Map (
        clk => tb_clk,
        i_nextInstr => tb_nextInstr,
        i_PCsrc => tb_PCsrc,
        o_pc => o_pc
    );

end architecture RTL;