library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity CPU is
    port (
        clk : in std_logic := '0'
    );
end entity;

architecture RTL of CPU is

    signal l_HDU_Fetch_stall : std_logic;
    signal r_Fetch_pc : std_logic_vector(63 downto 0);
    signal r_Fetch_instr : std_logic_vector(31 downto 0);

    signal l_HDU_Decode_stall : std_logic;
    signal r_Decode_pc : std_logic_vector(63 downto 0);
    signal r_Decode_data_a : std_logic_vector(63 downto 0);
    signal r_Decode_data_b : std_logic_vector(63 downto 0);
    signal r_Decode_imm : std_logic_vector(63 downto 0);

    signal r_Decode_reg_w : std_logic_vector(4 downto 0);
    signal r_Decode_func7 : std_logic_vector(6 downto 0);
    signal r_Decode_func3 : std_logic_vector(2 downto 0);
    signal l_Decode_reg_A : std_logic_vector(4 downto 0);
    signal l_Decode_reg_B : std_logic_vector(4 downto 0);

    signal l_Decode_branch : std_logic;
    signal r_Decode_branch : std_logic;
    signal r_Decode_mem_rd : std_logic;
    signal r_Decode_mem_we : std_logic;

    signal r_Decode_reg_we : std_logic;

    signal l_Decode_ALU_src_imm : std_logic;
    signal r_Decode_ALU_src_imm : std_logic;

    signal r_Decode_reg_src_mem : std_logic;
    signal r_Decode_alu_op : std_logic_vector(1 downto 0) := B"00";

    signal l_Execute_next_instr : std_logic_vector(63 downto 0);
    signal r_Execute_alu_res : std_logic_vector(63 downto 0);
    signal r_Execute_data_mem : std_logic_vector(63 downto 0);
    signal l_Execute_reg_w : std_logic_vector(4 downto 0);
    signal r_Execute_reg_w : std_logic_vector(4 downto 0);

    signal r_Execute_mem_rd : std_logic;
    signal r_Execute_mem_we : std_logic;
    signal l_Execute_reg_we : std_logic;
    signal r_Execute_reg_we : std_logic;
    signal r_Execute_reg_src_mem : std_logic;

    signal l_Execute_branch : std_logic;
    signal l_Execute_branch_taken : std_logic;

    --
    signal r_MemAccess_mem_data : std_logic_vector(63 downto 0);
    signal r_MemAccess_alu_res : std_logic_vector(63 downto 0);
    signal r_MemAccess_reg_w : std_logic_vector(4 downto 0);

    signal r_MemAccess_reg_src_mem : std_logic := '0';
    signal r_MemAccess_reg_we : std_logic := '0';
    --
    signal l_WriteBack_data_reg : std_logic_vector(63 downto 0);

    component HDU port (
        clk : in std_logic;
        i_branch : in std_logic;
        i_branch_taken : in std_logic;
        i_reg_A : in std_logic_vector(4 downto 0);
        i_reg_B : in std_logic_vector(4 downto 0);
        i_alu_src_imm : in std_logic;
        i_Execute_reg_w : in std_logic_vector(4 downto 0);
        i_Execute_reg_we : in std_logic;
        i_MemAccess_reg_w : in std_logic_vector(4 downto 0);
        i_MemAccess_reg_we : in std_logic;
        o_Fetch_stall : out std_logic;
        o_Decode_stall : out std_logic
        );
    end component;

    component Fetch port (
        clk : in std_logic;
        i_stall : in std_logic;
        i_branch_taken : in std_logic;
        i_next_instr : in std_logic_vector(63 downto 0);
        o_r_pc : out std_logic_vector(63 downto 0);
        o_r_instr : out std_logic_vector(31 downto 0)
        );
    end component;

    component Decode port (
        clk : in std_logic;
        i_instr : in std_logic_vector(31 downto 0);
        i_pc : in std_logic_vector(63 downto 0);
        i_w_reg : in std_logic_vector(4 downto 0);
        i_data_reg : in std_logic_vector(63 downto 0);
        i_reg_we : in std_logic;
        i_stall : in std_logic;
        --i_taken_branch:  in std_logic;
        --
        -- OUT
        --
        o_r_pc : out std_logic_vector(63 downto 0);
        o_r_data_a : out std_logic_vector(63 downto 0);
        o_r_data_b : out std_logic_vector(63 downto 0);
        o_r_imm : out std_logic_vector(63 downto 0);
        o_r_reg_w : out std_logic_vector(4 downto 0);
        o_r_func7 : out std_logic_vector(6 downto 0);
        o_r_func3 : out std_logic_vector(2 downto 0);
        o_l_reg_a : out std_logic_vector(4 downto 0);
        o_l_reg_b : out std_logic_vector(4 downto 0);
        -- Controll signal
        o_l_branch : out std_logic;
        o_r_branch : out std_logic;
        o_r_mem_rd : out std_logic;
        o_r_mem_we : out std_logic;
        o_r_reg_we : out std_logic;
        o_l_alu_src_imm : out std_logic;
        o_r_alu_src_imm : out std_logic;
        o_r_reg_src_mem : out std_logic;
        o_r_alu_op : out std_logic_vector(1 downto 0)
        );
    end component;

    component Execute port (
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
        o_l_branch : out std_logic;
        o_l_branch_taken : out std_logic
        );
    end component;

    component Mem_Access port (
        clk : in std_logic;
        i_alu_res : in std_logic_vector(63 downto 0);
        i_data_mem : in std_logic_vector(63 downto 0);
        i_reg_w : in std_logic_vector(4 downto 0);
        -- Control signals
        i_mem_rd : in std_logic;
        i_mem_we : in std_logic;
        i_reg_we : in std_logic;
        i_reg_src_mem : in std_logic;
        --
        -- OUT
        --
        o_r_mem_data : out std_logic_vector(63 downto 0);
        o_r_alu_res : out std_logic_vector(63 downto 0);
        o_r_reg_w : out std_logic_vector(4 downto 0);
        --
        o_r_reg_src_mem : out std_logic;
        o_r_reg_we : out std_logic
        );
    end component;
begin

    l_WriteBack_data_reg <= r_MemAccess_mem_data when r_MemAccess_reg_src_mem = '1' else
                            r_MemAccess_alu_res;

    HDU_inst : HDU
    port map(
        clk => clk,
        i_branch => l_Decode_branch,
        i_branch_taken => l_Execute_branch_taken,
        i_reg_a => l_Decode_reg_a,
        i_reg_b => l_Decode_reg_b,
        i_alu_src_imm => l_Decode_alu_src_imm,
        i_Execute_reg_w => r_Decode_reg_w,
        i_Execute_reg_we => r_Decode_reg_we,
        i_MemAccess_reg_W => r_Execute_reg_w,
        i_MemAccess_reg_we => r_Execute_reg_we,
        o_Fetch_stall => l_HDU_Fetch_stall,
        o_Decode_stall => l_HDU_Decode_stall
    );

    FETCH_PHASE : Fetch
    port map(
        clk => clk,
        i_stall => l_HDU_Fetch_stall,
        i_branch_taken => l_Execute_branch_taken,
        i_next_instr => l_Execute_next_instr,
        o_r_pc => r_Fetch_pc,
        o_r_instr => r_Fetch_instr
    );

    DECODE_PHASE : Decode
    port map(
        clk => clk,
        i_instr => r_Fetch_instr,
        i_pc => r_Fetch_pc,
        i_w_reg => r_MemAccess_reg_w,
        i_data_reg => l_WriteBack_data_reg,
        i_reg_we => r_MemAccess_reg_we,
        i_stall => l_HDU_Decode_stall,
        --
        -- OUT
        --
        o_r_pc => r_Decode_pc,
        o_r_data_a => r_Decode_data_a,
        o_r_data_b => r_Decode_data_b,
        o_r_imm => r_Decode_imm,
        o_r_reg_w => r_Decode_reg_w,
        o_r_func7 => r_Decode_func7,
        o_r_func3 => r_Decode_func3,
        o_l_reg_a => l_Decode_reg_a,
        o_l_reg_b => l_Decode_reg_b,
        -- Controll signal
        o_l_branch => l_Decode_branch,
        o_r_branch => r_Decode_branch,
        o_r_mem_rd => r_Decode_mem_rd,
        o_r_mem_we => r_Decode_mem_we,
        o_r_reg_we => r_Decode_reg_we,
        o_l_alu_src_imm => l_Decode_alu_src_imm,
        o_r_alu_src_imm => r_Decode_alu_src_imm,
        o_r_reg_src_mem => r_Decode_reg_src_mem,
        o_r_alu_op => r_Decode_alu_op
    );

    EXECUTE_PHASE : Execute
    port map(
        clk => clk,
        i_pc => r_Decode_pc,
        i_data_a => r_Decode_data_a,
        i_data_b => r_Decode_data_b,
        i_imm => r_Decode_imm,
        i_reg_w => r_Decode_reg_w,
        i_func7 => r_Decode_func7,
        i_func3 => r_Decode_func3,
        -- Controll signal
        i_branch => r_Decode_branch,
        i_mem_rd => r_Decode_mem_rd,
        i_mem_we => r_Decode_mem_we,
        i_reg_we => r_Decode_reg_we,
        i_alu_src_imm => r_Decode_alu_src_imm,
        i_reg_src_mem => r_Decode_reg_src_mem,
        i_alu_op => r_Decode_alu_op,
        --
        -- OUT
        --
        o_l_next_instr => l_Execute_next_instr,
        o_r_alu_res => r_Execute_alu_res,
        o_r_data_mem => r_Execute_data_mem,
        o_r_reg_w => r_Execute_reg_w,
        -- Controll signal
        o_r_mem_rd => r_Execute_mem_rd,
        o_r_mem_we => r_Execute_mem_we,
        o_r_reg_we => r_Execute_reg_we,
        o_r_reg_src_mem => r_Execute_reg_src_mem,
        -- Jump
        o_l_branch => l_Execute_branch,
        o_l_branch_taken => l_Execute_branch_taken
    );

    MEM_ACC_PHASE : Mem_Access
    port map(
        clk => clk,
        i_alu_res => r_Execute_alu_res,
        i_data_mem => r_Execute_data_mem,
        i_reg_w => r_Execute_reg_w,
        -- Control signals
        i_mem_rd => r_Execute_mem_rd,
        i_mem_we => r_Execute_mem_we,
        i_reg_we => r_Execute_reg_we,
        i_reg_src_mem => r_Execute_reg_src_mem,
        --
        -- OUT
        --
        o_r_mem_data => r_MemAccess_mem_data,
        o_r_alu_res => r_MemAccess_alu_res,
        o_r_reg_w => r_MemAccess_reg_w,
        --
        o_r_reg_src_mem => r_MemAccess_reg_src_mem,
        o_r_reg_we => r_MemAccess_reg_we
    );

end architecture RTL;