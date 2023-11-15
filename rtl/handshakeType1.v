module handshakeType1(
    input wire clk,
    input wire reset_n,
    input wire valid_pre_i,
    input wire ready_post_i,
    input wire [7:0] data_i,

    output wire valid_post_o,
    output wire ready_pre_o,
    output wire [7:0] data_o
);

assign ready_pre_o = ready_post_i;
assign valid_post_o = valid_pre_i;
assign data_o = data_i;

endmodule
