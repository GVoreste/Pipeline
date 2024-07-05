library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity ImmGen is
    port (
        i_instr : in std_logic_vector(31 downto 0);
        o_imm : out std_logic_vector(63 downto 0)
    );
end ImmGen;

architecture RTL of ImmGen is
    signal l_opcode : std_logic_vector(6 downto 0);
    signal l_imm12 : std_logic_vector(11 downto 0);
    signal l_imm : std_logic_vector(63 downto 0);
begin
    process (i_instr, l_imm12, l_opcode) is
    begin
        l_opcode <= i_instr(6 downto 0);
        case l_opcode is
            when B"0000011" => -- I-Type (LD)
                l_imm12 <= i_instr(31 downto 20);
            when B"0010011" => -- I-Type (ADDI)
                l_imm12 <= i_instr(31 downto 20);

            when B"0100011" => -- S-Type (SD)
                l_imm12 <= i_instr(31 downto 25) & i_instr(11 downto 7);
            when B"1100011" => -- SB-Type (Branch)
                l_imm12 <= i_instr(31) & i_instr(7) & i_instr(30 downto 25) & i_instr(11 downto 8);
            when others => -- NOP and unknown
                l_imm12 <= x"000";
        end case;
        if l_imm12(11) = '1' then
            l_imm <= x"FFFFFFFFFFFFF" & l_imm12;
        else
            l_imm <= x"0000000000000" & l_imm12;
        end if;
    end process;
    o_imm <= l_imm;
end architecture;