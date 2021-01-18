
typedef bit[10:0] addr_t /* verilator public */ ;
typedef bit[7:0] data_t /* verilator public */ ;

module cpumemory(
  input bit clk,
  input bit readwrite,
  input addr_t addr,
  output data_t data
  );

  parameter memory_file="";
  data_t memory_table[2048];

  initial begin
    $display("Loading rom.");
    $readmemh(memory_file, memory_table);
  end

  always_ff @(posedge clk) begin
    if (readwrite == 1) /* read */
      data <= memory_table[addr];
    else begin
      memory_table[addr] <= data;
    end
  end

  endmodule
