library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all; 
use ieee.std_logic_textio.all;
use std.textio.all;

entity ram_tb is
end entity ram_tb;

architecture RTL of ram_tb is
    signal tb_clk     : std_logic := '0';
    signal tb_we      : std_logic := '0';
    signal tb_address : std_logic_vector(63 downto 0);
    signal tb_data    : std_logic_vector(63 downto 0);
    signal o_data     : std_logic_vector(63 downto 0);
    constant clk_T    : time := 10 ns; 
    file mem_init_file : text;


begin
    file_open(mem_init_file, "ram_data.txt",  read_mode);

    CLK: process is
    begin
        wait for clk_T/2;
        tb_clk <= not tb_clk;
    end process CLK;


    READ_DATA: process(tb_clk) is
        variable mem_init_line : line;
        variable mem_init_var  : std_logic_vector(63 downto 0);
        variable tmp : string(1 to 100);
        variable len : integer;
    begin
        if rising_edge(tb_clk) then
            if not endfile(mem_init_file) then
                readline(mem_init_file,mem_init_line);
                len := mem_init_line'length;
                tmp := (others => ' ');
                read(mem_init_line,tmp);
                report "Ecco: " & tmp severity note;
                --read(mem_init_line,mem_init_var);
                --o_data <= mem_init_var;
            else
                --file_close(mem_init_file);
            end if;
        end if;
    end process READ_DATA;

end architecture RTL;

