library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port (
        i_operand_a : in std_logic_vector(63 downto 0);
        i_operand_b : in std_logic_vector(63 downto 0);
        i_alu_func : in std_logic_vector(3 downto 0);
        o_zero : out std_logic;
        o_pos : out std_logic;
        o_alu_res : out std_logic_vector(63 downto 0)
    );
end ALU;

architecture RTL of ALU is
    signal l_ADDERres : std_logic_vector(63 downto 0);
    signal l_alu_res : std_logic_vector(63 downto 0);
    signal l_sub : std_logic;
    component Adder
        port (
            i_operand_A : in std_logic_vector(63 downto 0);
            i_operand_B : in std_logic_vector(63 downto 0);
            i_sub : in std_logic;
            o_res : out std_logic_vector(63 downto 0)
        );
    end component;
begin
    process (i_alu_func, i_operand_A, i_operand_B, l_ADDERres, l_alu_res) is
    begin
        case i_alu_func is
            when "0010" => -- ADD
                l_sub <= '0';
                l_alu_res <= l_ADDERres;
            when "0110" => -- SUB
                l_sub <= '1';
                l_alu_res <= l_ADDERres;
            when "0000" => -- OR
                l_sub <= '-';
                for i in 0 to 63
                loop
                    l_alu_res(i) <= i_operand_A(i) or i_operand_B(i);
                end loop;
            when "0001" => -- AND 
                l_sub <= '-';
                for i in 0 to 63
                loop
                    l_alu_res(i) <= i_operand_A(i) and i_operand_B(i);
                end loop;
            when others => -- AND
                l_sub <= '-';
                for i in 0 to 63
                loop
                    l_alu_res(i) <= i_operand_A(i) and i_operand_B(i);
                end loop;
            end case;
            if l_alu_res = x"00000000_00000000" then
                o_Zero <= '1';
            else
                o_Zero <= '0';
            end if;
        end process;
        o_Pos <= '1' when l_alu_res(63) /= '1' else
                    '0';
        o_alu_res <= l_alu_res;
        ADDER_istance : Adder
        port map(
            i_operand_A => i_operand_A,
            i_operand_B => i_operand_B,
            i_sub => l_sub,
            o_res => l_ADDERres
        );

end architecture RTL;