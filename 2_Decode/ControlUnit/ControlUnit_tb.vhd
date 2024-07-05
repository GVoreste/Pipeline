library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity controlunit_tb is
end entity controlunit_tb;

architecture RTL of controlunit_tb is
    signal tb_opcode : std_logic_vector(6 downto 0) := (others => '0');
    constant clk_T : time := 10 ns;

    component ControllUnit
        port (
            i_opcode : in std_logic_vector(6 downto 0);
            o_branch : out std_logic;
            o_mem_rd : out std_logic;
            o_mem_we : out std_logic;
            o_reg_we : out std_logic;
            o_alu_src_imm : out std_logic;
            o_reg_src_mem : out std_logic;
            o_alu_op : out std_logic_vector(1 downto 0)
        );
    end component ControllUnit;
begin
    STIMULUS_GEN : process is
    begin
        wait for clk_T/2;
        tb_opcode <= B"0110011";
        wait for 2 * clk_T;
        tb_opcode <= B"0100011";
        wait for 2 * clk_T;
        tb_opcode <= B"0000011";
        wait for 2 * clk_T;
        tb_opcode <= B"1100011";
        wait for 2 * clk_T;
        tb_opcode <= B"1111111";
        wait for clk_T;
        tb_opcode <= B"0000000";
        wait for 50 * clk_T;

    end process STIMULUS_GEN;

    ControllUnit_to_test : ControllUnit
    port map(
        i_opcode => tb_opcode,
        o_branch => open,
        o_mem_rd => open,
        o_mem_we => open,
        o_reg_we => open,
        o_alu_src_imm => open,
        o_reg_src_mem => open,
        o_alu_op => open
    );
end architecture RTL;