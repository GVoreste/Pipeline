library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity FOUR_BIT_COUNTER_TB is
end FOUR_BIT_COUNTER_TB;

architecture TEST of FOUR_BIT_COUNTER_TB is 	

component FOUR_BIT_COUNTER
port (	clk: in std_logic;
			rst: in std_logic;
			count: in std_logic;
			z: out std_logic_vector(3 downto 0));
end component;

signal clk: std_logic;
signal rst: std_logic;
signal count: std_logic;
signal z: std_logic_vector(3 downto 0);

constant clock_period: TIME := 10 ns;
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
  count <= '0';
wait for 150 ns;
  rst <= '0'; -- resetting.....
wait for 20 ns;
  rst <= '1'; -- end reset
wait for 100 ns; -- start count
  count <= '1';
wait for 50 ns; -- stop count
  count <= '0';
wait for 200 ns; -- restart count
  count <= '1';
wait for 200 ns; -- STOP count
  count <= '0';
wait for 150000 ns;
end process STIMULUS_GEN;

DUT: FOUR_BIT_COUNTER
Port Map (
	clk => clk,
	rst => rst,
	count => count,
	z => z);
end architecture TEST;

