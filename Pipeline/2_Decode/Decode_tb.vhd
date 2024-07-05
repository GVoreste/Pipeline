library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity Decode_tb is
end entity Decode_tb;

architecture RTL of Decode_tb is
    type instr_table is array(0 to 99) of std_logic_vector(31 downto 0);
    signal tb_instr_table : instr_table := (
        -- immediate gen  
        --  
        0 => B"101011110101" & B"00001" & B"000" & B"00011" & B"0000011", -- I-Type
        1 => B"101011110101" & B"10001" & B"000" & B"10011" & B"0000011",
        2 => B"010111111010" & B"00001" & B"011" & B"10011" & B"0000011",
        3 => B"010111111010" & B"10001" & B"110" & B"10001" & B"0000011", -- same reg in and out
        4 => (others => '0'),
        5 => (others => '0'),
        --
        6 => B"1010111" & B"00001" & B"00011" & B"000" & B"10101" & B"0100011", -- S-Type
        7 => B"1010111" & B"10001" & B"10011" & B"000" & B"10101" & B"0100011",
        8 => B"0101111" & B"00001" & B"10011" & B"011" & B"11010" & B"0100011",
        9 => B"0101111" & B"10001" & B"10001" & B"110" & B"11010" & B"0100011",
        10 => (others => '0'),
        11 => (others => '0'),
        --
        12 => B"1" & B"101111" & B"00001" & B"00011" & B"000" & B"0101" & B"0" & B"1100011", -- SB-Type
        13 => B"1" & B"101111" & B"10001" & B"10011" & B"000" & B"0101" & B"0" & B"1100011",
        14 => B"0" & B"011111" & B"00001" & B"10011" & B"011" & B"1010" & B"1" & B"1100011",
        15 => B"0" & B"011111" & B"10001" & B"10001" & B"110" & B"1010" & B"1" & B"1100011",
        16 => (others => '0'),
        17 => (others => '0'),
        18 => (others => '0'),
        -- controll unit
        --
        19 => B"0000001" & B"00001" & B"01001" & B"000" & B"00011" & B"0110011", -- R-format
        20 => B"0000011" & B"00001" & B"00001" & B"000" & B"01011" & B"0110011",
        21 => B"0000111" & B"01001" & B"01001" & B"011" & B"01001" & B"0110011",
        22 => B"0001111" & B"00001" & B"01001" & B"110" & B"00001" & B"0110011",
        23 => (others => '0'),
        24 => (others => '0'),
        --
        25 => x"FA005F" & B"0" & B"0100011", -- SD
        26 => x"FA005F" & B"0" & B"0100011",
        27 => x"F500AF" & B"1" & B"0100011",
        28 => x"F500AF" & B"1" & B"0100011",
        29 => (others => '0'),
        30 => (others => '0'),
        --
        31 => x"FA005F" & B"0" & B"0000011", -- LD
        32 => x"FA005F" & B"0" & B"0000011",
        33 => x"F500AF" & B"1" & B"0000011",
        34 => x"F500AF" & B"1" & B"0000011",
        35 => (others => '0'),
        36 => (others => '0'),
        --
        37 => x"FA005F" & B"0" & B"1100011", -- BEQ
        38 => x"FA005F" & B"0" & B"1100011",
        39 => x"F500AF" & B"1" & B"1100011",
        40 => x"F500AF" & B"1" & B"1100011",
        41 => (others => '0'),
        42 => (others => '0'),
        43 => (others => '0'),
        -- Register 0
        44 => B"101011110101" & B"00000" & B"000" & B"00011" & B"0000001", -- I-Type
        45 => B"1010111" & B"00000" & B"00011" & B"000" & B"10101" & B"0000010", -- S-Type
        46 => B"0" & B"011111" & B"00000" & B"00000" & B"110" & B"1010" & B"1" & B"0000011", -- SB-Type
        47 => (others => '0'),
        48 => (others => '0'),
        --
        49 => B"0000001" & B"00001" & B"00000" & B"000" & B"00011" & B"0110011", -- R-format
        50 => B"0000001" & B"00000" & B"00000" & B"000" & B"00000" & B"0110011", -- R-format
        51 => (others => '0'),
        52 => (others => '0'),
        53 => (others => '0'),
        -- NOP and unknown
        54 => (others => '1'),
        others => (others => '0')
    );
    constant clk_T : time := 10 ns;
    signal tb_instr : std_logic_vector(31 downto 0) := (others => '0');
    signal tb_clk : std_logic := '0';
    signal tb_PC : std_logic_vector(63 downto 0) := (others => '0');
    component Decode
        port (
            clk : in std_logic;
            i_instr : in std_logic_vector(31 downto 0) := (others => '0');
            i_pc : in std_logic_vector(63 downto 0) := (others => '0');
            i_w_reg : in std_logic_vector(4 downto 0) := (others => '0');
            i_data_reg : in std_logic_vector(63 downto 0) := (others => '0');
            i_reg_we : in std_logic := '0';
            i_stall : in std_logic := '0';
            o_r_pc : out std_logic_vector(63 downto 0) := (others => '0');
            o_r_data_a : out std_logic_vector(63 downto 0) := (others => '0');
            o_r_data_b : out std_logic_vector(63 downto 0) := (others => '0');
            o_r_imm : out std_logic_vector(63 downto 0) := (others => '0');
            o_r_reg_w : out std_logic_vector(4 downto 0) := (others => '0');
            o_r_func7 : out std_logic_vector(6 downto 0) := (others => '0');
            o_r_func3 : out std_logic_vector(2 downto 0) := (others => '0');
            o_l_reg_a : out std_logic_vector(4 downto 0);
            o_l_reg_b : out std_logic_vector(4 downto 0);
            -- Controll signal
            o_l_branch : out std_logic := '0';
            o_r_branch : out std_logic := '0';
            o_r_mem_rd : out std_logic := '0';
            o_r_mem_we : out std_logic := '0';
            o_r_reg_we : out std_logic := '0';
            o_l_alu_src_imm : out std_logic := '0';
            o_r_alu_src_imm : out std_logic := '0';
            o_r_reg_src_mem : out std_logic := '0';
            o_r_alu_op : out std_logic_vector(1 downto 0) := B"00"
        );
    end component;
begin
    CLK : process is
    begin
        wait for clk_T/2;
        tb_clk <= not tb_clk;
    end process CLK;
    STIMULUS_GEN : process is
        variable opcode : std_logic_vector(6 downto 0) := (others => '0');
    begin
        wait for clk_T/2;
        for i in 0 to 99
            loop
                tb_PC <= std_logic_vector(to_unsigned(i * 4, 64));
                tb_instr <= tb_instr_table(i);
                wait for clk_T;
            end loop;
            wait;
        end process STIMULUS_GEN;

        Decode_to_test : Decode
        port map(
            clk => tb_clk,
            i_instr => tb_instr,
            i_pc => tb_PC,
            i_w_reg => (others => '0'),
            i_data_reg => (others => '0'),
            i_reg_we => '0',
            i_stall => '0',
            o_r_pc => open,
            o_r_data_a => open,
            o_r_data_b => open,
            o_r_imm => open,
            o_r_reg_w => open,
            o_r_func7 => open,
            o_r_func3 => open,
            o_l_reg_a => open,
            o_l_reg_b => open,
            -- Controll signal
            o_l_branch => open,
            o_r_branch => open,
            o_r_mem_rd => open,
            o_r_mem_we => open,
            o_r_reg_we => open,
            o_l_alu_src_imm => open,
            o_r_alu_src_imm => open,
            o_r_reg_src_mem => open,
            o_r_alu_op => open
        );
    end architecture RTL;