module axi_lite_slave (
    input  logic         ACLK,
    input  logic         ARESETn,
    input  logic [3:0]   AWADDR,
    input  logic         AWVALID,
    output logic         AWREADY,
    input  logic [31:0]  WDATA,
    input  logic         WVALID,
    output logic         WREADY,
    output logic [1:0]   BRESP,
    output logic         BVALID,
    input  logic         BREADY,
    input  logic [3:0]   ARADDR,
    input  logic         ARVALID,
    output logic         ARREADY,
    output logic [31:0]  RDATA,
    output logic [1:0]   RRESP,
    output logic         RVALID,
    input  logic         RREADY
);

    logic [31:0] mem [0:15];

    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            AWREADY <= 0; WREADY <= 0; BVALID <= 0;
            ARREADY <= 0; RVALID <= 0;
            RDATA <= 0; BRESP <= 0; RRESP <= 0;
        end else begin
            AWREADY <= ~AWREADY && AWVALID;
            WREADY  <= ~WREADY && WVALID;
            if (AWREADY && AWVALID && WREADY && WVALID) begin
                mem[AWADDR] <= WDATA;
                BVALID <= 1;
            end else if (BREADY && BVALID) BVALID <= 0;

            ARREADY <= ~ARREADY && ARVALID;
            if (ARREADY && ARVALID) begin
                RDATA <= mem[ARADDR];
                RVALID <= 1;
            end else if (RVALID && RREADY) RVALID <= 0;
        end
    end

endmodule
