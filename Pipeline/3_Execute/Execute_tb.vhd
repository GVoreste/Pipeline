library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 


entity Execute_tb is
end entity Execute_tb;

architecture RTL of Execute_tb is
    type ex_cntl is record
        branch:     std_logic;
        mem_read:   std_logic;
        mem_write:  std_logic;
        reg_write:  std_logic;
        ALUsrc:     std_logic;
        regsrc:     std_logic;
        ALUOp:      std_logic_vector(1 downto 0);
    end record;

    type ex_input is record
        PC:        std_logic_vector(63 downto 0);
        data_A:    std_logic_vector(63 downto 0);
        data_B:    std_logic_vector(63 downto 0);
        imm:       std_logic_vector(63 downto 0);
        reg_W:     std_logic_vector(4 downto 0);
        func7:     std_logic_vector(6 downto 0);
        func3:     std_logic_vector(2 downto 0);
        control:   ex_cntl;
end record;
    signal tb_ex_input: ex_input;

    type ex_input_table is array(0 to 99) of ex_input;
    constant tb_ex_input_table: ex_input_table := (
        0 => ( -- ADD
            PC      =>  "----------------------------------------------------------------",
            data_A  => x"000000000000FFFF",
            data_B  => x"AAAA000000000001",
            imm     =>  "----------------------------------------------------------------",
            reg_W   => B"00011",
            func7   => B"0000000",
            func3   => B"000",
            control => (
                branch    => '0',
                mem_read  => '0',
                mem_write => '0',
                reg_write => '1',
                ALUsrc    => '0',
                regsrc    => '0',
                ALUOp     => B"10"
            )
        ),
        1 => ( -- SUBI
            PC      =>  "----------------------------------------------------------------",
            data_A  => x"AAAA00000000FFFF",
            data_B  =>  "----------------------------------------------------------------",
            imm     => x"00000000000000F0",
            reg_W   => B"00000",
            func7   => B"0100000",
            func3   => B"000",
            control => (
                branch    => '0',
                mem_read  => '0',
                mem_write => '0',
                reg_write => '1',
                ALUsrc    => '1',
                regsrc    => '0',
                ALUOp     => B"10"
            )
        ),
        2 => (  -- LD
            PC      =>  "----------------------------------------------------------------",
            data_A  => x"000000000000FFFF",
            data_B  =>  "----------------------------------------------------------------",
            imm     => x"AAAA000000000001",
            reg_W   => B"00011",
            func7   => "-------",
            func3   => "---",
            control => (
                branch    => '0',
                mem_read  => '1',
                mem_write => '0',
                reg_write => '1',
                ALUsrc    => '1',
                regsrc    => '1',
                ALUOp     => B"00"
            )
        ),
        3 => (  -- SD
            PC      =>  "----------------------------------------------------------------",
            data_A  => x"AAAA000000000001",
            data_B  => x"AAAA55555555AAAA",
            imm     => x"000000000000FFFF",
            reg_W   =>  "-----",
            func7   =>  "-------",
            func3   =>  "---",
            control => (
                branch    => '0',
                mem_read  => '0',
                mem_write => '1',
                reg_write => '0',
                ALUsrc    => '1',
                regsrc    => '-',
                ALUOp     => B"00"
            )
        ), 
        4 => (  -- BEQ (taken)
            PC      => x"AAA000000000FFFF",
            data_A  => x"AAAA55555555AAAA",
            data_B  => x"AAAA55555555AAAA",
            imm     => x"0000000000000001",
            reg_W   => "-----",
            func7   => "-------",
            func3   => "---",
            control => (
                branch    => '1',
                mem_read  => '0',
                mem_write => '0',
                reg_write => '0',
                ALUsrc    => '0',
                regsrc    => '-',
                ALUOp     => B"01"
            )
        ),
        5 => (  -- BEQ (untaken)
            PC      => x"AAAA00000000FFFF",
            data_A  => x"AAAA55555555AAAA",
            data_B  => x"5555AAAAAAAA5555",
            imm     => x"0000000000000001",
            reg_W   => "-----",
            func7   => "-------",
            func3   => "---",
            control => (
                branch    => '1',
                mem_read  => '0',
                mem_write => '0',
                reg_write => '0',
                ALUsrc    => '0',
                regsrc    => '-',
                ALUOp     => B"01"
            )
        ),
        6 => (  -- UNKNOWN
            PC      => (others => '1'),
            data_A  => (others => '1'),
            data_B  => (others => '1'),
            imm     => (others => '1'),
            reg_W   => (others => '1'),
            func7   => (others => '1'),
            func3   => (others => '1'),
            control => (
                branch    => '1',
                mem_read  => '1',
                mem_write => '1',
                reg_write => '1',
                ALUsrc    => '1',
                regsrc    => '1',
                ALUOp     => B"11"
            )
        ),
        others => (
            PC      => (others => '0'),
            data_A  => (others => '0'),
            data_B  => (others => '0'),
            imm     => (others => '0'),
            reg_W   => (others => '0'),
            func7   => (others => '0'),
            func3   => (others => '0'),
            control => (
                branch    => '0',
                mem_read  => '0',
                mem_write => '0',
                reg_write => '0',
                ALUsrc    => '0',
                regsrc    => '0',
                ALUOp     => B"00"
            )
        )
        );
    constant clk_T : time := 10 ns;
    signal tb_instr:  std_logic_vector(31 downto 0) := (others => '0');
    signal tb_clk : std_logic := '0';
    signal tb_PC : std_logic_vector(63 downto 0) := (others => '0');
    component Execute
    port ( 
        clk:         in std_logic;
        i_PC:        in std_logic_vector(63 downto 0):= (others => '0');
        i_data_A:    in std_logic_vector(63 downto 0):= (others => '0');
        i_data_B:    in std_logic_vector(63 downto 0):= (others => '0');
        i_imm:       in std_logic_vector(63 downto 0):= (others => '0');
        i_reg_W:     in std_logic_vector(4 downto 0):= (others => '0');
        i_func7:     in std_logic_vector(6 downto 0):= (others => '0');
        i_func3:     in std_logic_vector(2 downto 0):= (others => '0');
        -- Controll signal
        i_branch:     in std_logic := '0';
        i_mem_read:   in std_logic := '0';
        i_mem_write:  in std_logic := '0';
        i_reg_write:  in std_logic := '0';
        i_ALUsrc:     in std_logic := '0';
        i_regsrc:     in std_logic := '0';
        i_ALUOp:      in std_logic_vector(1 downto 0):= B"00";
        --
        -- OUT
        --
        o_nextInstr:  out std_logic_vector(63 downto 0):= (others => '0');
        o_ALUres:     out std_logic_vector(63 downto 0):= (others => '0');
        o_data_MEM:   out std_logic_vector(63 downto 0):= (others => '0');
        o_reg_W:      out std_logic_vector(4 downto 0):= (others => '0');
        -- Controll signal
        o_branch:     out std_logic := '0';
        o_mem_read:   out std_logic := '0';
        o_mem_write:  out std_logic := '0';
        o_reg_write:  out std_logic := '0';
        o_regsrc:     out std_logic := '0';
        o_Zero:       out std_logic := '0'
    );
    end component;
begin
    CLK: process is
    begin
        wait for clk_T/2;
        tb_clk <= not tb_clk;
    end process CLK;
    STIMULUS_GEN: process is
    begin
        wait for clk_T/2;
        for i in 0 to 99
        loop
            tb_ex_input <= tb_ex_input_table(i);
            wait for clk_T;
        end loop;
        wait;
    end process STIMULUS_GEN;

    Execute_to_test: Execute
    Port Map (
        clk => tb_clk,
        i_PC => tb_ex_input.PC,
        i_data_A => tb_ex_input.data_A,
        i_data_B => tb_ex_input.data_B,
        i_imm    => tb_ex_input.imm,
        i_reg_W  => tb_ex_input.reg_W,
        i_func7  => tb_ex_input.func7,
        i_func3  => tb_ex_input.func3,
        -- Controll signal
        i_branch => tb_ex_input.control.branch,
        i_mem_read => tb_ex_input.control.mem_read,
        i_mem_write => tb_ex_input.control.mem_write,
        i_reg_write => tb_ex_input.control.reg_write,
        i_ALUsrc => tb_ex_input.control.ALUsrc,
        i_regsrc => tb_ex_input.control.regsrc,
        i_ALUOp  => tb_ex_input.control.ALUOp,
        --
        -- OUT
        --
        o_nextInstr => open,
        o_ALUres =>    open,
        o_data_MEM =>  open,
        o_reg_W =>     open,
        -- Controll signal
        o_branch =>    open,
        o_mem_read =>  open,
        o_mem_write => open,
        o_reg_write => open,
        o_regsrc =>    open,
        o_Zero =>      open
    );
end architecture RTL;