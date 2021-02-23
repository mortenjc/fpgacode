

# 
set_time_format -unit ns -decimal_places 3

# clk is 50MHz
create_clock -name clk -period 20.000 [get_ports clk]

# clk_btn is very slow 
create_clock -name clk_btn -period 20000.000 [get_ports clk_btn]

# clk_fast is 5MHz 
create_clock -name clockdiv:clockdiv_i|clk_fast -period 200.000 clockdiv:clockdiv_i|clk_fast

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty