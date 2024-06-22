entity fwdUnit is
    port (
      clk               : in  std_logic;
      i_EX_reg_A        : in  std_logic_vector(4 downto 0);
      i_EX_reg_B        : in  std_logic_vector(4 downto 0);
      i_MEM_reg_W       : in  std_logic_vector(4 downto 0);
      i_MEM_we_reg      : in  std_logic;
      i_WB_reg_W        : in  std_logic_vector(4 downto 0);
      i_WB_we_reg       : in  std_logic;
      o_fwd_A           : out std_logic_vector(1 downto 0);
      o_fwd_B           : out std_logic_vector(1 downto 0)
    );
  end entity fwdUnit;
  
  architecture RTL of fwdUnit is
  begin
    process(clk)
    begin
        o_fwd_A <= B"00";
        o_fwd_B <= B"00"; 
        
        if i_MEM_we_reg then
            if i_MEM_reg_W /= B"00000" then
                if  i_EX_reg_A = i_MEM_reg_W then
                    o_fwd_A <= B"10"; 
                end if;
                if  i_EX_reg_B = i_MEM_reg_W then
                    o_fwd_B <= B"10"; 
                end if;
            end if;
        end if;

        if i_WB_we_reg then
            if i_WB_reg_W /= B"00000" then
                if  i_EX_reg_A = i_MEM_reg_W and
                    not (
                            i_MEM_we_reg and 
                            i_MEM_reg_W /= B"00000" and 
                            i_EX_reg_A = i_MEM_reg_W
                        ) then
                    o_fwd_A <= B"01"; 
                end if;
                if  i_EX_reg_B = i_MEM_reg_W and
                    not (
                            i_MEM_we_reg and 
                            i_MEM_reg_W /= B"00000" and 
                            i_EX_reg_B = i_MEM_reg_W
                        ) then
                    o_fwd_B <= B"01"; 
                end if;
            end if;
        end if;
    end process;
  end architecture RTL;