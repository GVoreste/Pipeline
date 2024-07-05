library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity Processor_tb is
end entity;

architecture RTL of Processor_tb is
    component CPU
        port (
            clk : in std_logic := '0'
        );
    end component;
    constant clk_T : time := 10 ns;
    signal tb_clk : std_logic := '0';
begin
    CLK : process is
    begin
        wait for clk_T/2;
        tb_clk <= not tb_clk;
    end process CLK;

    PROCESSOR_UNIT : CPU
    port map(
        clk => tb_clk
    );
end architecture;