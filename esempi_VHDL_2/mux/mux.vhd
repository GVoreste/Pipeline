library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux is
  port (x0, x1, x2, x3: in STD_LOGIC_vector(7 downto 0);
        sel: in STD_LOGIC_VECTOR(1 downto 0);
        y:   out STD_LOGIC_vector(7 downto 0)
        );
end MUX;

---------------------------------
-- with_when architecture --
---------------------------------
-- architecture with_when of mux IS

-- BEGIN

-- y <= x0 when sel="00" else
--      x1 when sel="01" else
--      x2 when sel="10" else
--      x3;
     
-- end architecture;



---------------------------------
--   with_select architecture  --
---------------------------------
architecture with_select of mux IS

BEGIN
  with sel SELECT
y <= x3 when "00",
     x2 when "01",
     x1 when "10",
     x0 when OTHERS;
     
end architecture;



---------------------------------
--   with_if architecture  --
---------------------------------

-- architecture with_if of mux IS

-- begin

-- process(sel,x0,x2,x3)
-- begin
--   if sel="00" then
--     y<=x0;
--   elsif sel="01" then
--     y<=x1;
--   elsif sel="10" then
--     y<=x2;
--   else
--     y<=x3;
--   end if;
-- end process;

-- end architecture;

---------------------------------
--   with_case architecture  --
---------------------------------

-- architecture with_case of mux IS

-- begin

-- process(sel,x0,x1,x2,x3)
-- begin
--   case sel is
--     when "00"   => y<=x0;
--     when "01"   => y<=x1;
--     when "10"   => y<=x2;
--     when OTHERS => y<=x3;
--   end case;
-- end process;
-- end architecture;


--configuration config_when of mux is
--  for with_when
--end for;
--end configuration;

--configuration config_if of mux is
-- for with_if
--end for;
--end configuration;

--configuration config_select of mux is
--  for with_select
--end for;
--end configuration;

--configuration config_case of mux is
--  for with_case
--end for;
--end configuration;
    
