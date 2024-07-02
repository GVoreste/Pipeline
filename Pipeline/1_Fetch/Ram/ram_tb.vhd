library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 

entity ram_tb is
end entity ram_tb;

architecture RTL of ram_tb is
    signal tb_clk     : std_logic := '0';
    signal tb_we      : std_logic := '0';
    signal tb_address : std_logic_vector(63 downto 0):= (others => '0');
    signal tb_data    : std_logic_vector(31 downto 0):= (others => '0');
    signal o_data     : std_logic_vector(31 downto 0):= (others => '0');
    constant clk_T    : time := 10 ns; 

    component sync_ram is
        port (
          clk       : in  std_logic;
          i_reg_stall: in  std_logic;
          i_we      : in  std_logic;
          i_address : in  std_logic_vector;
          i_data    : in  std_logic_vector;
          o_data    : out std_logic_vector
        );
    end component sync_ram;

begin

    CLK: process is
    begin
        wait for clk_T/2;
        tb_clk <= not tb_clk;
    end process CLK;

    process is
        constant TOP_VAL : unsigned(31 downto 0) := x"00AA001f";
    begin
        tb_we <= '1';
        wait for clk_T/2;
        for i in 0 to 31
        loop
            tb_data <= std_logic_vector(to_unsigned(i+256,32));
            tb_address <= std_logic_vector(to_unsigned(i,64));
            wait for clk_T;
        end loop;
        wait for clk_T*2;
        tb_we <= '0';
        wait for clk_T*3;
        for i in 0 to 31
        loop
            wait for clk_T;
            tb_address <= std_logic_vector(to_unsigned(i,64));
        end loop;
        wait for 100*clk_T;
    end process;

    INST_MEM: sync_ram
    Port Map(
        clk => tb_clk,
        i_reg_stall => '0',
        i_we => tb_we,
        i_address => tb_address,
        i_data => tb_data,
        o_data => o_data
    );
    

end architecture RTL;

