library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 


entity ImmediateGen_tb is
end entity ImmediateGen_tb;

architecture RTL of ImmediateGen_tb is
    signal tb_instr:     std_logic_vector(31 downto 0):= (others => '0');
    constant clk_T : time := 10 ns;

    component ImmGen 
    port ( 
            i_instr:      in std_logic_vector(31 downto 0):= (others => '0');
            o_imm:        out std_logic_vector(63 downto 0):= (others => '0')
            );
    end component ImmGen;
begin
    STIMULUS_GEN: process is
    variable opcode: std_logic_vector(6 downto 0):= (others => '0');
    begin
        wait for clk_T/2;
        opcode := B"0000001";
        tb_instr <= B"111110100101_00000_000_00000" & opcode;
        wait for 2*clk_T;
        opcode := B"0000010";
        tb_instr <= B"1111101_00000_00000_000_00101" & opcode;
        wait for 2*clk_T;
        opcode := B"0000011";
        tb_instr <=  B"1_11101_00000_00000_000_00101_1" & opcode;
        wait for 2*clk_T;
        tb_instr <=  x"FFFF_FFFF";
        wait for clk_T;
        tb_instr <=  x"0000_0000";
        wait for clk_T/2;
        opcode := B"0000001";
        tb_instr <= B"010110101111_00000_000_00000" & opcode;
        wait for 2*clk_T;
        opcode := B"0000010";
        tb_instr <= B"0101101_00000_00000_000_01111" & opcode;
        wait for 2*clk_T;
        opcode := B"0000011";
        tb_instr <=  B"0_01101_00000_00000_000_01111_1" & opcode;
        wait for 50*clk_T;

    end process STIMULUS_GEN;

    ImmGen_to_test: ImmGen
    Port Map (
        i_instr => tb_instr,
        o_imm => open
    );
end architecture RTL;