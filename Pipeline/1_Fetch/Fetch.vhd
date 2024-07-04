library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity Fetch is
    port (
        clk: in std_logic;
        i_flush: in std_logic;
        i_stall: in std_logic;
        i_branch_taken: in std_logic;
        i_next_instr: in std_logic_vector(63 downto 0);
        o_r_pc: out std_logic_vector(63 downto 0);
        o_r_instr: out std_logic_vector(31 downto 0)
    );
end Fetch;

architecture RTL of Fetch is
    component sync_ram
        port (
            clk: in std_logic;
            i_flush: in std_logic;
            i_address: in std_logic_vector(63 downto 0);
            o_r_data: out std_logic_vector(31 downto 0)
        );
    end component sync_ram;
    component PC
        port (
            clk: in std_logic;
            i_stall: in std_logic;
            i_branch_taken: in std_logic;
            i_next_instr: in std_logic_vector(63 downto 0);
            o_r_pc: out std_logic_vector(63 downto 0);
            o_l_pc: out std_logic_vector(63 downto 0)
        );
    end component PC;
    signal l_pc: std_logic_vector(63 downto 0);
begin
    INSTRUCTION_MEM: sync_ram
    Port Map (
        clk => clk,
        i_flush => i_flush,
        i_address => l_pc,
        o_r_data => o_r_instr
    );
    PC_BLOCK: PC
    Port Map (
        clk => clk,
        i_stall => i_stall,
        i_branch_taken => i_branch_taken,
        i_next_instr => i_next_instr,
        o_r_pc => o_r_pc,
        o_l_pc => l_pc
    );
    
end architecture;
