library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 


entity MemoryAccess_tb is
end entity MemoryAccess_tb;

architecture RTL of MemoryAccess_tb is

    -- 64 (next instr) + 64 (ALUres) + 64 (write mem) + 5 (reg) + 6 (controls) = 203
    signal tb_mem_acc_input: std_logic_vector(202 downto 0);

    type mem_acc_input_table is array(0 to 99) of std_logic_vector(202 downto 0);
    constant tb_mem_acc_input_table: mem_acc_input_table := (
        0 => x"FFFFFFFFFFFFFFFF" & x"AAAA000000005555" & x"FFFFFFFFFFFFFFFF" & B"00011" & B"100000", -- R-Type / I-Type
        1 => x"EEEEEEEEEEEEEEEE" & x"00000000000000F0" & x"555500000000AAAA" &  "-----" & B"000010", -- SD
        2 => x"DDDDDDDDDDDDDDDD" & x"00000000000000F0" & x"DDDDDDDDDDDDDDDD" & B"00110" & B"110100", -- LD
        3 => x"0000000000005550" & x"CCCCCCCCCCCCCCCC" & x"CCCCCCCCCCCCCCCC" &  "-----" & B"001001", -- BEQ taken
        4 => x"000000000000AAA0" & x"BBBBBBBBBBBBBBBB" & x"BBBBBBBBBBBBBBBB" &  "-----" & B"001000", -- BEQ untaken
        others => (others => '0')
    );
    constant clk_T : time := 10 ns;
    signal tb_clk : std_logic := '0';

    component Mem_Access
    port ( 
        clk: in std_logic := '0';
        i_ALUres: in std_logic_vector(63 downto 0);
        i_data_MEM: in std_logic_vector(63 downto 0);
        i_reg_W: in std_logic_vector(4 downto 0);
        i_nextInstr: in std_logic_vector(63 downto 0);
        -- Control signals
        i_bge: in std_logic;
        i_branch: in std_logic := '0';
        i_mem_read: in std_logic := '0';
        i_mem_write: in std_logic := '0';
        i_reg_write: in std_logic := '0';
        i_regsrc: in std_logic := '0';
        i_Zero: in std_logic := '0';
        i_Pos: in std_logic;
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
            tb_mem_acc_input <= tb_mem_acc_input_table(i);
            wait for clk_T;
        end loop;
        wait;
    end process STIMULUS_GEN;

    Mem_Access_to_test: Mem_Access
    Port Map (
        clk => tb_clk,
        i_nextInstr => tb_mem_acc_input(202 downto 139),
        i_ALUres => tb_mem_acc_input(138 downto 75),
        i_data_MEM => tb_mem_acc_input(74 downto 11),
        i_reg_W => tb_mem_acc_input(10 downto 6),
        -- Control signals
        i_bge => '0',
        i_branch => tb_mem_acc_input(3),
        i_mem_read => tb_mem_acc_input(2),
        i_mem_write => tb_mem_acc_input(1),
        i_reg_write => tb_mem_acc_input(5),
        i_regsrc => tb_mem_acc_input(4),
        i_Zero => tb_mem_acc_input(0),
        i_Pos => '0',
        --
        -- OUT
        --
        o_nextInstr => open,
        o_mem_data => open,
        o_ALUres => open,
        o_reg_W => open,
        --
        o_PCsrc => open,
        --
        o_regsrc => open,
        o_reg_write => open
        
    );
end architecture RTL;