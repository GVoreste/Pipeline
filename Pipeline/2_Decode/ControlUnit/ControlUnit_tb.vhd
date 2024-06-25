library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 


entity controllunit_tb is
end entity controllunit_tb;

architecture RTL of controllunit_tb is
    signal tb_opcode:     std_logic_vector(6 downto 0):= (others => '0');
    constant clk_T : time := 10 ns;

    component ControllUnit 
    port ( 
            i_opcode:     in std_logic_vector(6 downto 0):= (others => '0');
            o_branch:     out std_logic := '0';
            o_mem_read:   out std_logic := '0';
            o_mem_write:  out std_logic := '0';
            o_reg_write:  out std_logic := '0';
            o_ALUsrc:     out std_logic := '0';
            o_regsrc:     out std_logic := '0';
            o_ALUOp:      out std_logic_vector(1 downto 0):= B"00"
            );
    end component ControllUnit;
begin
    STIMULUS_GEN: process is
    begin
        wait for clk_T/2;
        tb_opcode <= B"0110011";
        wait for 2*clk_T;
        tb_opcode <= B"0100011";
        wait for 2*clk_T;
        tb_opcode <= B"0000011";
        wait for 2*clk_T;
        tb_opcode <= B"1100011";
        wait for 2*clk_T;
        tb_opcode <= B"1111111";
        wait for clk_T;
        tb_opcode <= B"0000000";
        wait for 50*clk_T;

    end process STIMULUS_GEN;

    ControllUnit_to_test: ControllUnit
    Port Map (
        i_opcode => tb_opcode,
        o_branch => open,
        o_mem_read => open,
        o_mem_write => open,
        o_reg_write => open,
        o_ALUsrc => open,
        o_regsrc => open,
        o_ALUOp => open
    );
end architecture RTL;