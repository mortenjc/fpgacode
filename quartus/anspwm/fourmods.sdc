

# 
set_time_format -unit ns -decimal_places 3

# clk is 50MHz
create_clock -name max10_clk -period 20.000 [get_ports max10_clk]

# clk_btn is very slow 
create_clock -name btn_clk -period 20000.000 [get_ports btn_clk]

# clk_fast is 5MHz 
create_clock -name clockunit:clockunit_i|clockdiv:clockdiv_i|clk_fast -period 200.000 clockunit:clockunit_i|clockdiv:clockdiv_i|clk_fast

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
