library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity ALUControl is
port (
       i_ALU_Op:      in std_logic_vector(1 downto 0):= (others => '0');
       i_func3:      in std_logic_vector(2 downto 0):= (others => '0');
       i_func7:      in std_logic_vector(6 downto 0):= (others => '0');
       o_bge:        out std_logic := '0';
       o_ALU_func:    out std_logic_vector(3 downto 0):= B"0000"
       );
end ALUControl;

architecture RTL of ALUControl is
    -- type istruction is ( NOP, LD, SD, BEQ, ADD, SUB, BW_OR, BW_AND);
    -- signal operation:  istruction := NOP;
begin
    process(i_ALU_Op,i_func3,i_func7) is
    begin
    case i_ALU_Op is
        when B"00" =>     -- LD or SD
            o_ALU_func <= B"0010";  -- ADD
            o_bge <= '0';
        when B"01" =>     -- BEQ
            o_ALU_func <= B"0110";  -- SUB
            if i_func3=B"101" then
                o_bge <= '1';
            else
                o_bge <= '0';
            end if;
        when others =>    -- R-type
            if    i_func7=B"0000000"  and i_func3=B"000" then
                o_ALU_func <= B"0010";  -- ADD
            elsif i_func7=B"0100000"  and i_func3=B"000" then
                o_ALU_func <= B"0110";  -- SUB
            elsif i_func7=B"0000000"  and i_func3=B"111" then
                o_ALU_func <= B"0000";  -- AND
            elsif i_func7=B"0000000"  and i_func3=B"110" then
                o_ALU_func <= B"0001";  -- OR
            else
                o_ALU_func <= B"0010";  -- ADD
            end if;
            o_bge <= '0';
    end case;
    end process;
end architecture;
