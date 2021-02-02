

# 
set_time_format -unit ns -decimal_places 3

# clk is 50MHz
create_clock -name clk -period 20.000 [get_ports clk]

# s and hs are 1Hz and 2Hz respetively
create_clock -period 20.000 -name clockdivider:clockdiv_i|s clockdivider:clockdiv_i|s
create_clock -period 20.000 -name clockdivider:clockdiv_i|hs clockdivider:clockdiv_i|hs

derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
