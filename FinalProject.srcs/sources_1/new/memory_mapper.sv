`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2023 10:37:48 PM
// Design Name: 
// Module Name: memory_mapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memory_mapper #(
    parameter w = 32
    
   )(
    input wire cpu_wr,
    input wire [w-1:0] cpu_addr,
    output wire [w-1:0] cpu_readdata,
    
    output wire lights_wr,
    output wire sound_wr,
    input wire [w-1:0] accel_val,
    input wire [w-1:0] keyb_char,
    
    output wire smem_wr,
    input wire [w-1:0] smem_readdata,
    
    output wire dmem_wr,
    input wire [w-1:0] dmem_readdata,
    
    output wire seg_wr,
    input wire [w-1:0] seg_val
    );
    
    assign lights_wr = (cpu_wr==1) && (cpu_addr == 32'h1003_000c) ? 1 : 0; 
    assign sound_wr = (cpu_wr == 1) && (cpu_addr == 32'h1003_0008) ? 1 : 0; 
    assign smem_wr = (cpu_wr == 1) && (cpu_addr <= 32'h1002_12bc && cpu_addr >= 32'h1002_0000) ? 1 : 0; 
    assign dmem_wr = (cpu_wr == 1) && (cpu_addr <= 32'h1001_0ffc && cpu_addr >= 32'h1001_0000) ? 1 : 0; 
    assign seg_wr = (cpu_wr == 1) && (cpu_addr == 32'h1003_0010) ? 1 : 0;
    
    assign cpu_readdata = (cpu_addr[17:16] == 2'b01) ? dmem_readdata : 
                          (cpu_addr[17:16] == 2'b10) ? smem_readdata :
                          (cpu_addr[3:2] == 2'b00)   ? keyb_char     :
                          (cpu_addr[3:2] == 2'b01)   ? accel_val     :
                          (cpu_addr[4:2] == 3'b100)   ? seg_val      : 0;
    
endmodule
