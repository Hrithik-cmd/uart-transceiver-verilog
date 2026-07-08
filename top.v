`timescale 1ns / 1ps
module top(
    input clk,
    input rst,
    input wr_en,
    input [7:0]data_in,
    output [7:0] data_out,
    output data_valid,
    output busy
    );
    wire tx_en, rx_en;
    wire tx_to_rx;
    wire tx_busy, rx_busy;
    
    baud baud_1 (.clk(clk),.rst(rst),.tx_en(tx_en),.rx_en(rx_en));
    
    transmitter transmitter_1(.clk(clk),.rst(rst),.wr_en(wr_en),.tx_en(tx_en),.data_in(data_in),.tx(tx_to_rx),.busy(tx_busy));
    
    receiver receiver_1(.clk(clk),.rst(rst),.rx(tx_to_rx),.rx_en(rx_en),.data_out(data_out),.data_valid(data_valid),.busy(rx_busy));
    
    assign busy=tx_busy | rx_busy;
endmodule