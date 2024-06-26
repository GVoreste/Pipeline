library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity ALU is
port (
       i_operand_A: in std_logic_vector(63 downto 0):= (others => '0');
	   i_operand_B: in std_logic_vector(63 downto 0):= (others => '0');
       i_ALUfunc:   in std_logic_vector( 3 downto 0):= (others => '0');
       o_Zero:      out std_logic := '0';
       o_ALUres:    out std_logic_vector(63 downto 0):=(others => '0')
       );
end ALU;


architecture RTL of ALU is
    signal l_ADDERres: std_logic_vector(63 downto 0):=(others => '0');
    signal l_ALUres: std_logic_vector(63 downto 0):=(others => '0');
    signal l_sub: std_logic := '0';
    component Adder
        port(
            i_operand_A: in std_logic_vector(63 downto 0):= (others => '0');
            i_operand_B: in std_logic_vector(63 downto 0):= (others => '0');
            i_sub:       in std_logic := '0';
            o_res:       out std_logic_vector(63 downto 0):=(others => '0')
        );
    end component;
begin
    process(i_ALUfunc,i_operand_A,i_operand_B,l_ADDERres,l_ALUres) is
    begin
        case i_ALUfunc is
            when "0010" => -- ADD
                l_sub <= '0';
                l_ALUres <= l_ADDERres;
            when "0110" => -- SUB
                l_sub <= '1';
                l_ALUres <= l_ADDERres;
            when "0000" => -- OR
                l_sub <= '-';
                for i in 0 to 63
                loop
                    l_ALUres(i) <= i_operand_A(i) or  i_operand_B(i);
                end loop;
            when "0001" => -- AND 
                l_sub <= '-';
                for i in 0 to 63
                loop
                    l_ALUres(i) <= i_operand_A(i) and  i_operand_B(i);
                end loop;
            when others => -- AND
                l_sub <= '-';
                for i in 0 to 63
                loop
                    l_ALUres(i) <= i_operand_A(i) and  i_operand_B(i);
                end loop;
        end case;
        if l_ALUres = x"00000000_00000000" then
            o_Zero <= '1';
        else
            o_Zero <= '0';
        end if;
    end process;   
    o_ALUres <= l_ALUres;
    ADDER_istance: Adder
    Port Map(
        i_operand_A => i_operand_A,
        i_operand_B => i_operand_B,
        i_sub       => l_sub, 
        o_res       => l_ADDERres
    );
	
end architecture RTL;