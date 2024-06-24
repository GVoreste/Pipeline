library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity PC is
	port ( 
		clk:         in std_logic;
		i_nextInstr: in std_logic_vector(63 downto 0):= (others => '0');
		i_PCsrc: 	 in std_logic := '0';
		i_PCstall:   in std_logic := '0';
		o_pc:        out std_logic_vector(63 downto 0)
       );
end PC;


architecture count of PC is
begin
	process(clk)
	variable current_pc: unsigned(63 downto 0) := to_unsigned(0,64);
	begin
		if rising_edge(clk) then
			if not i_PCstall then
				if i_PCsrc = '1' then
					current_pc := unsigned(i_nextInstr);
				elsif current_pc = current_pc'HIGH then
					current_pc := to_unsigned(0,64);
				else
					current_pc := current_pc + 4;
				end if;
				o_pc <= std_logic_vector(current_pc);
			end if;
		end if;
	end process;
end architecture count;
