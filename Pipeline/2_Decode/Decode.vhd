library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity Decode is
    port (
        clk:           in std_logic;
        i_instr:       in std_logic_vector(31 downto 0);
        i_pc: 	       in std_logic_vector(63 downto 0);
        i_w_reg: in std_logic_vector(4 downto 0);
        i_data_reg: in std_logic_vector(63 downto 0);
        i_reg_we:      in std_logic;
        --i_stall:      in std_logic;
        i_stall:  in std_logic;
        --
        -- OUT
        --
        o_r_pc:        out std_logic_vector(63 downto 0);
        o_r_data_a:    out std_logic_vector(63 downto 0);
        o_r_data_b:    out std_logic_vector(63 downto 0);
        o_r_imm:       out std_logic_vector(63 downto 0);
        o_r_reg_w:     out std_logic_vector(4 downto 0);
        o_r_func7:     out std_logic_vector(6 downto 0);
        o_r_func3:     out std_logic_vector(2 downto 0);
        o_l_reg_a:     out std_logic_vector(4 downto 0);
        o_l_reg_b:     out std_logic_vector(4 downto 0);
        -- Controll signal
        o_l_branch:   out std_logic;
        o_r_branch:     out std_logic;
        o_r_mem_rd:   out std_logic;
        o_r_mem_we:  out std_logic;
        o_r_reg_we:  out std_logic;
        o_l_alu_src_imm:   out std_logic;
        o_r_alu_src_imm:     out std_logic;
        o_r_reg_src_mem:     out std_logic;
        o_r_alu_op:      out std_logic_vector(1 downto 0)
        );
end Decode;

architecture RTL of Decode is
    constant ZERO_DATA: std_logic_vector(31 downto 0):= (others => '0');
    component registers 
    port (
        clk:         in std_logic;
        i_reg_a:     in std_logic_vector(4 downto 0);
        i_reg_b: 	 in std_logic_vector(4 downto 0);
        i_w_reg:     in std_logic_vector(4 downto 0);
        i_data_reg:      in std_logic_vector(63 downto 0);
        i_we:        in std_logic := '0';
        o_r_data_a:    out std_logic_vector(63 downto 0);
        o_r_data_b:    out std_logic_vector(63 downto 0)
    );
    end component;
    component ControllUnit
    port (
        i_opcode:     in std_logic_vector(6 downto 0);
        o_branch:     out std_logic := '0';
        o_mem_rd:   out std_logic := '0';
        o_mem_we:  out std_logic := '0';
        o_reg_we:  out std_logic := '0';
        o_alu_src_imm:     out std_logic := '0';
        o_reg_src_mem:     out std_logic := '0';
        o_alu_op:      out std_logic_vector(1 downto 0)
    );
    end component;
    component ImmGen
    port (
        i_instr:      in std_logic_vector(31 downto 0);
        o_imm:        out std_logic_vector(63 downto 0)
    );
    end component;
    signal r_pc:     std_logic_vector(63 downto 0);
    signal l_pc:     std_logic_vector(63 downto 0);

    signal l_reg_w:  std_logic_vector( 4 downto 0);
    signal r_reg_w:  std_logic_vector( 4 downto 0);

    signal l_func7:  std_logic_vector( 6 downto 0);
    signal r_func7:  std_logic_vector( 6 downto 0);

    signal l_func3:  std_logic_vector( 2 downto 0);
    signal r_func3:  std_logic_vector( 2 downto 0);

    signal l_reg_a:  std_logic_vector( 4 downto 0);
    signal l_reg_b:  std_logic_vector( 4 downto 0);

    signal r_data_a: std_logic_vector(63 downto 0);
    signal r_data_b: std_logic_vector(63 downto 0);

    signal l_imm: std_logic_vector(63 downto 0);
    signal r_imm: std_logic_vector(63 downto 0);

    signal l_branch:    std_logic;
    signal r_branch:    std_logic;

    signal l_mem_rd:  std_logic;
    signal r_mem_rd:  std_logic;

    signal l_mem_we: std_logic;
    signal r_mem_we: std_logic;

    signal l_reg_we: std_logic;
    signal r_reg_we: std_logic;

    signal l_alu_src_imm:    std_logic;
    signal r_alu_src_imm:    std_logic;
    
    signal l_reg_src_mem:    std_logic;
    signal r_reg_src_mem:    std_logic;
    
    signal l_alu_op:     std_logic_vector(1 downto 0);
    signal r_alu_op:     std_logic_vector(1 downto 0);

    signal l_stall:    std_logic;
    --signal r_stall:    std_logic;

    --signal l_taken_branch:    std_logic;
begin
    l_func7 <= i_instr(31 downto 25);
    l_func3 <= i_instr(14 downto 12);

    l_reg_w <= i_instr(11 downto 7);

    l_reg_A <= i_instr(19 downto 15);
    l_reg_B <= i_instr(24 downto 20);

    l_pc <= i_pc;

    l_stall <= i_stall;

    --l_taken_branch <= i_taken_branch;
    o_l_branch <= l_branch;
    process(clk) 
    begin
        if rising_edge(clk) then
            --r_stall <= l_stall;
            --if r_stall /= '1' and l_taken_branch/='1' then
            r_pc <= l_pc;
            r_reg_w <= l_reg_w;
            r_func7 <= l_func7;
            r_func3 <= l_func3;
            r_imm <= l_imm;
            
            r_branch <= l_branch;
            if l_stall/='1' then
                
                r_mem_rd <= l_mem_rd;
                r_mem_we <= l_mem_we;
                r_reg_we <= l_reg_we;
                r_alu_src_imm <= l_alu_src_imm;
                r_reg_src_mem <= l_reg_src_mem;
                r_alu_op <= l_alu_op;
            else
                
                r_mem_rd <= '0';
                r_mem_we <= '0';
                r_reg_we <= '0';
                r_alu_src_imm <= '0';
                r_reg_src_mem <= '0';
                r_alu_op <= B"00"; 
            end if;
        end if;
    end process;
    o_r_pc <= r_pc;
    o_r_data_a <= r_data_a;
    o_r_data_b <= r_data_b;
    o_r_reg_w <= r_reg_w;
    o_r_func7 <= r_func7;
    o_r_func3 <= r_func3;
    o_r_imm <= r_imm;

    o_r_branch <= r_branch;
    o_r_mem_rd <= r_mem_rd;
    o_r_mem_we <= r_mem_we;
    o_r_reg_we <= r_reg_we;

    o_r_alu_src_imm <= r_alu_src_imm;
    o_r_reg_src_mem <= r_reg_src_mem;
    o_r_alu_op <= r_alu_op;
    
 
    o_l_reg_A <= l_reg_A;
    o_l_reg_B <= l_reg_B;
    REGISTER_FILE: registers
    Port Map(
        clk => clk,
        i_reg_a => l_reg_a,
        i_reg_b => l_reg_b,
        i_w_reg => i_w_reg,
        i_data_reg =>  i_data_reg,
        i_we => i_reg_we,
        o_r_data_a => r_data_a,
        o_r_data_b => r_data_b
    );

    o_l_alu_src_imm <= l_alu_src_imm;
    CONTOLL_UNIT: ControllUnit
    Port Map(
        i_opcode => i_instr(6 downto 0),
        o_branch => l_branch,
        o_mem_rd => l_mem_rd,
        o_mem_we => l_mem_we,
        o_reg_we => l_reg_we,
        o_alu_src_imm => l_alu_src_imm,
        o_reg_src_mem => l_reg_src_mem,
        o_alu_op => l_alu_op
    );

    IMMEDIATE_GEN: ImmGen
    Port Map(
        i_instr => i_instr,
        o_imm  => l_imm
    );
    
end architecture;
