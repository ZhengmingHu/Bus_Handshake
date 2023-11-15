module tb_handshakeType1();
logic clk               ;
logic reset_n           ;

logic [7:0] data_pre    ;
logic [7:0] data_post   ;
logic [7:0] data_ref    ;

logic valid_pre         ;
logic ready_pre         ;

logic valid_post        ;
logic ready_post        ;

logic random_valid_pre  ;
logic random_ready_post ;


integer        i        ;
integer        error    ;
integer        cycle_cnt;

sender u_sender(
    .clk(clk),
    .reset_n(reset_n),
    .random_valid(random_valid_pre),
    .ready_i(ready_pre),

    .valid_o(valid_pre),
    .data_o(data_pre)
);

handshakeType2 u_bridge(
    .clk(clk),
    .reset_n(reset_n),
    .valid_pre_i(valid_pre),
    .ready_post_i(ready_post),
    .data_i(data_pre),

    .valid_post_o(valid_post),
    .ready_pre_o(ready_pre),
    .data_o(data_post)
);

receiver u_receiver(
    .clk(clk),
    .reset_n(reset_n),
    .data_i(data_post),
    .valid_i(valid_post),
    .random_ready(random_ready_post),
    .ready_o(ready_post)
);

initial begin
    $dumpfile("tb_handshakeType1.vcd");
    $dumpvars(0, tb_handshakeType1);
end

parameter clk_period = 10;

always #(clk_period/2) clk = ~clk;

initial begin
    clk = 1'b1;
    reset_n = 1'b0;
    cycle_cnt = 0;

    #(clk_period*5);
    @(negedge clk); reset_n = 1'b1;
end

initial begin
    data_ref = 'b1;
    error    = 0;
    while(1) begin
        @(posedge clk) begin
            if(valid_post & ready_post) begin
                data_ref <= #1 data_ref + 1'b1;
                if (data_ref != data_post) begin
                    error <= error + 1;
                    $display("data_ref: %d, data_post:%d", data_ref, data_post);
                end
            end 
        end
    end
end

initial begin
    $display("*********** tb_handshakeType1 *****************");
    i = 0;
    random_valid_pre = 0;
    random_ready_post = 0;
    @(posedge reset_n);
    while (data_ref <= 8'd200) begin
        random_valid_pre  = $random();
        random_ready_post = $random();
        #(clk_period);
        cycle_cnt = cycle_cnt + 1;
    end
    #(clk_period*5);
    $display("cycle_cnt: %d", cycle_cnt);
    if(error == 0)
        $display("*****************PASSED*************************");
    else
        $display("******************ERROR*************************");    
    $finish;
end


endmodule