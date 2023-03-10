	component clkctr_s is
		port (
			inclk  : in  std_logic := 'X'; -- inclk
			outclk : out std_logic         -- outclk
		);
	end component clkctr_s;

	u0 : component clkctr_s
		port map (
			inclk  => CONNECTED_TO_inclk,  --  altclkctrl_input.inclk
			outclk => CONNECTED_TO_outclk  -- altclkctrl_output.outclk
		);

