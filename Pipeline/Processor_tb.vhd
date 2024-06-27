library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity Processor_tb is
end entity;

architecture RTL of Processor_tb is
    type instr_table is array(0 to 99) of std_logic_vector(31 downto 0);
    constant programm: instr_table := (
        0 => x"FFFF_FFFF",
        1 => x"FFFF_FFFF",
        2 => x"FFFF_FFFF",
        others => (others => '0')
    );
    type data_table is array(0 to 99) of std_logic_vector(63 downto 0);
    constant data_ram: data_table := (
        0 => x"FFFFFFFFFFFFFFFF",
        1 => x"FFFFFFFFFFFFFFFF",
        2 => x"FFFFFFFFFFFFFFFF",
        others => (others => '0')
    );
    component CPU
    port (
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
    end component;
    constant clk_T : time := 10 ns;
    signal tb_power_on : std_logic := '0';
    signal tb_clk : std_logic := '0';
    signal tb_we : std_logic := '0';
    signal tb_re : std_logic := '0';
    signal tb_data : std_logic_vector(63 downto 0) := (others => '0');
    signal tb_instr : std_logic_vector(31 downto 0) := (others => '0');
    signal tb_data_pos : std_logic_vector(63 downto 0) := (others => '0');
    signal tb_instr_pos : std_logic_vector(63 downto 0) := (others => '0');
begin
    CLK: process is
        begin
            wait for clk_T/2;
            tb_clk <= not tb_clk;
        end process CLK;
    
    WRITE_IN: process is
    begin
        wait for clk_T/2;
        tb_we <= '1';
        tb_data_pos  <= x"0000000000000000";
        tb_instr_pos <= x"0000000000000000";
        for i in 0 to 99
        loop
            tb_instr <= programm(i);
            tb_data <= data_ram(i);
            wait for clk_T;
        end loop;
        tb_we <= '0';
        --
        tb_power_on <= '1';
        wait for clk_T*100;
        tb_power_on <= '0';
        --
        tb_re <= '1';
        wait for clk_T*100;
        tb_re <= '0';
        wait;
    end process;

    PROCESSOR_UNIT: CPU
    Port Map (
        clk => tb_clk,
        power_on => tb_power_on,
        i_we => tb_we,
        i_re => tb_re,
        i_data => tb_data,
        i_instr => tb_instr,
        i_data_pos => tb_data_pos,
        i_instr_pos => tb_instr_pos,
        o_sel_instr => open,
        o_sel_data => open,
        o_read_instr => open,
        o_read_data => open
    );
end architecture;