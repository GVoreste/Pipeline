library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity FOUR_BIT_COUNTER is
port (	clk: in std_logic;
	rst: in std_logic;
	count: in std_logic;
	z: out std_logic_vector(3 downto 0)
        );
end FOUR_BIT_COUNTER;



-------------------------------------

--architecture cnt_var of four_bit_counter is
--begin
--
--process(clk,rst)
--variable cnt: integer range 0 to 10;
--begin
--  if (rst = '0') then
--    cnt := 0;
--  elsif (clk'event and clk= '1') then
--    if count = '1' then
--      cnt:= cnt+1;
--      if cnt=10 then
--        cnt:= 0;
--      end if;
--    end if;
--    z <= std_logic_vector(to_unsigned(CNT,4));
--  end if;
--end process;

--end architecture;

-------------------------------------

--architecture cnt_sig_bad of four_bit_counter is
--signal cnt: integer range 0 to 11;
--begin

--process(clk,rst)
--begin
--  if (rst = '0') then
--    cnt <= 0;
--  elsif (clk'event and clk= '1') then
--    if count = '1' then
--      cnt<= cnt+1;
--      if cnt=10 then
--        cnt<= 0;
--      end if;
--    end if;
--    z <= std_logic_vector(to_unsigned(CNT,4));
--  end if;
--end process;

--end architecture;

-------------------------------------

--architecture cnt_sig of four_bit_counter is
--signal cnt: integer range 0 to 9;
--begin

--process(clk,rst)
--begin
--  if (rst = '0') then
--    cnt <= 0;
--  elsif (clk'event and clk= '1') then
--    if count = '1' then
--      if cnt=9 then
--        cnt <= 0;
--      else
--        cnt <= cnt+1;
--      end if;
--    end if;
--    z <= std_logic_vector(to_unsigned(CNT,4));
--  end if;
--end process;

--end architecture;


------------------------------------------------
------------------------------------------------

architecture cnt_sm of four_bit_counter is

  type state is (zero, one, two, three, four, five, six, seven, eight, nine);
  signal pr_state,nx_state: state;
  
begin
-- Lower section of FSM ---
process(clk,rst)
begin
  if (rst = '0') then
    pr_state <= zero;
  elsif (clk'event and clk= '1') then
    pr_state <= nx_state;
  end if;
end process;
---- Lower section of FSM ---
process(pr_state)
begin
 case pr_state is
   when zero =>
     z <= std_logic_vector(to_unsigned(0,4));
     nx_state <= one;
    
   when one =>
     z <= std_logic_vector(to_unsigned(1,4));
     nx_state <= two;

   when two =>
     z <= std_logic_vector(to_unsigned(2,4));
     nx_state <= three;

     when three =>
     z <= std_logic_vector(to_unsigned(3,4));
     nx_state <= four;

     when four =>
     z <= std_logic_vector(to_unsigned(4,4));
    nx_state <= five;

     when five =>
     z <= std_logic_vector(to_unsigned(5,4));
    nx_state <= six;

     when six =>
     z <= std_logic_vector(to_unsigned(6,4));
     nx_state <= seven;

     when seven =>
     z <= std_logic_vector(to_unsigned(7,4));
     nx_state <= eight;

     when eight =>
     z <= std_logic_vector(to_unsigned(8,4));
     nx_state <= nine;

     when nine =>
     z <= std_logic_vector(to_unsigned(9,4));
     nx_state <= zero;
 end case;
end process;
end architecture;

--architecture BEHAVIORAL of FOUR_BIT_COUNTER is 	
--begin

--MY_COUNT: process(clk,rst)
--variable CNT: unsigned(3 downto 0) := "0000";
--begin
--  if(rst = '0') then
--    CNT := "0000";
--  elsif(clk'event and clk= '1') then
--    if (count = '1') then
--      if (CNT = "1111") then
--        CNT := "0000";
--      else
--        CNT := CNT+1;
--      end if;
--    end if;
--    z <= std_logic_vector(CNT);
--  end if;
--end process MY_COUNT;

--end architecture;
  
  
  
-- architecture selection
--configuration config1 of FOUR_BIT_COUNTER is
--  for behavioral
--end for;
--end configuration;

    
