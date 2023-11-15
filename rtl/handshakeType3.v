module handshakeType3(
    input wire clk,
    input wire reset_n,
    input wire valid_pre_i,
    input wire ready_post_i,
    input wire [7:0] data_i,

    output wire valid_post_o,
    output wire ready_pre_o,
    output wire [7:0] data_o
);

reg valid_buf;
reg [7:0] data_buf;

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        valid_buf <= 1'b0;
        data_buf <= 8'b0;
    end else if (ready_post_i) begin
        valid_buf <= 1'b0;
    end else if(!ready_post_i & ready_pre_o) begin
        valid_buf <= valid_pre_i;
        data_buf  <= data_i;
    end 
end

assign ready_pre_o  = !valid_buf;
assign valid_post_o = valid_buf ? valid_buf : valid_pre_i;
assign data_o       = valid_buf ? data_buf  : data_i;

endmodule