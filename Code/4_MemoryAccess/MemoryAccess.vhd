library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity Mem_Access is
    port (
        clk: in std_logic;
        i_alu_res: in std_logic_vector(63 downto 0);
        i_data_mem: in std_logic_vector(63 downto 0);
        i_reg_w: in std_logic_vector(4 downto 0);
        -- Control signals
        i_mem_rd: in std_logic;
        i_mem_we: in std_logic;
        i_reg_we: in std_logic;
        i_reg_src_mem: in std_logic;
        --
        -- OUT
        --
        o_r_mem_data: out std_logic_vector(63 downto 0);
        o_r_alu_res: out std_logic_vector(63 downto 0);
        o_r_reg_w: out std_logic_vector(4 downto 0);
        --
        o_r_reg_src_mem: out std_logic;
        o_r_reg_we: out std_logic
        
    );
end entity;


architecture RTL of Mem_Access is
    component sync_data_ram
        port(
            clk: in  std_logic;
            i_we: in  std_logic;
            i_re: in  std_logic;
            i_address: in  std_logic_vector(63 downto 0);
            i_data_mem: in  std_logic_vector(63 downto 0);
            o_r_data: out std_logic_vector
        );
    end component sync_data_ram;
    signal l_alu_res: std_logic_vector(63 downto 0);
    signal r_alu_res: std_logic_vector(63 downto 0);
    signal l_reg_w: std_logic_vector(4 downto 0);
    signal r_reg_w: std_logic_vector(4 downto 0);
    --
    signal l_reg_src_mem: std_logic;
    signal r_reg_src_mem: std_logic;
    signal l_reg_we: std_logic;
    signal r_reg_we: std_logic;

begin
    l_alu_res <= i_alu_res;
    l_reg_w <= i_reg_w;
    --
    l_reg_src_mem <= i_reg_src_mem;
    l_reg_we <= i_reg_we;
    process(clk) is
    begin
        if rising_edge(clk) then
            r_alu_res <= l_alu_res;
            r_reg_w <= l_reg_w;
            --
            r_reg_src_mem <= l_reg_src_mem;
            r_reg_we <= l_reg_we;
        end if;
    end process;
    o_r_alu_res <= r_alu_res;
    o_r_reg_w <= r_reg_w;
    --
    o_r_reg_src_mem <= r_reg_src_mem;
    o_r_reg_we <= r_reg_we;

    DATA_MEMORY: sync_data_ram
    Port Map(
        clk => clk,
        i_we => i_mem_we,
        i_re => i_mem_rd,
        i_address  => i_alu_res,
        i_data_mem => i_data_mem,
        o_r_data => o_r_mem_data
    );

end architecture;