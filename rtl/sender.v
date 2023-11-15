module sender(
    input wire  clk,
    input wire  reset_n,
    input wire  random_valid,
    input wire  ready_i,
    
    output wire valid_o,
    output wire [7:0] data_o
);

reg valid_o_r;
reg [7:0] cnt;

always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        cnt <= 'b1;
    end else if (valid_o & ready_i) begin
        cnt <= cnt + 1;
    end
end

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        valid_o_r <= 1'b0;
    end else begin
        valid_o_r <= random_valid;
    end
end

assign valid_o = valid_o_r;
assign data_o = cnt;

endmodule