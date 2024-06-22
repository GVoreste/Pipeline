library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity edge_detector_TB is
end edge_detector_TB;

architecture TEST of edge_detector_TB is 	

component EDGE_DETECTOR is
  Generic(Inv_Delay: TIME := 5 ns);
  Port(
    clk_in: in std_logic;
    clk_out: out std_logic
    );
end component;
signal clk: std_logic;
signal clk_out : std_logic;
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

DUT: edge_detector
  generic map (Inv_Delay => 5 ns)
  Port Map (
	     clk_in => clk,
	     clk_out => clk_out);
end architecture TEST;

configuration ED_seq of edge_detector_TB is
  for TEST
    for DUT : edge_detector
      use entity work.edge_detector(behavioral_seq); 
 --     generic map (Inv_Delay => 0 ns);
    end for;
  end for;

end ED_seq;
