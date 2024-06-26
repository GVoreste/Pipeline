library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 

entity ALUcontrol_tb is
end entity ALUcontrol_tb;

architecture RTL of ALUcontrol_tb is
    signal tb_ALUOp:      std_logic_vector(1 downto 0):= (others => '0');
    signal tb_func3: 	  std_logic_vector(2 downto 0):= (others => '0');
    signal tb_func7: 	  std_logic_vector(6 downto 0):= (others => '0');

    constant clk_T : time := 10 ns;

    component ALUControl
    port (
        i_ALUOp:      in std_logic_vector(1 downto 0):= (others => '0');
        i_func3:      in std_logic_vector(2 downto 0):= (others => '0');
        i_func7:      in std_logic_vector(6 downto 0):= (others => '0');
        o_ALUfunc:    out std_logic_vector(3 downto 0):= B"0000"
        );
    end component;
begin
    STIMULUS_GEN: process is
    begin
        wait for clk_T/2;
        tb_ALUOp <= B"00";
        tb_func3 <= "---";
        tb_func7 <= "-------";
        wait for clk_T;
        tb_ALUOp <= B"01";
        tb_func3 <= "---";
        tb_func7 <= "-------";
        wait for clk_T;
        tb_ALUOp <= B"10";
        tb_func3 <= B"000";
        tb_func7 <= B"0000000";
        wait for clk_T;
        tb_ALUOp <= B"11";
        tb_func3 <= B"000";
        tb_func7 <= B"0100000";
        wait for clk_T;
        tb_ALUOp <= B"10";
        tb_func3 <= B"111";
        tb_func7 <= B"0000000";
        wait for clk_T;
        tb_ALUOp <= B"11";
        tb_func3 <= B"110";
        tb_func7 <= B"0000000";
        wait for clk_T;
        tb_ALUOp <= B"00";
        tb_func3 <= B"000";
        tb_func7 <= B"0000000";
        wait for clk_T;
        tb_ALUOp <= B"11";
        tb_func3 <= B"111";
        tb_func7 <= B"1111111";
        wait for clk_T;
        wait;
    end process STIMULUS_GEN;

    ALUControl_file_to_test: ALUControl
    Port Map (
        i_ALUOp  => tb_ALUOp,
        i_func3  => tb_func3,
        i_func7  => tb_func7,
        o_ALUfunc => open
    );
end architecture RTL;