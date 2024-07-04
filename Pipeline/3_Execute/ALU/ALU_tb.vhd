library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 

entity ALU_tb is
end entity ALU_tb;

architecture RTL of ALU_tb is
    type operand_table is array(0 to 99) of std_logic_vector(63 downto 0);
    signal tb_operand_A: std_logic_vector(63 downto 0):= (others => '0');
    signal tb_operand_B: std_logic_vector(63 downto 0):= (others => '0');
    constant tb_operand_A_table: operand_table := (
        0 => x"AAAA00000000AAAA",
        1 => x"FFFFFFFFFFFFFFFF",
        2 => x"AAAAAAAAAAAAAAAA",
        3 => x"5555000000005555",
        4 => x"FFFFFFFFFFFFFFFF",
        5 => x"3333666666663333",
        6 => x"0123456789ABCDEF",
        7 => x"0000000000000000",
        8 => x"0123456789ABCDEF",
        others => (others => '0')
    );
    constant tb_operand_B_table: operand_table := (
        0 => x"AAAA00000000AAAA",
        1 => x"FFFFFFFFFFFFFFFF",
        2 => x"5555555555555555",
        3 => x"5555000000005555",
        4 => x"0000000000000001",
        5 => x"6666333333336666",
        6 => x"0000000000000000",
        7 => x"FEDCBA9876543210",
        8 => x"FEDCBA9876543210",
        others => (others => '0')
    );
    signal tb_ALUfunc:      std_logic_vector(3 downto 0):= (others => '0');   
    constant clk_T : time := 10 ns;

    component ALU
        port ( 
            i_operand_A: in std_logic_vector(63 downto 0):= (others => '0');
            i_operand_B: in std_logic_vector(63 downto 0):= (others => '0');
            i_ALU_func:   in std_logic_vector( 3 downto 0):= (others => '0');
            o_Zero:      out std_logic := '0';
            o_Pos:       out std_logic := '0';
            o_ALUres:    out std_logic_vector(63 downto 0):=(others => '0')
            );
    end component ALU;
begin
    STIMULUS_GEN: process is
    begin
        wait for clk_T/2;
        for i in 0 to 99
        loop
            tb_operand_A <= tb_operand_A_table(i);
            tb_operand_B <= tb_operand_A_table(i);
            
            tb_ALUfunc   <= "0010"; -- ADD
            wait for clk_T;
            tb_ALUfunc   <= "0110"; -- SUB
            wait for clk_T;
            tb_ALUfunc   <= "0000"; -- OR
            wait for clk_T;
            tb_ALUfunc   <= "0001"; -- AND
            wait for clk_T;
            tb_ALUfunc   <= "1111"; -- UNKOWN
            wait for clk_T;
        end loop;
        wait;
    end process STIMULUS_GEN;

    ALU_file_to_test: ALU
    Port Map (
        i_operand_A => tb_operand_A,
        i_operand_B => tb_operand_B,
        i_ALU_func => tb_ALUfunc,
        o_Zero => open,
        o_Pos => open,
        o_ALUres => open
    );
end architecture RTL;