module handshakeType2(
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
reg [7:0] data_o_r;

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        data_o_r  <= 8'b0;
        valid_o_r <= 1'b0;
    end else if(ready_pre_o) begin
        data_o_r  <= data_i;
        valid_o_r <= valid_pre_i; 
    end
end

assign ready_pre_o = ready_post_i || !valid_o_r;
assign valid_post_o = valid_o_r;
assign data_o = data_o_r;

endmodule
