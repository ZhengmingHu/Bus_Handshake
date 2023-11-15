module receiver(
    input wire clk,
    input wire reset_n,
    input wire [7:0] data_i,
    input wire valid_i,
    input wire random_ready,

    output wire ready_o
);

reg ready_o_r;

always @ (posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        ready_o_r <= 1'b0;
    end else begin
        ready_o_r <= random_ready; 
    end
end

assign ready_o = ready_o_r;

endmodule