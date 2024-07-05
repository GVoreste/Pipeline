library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity reg_tb is
end entity reg_tb;

architecture RTL of reg_tb is
    signal tb_clk : std_logic := '0';
    signal tb_reg_a : std_logic_vector(4 downto 0) := (others => '0');
    signal tb_reg_b : std_logic_vector(4 downto 0) := (others => '0');
    signal tb_w_reg : std_logic_vector(4 downto 0) := (others => '0');
    signal tb_data_reg : std_logic_vector(63 downto 0) := (others => '0');
    signal tb_we : std_logic := '0';
    constant clk_T : time := 10 ns;

    component registers
        port (
            clk : in std_logic;
            i_reg_a : in std_logic_vector(4 downto 0);
            i_reg_b : in std_logic_vector(4 downto 0);
            i_w_reg : in std_logic_vector(4 downto 0);
            i_data_reg : in std_logic_vector(63 downto 0);
            i_we : in std_logic;
            o_r_data_a : out std_logic_vector(63 downto 0);
            o_r_data_b : out std_logic_vector(63 downto 0)
        );
    end component registers;
begin
    CLK : process is
    begin
        wait for clk_T/2;
        tb_clk <= not tb_clk;
    end process CLK;

    STIMULUS_GEN : process is
    begin
        wait for clk_T/2;
        tb_we <= '1';
        wait for 2 * clk_T;
        tb_w_reg <= std_logic_vector(to_unsigned(1, 5));
        tb_data_reg <= x"00ff00ff00aa0001";
        wait for clk_T;
        tb_reg_a <= std_logic_vector(to_unsigned(1, 5));
        tb_w_reg <= std_logic_vector(to_unsigned(2, 5));
        tb_data_reg <= x"00ff00ff00aa0002";
        wait for clk_T;
        tb_reg_b <= std_logic_vector(to_unsigned(2, 5));
        tb_w_reg <= std_logic_vector(to_unsigned(3, 5));
        tb_data_reg <= x"00ff00ff00aa0003";
        wait for clk_T;
        tb_reg_a <= std_logic_vector(to_unsigned(3, 5));
        tb_w_reg <= std_logic_vector(to_unsigned(29, 5));
        tb_data_reg <= x"00ff00ff00aa001e";
        wait for clk_T;
        tb_reg_b <= std_logic_vector(to_unsigned(29, 5));
        tb_w_reg <= std_logic_vector(to_unsigned(30, 5));
        tb_data_reg <= x"00ff00ff00aa001f";
        wait for clk_T;
        tb_reg_a <= std_logic_vector(to_unsigned(30, 5));
        tb_w_reg <= std_logic_vector(to_unsigned(31, 5));
        tb_data_reg <= x"00ff00ff00aa0020";
        wait for clk_T;
        tb_reg_b <= std_logic_vector(to_unsigned(31, 5));
        tb_w_reg <= std_logic_vector(to_unsigned(0, 5));
        tb_data_reg <= x"55ffffffffffffaa";
        wait for clk_T;
        tb_reg_a <= std_logic_vector(to_unsigned(0, 5));
        wait for clk_T;
        tb_we <= '0';
        tb_reg_b <= std_logic_vector(to_unsigned(0, 5));
        wait for clk_T;
        tb_w_reg <= std_logic_vector(to_unsigned(3, 5));
        tb_data_reg <= x"55ffffffffffffaa";
        wait for clk_T;
        tb_w_reg <= std_logic_vector(to_unsigned(29, 5));
        tb_data_reg <= x"55ffffffffffffaa";
        tb_reg_a <= std_logic_vector(to_unsigned(29, 5));
        tb_reg_b <= std_logic_vector(to_unsigned(3, 5));
        wait;
    end process STIMULUS_GEN;

    reg_file_to_test : registers
    port map(
        clk => tb_clk,
        i_reg_a => tb_reg_a,
        i_reg_b => tb_reg_b,
        i_w_reg => tb_w_reg,
        i_data_reg => tb_data_reg,
        i_we => tb_we,
        o_r_data_a => open,
        o_r_data_b => open
    );
end architecture RTL;