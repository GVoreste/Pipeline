library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity ram_tb is
end entity ram_tb;

architecture RTL of ram_tb is
    signal tb_clk : std_logic := '0';
    signal tb_flush : std_logic := '0';
    signal tb_address : std_logic_vector(63 downto 0) := (others => '0');
    constant clk_T : time := 10 ns;
    component sync_ram is
        port (
            clk : in std_logic;
            i_flush : in std_logic;
            i_address : in std_logic_vector(63 downto 0);
            o_r_data : out std_logic_vector(31 downto 0)
        );
    end component sync_ram;

begin

    CLK : process is
    begin
        wait for clk_T/2;
        tb_clk <= not tb_clk;
    end process CLK;

    process is
    begin
        wait for clk_T/2;
        for i in 0 to 10
            loop
                wait for clk_T;
                tb_address <= std_logic_vector(to_unsigned(i, 64));
            end loop;
            wait for clk_T * 5;

            tb_address <= std_logic_vector(to_unsigned(4, 64));
            wait for clk_T;
            tb_flush <= '1';
            tb_address <= std_logic_vector(to_unsigned(5, 64));
            wait for clk_T;
            tb_flush <= '0';
            tb_address <= std_logic_vector(to_unsigned(6, 64));
            wait for clk_T;
            tb_address <= std_logic_vector(to_unsigned(0, 64));
            wait;
        end process;

        INST_MEM : sync_ram
        port map(
            clk => tb_clk,
            i_flush => tb_flush,
            i_address => tb_address,
            o_r_data => open
        );

    end architecture RTL;