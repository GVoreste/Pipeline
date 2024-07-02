library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity Mem_Access is
    port (
        clk: in std_logic;
        i_ALUres: in std_logic_vector(63 downto 0);
        i_data_MEM: in std_logic_vector(63 downto 0);
        i_reg_W: in std_logic_vector(4 downto 0);
        i_nextInstr: in std_logic_vector(63 downto 0);
        -- Control signals
        i_bge: in std_logic;
        i_branch: in std_logic;
        i_mem_read: in std_logic;
        i_mem_write: in std_logic;
        i_reg_write: in std_logic;
        i_regsrc: in std_logic;
        i_Zero: in std_logic;
        i_Pos: in std_logic;
        --
        -- OUT
        --
        o_nextInstr: out std_logic_vector(63 downto 0);
        o_mem_data: out std_logic_vector(63 downto 0);
        o_ALUres: out std_logic_vector(63 downto 0);
        o_reg_W: out std_logic_vector(4 downto 0);
        --
        o_PCsrc: out std_logic;
        --
        o_regsrc: out std_logic;
        o_reg_write: out std_logic
        
    );
end entity;


architecture RTL of Mem_Access is
    component sync_data_ram
        port(
            clk       : in  std_logic;
            i_we      : in  std_logic;
            i_re      : in  std_logic;
            i_address : in  std_logic_vector(63 downto 0);
            i_data    : in  std_logic_vector(63 downto 0);
            o_data    : out std_logic_vector
        );
    end component sync_data_ram;
    signal r_ALUres: std_logic_vector(63 downto 0);
    signal r_reg_W: std_logic_vector(4 downto 0);
    signal r_regsrc: std_logic;
    signal r_reg_write: std_logic;
    signal r_branch: std_logic;
    signal r_Zero: std_logic;
begin
    -- r_branch <= i_branch;
    -- r_Zero <= i_Zero;
    --
    o_PCsrc <= '1' when i_branch='1' and ((i_Pos='1' and i_bge='1') or (i_Zero='1' and i_bge/='1')) else '0';
    o_nextInstr <= i_nextInstr;
    r_ALUres <= i_ALUres;
    r_reg_W <= i_reg_W;
    --
    r_regsrc <= i_regsrc;
    r_reg_write <= i_reg_write;
    process(clk) is
    begin
        if rising_edge(clk) then
            -- if r_branch='1' and r_Zero='1' then
            --     o_PCsrc <= '1';
            -- else
            --     o_PCsrc <= '0';
            -- end if;
            o_ALUres <= r_ALUres;
            o_reg_W <= r_reg_W;
            --
            o_regsrc <= r_regsrc;
            o_reg_write <= r_reg_write;
        end if;
    end process;

    DATA_MEMORY: sync_data_ram
    Port Map(
        clk => clk,
        i_we => i_mem_write,
        i_re => i_mem_read,
        i_address => i_ALUres,
        i_data => i_data_MEM,
        o_data => o_mem_data
    );

end architecture;