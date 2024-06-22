library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity DFF is
port (	clk: in  std_logic;
	rst: in  std_logic;
	clr: in  std_logic;
-- rst async        
	d1:   in  std_logic;
	q1:   out std_logic;
-- clr sync        
	d2:   in  std_logic;
	q2:   out std_logic
        );
end DFF;

architecture BEHAVIORAL of DFF is 	
begin

-- rst async
process(clk,rst)
begin
  if(rst = '0') then
    q1 <= '0';
  elsif(clk'event and clk= '1') then
    q1 <= d1;
  end if;
end process;

--clr sync
process(clk)
begin
  if (clk'event and clk= '1') then
    if clr='1' then 
      q2 <= '0';
    else
      q2 <= d2;
    end if;
  end if;
end process;

end architecture;					
