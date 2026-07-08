`timescale 1ns / 1ps
module transmitter(
    input clk,
    input rst,
    input wr_en,
    input tx_en,
    input [7:0] data_in,
    output reg tx,
    output reg busy
    );
    
    localparam IDLE=2'b00;
    localparam START=2'b01;
    localparam DATA=2'b10;
    localparam STOP=2'b11;
    
    reg [1:0] state;
    reg [7:0] data;
    reg [2:0] bit_count;
    
    always @(posedge clk or posedge rst)
    begin 
        if(rst)
        begin
            tx<=1'b1;
            state<=IDLE;
            busy<=1'b0;
            data<=8'd0;
            bit_count<=3'd0;
        end
        else
        begin
            case(state)
            IDLE:
                begin
                    tx<=1'b1;
                    busy<=1'b0;
                    if(wr_en)
                    begin
                    data<= data_in;
                    busy<= 1'b1;
                    state<= START;
                    end
                end
            START:
            begin
                if(tx_en)
                begin
                    tx<= 1'b0;
                    bit_count <= 3'd0;
                    state <= DATA;
                end
            end
            DATA:
            begin
                if(tx_en)
                begin
                    tx<= data[bit_count];
                    if(bit_count == 3'd7)
                        state <= STOP;
                    else
                        bit_count <= bit_count + 1'b1;
                end
            end
            STOP:
            begin
                if(tx_en)
                begin
                    tx <= 1'b1;
                    state <= IDLE;
                end
            end
            default:
                state <= IDLE;
            endcase
        end
    end
endmodule
