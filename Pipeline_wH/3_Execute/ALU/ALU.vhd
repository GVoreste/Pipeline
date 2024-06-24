library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    type ALUOp is (_SUB_, _ADD_, _OR_, _AND_);
port ( clk:         in std_logic;
       i_operand_A: in std_logic_vector(63 downto 0):= (others => '0');
	   i_operand_B: in std_logic_vector(63 downto 0):= (others => '0');
       i_ALUOp:     in ALUOp;
       o_Zero:      out std_logic := '0';
       o_ALUres:    out std_logic_vector(63 downto 0):=(others => '0');
       );
end ALU;


architecture RTL of ALU is
begin

    case u_ALUOp is
        when _ADD_ => 
            o_ALUres <= std_logic_vector(signed(i_operand_A)+signed(i_operand_B));
        when _SUB_ =>  
            o_ALUres <= std_logic_vector(signed(i_operand_A)-signed(i_operand_B));
        when _OR_ => 
            o_ALUres <= i_operand_A or  i_operand_B;
        when _AND_ => 
            o_ALUres <= i_operand_A and  i_operand_B;

	-- process(clk)
	-- variable current_ALU: unsigned(63 downto 0) := to_unsigned(0,64);
	-- begin
	-- 	if rising_edge(clk) then
	-- 		if i_ALUsrc = '1' then
	-- 			current_ALU := unsigned(i_nextInstr);
	-- 		elsif current_ALU = current_ALU'HIGH then
	-- 			current_ALU := to_unsigned(0,64);
	-- 		else
	-- 			current_ALU := current_ALU + 4;
	-- 		end if;
	-- 		o_ALU <= std_logic_vector(current_ALU);
	-- 	end if;
	-- end process;
end architecture RTL;