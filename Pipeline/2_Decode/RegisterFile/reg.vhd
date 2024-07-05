library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity registers is
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
end registers;

architecture RTL of registers is
    type reg_file is array (0 to 31) of std_logic_vector(63 downto 0);
    signal reg : reg_file := (
        others => (others => '0')
    );
    signal r_data_a : std_logic_vector(63 downto 0);
    signal r_data_b : std_logic_vector(63 downto 0);
    signal l_reg_a : std_logic_vector(4 downto 0);
    signal l_reg_b : std_logic_vector(4 downto 0);
    signal l_w_reg : std_logic_vector(4 downto 0);
    signal l_we : std_logic;
    signal l_data_reg : std_logic_vector(63 downto 0);
begin
    l_reg_a <= i_reg_a;
    l_reg_b <= i_reg_b;
    l_w_reg <= i_w_reg;
    l_data_reg <= i_data_reg;
    l_we <= i_we;
    process (clk)
    begin
        if rising_edge(clk) then

            if unsigned(l_reg_a) /= 0 then
                r_data_a <= reg(to_integer(unsigned(l_reg_a)));
            else
                r_data_a <= (others => '0');
            end if;
            if unsigned(l_reg_b) /= 0 then
                r_data_b <= reg(to_integer(unsigned(l_reg_b)));
            else
                r_data_b <= (others => '0');
            end if;

            if l_we = '1' then
                reg(to_integer(unsigned(l_w_reg))) <= l_data_reg;
            end if;

        end if;
    end process;
    o_r_data_a <= r_data_a;
    o_r_data_b <= r_data_b;
end architecture RTL;