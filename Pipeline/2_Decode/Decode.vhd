library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity Decode is
    port (
        clk:           in std_logic;
        i_instr:       in std_logic_vector(31 downto 0):= (others => '0');
        i_PC: 	       in std_logic_vector(63 downto 0):= (others => '0');
        i_reg_to_write: in std_logic_vector(4 downto 0):= (others => '0');
        i_data_to_reg: in std_logic_vector(63 downto 0):= (others => '0');
        i_reg_we:      in std_logic := '0';
        o_PC:        out std_logic_vector(63 downto 0):= (others => '0');
        o_data_A:    out std_logic_vector(63 downto 0):= (others => '0');
        o_data_B:    out std_logic_vector(63 downto 0):= (others => '0');
        o_imm:       out std_logic_vector(63 downto 0):= (others => '0');
        o_reg_W:     out std_logic_vector(4 downto 0):= (others => '0');
        o_func7:     out std_logic_vector(6 downto 0):= (others => '0');
        o_func3:     out std_logic_vector(2 downto 0):= (others => '0');
        -- Controll signal
        o_branch:     out std_logic := '0';
        o_mem_read:   out std_logic := '0';
        o_mem_write:  out std_logic := '0';
        o_reg_write:  out std_logic := '0';
        o_ALUsrc:     out std_logic := '0';
        o_regsrc:     out std_logic := '0';
        o_ALUOp:      out std_logic_vector(1 downto 0):= B"00"
        );
end Decode;

architecture RTL of Decode is
    constant ZERO_DATA: std_logic_vector(31 downto 0):= (others => '0');
    component registers 
    port (
        clk:         in std_logic;
        i_reg_A:     in std_logic_vector(4 downto 0):= (others => '0');
        i_reg_B: 	 in std_logic_vector(4 downto 0):= (others => '0');
        i_reg_W:     in std_logic_vector(4 downto 0):= (others => '0');
        i_data:      in std_logic_vector(63 downto 0):= (others => '0');
        i_we:        in std_logic := '0';
        o_data_A:    out std_logic_vector(63 downto 0):= (others => '0');
        o_data_B:    out std_logic_vector(63 downto 0):= (others => '0')
    );
    end component;
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
    end component;
    component ImmGen
    port (
        i_instr:      in std_logic_vector(31 downto 0):= (others => '0');
        o_imm:        out std_logic_vector(63 downto 0):= (others => '0')
    );
    end component;
    signal r_PC:     std_logic_vector(63 downto 0):= (others => '0');
    signal r_reg_W:  std_logic_vector( 4 downto 0):= (others => '0');
    signal r_func7:  std_logic_vector( 6 downto 0):= (others => '0');
    signal r_func3:  std_logic_vector( 2 downto 0):= (others => '0');
    signal r_data_A: std_logic_vector(63 downto 0):= (others => '0');
    signal r_data_B: std_logic_vector(63 downto 0):= (others => '0');

    signal r_branch:    std_logic := '0';
    signal r_mem_read:  std_logic := '0';
    signal r_mem_write: std_logic := '0';
    signal r_reg_write: std_logic := '0';
    signal r_ALUsrc:    std_logic := '0';
    signal r_regsrc:    std_logic := '0';
    signal r_ALUOp:     std_logic_vector(1 downto 0):= B"00";
begin
    process(clk) 
    begin
        if rising_edge(clk) then
            o_PC <= r_PC;
            o_reg_W <= r_reg_W;
            o_func7 <= r_func7;
            o_func3 <= r_func3;
            o_data_A <= r_data_A;
            o_data_B <= r_data_B;

            o_branch <= r_branch;
            o_mem_read <= r_mem_read;
            o_mem_write <= r_mem_write;
            o_reg_write <= r_reg_write;
            o_ALUsrc    <= r_ALUsrc;
            o_regsrc    <= r_regsrc;
            o_ALUOp <= r_ALUOp;

            r_func7 <= i_instr(31 downto 25);
            r_func3 <= i_instr(14 downto 12);
            r_PC <= i_PC;
            r_reg_W <= i_instr(11 downto 7);

        end if;
    end process;

    REGISTER_FILE: registers
    Port Map(
        clk => clk,
        i_reg_A => i_instr(24 downto 20),
        i_reg_B => i_instr(19 downto 15),
        i_reg_W => i_reg_to_write,
        i_data =>  i_data_to_reg,
        i_we =>    i_reg_we,
        o_data_A =>  r_data_A,
        o_data_B =>  r_data_B
    );

    CONTOLL_UNIT: ControllUnit
    Port Map(
        i_opcode => i_instr(6 downto 0),
        o_branch => r_branch,
        o_mem_read => r_mem_read,
        o_mem_write => r_mem_write,
        o_reg_write => r_reg_write,
        o_ALUsrc    => r_ALUsrc,
        o_regsrc    => r_regsrc,
        o_ALUOp => r_ALUOp
    );

    IMMEDIATE_GEN: ImmGen
    Port Map(
        i_instr => i_instr,
        o_imm  => o_imm
    );
    
end architecture;
