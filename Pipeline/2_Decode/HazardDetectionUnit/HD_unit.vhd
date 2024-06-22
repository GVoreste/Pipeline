entity hdUnit is
    port (
      clk               : in  std_logic;
      i_DEC_reg_A       : in  std_logic_vector(4 downto 0);
      i_DEC_reg_B       : in  std_logic_vector(4 downto 0);
      i_EX_reg_W        : in  std_logic_vector(4 downto 0);
      i_EX_mem_read     : in  std_logic;
      o_PC_stall           : out std_logic;
      o_DEC_reg_stall      : out std_logic;
      o_cntl_stall           : out std_logic;
    );
  end entity hdUnit;
  
  architecture RTL of hdUnit is
  begin
    process(clk)
    begin
        if i_EX_mem_read then
            if i_DEC_reg_A = i_EX_reg_W or i_DEC_reg_B = i_EX_reg_W then
                o_PC_stall      <= '1';
                o_DEC_reg_stall <= '1';
                o_cntl_stall    <= '1';
            else
                o_PC_stall      <= '0';
                o_DEC_reg_stall <= '0';
                o_cntl_stall    <= '0';
            end if;
        end if;
       
    end process;
  end architecture RTL;