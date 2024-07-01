library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity ControllUnit is
port (
       i_opcode:     in std_logic_vector(6 downto 0):= (others => '0');
	   o_branch:     out std_logic := '0';
       o_mem_read:   out std_logic := '0';
       o_mem_write:  out std_logic := '0';
       o_reg_write:  out std_logic := '0';
       o_ALUsrc:     out std_logic := '0';
       o_regsrc:     out std_logic := '0';
       o_ALUOp:      out std_logic_vector(1 downto 0):= B"00"
       );
end ControllUnit;

architecture RTL of ControllUnit is
begin
    process(i_opcode) is
    begin
        case i_opcode is
            when B"0110011" =>           -- R-format
                o_branch    <= '0';
                o_mem_read  <= '0';
                o_mem_write <= '0';
                o_reg_write <= '1';
                o_ALUsrc    <= '0';
                o_regsrc    <= '0';
                o_ALUOp     <= B"10";
            when B"0100011" =>           -- SD
                o_branch    <= '0';
                o_mem_read  <= '0';
                o_mem_write <= '1';
                o_reg_write <= '0';
                o_ALUsrc    <= '1';
                o_regsrc    <= '-';
                o_ALUOp     <= B"00";
            when B"0000011" =>           -- LD
                o_branch    <= '0';
                o_mem_read  <= '1';
                o_mem_write <= '0';
                o_reg_write <= '1';
                o_ALUsrc    <= '1';
                o_regsrc    <= '1';
                o_ALUOp     <= B"00";
            when B"1100011" =>           -- BEQ BGE
                o_branch    <= '1';
                o_mem_read  <= '0';
                o_mem_write <= '0';
                o_reg_write <= '0';
                o_ALUsrc    <= '0';
                o_regsrc    <= '-';
                o_ALUOp     <= B"01";
            when B"0010011" =>           -- ADDI   (TO TEST)
                o_branch    <= '0';
                o_mem_read  <= '0';
                o_mem_write <= '0';
                o_reg_write <= '1';
                o_ALUsrc    <= '1';
                o_regsrc    <= '0';
                o_ALUOp     <= B"00";
            when others =>               -- NOP and unknown
                o_branch    <= '0';
                o_mem_read  <= '0';
                o_mem_write <= '0';
                o_reg_write <= '0';
                o_ALUsrc    <= '0';
                o_regsrc    <= '0';
                o_ALUOp     <= B"00";
        end case;
    end process;
end architecture;
