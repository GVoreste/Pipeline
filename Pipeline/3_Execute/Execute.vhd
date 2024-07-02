library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 

entity Execute is
    port ( 
        clk:         in std_logic;
        i_PC:        in std_logic_vector(63 downto 0);
        i_data_A:    in std_logic_vector(63 downto 0);
        i_data_B:    in std_logic_vector(63 downto 0);
        i_imm:       in std_logic_vector(63 downto 0);
        i_reg_W:     in std_logic_vector(4 downto 0);
        i_func7:     in std_logic_vector(6 downto 0);
        i_func3:     in std_logic_vector(2 downto 0);
        -- Controll signal
        i_branch:     in std_logic;
        i_mem_read:   in std_logic;
        i_mem_write:  in std_logic;
        i_reg_write:  in std_logic;
        i_ALUsrc:     in std_logic;
        i_regsrc:     in std_logic;
        i_ALUOp:      in std_logic_vector(1 downto 0);
        --
        -- OUT
        --
        o_nextInstr:  out std_logic_vector(63 downto 0);
        o_ALUres:     out std_logic_vector(63 downto 0);
        o_data_MEM:   out std_logic_vector(63 downto 0);
        o_reg_W:      out std_logic_vector(4 downto 0);
        -- Controll signal
        o_bge:        out std_logic;
        o_branch:     out std_logic;
        o_mem_read:   out std_logic;
        o_mem_write:  out std_logic;
        o_reg_write:  out std_logic;
        o_regsrc:     out std_logic;
        o_Zero:       out std_logic;
        o_Pos:        out std_logic
        );
end entity;

architecture RTL of Execute is
    component Adder
        port(
            i_operand_A: in std_logic_vector(63 downto 0);
            i_operand_B: in std_logic_vector(63 downto 0);
            i_sub:       in std_logic;
            o_res:       out std_logic_vector(63 downto 0)
        );
    end component;
    component ALU
        port ( 
            i_operand_A: in std_logic_vector(63 downto 0);
            i_operand_B: in std_logic_vector(63 downto 0);
            i_ALUfunc:   in std_logic_vector( 3 downto 0);
            o_Zero:      out std_logic;
            o_Pos:       out std_logic;
            o_ALUres:    out std_logic_vector(63 downto 0)
            );
    end component ALU;
    component ALUControl
        port (
            i_ALUOp:      in std_logic_vector(1 downto 0);
            i_func3:      in std_logic_vector(2 downto 0);
            i_func7:      in std_logic_vector(6 downto 0);
            o_bge:        out std_logic := '0';
            o_ALUfunc:    out std_logic_vector(3 downto 0)
            );
    end component;
    signal l_ALUfunc: std_logic_vector(3 downto 0);
    signal l_data_B: std_logic_vector(63 downto 0); 
    signal r_nextInstr: std_logic_vector(63 downto 0); 
    signal r_ALUres: std_logic_vector(63 downto 0); 
    signal r_data_MEM: std_logic_vector(63 downto 0); 
    signal r_reg_W: std_logic_vector(4 downto 0);
    --
    signal r_branch: std_logic;
    signal r_mem_read: std_logic;
    signal r_mem_write: std_logic;
    signal r_reg_write: std_logic;
    signal r_regsrc: std_logic;
    signal r_Zero: std_logic;
    signal r_Pos: std_logic;
    signal r_bge: std_logic;

    signal l_imm_jump: std_logic_vector(63 downto 0);
begin
    r_reg_W <= i_reg_W;
    r_data_MEM <= i_data_B;

    r_branch <= i_branch;
    r_mem_read <= i_mem_read;
    r_mem_write <= i_mem_write;
    r_reg_write <= i_reg_write;
    r_regsrc <= i_regsrc;
    process(clk) is
    begin
        if rising_edge(clk) then
            o_nextInstr <= r_nextInstr;
            o_ALUres  <= r_ALUres;
            o_data_MEM <= r_data_MEM;
            o_reg_W <= r_reg_W;
            -- Controll signal
            o_branch    <= r_branch;
            o_mem_read  <= r_mem_read;
            o_mem_write <= r_mem_write;
            o_reg_write <= r_reg_write;
            o_regsrc    <= r_regsrc;
            o_bge       <= r_bge;
            o_Zero      <= r_Zero;
            o_Pos       <= r_Pos;
        end if;
    end process;
    process(i_imm,i_data_B,i_ALUsrc) is
    begin
        if i_ALUsrc = '1' then
            l_data_B <= i_imm;
        else
            l_data_B <= i_data_B;
        end if;
    end process;
    l_imm_jump <= i_imm(63 downto 0); -- i_imm(62 downto 0) & B"0";

    ALU_INST: ALU
    Port Map(
        i_operand_A => i_data_A,
        i_operand_B => l_data_B,
        i_ALUfunc => l_ALUfunc,
        o_Zero    => r_Zero,
        o_Pos     => r_Pos,
        o_ALUres  => r_ALUres
    );

    ALU_CNTL_INST: ALUControl
    Port Map(
        i_ALUOp => i_ALUOp,
        i_func3 => i_func3,
        i_func7 => i_func7,
        o_bge   => r_bge,
        o_ALUfunc => l_ALUfunc
    );

    ADDER_ADDRESS: Adder
    Port Map(
        i_operand_A => i_PC,
        i_operand_B => l_imm_jump,
        i_sub => '0',
        o_res => r_nextInstr
    );

end architecture;