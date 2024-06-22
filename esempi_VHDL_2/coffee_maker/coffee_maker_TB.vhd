-- Coffee_maker Test Bench
-- Novembre 2013 P.V.

library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.NUMERIC.all;

entity COFFEE_MAKER_TB is
end COFFEE_MAKER_TB;

architecture TEST of COFFEE_MAKER_TB is 	

component COFFEE_MAKER
port (	clk: in std_logic;
        rst: in std_logic;
        moneta: in std_logic;                   -- inserita una moneta
        peso_moneta: in std_logic;            -- peso della moneta inserita
        coffee_out: out std_logic);
end component;

signal clk: std_logic;
signal rst: std_logic;
signal moneta, peso_moneta: std_logic;
signal coffee_out: std_logic;

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
		moneta <= '0';
		peso_moneta <= '0';
                
	wait for 150 ns;
		rst <= '0'; -- resetting.....
	wait for 20 ns;
		rst <= '1'; -- end reset
       wait for 100 ns; -- powerupped
-- voglio ingressi disallineati rispetto ai fronti di clock
-- poiche' la propagazione e' sempre non nulla assumo che i segnali in ingresso
-- arrivano (per esempio) dopo 3 ns.
-- Di conseguenza
       wait for 3 ns;
-- Ora la macchina e' pronta per servire i caffe'....

                
-- Prima sequenza 10c, 10c ,10c
		moneta <= '1';
		peso_moneta <= '0';
	wait for 10 ns; -- stop count
		moneta <= '0';
	wait for 30 ns; 
		moneta <= '1';
		peso_moneta <= '0';
	wait for 10 ns; -- stop count
		moneta <= '0';
	wait for 30 ns; 
		moneta <= '1';
		peso_moneta <= '0';
	wait for 10 ns; -- stop count
		moneta <= '0';

-- End prima sequenza 10c, 10c ,10c
	wait for 200 ns; 

-- Seconda sequenza 10c, 20c
		moneta <= '1';
		peso_moneta <= '0';
	wait for 10 ns; -- stop count
		moneta <= '0';
	wait for 30 ns; 
		moneta <= '1';
		peso_moneta <= '1';
	wait for 10 ns; -- stop count
		moneta <= '0';
-- End seconda sequenza 10c, 20c
	wait for 200 ns; 

-- Terza sequenza 20c, 10c
		moneta <= '1';
		peso_moneta <= '1';
	wait for 10 ns; -- stop count
		moneta <= '0';
	wait for 30 ns; 
		moneta <= '1';
		peso_moneta <= '0';
	wait for 10 ns; -- stop count
		moneta <= '0';
-- End terza sequenza 20c, 10c
	wait for 200 ns; 

-- Quarta sequenza 20c, 20c  no resto....
		moneta <= '1';
		peso_moneta <= '1';
	wait for 10 ns; -- stop count
		moneta <= '0';
	wait for 30 ns; 
		moneta <= '1';
		peso_moneta <= '1';
	wait for 10 ns; -- stop count
		moneta <= '0';
-- End quarta sequenza 20c, 20c  no resto....

	wait for 150000 ns;
end process STIMULUS_GEN;

DUT: COFFEE_MAKER
Port Map (
				clk => clk,
				rst => rst,
				moneta => moneta,
				peso_moneta => peso_moneta,
				coffee_out => coffee_out);
end architecture TEST;

