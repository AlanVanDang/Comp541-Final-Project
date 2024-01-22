`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2023 05:48:50 PM
// Design Name: 
// Module Name: vgadisplaydriver
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
`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.vh"    // Replace this with the 640x480 values for actual implementation

module vgadisplaydriver(
    input wire clk,
    output wire [3:0] red, green, blue,
    output wire hsync, vsync
    );

   wire [`xbits-1:0] x;
   wire [`ybits-1:0] y;
   wire activevideo;

   // vgatimer myvgatimer(.clk, .hsync, .vsync, .activevideo, .x, .y);
   // or, simply!!
   
   vgatimer myvgatimer(.*);
   
   
   assign red[3:0]   = (activevideo == 1) ? x[5:2] : 4'b0;
   assign blue[3:0] = (activevideo == 1) ? {x[5:2]+y[5:2]} : 4'b0;
   assign green[3:0]  = (activevideo == 1) ? y[5:2] : 4'b0;

endmodule