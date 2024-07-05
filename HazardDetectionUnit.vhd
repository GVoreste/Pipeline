library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity HDU is
    port (
        clk : in std_logic;
        i_branch : in std_logic;
        i_branch_taken : in std_logic;
        i_reg_A : in std_logic_vector(4 downto 0);
        i_reg_B : in std_logic_vector(4 downto 0);
        i_alu_src_imm : in std_logic;
        i_Execute_reg_w : in std_logic_vector(4 downto 0);
        i_Execute_reg_we : in std_logic;
        i_MemAccess_reg_w : in std_logic_vector(4 downto 0);
        i_MemAccess_reg_we : in std_logic;
        o_Fetch_stall : out std_logic;
        o_Decode_stall : out std_logic
    );
end entity;

architecture RTL of HDU is
    signal l_branch_taken : std_logic;
    signal l_branch : std_logic;
    signal r_branch : std_logic;
    signal l_Fetch_stall : std_logic;
    signal r_Fetch_stall : std_logic;
    signal l_Decode_stall : std_logic;
    signal l_control_hazard : std_logic;
    signal r_control_hazard : std_logic;
    signal l_data_hazard : std_logic;
    signal r_data_hazard : std_logic;
begin
    process (clk) is
    begin
        if rising_edge(clk) then
            r_data_hazard <= l_data_hazard;
            r_control_hazard <= l_control_hazard;
            r_Fetch_stall <= l_Fetch_stall;
            r_branch <= l_branch;
        end if;
    end process;
    l_branch_taken <= i_branch_taken;
    l_branch <= i_branch;


    process(i_Execute_reg_we,i_MemAccess_reg_we,i_Execute_reg_w,i_MemAccess_reg_w,i_reg_a,i_reg_b,i_alu_src_imm) is
    begin
        if i_Execute_reg_we = '1' then
            if i_Execute_reg_w /= B"00000" then
                if i_reg_a = i_Execute_reg_w then
                    l_data_hazard <='1';
                elsif (i_reg_b = i_Execute_reg_w) and i_alu_src_imm /= '1' then
                    l_data_hazard <='1';
                else
                    l_data_hazard <='0';
                end if;
            else
                l_data_hazard <='0';
            end if;
        elsif i_MemAccess_reg_we = '1' then
            if i_MemAccess_reg_w /= B"00000" then
                if i_reg_a = i_MemAccess_reg_w then
                    l_data_hazard <='1';
                elsif (i_reg_b = i_MemAccess_reg_w) and i_alu_src_imm /= '1' then
                    l_data_hazard <='1';
                else
                    l_data_hazard <='0';
                end if;
            else
                l_data_hazard <='0';
            end if;
        else
            l_data_hazard <='0';
        end if;
    end process;

    

    l_control_hazard <= '1' when l_branch = '1' and r_branch /= '1' else
                        '0';

    l_Fetch_stall <= '1' when (l_control_hazard = '1' or r_control_hazard = '1') or (l_data_hazard = '1' or r_data_hazard = '1') else
                     '0';
    l_Decode_stall <= '1' when ((l_control_hazard = '1' or r_control_hazard = '1') or (l_data_hazard = '1' or r_data_hazard = '1') or l_branch_taken = '1') else
                      '0';
    o_Fetch_stall <= l_Fetch_stall;
    o_Decode_stall <= l_Decode_stall;
end architecture RTL;