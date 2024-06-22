--  Hello world program.
use std.textio.all; --  Imports the standard textio package.

--  Defines a design entity, without any ports.
entity HelloWorld is
end entity HelloWorld;

architecture Behaviour of HelloWorld is
begin
   say_hi: process
   variable l : line;
   begin
      write(l,string'("Hello world!"));
      writeline(output,l);
      wait;
   end process say_hi;
end architecture Behaviour; -- of entity HelloWorld
