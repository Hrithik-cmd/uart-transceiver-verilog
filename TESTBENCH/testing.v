`timescale 1ns / 1ps
module testing();
reg clk;
reg rst;
reg wr_en;
reg[7:0]data_in;
wire[7:0] data_out;
wire data_valid;
wire busy;
top uut(.clk(clk),.rst(rst),.wr_en(wr_en),.data_in(data_in),.data_out(data_out),.data_valid(data_valid),.busy(busy));

always #5 clk=~clk;

initial begin
    clk=0; rst=1; wr_en=0; data_in=8'd0;#20;
    rst=0; #10;
    data_in=8'd152; #10;
    wr_en=1; #30; wr_en=0;
    #4000;
    data_in=8'd143; wr_en=1; #10; wr_en=0;
    #4000;
    $finish;
end
endmodule
