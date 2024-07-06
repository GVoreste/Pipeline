library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity ControllUnit is
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
end ControllUnit;

architecture RTL of ControllUnit is
    signal l_opcode : std_logic_vector(6 downto 0);

    signal l_branch : std_logic;
    signal l_mem_rd : std_logic;
    signal l_mem_we : std_logic;
    signal l_reg_we : std_logic;
    signal l_alu_src_imm : std_logic;
    signal l_reg_src_mem : std_logic;
    signal l_alu_op : std_logic_vector(1 downto 0);
begin
    l_opcode <= i_opcode;
    process (l_opcode) is
    begin
        case l_opcode is
            when B"0110011" => -- R-format
                l_branch <= '0';
                l_mem_rd <= '0';
                l_mem_we <= '0';
                l_reg_we <= '1';
                l_alu_src_imm <= '0';
                l_reg_src_mem <= '0';
                l_alu_op <= B"10";
            when B"0100011" => -- SD
                l_branch <= '0';
                l_mem_rd <= '0';
                l_mem_we <= '1';
                l_reg_we <= '0';
                l_alu_src_imm <= '1';
                l_reg_src_mem <= '-';
                l_alu_op <= B"00";
            when B"0000011" => -- LD
                l_branch <= '0';
                l_mem_rd <= '1';
                l_mem_we <= '0';
                l_reg_we <= '1';
                l_alu_src_imm <= '1';
                l_reg_src_mem <= '1';
                l_alu_op <= B"00";
            when B"1100011" => -- BEQ BGE
                l_branch <= '1';
                l_mem_rd <= '0';
                l_mem_we <= '0';
                l_reg_we <= '0';
                l_alu_src_imm <= '0';
                l_reg_src_mem <= '-';
                l_alu_op <= B"01";
            when B"0010011" => -- ADDI
                l_branch <= '0';
                l_mem_rd <= '0';
                l_mem_we <= '0';
                l_reg_we <= '1';
                l_alu_src_imm <= '1';
                l_reg_src_mem <= '0';
                l_alu_op <= B"00";
            when others => -- NOP and unknown
                l_branch <= '0';
                l_mem_rd <= '0';
                l_mem_we <= '0';
                l_reg_we <= '0';
                l_alu_src_imm <= '0';
                l_reg_src_mem <= '0';
                l_alu_op <= B"00";
        end case;
    end process;
    o_branch <= l_branch;
    o_mem_rd <= l_mem_rd;
    o_mem_we <= l_mem_we;
    o_reg_we <= l_reg_we;
    o_alu_src_imm <= l_alu_src_imm;
    o_reg_src_mem <= l_reg_src_mem;
    o_alu_op <= l_alu_op;
end architecture;