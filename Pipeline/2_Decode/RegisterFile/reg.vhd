library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity registers is
port ( clk:         in std_logic;
       i_reg_A:     in std_logic_vector(4 downto 0):= (others => '0');
	   i_reg_B: 	in std_logic_vector(4 downto 0):= (others => '0');
       i_reg_W:     in std_logic_vector(4 downto 0):= (others => '0');
       i_data:      in std_logic_vector(63 downto 0):= (others => '0');
       i_we:        in std_logic := '0';
       o_data_A:    out std_logic_vector(63 downto 0):= (others => '0');
       o_data_B:    out std_logic_vector(63 downto 0):= (others => '0')
       );
end registers;


architecture RTL of registers is 
    type reg_file is array (0 to 31) of std_logic_vector(63 downto 0);
    signal reg: reg_file :=(
        0  => x"FFFF0000AAAA0000",
        1  => x"FFFF0000AAAA0001",
        2  => x"FFFF0000AAAA0002",
        3  => x"FFFF0000AAAA0003",
        4  => x"FFFF0000AAAA0004",
        5  => x"FFFF0000AAAA0005",
        6  => x"FFFF0000AAAA0006",
        7  => x"FFFF0000AAAA0007",
        8  => x"FFFF0000AAAA0008",
        9  => x"FFFF0000AAAA0009",
        10 => x"FFFF0000AAAA000A",
        11 => x"FFFF0000AAAA000B",
        12 => x"FFFF0000AAAA000C",
        13 => x"FFFF0000AAAA000D",
        14 => x"FFFF0000AAAA000E",
        15 => x"FFFF0000AAAA000F",
        others => (others => '0')
    );
begin 
	process(clk)
	begin
        if unsigned(i_reg_A) /= 0 then
            o_data_A <= reg(to_integer(unsigned(i_reg_A)));
        else
            o_data_A <= (others => '0');
        end if;
        if unsigned(i_reg_B) /= 0 then
            o_data_B <= reg(to_integer(unsigned(i_reg_B)));
        else
            o_data_B <= (others => '0');
        end if;
		if rising_edge(clk) then
			if i_we = '1' then
				reg(to_integer(unsigned(i_reg_W))) <= i_data;
			end if;
		end if;
	end process;
end architecture RTL;
