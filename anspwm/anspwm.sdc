

# 
set_time_format -unit ns -decimal_places 3

# clk is 50MHz
create_clock -name max10_clk -period 20.000 [get_ports max10_clk]

# ext clk is 6.5536MHz but let's say it must be able to run at 10MHz
create_clock -name ext_clk -period 100.000 [get_ports ext_clk]

# clk_btn is very slow 
create_clock -name btn_clk -period 20000.000 [get_ports btn_clk]

# clk_fast is about 5MHz 
create_clock -name clockunit:clockunit_i|clockdivparm:fpgaclk_to_5MHz|clk_out -period 200.000 clockunit:clockunit_i|clockdivparm:fpgaclk_to_5MHz|clk_out



derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
