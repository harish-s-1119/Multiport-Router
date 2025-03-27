module Router_tb();

  reg [15:0] data_in[16:0];
  wire [15:0] data_out[2:0];
  reg [16:0] valid_in;
  wire [3:0] valid_out;
  reg clk, reset;
//Unit under test to testbench
  Router UUT (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .valid_in(valid_in),
    .valid_out(valid_out),
    .data_out(data_out)
  );

  // Probes for FIFO to make sure the data_in is routed to right FIFO storage
  wire [15:0] FIFO_full[0:16];
  generate
    genvar i;
    for (i = 0; i < 17; i++) begin
      assign FIFO_full[i] = UUT.FIFO_full[i];
    end
  endgenerate

  // Clock signal generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // clearing all output ports using the reset signal
  initial begin
    reset = 1;
    #20;  // Hold reset high 
    reset = 0;
  end

 
  initial begin     // Initialize all input ports to obtain output data which has been inputted by the testbench
    data_in = '{default: 16'b0}; // Initialize all elements to 0
    valid_in = 17'b0;

    for (int i = 0; i < 17; i++) begin
      data_in[i] = $random;
      valid_in[i] = 1;
      #10;
      valid_in[i] = 0;
      #10;
    end
    #100;
    $stop;
  end

  // Clock generation
  always @(posedge clk) begin
    $display("TIME: %0t, DATA_IN: %p, FIFO_DATA: %p, DATA_OUT: %p",
             $time, data_in, FIFO_full, data_out);
  end
initial begin $dumpfile("dump.vcd"); $dumpvars(0); end 
  
endmodule