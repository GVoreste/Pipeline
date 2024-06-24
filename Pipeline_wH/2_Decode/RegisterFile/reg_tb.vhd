library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 


entity reg_tb is
end entity reg_tb;

architecture RTL of reg_tb is
    signal tb_clk : std_logic := '0';
    signal tb_reg_A:     std_logic_vector(4 downto 0):= (others => '0');
    signal tb_reg_B: 	  std_logic_vector(4 downto 0):= (others => '0');
    signal tb_reg_W:      std_logic_vector(4 downto 0):= (others => '0');
    signal tb_data:      std_logic_vector(63 downto 0):= (others => '0');
    signal tb_we:        std_logic := '0';
    signal o_data_A:    std_logic_vector(63 downto 0):= (others => '0');
    signal o_data_B:    std_logic_vector(63 downto 0):= (others => '0');
    constant clk_T : time := 10 ns;

    component registers 
        port ( clk:         in std_logic;
               i_reg_A:     in std_logic_vector(4 downto 0):= (others => '0');
               i_reg_B: 	in std_logic_vector(4 downto 0):= (others => '0');
               i_reg_W:      in std_logic_vector(4 downto 0):= (others => '0');
               i_data:      in std_logic_vector(63 downto 0):= (others => '0');
               i_we:        in std_logic := '0';
               o_data_A:    out std_logic_vector(63 downto 0):= (others => '0');
               o_data_B:    out std_logic_vector(63 downto 0):= (others => '0')
               );
    end component registers;
begin
    CLK: process is
    begin
        wait for clk_T/2;
        tb_clk <= not tb_clk;
    end process CLK;

    STIMULUS_GEN: process is
    begin
        wait for clk_T/4;
        tb_we <= '1';
        wait for 2*clk_T;
        tb_reg_W <= std_logic_vector(to_unsigned(1,5));
        tb_data  <= x"00ff00ff00aa0001";
        wait for clk_T*2;
        tb_reg_A  <= std_logic_vector(to_unsigned(1,5));
        tb_reg_W <= std_logic_vector(to_unsigned(2,5));
        tb_data  <= x"00ff00ff00aa0002";
        wait for clk_T*2;
        tb_reg_B  <= std_logic_vector(to_unsigned(2,5));
        tb_reg_W <= std_logic_vector(to_unsigned(3,5));
        tb_data  <= x"00ff00ff00aa0003";
        wait for clk_T*2;
        tb_reg_A  <= std_logic_vector(to_unsigned(3,5));
        tb_reg_W <= std_logic_vector(to_unsigned(29,5));
        tb_data  <= x"00ff00ff00aa001e";
        wait for clk_T*2;
        tb_reg_B  <= std_logic_vector(to_unsigned(29,5));
        tb_reg_W <= std_logic_vector(to_unsigned(30,5));
        tb_data  <= x"00ff00ff00aa001f";
        wait for clk_T*2;
        tb_reg_A  <= std_logic_vector(to_unsigned(30,5));
        tb_reg_W <= std_logic_vector(to_unsigned(31,5));
        tb_data  <= x"00ff00ff00aa0020";
        wait for clk_T*2;
        tb_reg_B  <= std_logic_vector(to_unsigned(31,5));
        tb_reg_W <= std_logic_vector(to_unsigned(0,5));
        tb_data  <= x"55ffffffffffffaa";
        wait for clk_T*2;
        tb_reg_A  <= std_logic_vector(to_unsigned(0,5));
        wait for clk_T;
        tb_we <= '0';
        tb_reg_B  <= std_logic_vector(to_unsigned(0,5));
        wait for clk_T*2;
        tb_reg_W <= std_logic_vector(to_unsigned(3,5));
        tb_data  <= x"55ffffffffffffaa";
        wait for clk_T*2;
        tb_reg_W <= std_logic_vector(to_unsigned(29,5));
        tb_data  <= x"55ffffffffffffaa";
        tb_reg_A  <= std_logic_vector(to_unsigned(29,5));
        tb_reg_B  <= std_logic_vector(to_unsigned(3,5));
        wait for clk_T*100;
    end process STIMULUS_GEN;

    reg_file_to_test: registers
    Port Map (
        clk      => tb_clk,
        i_reg_A  => tb_reg_A,
        i_reg_B  => tb_reg_B,
        i_reg_W   => tb_reg_W,
        i_data   => tb_data,
        i_we     => tb_we,
        o_data_A => o_data_A,
        o_data_B => o_data_B
    );
end architecture RTL;