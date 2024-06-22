library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity MUX_TB is
end MUX_TB;

architecture TEST of MUX_TB is 	

component mux is
  port (x0, x1, x2, x3: in STD_LOGIC_VECTOR(7 downto 0);
        sel: in STD_LOGIC_VECTOR(1 downto 0);
        y:   out STD_LOGIC_vector(7 downto 0)
        );
end component;


signal s_x0, s_x1, s_x2, s_x3, s_y:  STD_LOGIC_VECTOR(7 downto 0);
signal s_sel: std_logic_vector(1 downto 0);
begin


STIMULUS_GEN: process
begin
  s_x0  <= x"80";
  s_x1  <= x"81";
  s_x2  <= x"82";
  s_x3  <= x"83";
  s_sel <= "00";
 wait for 60 ns;
  s_x0  <= x"90";
 wait for 60 ns; --120ns
  s_sel <= "01";
 wait for 60 ns; --180ns
  s_x1  <= x"91";
 wait for 60 ns; --240ns
  s_sel <= "10";
 wait for 60 ns; --300ns
  s_x2  <= x"92";
 wait for 60 ns; --360ns
  s_sel <= "11";
 wait for 60 ns; --420ns
  s_x3  <= x"93";
 wait for 60 ns; --480ns
  s_sel <= "00";
 wait until 1=0;
end process;

DUT: MUX
  Port Map
  (
    x0 => s_x0,
    x1 => s_x1,
    x2 => s_x2,
    x3 => s_x3,
    sel => s_sel,
    y => s_y
    );
end architecture TEST;

