`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2023 06:24:36 PM
// Design Name: 
// Module Name: montek_sound_Nexys4
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

module montek_sound_Nexys4(
    input wire clock100,
    input wire unsigned [31:0] period,          // sound period in tens of nanoseconds
                                                // period = 1 means 10 ns (i.e., 100 MHz)      
    output wire audPWM
    );
        
    logic unsigned [31:0] count=0;
    
    always_ff @(posedge clock100)
        count <= (count >= period-1)? 0 : count + 1;           // Counter mod period
        
    assign audPWM = (count < (period >> 1));
    
endmodule
