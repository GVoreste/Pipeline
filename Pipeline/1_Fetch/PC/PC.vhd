library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity PC is
	port ( 
		clk:         in std_logic;
		i_reg_stall: in std_logic;
		i_nextInstr: in std_logic_vector(63 downto 0);
		i_PCsrc: 	 in std_logic;
		i_PCstall:   in std_logic;
		o_pc:        out std_logic_vector(63 downto 0);
		o_l_pc:      out std_logic_vector(63 downto 0)
       );
	constant MAX_PC: integer := 255;
	constant PC_INCREMENT: std_logic_vector(63 downto 0) := x"0000000000000001";
end PC;


architecture count of PC is
	component Adder_fetch
	port (
		i_operand_A:     in std_logic_vector(63 downto 0);
		i_operand_B: 	 in std_logic_vector(63 downto 0);
		i_sub:           in std_logic;
		o_res:           out std_logic_vector(63 downto 0)
        );
    end component Adder_fetch;
	-- signal l_next_pc: std_logic_vector(63 downto 0);
	-- signal r_next_pc: std_logic_vector(63 downto 0) := (others => '0');
	signal l_pc_summed: std_logic_vector(63 downto 0);
	--signal r_pc_summed: std_logic_vector(63 downto 0):= (others => '0');
	signal l_pc: std_logic_vector(63 downto 0);
	-- signal l_new_pc: std_logic_vector(63 downto 0);
	signal r_pc: std_logic_vector(63 downto 0):= x"FFFFFFFFFFFFFFFE";
begin
	process(clk)
	variable v_next_pc: std_logic_vector(63 downto 0) := (others => '0');
	begin
	if rising_edge(clk) then
		--if i_reg_stall /= '1' then
			r_pc <= l_pc;
		--end if;
	end if;
	end process;

	process(i_nextInstr,i_PCsrc,l_pc_summed,i_reg_stall,r_pc,l_pc) is
	begin
	if i_reg_stall /= '1' then
		--l_pc <= i_nextInstr when i_PCsrc = '1' else l_pc_summed;
		if i_PCsrc = '1' then
			l_pc <= i_nextInstr;
		else
			l_pc <= l_pc_summed;
		end if;
		--o_l_pc <= i_nextInstr when i_PCsrc = '1' else l_pc_summed;
	else
		l_pc <= l_pc;
	end if;
	end process;
	o_l_pc <= l_pc;
	o_pc <= r_pc;

	Adder_instance_fetch: Adder_fetch
	Port Map(
		i_operand_A => r_pc,
		i_operand_B => PC_INCREMENT,
		i_sub => '0',
		o_res => l_pc_summed
	);


end architecture count;
