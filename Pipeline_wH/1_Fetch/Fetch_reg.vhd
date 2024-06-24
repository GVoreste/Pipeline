library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity Fetch is
    port (
        clk:         in std_logic;
        i_nextInstr: in std_logic_vector(63 downto 0):= (others => '0');
        i_PCsrc: 	 in std_logic := '0';
        i_PCstall:   in std_logic := '0';
        i_reg_stall: in std_logic := '0';
        i_Flush:     in std_logic := '0';
        i_PC:        in std_logic_vector(63 downto 0):= (others => '0');
        o_PC:        in std_logic_vector(63 downto 0):= (others => '0');
        o_inst:      in std_logic_vector(31 downto 0):= (others => '0');
    );
end Fetch;

architecture RTL of Fetch is
    signal reg_i_PC:    std_logic_vector(63 downto 0):= (others => '0');
    signal reg_i_instr: std_logic_vector(31 downto 0):= (others => '0');
    component sync_ram
        port (
            clk       : in  std_logic;
            i_we      : in  std_logic;
            i_address : in  std_logic_vector;
            i_data    : in  std_logic_vector;
            o_data    : out std_logic_vector
        );
    end component sync_ram;
    component PC
        port (
            clk:         in std_logic;
            i_nextInstr: in std_logic_vector(63 downto 0):= (others => '0');
            i_PCsrc: 	 in std_logic := '0';
            i_PCstall:   in std_logic := '0';
            o_pc:        out std_logic_vector(63 downto 0)
        );
    end component PC;
begin
    process(clk) 
    begin
        if rising_edge(clk) then
            o_PC <= reg_i_PC;
            if i_Flush then
                o_instr <= std_logic_vector(to_unsigned(0,32))
            end if;
        end if;
    end process;

    INSTRUCTION_MEM: sync_ram
    Port Map (
        clk => clk,
        i_we => '0',
        i_address => ,
        i_data => std_logic_vector(to_unsigned(0,64)),
        o_data => 
    );
    
end architecture;
