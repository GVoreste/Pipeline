library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity Adder is
    port (
        i_operand_A : in std_logic_vector(63 downto 0);
        i_operand_B : in std_logic_vector(63 downto 0);
        i_sub : in std_logic;
        o_res : out std_logic_vector(63 downto 0)
    );
end entity;

architecture RTL of Adder is
begin
    process (i_operand_A, i_operand_B, i_sub) is
        variable carry : std_logic;
        variable tmp_res : std_logic;
        variable tmp_carry : std_logic;
        variable operand_B : std_logic_vector(63 downto 0);
    begin
        if i_sub = '1' then -- SUB
            carry := '1';
            for i in 0 to 63
            loop
                operand_B(i) := not i_operand_B(i);
            end loop;
        else -- SUM
            carry := '0';
            for i in 0 to 63
            loop
                operand_B(i) := i_operand_B(i);
            end loop;
        end if;
        for i in 0 to 63
        loop
            tmp_res := (i_operand_A(i) xor operand_B(i));
            tmp_carry := (i_operand_A(i) and operand_B(i));
            o_res(i) <= (tmp_res xor carry);
            carry := tmp_carry or (tmp_res and carry);
        end loop;
    end process;

end architecture;