library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity PC is
	port ( 
		clk:         in std_logic;
		i_nextInstr: in std_logic_vector(63 downto 0):= (others => '0');
		i_PCsrc: 	 in std_logic := '0';
		i_PCstall:   in std_logic := '0';
		o_pc:        out std_logic_vector(63 downto 0):= (others => '0')
       );
	constant MAX_PC: integer := 255;
end PC;


architecture count of PC is
	signal o_next_pc: std_logic_vector(63 downto 0):= (others => '0');
begin
	process(clk)
	variable current_pc: std_logic_vector(63 downto 0) := (others => '0');
	begin
		if i_PCstall/='1' and i_PCsrc = '1' then
			o_pc <= std_logic_vector(i_nextInstr);
			o_next_pc <= std_logic_vector(i_nextInstr);
		end if;
		if rising_edge(clk) then
			if i_PCstall/='1' and i_PCsrc /= '1' then
				if unsigned(o_next_pc) > to_unsigned(MAX_PC-4,64) then
					o_next_pc <= std_logic_vector(to_unsigned(0,64));
				else
					o_next_pc <= std_logic_vector(unsigned(o_next_pc) + to_unsigned(4,64));
				end if;
			end if;
			o_pc <= o_next_pc;
		end if;
	end process;

end architecture count;
