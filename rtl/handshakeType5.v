module handshakeType5(
    input wire clk,
    input wire reset_n,
    input wire valid_pre_i,
    input wire ready_post_i,
    input wire [7:0] data_i,

    output wire valid_post_o,
    output wire ready_pre_o,
    output wire [7:0] data_o
);

reg valid_o_r;
reg ready_pre_o_r;
reg [7:0] data_o_r;

wire      rd_addr;
wire      wr_addr;
reg [1:0] read_pointer;
reg [1:0] write_pointer;

reg [7:0] fifo_mem [1:0];
wire      fifo_full;
wire      fifo_empty;

assign rd_addr = read_pointer[0];
assign wr_addr = write_pointer[0];


always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        read_pointer <= 2'b0;
    end else if (ready_post_i & (~fifo_empty)) begin
        read_pointer <= read_pointer + 1;
        data_o_r     <= fifo_mem[rd_addr];
    end
end

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        write_pointer <= 2'b0;
    end else if (valid_pre_i & (~fifo_full)) begin
        write_pointer <= write_pointer + 1;
        fifo_mem[wr_addr] <= data_i;
    end
end

assign fifo_empty = (write_pointer == read_pointer);
assign fifo_full  = (read_pointer[1] != write_pointer[1]) & (rd_addr == wr_addr);

assign data_o  = data_o_r;
assign valid_post_o = ~fifo_empty;
assign ready_pre_o = ~fifo_full;

endmodule