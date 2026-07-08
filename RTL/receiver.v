`timescale 1ns / 1ps
module receiver(
    input clk,
    input rst,
    input rx,
    input rx_en,
    output reg [7:0] data_out,
    output reg data_valid,
    output reg busy
    );
    localparam IDLE=2'b00;
    localparam START=2'b01;
    localparam DATA=2'b10;
    localparam STOP=2'b11;
    
    reg [3:0] sample;
    reg [1:0] state;
    reg [7:0] data;
    reg [2:0] bit_count;
         
    always @(posedge clk or posedge rst)
    begin 
        if(rst)
        begin
            state<=IDLE;
            busy<=1'b0;
            data<=8'd0;
            sample<=4'd0;
            data_valid<=1'b0;
            bit_count<=3'd0;
        end
        else
        begin
            data_valid<=1'b0;
            case(state)
            IDLE:
                begin
                    busy<=1'b0;
                    if(!rx)
                    begin
                    busy<= 1'b1;
                    sample<=0;
                    state<= START;
                    end
                end
            START:
            begin
                if(rx_en)
                begin
                    sample<=sample+1'b1;
                
                    if(sample==4'd7)
                    begin
                        if(rx==0)
                        begin
                        sample<=0;
                        bit_count<=0;
                        state <= DATA;
                        end
                        else
                        state<=IDLE;
                    end
                end
            end
            DATA:
            begin
                if(rx_en)
                begin
                sample<=sample+1'b1;
                    if(sample == 4'd15)
                    begin
                        sample<=0;
                        data[bit_count]<=rx;
                        if(bit_count == 3'd7)
                            state <= STOP;
                        else
                            bit_count <= bit_count + 1'b1;
                    end
                end
            end
            STOP:
            begin
                if (rx_en)
                begin
                    sample <= sample + 4'b1;
            
                    if (sample == 15)
                    begin
                        sample <= 0;
            
                        if (rx == 1)
                        begin
                            data_out   <= data;
                            data_valid <= 1'b1;
                        end
            
                        state <= IDLE;
                    end
                end
            end
            default:
                state <= IDLE;
            endcase
        end
    end
endmodule
