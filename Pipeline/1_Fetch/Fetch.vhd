library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity Fetch is
    port (
        clk:         in std_logic;
        i_nextInstr: in std_logic_vector(63 downto 0);
        i_PCsrc: 	 in std_logic;
        i_PCstall:   in std_logic;
        i_flush:     in std_logic;
        i_reg_stall: in std_logic;
        o_PC:        out std_logic_vector(63 downto 0);
        o_instr:     out std_logic_vector(31 downto 0)
    );
end Fetch;

architecture RTL of Fetch is
    signal l_PC:    std_logic_vector(63 downto 0);
    constant ZERO_DATA: std_logic_vector(31 downto 0):= (others => '0');
    component sync_ram
        port (
            clk       : in  std_logic;
            i_flush: in std_logic;
            i_reg_stall: in  std_logic;
            i_we      : in  std_logic;
            i_address : in  std_logic_vector;
            i_data    : in  std_logic_vector;
            o_data    : out std_logic_vector
        );
    end component sync_ram;
    component PC
        port (
            clk:         in std_logic;
            i_reg_stall: in std_logic;
            i_nextInstr: in std_logic_vector(63 downto 0):= (others => '0');
            i_PCsrc: 	 in std_logic := '0';
            i_PCstall:   in std_logic := '0';
            o_pc:        out std_logic_vector(63 downto 0);
            o_l_pc: out std_logic_vector(63 downto 0)
        );
    end component PC;
begin
    INSTRUCTION_MEM: sync_ram
    Port Map (
        clk => clk,
        i_flush => i_flush,
        i_reg_stall => i_reg_stall,
        i_we => '0',
        i_address => l_PC,
        i_data => ZERO_DATA,
        o_data => o_instr
    );
    PC_BLOCK: PC
    Port Map (
        clk => clk,
        i_reg_stall => i_reg_stall,
        i_nextInstr => i_nextInstr,
        i_PCsrc => i_PCsrc,
        i_PCstall => i_PCstall,
        o_pc => o_PC,
        o_l_pc => l_PC
    );
    
end architecture;
