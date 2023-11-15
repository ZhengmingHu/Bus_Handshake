module handshakeType4(
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
wire valid_post_m;
wire [7:0] data_m;

reg valid_o_r;
reg [7:0] data_o_r;

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        valid_buf <= 1'b0;
        data_buf <= 8'b0;
    end else if (ready_post_m) begin
        valid_buf <= 1'b0;
    end else if(!ready_post_m & ready_pre_o) begin
        valid_buf <= valid_pre_i;
        data_buf  <= data_i;
    end 
end

assign ready_pre_o  = !valid_buf;
assign valid_post_m = valid_buf ? valid_buf : valid_pre_i;
assign data_m       = valid_buf ? data_buf  : data_i;

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        data_o_r  <= 8'b0;
        valid_o_r <= 1'b0;
    end else if(ready_post_m) begin
        data_o_r  <= data_m;
        valid_o_r <= valid_post_m; 
    end
end

assign ready_post_m = ready_post_i || !valid_o_r;
assign valid_post_o = valid_o_r;
assign data_o = data_o_r;

endmodule