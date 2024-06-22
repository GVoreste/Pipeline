library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity dff_TB is
end dff_TB;

architecture TEST of dff_TB is 	

component DFF is
port (	clk: in  std_logic;
	rst: in  std_logic;
	clr: in  std_logic;
-- rst sync        
	d1:  in  std_logic;
	q1:  out std_logic;
-- clr async        
	d2:  in  std_logic;
	q2:  out std_logic
        );
end component;

signal clk, rst, clr: std_logic;
signal d1, d2: std_logic;
signal q1, q2: std_logic;
constant clock_period: TIME := 20 ns;
begin

-- Generatore del clock

CLK_GEN: process
begin
	clk <= '0';
	wait for clock_period/2;
	clk <= '1';
	wait for clock_period/2;
end process CLK_GEN;

STIMULUS_GEN: process
begin
  rst <= '1'; -- no reset @ powerup...
  d1  <= '1';
 wait for 200 ns;
  rst  <= '0'; -- resetting.....
 wait for 20 ns;
  rst  <= '1'; -- end reset
 wait for 20 ns;
  d1  <= '0';
 wait for 20 ns;
  d1  <= '1';
 wait for 40 ns;
  d1  <= '1';
 wait for 80 ns;
  d1  <= '0';
 wait for 5 ns;
  d1  <= '1';
 wait for 80 ns;
  rst <= '0';
 wait for 5 ns;
  rst <= '1'; 
 wait until 1=0;
end process;

STIMULUS_GEN_sync: process
begin
 wait for 600 ns;
  clr <= '1'; -- no reset @ powerup...
  d2  <= '0';
 wait for 100 ns;
  clr <= '0';
  d2  <= '1';
 wait for 55 ns;
  clr <= '1';
 wait for 5 ns;
  clr <= '0';
 wait until 1=0;
end process;

DUT: dff
  Port Map (
    clk => clk,
    rst => rst,
    d1  => d1,
    q1  => q1,
    clr => clr,
    d2  => d2,
    q2  => q2
    );

end architecture TEST;

