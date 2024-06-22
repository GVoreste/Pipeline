library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FULLADDER_TB is
end FULLADDER_TB;

architecture TEST of FULLADDER_TB is 	

component FULLADDER is
port (	a: in std_logic;
	b: in std_logic;
	c_in: in std_logic;
	s: out std_logic;
        c_out: out std_logic);
end component;
signal a, b, s: std_logic;
signal cin: std_logic;
signal cout: std_logic;
begin


STIMULUS_GEN: process
begin
  wait for 100 ns;
  a   <= '0';
  b   <= '0';
  cin <= '0';
  wait for 100 ns;
  a   <= '0';
  b   <= '0';
  cin <= '1';
  wait for 100 ns;
  a   <= '0';
  b   <= '1';
  cin <= '0';
  wait for 100 ns;
  a   <= '0';
  b   <= '1';
  cin <= '1';
  wait for 100 ns;
  a   <= '1';
  b   <= '0';
  cin <= '0';
  wait for 100 ns;
  a   <= '1';
  b   <= '0';
  cin <= '1';
  wait for 100 ns;
  a   <= '1';
  b   <= '1';
  cin <= '0';
  wait for 100 ns;
  a   <= '1';
  b   <= '1';
  cin <= '1';
  wait for 100 ns;
  a   <= '0';
  b   <= '0';
  cin <= '0';  
  wait for 300 ns;
end process;

DUT: FULLADDER
  Port Map (
    a => a,
    b => b,
    c_in => cin,
    s => s,
    c_out => cout);
end architecture TEST;

