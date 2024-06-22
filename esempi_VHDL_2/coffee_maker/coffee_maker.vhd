
-- HP costo caffe' 30c;
-- La macchina accetta monete da 10 e 20 cent ma non da' resto....
-- La macchina distingue tra monete in base al peso (-- 0 leggera == 10c, -- 1 pesante ==20c)

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity COFFEE_MAKER is
port (	clk: in std_logic;
        rst: in std_logic;
        moneta: in std_logic;                   -- inserita una moneta
        peso_moneta: in std_logic;            -- peso della moneta inserita
        coffee_out: out std_logic);
end COFFEE_MAKER;

architecture BU of COFFEE_MAKER is 	
type   CM_STATE_type is (IDLE, ten_cents_INSERTED, twenty_cents_INSERTED, MAKE_COFFEE);
signal CM_STATE : CM_STATE_type;
signal stato: std_logic_vector(1 downto 0);
signal ten_cents, twenty_cents : std_logic;
begin


MONEY_IN: process(clk,rst)
begin
  if(rst='0') then
    ten_cents <= '0';
    twenty_cents <= '0';
  elsif(clk'event and clk='1') then
    if(moneta = '1') then             -- moneta inserita
      if(peso_moneta = '0') then      -- e' leggera?
        ten_cents <= '1';
        twenty_cents <= '0';
--        assert false report "10c inserted..." severity note;
      else                            -- e' pesante
        ten_cents <= '0';
        twenty_cents <= '1';
--        assert false report "20c inserted..." severity note;
      end if;
    else                        --no moneta
      ten_cents <= '0';
      twenty_cents <= '0';
    end if;
  end if;
end process MONEY_IN;
          
-- Moore State Machine

MAIN_SM: process(clk,rst)
begin
  if(rst = '0') then
    CM_STATE <= IDLE; -- a reset in attesa di inserimento monete...
  elsif(clk'event and clk='1') then
      case CM_STATE is
        when IDLE =>
          if(ten_cents = '1') then
             CM_STATE <= ten_cents_INSERTED;
          elsif(twenty_cents = '1') then  
             CM_STATE <= twenty_cents_INSERTED;
          else
             CM_STATE <= IDLE;
          end if;
          
        when ten_cents_INSERTED =>
          if(ten_cents = '1') then
             CM_STATE <= twenty_cents_INSERTED;
          elsif(twenty_cents = '1') then  
             CM_STATE <= MAKE_COFFEE;
          else
             CM_STATE <= ten_cents_INSERTED;
          end if;

        when twenty_cents_INSERTED =>
          if(ten_cents = '1' or twenty_cents = '1') then
             CM_STATE <= MAKE_COFFEE;   -- ricorda... niente resto....
          else
             CM_STATE <= twenty_cents_INSERTED;
          end if;

        when MAKE_COFFEE =>
          CM_STATE <= IDLE;   -- make coffee e torna all'inizio
      end case;
    end if;
end process MAIN_SM;

-- Trick per simulatore GHDL che non gestisce i tipi enumerati....

DECODER_STATE: process(CM_STATE)
  begin
    case CM_STATE is
      when IDLE =>
        stato <= "00";
        assert false report "Insert your money, please..." severity note;
      when ten_cents_INSERTED =>
        stato <= "01";
        assert false report "10c inserted..." severity note;
      when twenty_cents_INSERTED =>
        stato <= "10";
        assert false report "20c inserted..." severity note;
      when MAKE_COFFEE =>
        stato <= "11";
        assert false report "Take your coffee, please..." severity note;
      when others => null;
    end case;
  end process DECODER_STATE;

-- End trick per simulatore GHDL che non gestisce i tipi enumerati....

CM_STATE_DECODER: process(CM_STATE)
begin
  if (CM_STATE = MAKE_COFFEE) then
    coffee_out <= '1';
  else
    coffee_out <= '0';
  end if;
end process CM_STATE_DECODER;

end architecture;

--------------------------------

architecture CM_FSM of COFFEE_MAKER is

type state is (idle, ten_cents_inserted, twenty_cents_inserted, make_coffee);
signal pr_state,nx_state: state;

signal ten_cents, twenty_cents : std_logic;
signal stato: std_logic_vector(1 downto 0);

  
begin

MONEY_IN: process(clk,rst)
begin
  if(rst='0') then
    ten_cents <= '0';
    twenty_cents <= '0';
  elsif(clk'event and clk='1') then
    if(moneta = '1') then             -- moneta inserita
      if(peso_moneta = '0') then      -- e' leggera?
        ten_cents <= '1';
        twenty_cents <= '0';
--        assert false report "10c inserted..." severity note;
      else                            -- e' pesante
        ten_cents <= '0';
        twenty_cents <= '1';
--        assert false report "20c inserted..." severity note;
      end if;
    else                        --no moneta
      ten_cents <= '0';
      twenty_cents <= '0';
    end if;
  end if;
end process MONEY_IN;
  
---- Lower section of FSM ---
process(clk,rst)
begin
  if (rst = '0') then
    pr_state <= idle;
  elsif (clk'event and clk= '1') then
    pr_state <= nx_state;
  end if;
end process;
---- Lower section of FSM ---
process(pr_state,ten_cents,twenty_cents)
begin
  case pr_state is

    when idle =>
      if (ten_cents = '1') then
        nx_state <= ten_cents_inserted;
      elsif(twenty_cents = '1') then  
        nx_state <= twenty_cents_inserted;
      else
        nx_state <= idle;
      end if;

    when ten_cents_inserted =>
      if(ten_cents = '1') then
        nx_state <= twenty_cents_inserted;
      elsif(twenty_cents = '1') then  
        nx_state <= make_coffee;
      else
        nx_state <= ten_cents_inserted;
      end if;      

    when twenty_cents_inserted =>
      if(ten_cents = '1' or twenty_cents = '1') then
        nx_state <= make_coffee;   -- ricorda... niente resto....
       else
        nx_state <= twenty_cents_inserted;
      end if;

    when make_coffee =>
      nx_state <= idle;
   
    end case;

end process;

---- Output section of FSM ---

process(pr_state)
begin
  case pr_state is
    when idle =>
      stato      <= "00";
      coffee_out <= '0';
      assert false report "Insert your money, please..." severity note;
    when ten_cents_INSERTED =>
      stato      <= "01";
      coffee_out <= '0';
      assert false report "10c inserted..." severity note;
    when twenty_cents_INSERTED =>
      stato      <= "10";
      coffee_out <= '0';
      assert false report "20c inserted..." severity note;
    when MAKE_COFFEE =>
      stato      <= "11";
      coffee_out <= '1';
      assert false report "Take your coffee, please..." severity note;
    when others => null;
  end case;
end process;

end architecture;
--------------------------------

architecture CM_FSM_clocked of COFFEE_MAKER is

type state is (idle, ten_cents_inserted, twenty_cents_inserted, make_coffee);
signal pr_state,nx_state: state;

signal ten_cents, twenty_cents : std_logic;
signal stato: std_logic_vector(1 downto 0);

  
begin

MONEY_IN: process(clk,rst)
begin
  if(rst='0') then
    ten_cents <= '0';
    twenty_cents <= '0';
  elsif(clk'event and clk='1') then
    if(moneta = '1') then             -- moneta inserita
      if(peso_moneta = '0') then      -- e' leggera?
        ten_cents <= '1';
        twenty_cents <= '0';
--        assert false report "10c inserted..." severity note;
      else                            -- e' pesante
        ten_cents <= '0';
        twenty_cents <= '1';
--        assert false report "20c inserted..." severity note;
      end if;
    else                        --no moneta
      ten_cents <= '0';
      twenty_cents <= '0';
    end if;
  end if;
end process MONEY_IN;
  
---- Lower section of FSM ---
process(clk,rst)
begin
  if (rst = '0') then
    pr_state <= idle;
  elsif (clk'event and clk= '1') then
    pr_state <= nx_state;
  end if;
end process;
---- Lower section of FSM ---
process(pr_state,ten_cents,twenty_cents)
begin
  case pr_state is

    when idle =>
      if (ten_cents = '1') then
        nx_state <= ten_cents_inserted;
      elsif(twenty_cents = '1') then  
        nx_state <= twenty_cents_inserted;
      else
        nx_state <= idle;
      end if;

    when ten_cents_inserted =>
      if(ten_cents = '1') then
        nx_state <= twenty_cents_inserted;
      elsif(twenty_cents = '1') then  
        nx_state <= make_coffee;
      else
        nx_state <= ten_cents_inserted;
      end if;      

    when twenty_cents_inserted =>
      if(ten_cents = '1' or twenty_cents = '1') then
        nx_state <= make_coffee;   -- ricorda... niente resto....
       else
        nx_state <= twenty_cents_inserted;
      end if;

    when make_coffee =>
      nx_state <= idle;
   
    end case;

end process;

---- Output section of FSM ---

process(clk,rst)
begin
  if rst='0' then
    stato<="00";
    coffee_out<='0';
  elsif clk'event and clk='1' then
    case pr_state is
      when idle =>
        stato      <= "00";
        coffee_out <= '0';
        assert false report "Insert your money, please..." severity note;
      when ten_cents_INSERTED =>
        stato      <= "01";
        coffee_out <= '0';
        assert false report "10c inserted..." severity note;
      when twenty_cents_INSERTED =>
        stato      <= "10";
        coffee_out <= '0';
        assert false report "20c inserted..." severity note;
      when MAKE_COFFEE =>
        stato      <= "11";
        coffee_out <= '1';
        assert false report "Take your coffee, please..." severity note;
      when others => null;
    end case;
  end if;
end process;

end architecture;

-- architecture selection
configuration config1 of COFFEE_MAKER is
 for cm_fsm_clocked
-- for cm_fsm
--  for bu
end for;
end configuration;

