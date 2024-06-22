library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FOUR_BIT_ADDER_TB is
end FOUR_BIT_ADDER_TB;

architecture TEST of FOUR_BIT_ADDER_TB is 	

component FOUR_BIT_ADDER is
port (	a: in std_logic_vector(3 downto 0);
	b: in std_logic_vector(3 downto 0);
	c_in: in std_logic;
	s: out std_logic_vector(3 downto 0);
        Ovrf: out std_logic);
end component;
signal a, b, s: std_logic_vector(3 downto 0);
signal c_in: std_logic;
signal Ovrf: std_logic;
begin


c_in <= '0';

STIMULUS_GEN: process
begin
  wait for 10 ns;
  a <= X"1";
  b <= X"2";
  wait for 20 ns;
  a <= X"5";
  b <= X"2";
  wait for 20 ns;
  a <= X"0";
  b <= X"7";
  wait for 20 ns;
  a <= X"7";
  b <= X"1";
  wait for 20 ns;
  a <= X"7";
  b <= X"8";
  wait for 20 ns;
  a <= X"9";
  b <= X"9";
  wait for 300 ns;

end process;

DUT: FOUR_BIT_ADDER
  Port Map (
    a => a,
    b => b,
    c_in => c_in,
    s => s,
    Ovrf => Ovrf);
end architecture TEST;

