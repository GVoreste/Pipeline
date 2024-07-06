library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity Execute is
    port (
        clk : in std_logic;
        i_pc : in std_logic_vector(63 downto 0);
        i_data_a : in std_logic_vector(63 downto 0);
        i_data_b : in std_logic_vector(63 downto 0);
        i_imm : in std_logic_vector(63 downto 0);
        i_reg_w : in std_logic_vector(4 downto 0);
        i_func7 : in std_logic_vector(6 downto 0);
        i_func3 : in std_logic_vector(2 downto 0);
        -- Controll signal
        i_branch : in std_logic;
        i_mem_rd : in std_logic;
        i_mem_we : in std_logic;
        i_reg_we : in std_logic;
        i_alu_src_imm : in std_logic;
        i_reg_src_mem : in std_logic;
        i_alu_op : in std_logic_vector(1 downto 0);
        --
        -- OUT
        --
        o_l_next_instr : out std_logic_vector(63 downto 0);
        o_r_alu_res : out std_logic_vector(63 downto 0);
        o_r_data_mem : out std_logic_vector(63 downto 0);
        o_r_reg_w : out std_logic_vector(4 downto 0);
        -- Controll signal
        o_r_mem_rd : out std_logic;
        o_r_mem_we : out std_logic;
        o_r_reg_we : out std_logic;
        o_r_reg_src_mem : out std_logic;
        -- Jump
        o_l_branch_taken : out std_logic
    );
end entity;

architecture RTL of Execute is
    component Adder
        port (
            i_operand_a : in std_logic_vector(63 downto 0);
            i_operand_b : in std_logic_vector(63 downto 0);
            i_sub : in std_logic;
            o_res : out std_logic_vector(63 downto 0)
        );
    end component;
    component ALU
        port (
            i_operand_A : in std_logic_vector(63 downto 0);
            i_operand_B : in std_logic_vector(63 downto 0);
            i_alu_func : in std_logic_vector(3 downto 0);
            o_zero : out std_logic;
            o_pos : out std_logic;
            o_alu_res : out std_logic_vector(63 downto 0)
        );
    end component ALU;
    component ALUControl
        port (
            i_alu_op : in std_logic_vector(1 downto 0);
            i_func3 : in std_logic_vector(2 downto 0);
            i_func7 : in std_logic_vector(6 downto 0);
            o_bge : out std_logic := '0';
            o_alu_func : out std_logic_vector(3 downto 0)
        );
    end component;
    signal l_alu_func : std_logic_vector(3 downto 0);
    signal l_data_b : std_logic_vector(63 downto 0);
    signal l_next_instr : std_logic_vector(63 downto 0);
    signal l_alu_res : std_logic_vector(63 downto 0);
    signal r_alu_res : std_logic_vector(63 downto 0);
    signal l_data_mem : std_logic_vector(63 downto 0);
    signal r_data_mem : std_logic_vector(63 downto 0);
    signal l_reg_w : std_logic_vector(4 downto 0);
    signal r_reg_w : std_logic_vector(4 downto 0);
    --
    signal l_branch : std_logic;
    signal r_branch : std_logic;
    signal l_mem_rd : std_logic;
    signal r_mem_rd : std_logic;
    signal l_mem_we : std_logic;
    signal r_mem_we : std_logic;
    signal l_reg_we : std_logic;
    signal r_reg_we : std_logic;
    signal l_reg_src_mem : std_logic;
    signal r_reg_src_mem : std_logic;

    signal l_branch_taken : std_logic;
    signal l_pos : std_logic;
    signal l_zero : std_logic;
    signal l_bge : std_logic;
    signal l_imm_jump : std_logic_vector(63 downto 0);
    signal l_imm_jump_corrected : std_logic_vector(63 downto 0);
begin
    l_reg_w <= i_reg_w;
    l_data_mem <= i_data_b;

    l_data_b <= i_data_b when i_alu_src_imm /= '1' else
                i_imm;
    l_imm_jump <= i_imm(63 downto 0); -- i_imm(62 downto 0) & B"0";

    l_branch <= i_branch;

    l_mem_rd <= i_mem_rd;
    l_mem_we <= i_mem_we;
    l_reg_we <= i_reg_we;
    l_reg_src_mem <= i_reg_src_mem;

    l_branch_taken <= '1' when l_branch = '1' and (
                      (l_pos = '1' and l_bge = '1') or
                      (l_zero = '1' and l_bge /= '1')
                      ) else
                      '0';
    l_branch <= i_branch;

    process (clk) is
    begin
        if rising_edge(clk) then
            r_alu_res <= l_alu_res;
            r_data_mem <= l_data_mem;
            r_reg_w <= l_reg_w;
            -- Controll signal
            r_mem_rd <= l_mem_rd;
            r_mem_we <= l_mem_we;
            r_reg_we <= l_reg_we;
            r_reg_src_mem <= l_reg_src_mem;
        end if;
    end process;
    o_r_alu_res <= r_alu_res;
    o_r_data_mem <= r_data_mem;
    o_r_reg_w <= r_reg_w;
    -- Controll signal
    o_r_mem_rd <= r_mem_rd;
    o_r_mem_we <= r_mem_we;
    o_r_reg_we <= r_reg_we;
    o_r_reg_src_mem <= r_reg_src_mem;

    o_l_branch_taken <= l_branch_taken;

    ALU_INST : ALU
    port map(
        i_operand_A => i_data_a,
        i_operand_B => l_data_b,
        i_alu_func => l_alu_func,
        o_zero => l_zero,
        o_pos => l_pos,
        o_alu_res => l_alu_res
    );

    ALU_CNTL_INST : ALUControl
    port map(
        i_alu_op => i_alu_op,
        i_func3 => i_func3,
        i_func7 => i_func7,
        o_bge => l_bge,
        o_alu_func => l_alu_func
    );

    CORRECTION_ADDER : Adder
    port map(
        i_operand_A => l_imm_jump,
        i_operand_B => (others => '0'), --(others => '1'),
        i_sub => '0',
        o_res => l_imm_jump_corrected
    );

    ADDER_ADDRESS : Adder
    port map(
        i_operand_A => i_pc,
        i_operand_B => l_imm_jump_corrected,
        i_sub => '0',
        o_res => o_l_next_instr
    );

end architecture;