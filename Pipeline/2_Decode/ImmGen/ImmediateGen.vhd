library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity ImmGen is
port (
       i_instr:      in std_logic_vector(31 downto 0):= (others => '0');
	   o_imm:        out std_logic_vector(63 downto 0):= (others => '0')
       );
end ImmGen;

architecture RTL of ImmGen is
begin
    process(i_instr) is
    variable opcode: std_logic_vector(6 downto 0):= (others => '0');
    variable imm12:  std_logic_vector(11 downto 0):= (others => '0');
    begin
        opcode := i_instr(6 downto 0);
        case opcode is
            when B"0000011" =>           -- I-Type (LD)
               imm12 := i_instr(31 downto 20);
            when B"0010011" =>           -- I-Type (ADDI)
               imm12 := i_instr(31 downto 20);

            when B"0100011" =>           -- S-Type (SD)
               imm12 := i_instr(31 downto 25) & i_instr(11 downto 7);
            when B"1100011" =>           -- SB-Type (Branch)
               imm12 := i_instr(31) & i_instr(7) & i_instr(30 downto 25) & i_instr(11 downto 8);
            when others =>               -- NOP and unknown
               imm12 := x"000";
        end case;
        if imm12(11) = '1' then
            o_imm <= x"FFFFFFFFFFFFF" & imm12;
        else
            o_imm <= x"0000000000000" & imm12;
        end if;
    end process;
end architecture;