library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity EDGE_DETECTOR is
  Generic(Inv_Delay: TIME := 5 ns);
  Port(
    clk_in: in std_logic;
    clk_out: out std_logic
    );
end EDGE_DETECTOR;

architecture BEHAVIORAL_DF of EDGE_DETECTOR is
signal clk_in_not: std_logic;

begin  -- BEHAVIORAL_DF
  clk_in_not <= not (clk_in) after Inv_Delay;
  clk_out <= clk_in_not and clk_in;

end BEHAVIORAL_DF;

architecture BEHAVIORAL_SEQ of EDGE_DETECTOR is
signal clk_in_not: std_logic;

begin  -- BEHAVIORAL_SEQ
  INV_GATE: process(clk_in)
    begin
      clk_in_not <= not(clk_in) after Inv_Delay;
  end process INV_GATE;
    
  AND_GATE: process(clk_in, clk_in_not)
    begin
      clk_out <= clk_in_not and clk_in;
  end process AND_GATE;

end BEHAVIORAL_SEQ;
    
