`timescale 1ns / 1ps
module baud(
    input clk,
    input rst,
    output tx_en,
    output rx_en
    );
    reg[5:0] tx_count;
    reg[1:0] rx_count;
    
    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            tx_count<=5'd0;
            rx_count<=1'd0;
        end
    end
    
    always @(posedge clk)
    begin
        if(tx_count==5'b11111)
        tx_count<=5'd0;
        else
        tx_count<=tx_count+1'b1;
    end
    always @(posedge clk)
    begin
        if(rx_count==1'b1)
        rx_count<=1'd0;
        else
        rx_count<=rx_count+1'b1;
    end
    
    assign tx_en=(tx_count==5'd0)?1'b1:1'b0;
    assign rx_en=(rx_count==1'd0)?1'b1:1'b0;
    
endmodule
