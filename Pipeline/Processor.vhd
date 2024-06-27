library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;


entity CPU is
    port(
        clk: in std_logic := '0';
        power_on: in std_logic :='0';
        i_we: in std_logic :='0';
        i_re: in std_logic :='0';
        i_data: in std_logic_vector(63 downto 0);
        i_instr: in std_logic_vector(31 downto 0);
        i_data_pos: in std_logic_vector(63 downto 0);
        i_instr_pos: in std_logic_vector(63 downto 0);
        o_sel_instr: out std_logic_vector(63 downto 0);
        o_sel_data: out std_logic_vector(63 downto 0);
        o_read_instr: out std_logic_vector(31 downto 0);
        o_read_data: out std_logic_vector(63 downto 0)
    );
end entity;

architecture RTL of CPU is
    signal l_MemAccess_nextInstr: std_logic_vector(63 downto 0):= (others => '0');
    signal l_PCsrc: 	std_logic := '0';
    signal l_PCstall:   std_logic := '0';
    signal l_reg_stall: std_logic := '0';
    signal l_Fetch_PC:  std_logic_vector(63 downto 0):= (others => '0');
    signal l_instr:     std_logic_vector(31 downto 0):= (others => '0');
    signal l_Decode_PC: std_logic_vector(63 downto 0):= (others => '0');
    signal l_data_A:  std_logic_vector(63 downto 0):= (others => '0');
    signal l_data_B:  std_logic_vector(63 downto 0):= (others => '0');
    signal l_imm:     std_logic_vector(63 downto 0):= (others => '0');
    signal l_Decode_reg_W: std_logic_vector(4 downto 0):= (others => '0');
    signal l_func7: std_logic_vector(6 downto 0):= (others => '0');
    signal l_func3: std_logic_vector(2 downto 0):= (others => '0');
    signal l_Decode_branch: std_logic := '0';
    signal l_Decode_mem_read: std_logic := '0';
    signal l_Decode_mem_write: std_logic := '0';
    signal l_Decode_reg_write: std_logic := '0';
    signal l_ALUsrc: std_logic := '0';
    signal l_Decode_regsrc: std_logic := '0';
    signal l_ALUOp: std_logic_vector(1 downto 0):= B"00";
    signal l_Execute_nextInstr: std_logic_vector(63 downto 0):= (others => '0');
    signal l_Execute_ALUres: std_logic_vector(63 downto 0):= (others => '0');
    signal l_Execute_reg_W: std_logic_vector(4 downto 0):= (others => '0');
    signal l_data_MEM: std_logic_vector(63 downto 0):= (others => '0');
    signal l_Execute_branch: std_logic := '0';
    signal l_Execute_mem_read: std_logic := '0';
    signal l_Execute_mem_write: std_logic := '0';
    signal l_Execute_reg_write: std_logic := '0';
    signal l_Execute_regsrc: std_logic := '0';
    signal l_Execute_Zero: std_logic := '0';
    --
    signal r_mem_data: std_logic_vector(63 downto 0):= (others => '0');
    signal r_MemAccess_ALUres: std_logic_vector(63 downto 0):= (others => '0');
    signal r_MemAccess_reg_W: std_logic_vector(4 downto 0):= (others => '0');
    signal r_MemAccess_regsrc: std_logic := '0';
    signal r_MemAccess_reg_write: std_logic := '0';
    --
    signal l_mem_data: std_logic_vector(63 downto 0):= (others => '0');
    signal l_MemAccess_ALUres: std_logic_vector(63 downto 0):= (others => '0');
    signal l_MemAccess_reg_W: std_logic_vector(4 downto 0):= (others => '0');
    signal l_MemAccess_regsrc: std_logic := '0';
    signal l_MemAccess_reg_write: std_logic := '0';
    signal l_data_to_reg: std_logic_vector(63 downto 0):= (others => '0');

    component Fetch port(
        clk:         in std_logic;
        i_nextInstr: in std_logic_vector(63 downto 0):= (others => '0');
        i_PCsrc: 	 in std_logic := '0';
        i_PCstall:   in std_logic := '0';
        i_reg_stall: in std_logic := '0';
        o_PC:        out std_logic_vector(63 downto 0):= (others => '0');
        o_instr:     out std_logic_vector(31 downto 0):= (others => '0')
    );
    end component;

    component Decode port(
        clk:         in std_logic;
        i_instr:     in std_logic_vector(31 downto 0):= (others => '0');
        i_PC: 	     in std_logic_vector(63 downto 0):= (others => '0');
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
    end component;

    component Execute port(
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

    component Mem_Access port(
        clk: in std_logic := '0';
        i_ALUres: in std_logic_vector(63 downto 0);
        i_data_MEM: in std_logic_vector(63 downto 0);
        i_reg_W: in std_logic_vector(4 downto 0);
        i_nextInstr: in std_logic_vector(63 downto 0);
        -- Control signals
        i_branch: in std_logic := '0';
        i_mem_read: in std_logic := '0';
        i_mem_write: in std_logic := '0';
        i_reg_write: in std_logic := '0';
        i_regsrc: in std_logic := '0';
        i_Zero: in std_logic := '0';
        --
        -- OUT
        --
        o_nextInstr: out std_logic_vector(63 downto 0);
        o_mem_data: out std_logic_vector(63 downto 0);
        o_ALUres: out std_logic_vector(63 downto 0);
        o_reg_W: out std_logic_vector(4 downto 0);
        --
        o_PCsrc: out std_logic := '0';
        --
        o_regsrc: out std_logic := '0';
        o_reg_write: out std_logic := '0'
    );
    end component;
begin

process(clk) is
    variable tmp_mem_data: std_logic_vector(63 downto 0):= (others => '0');
    variable tmp_MemAccess_ALUres: std_logic_vector(63 downto 0):= (others => '0');
    variable tmp_MemAccess_reg_W: std_logic_vector(4 downto 0):= (others => '0');
    variable tmp_MemAccess_regsrc: std_logic := '0';
    variable tmp_MemAccess_reg_write: std_logic := '0';
begin
    if rising_edge(clk) then
        l_mem_data <= tmp_mem_data;
        l_MemAccess_ALUres <= tmp_MemAccess_ALUres;
        l_MemAccess_reg_W <= tmp_MemAccess_reg_W;
        l_MemAccess_regsrc <= tmp_MemAccess_regsrc;
        l_MemAccess_reg_write <= tmp_MemAccess_reg_write;

        if l_MemAccess_regsrc = '1' then
            l_data_to_reg <= tmp_mem_data; 
        else
            l_data_to_reg <= tmp_MemAccess_ALUres;
        end if;

        tmp_mem_data := r_mem_data;
        tmp_MemAccess_ALUres := r_MemAccess_ALUres;
        tmp_MemAccess_reg_W := r_MemAccess_reg_W;
        tmp_MemAccess_regsrc := r_MemAccess_regsrc;
        tmp_MemAccess_reg_write := r_MemAccess_reg_write;
    end if;
end process;


-- INIT: process(clk) is
-- begin
-- if power_on /= '1' then
--     l_PCstall <= '1';
--     if i_we = '1' then

--     end if;
-- else
--     l_PCstall <= '0';
-- end if;

-- end INIT process



l_PCstall <= '0';
l_reg_stall <= '0';
FETCH_PHASE: Fetch 
Port Map(
    clk => clk,
    i_nextInstr => l_MemAccess_nextInstr,
    i_PCsrc => l_PCsrc,
    i_PCstall => l_PCstall,
    i_reg_stall => l_reg_stall,
    o_PC => l_Fetch_PC,
    o_instr => l_instr
);

DECODE_PHASE: Decode
Port Map(
    clk => clk,
    i_instr => l_instr,
    i_PC => l_Fetch_PC,
    i_reg_to_write => l_MemAccess_reg_W,
    i_data_to_reg => l_data_to_reg,
    i_reg_we => l_MemAccess_reg_write,
    o_PC => l_Decode_PC,
    o_data_A => l_data_A,
    o_data_B => l_data_B,
    o_imm => l_imm,
    o_reg_W => l_Decode_reg_W,
    o_func7 => l_func7,
    o_func3 => l_func3,
    --
    o_branch => l_Decode_branch,
    o_mem_read => l_Decode_mem_read,
    o_mem_write => l_Decode_mem_write,
    o_reg_write => l_Decode_reg_write,
    o_ALUsrc => l_ALUsrc,
    o_regsrc => l_Decode_regsrc,
    o_ALUOp => l_ALUOp
);

EXECUTE_PHASE: Execute
Port Map(
    clk => clk,
    i_PC => l_Decode_PC,
    i_data_A => l_data_A,
    i_data_B => l_data_B,
    i_imm => l_imm,
    i_reg_W => l_Decode_reg_W,
    i_func7 => l_func7,
    i_func3 => l_func3,
    -- Controll signal
    i_branch => l_Decode_branch,
    i_mem_read => l_Decode_mem_read,
    i_mem_write => l_Decode_mem_write,
    i_reg_write => l_Decode_reg_write,
    i_ALUsrc => l_ALUsrc,
    i_regsrc => l_Decode_regsrc,
    i_ALUOp => l_ALUOp,
    --
    -- OUT
    --
    o_nextInstr => l_Execute_nextInstr,
    o_ALUres => l_Execute_ALUres,
    o_data_MEM => l_data_MEM,
    o_reg_W => l_Execute_reg_W,
    -- Controll signal
    o_branch => l_Execute_branch,
    o_mem_read => l_Execute_mem_read,
    o_mem_write => l_Execute_mem_write,
    o_reg_write => l_Execute_reg_write,
    o_regsrc => l_Execute_regsrc,
    o_Zero => l_Execute_Zero
);


MEM_ACC_PHASE: Mem_Access
Port Map(
    clk => clk,
    i_ALUres => l_Execute_ALUres,
    i_data_MEM => l_data_MEM,
    i_reg_W => l_Execute_reg_W,
    i_nextInstr => l_Execute_nextInstr,
    -- Control signals
    i_branch => l_Execute_branch,
    i_mem_read => l_Execute_mem_read,
    i_mem_write => l_Execute_mem_write,
    i_reg_write => l_Execute_reg_write,
    i_regsrc => l_Execute_regsrc,
    i_Zero => l_Execute_Zero,
    --
    -- OUT
    --
    o_nextInstr => l_MemAccess_nextInstr,
    o_mem_data => r_mem_data,
    o_ALUres   => r_MemAccess_ALUres,
    o_reg_W    => r_MemAccess_reg_W,
    --
    o_PCsrc => l_PCsrc,
    --
    o_regsrc   => r_MemAccess_regsrc,
    o_reg_write => r_MemAccess_reg_write
);



end architecture RTL;
