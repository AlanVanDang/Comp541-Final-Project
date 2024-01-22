`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2023 10:09:57 PM
// Design Name: 
// Module Name: memIO
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
`default_nettype none

module memIO #(
    parameter w = 32,
    parameter dmem_size = 1024,
    parameter dmem_init = "dmem_test.mem",
    parameter Nchars = 64,
    parameter smem_size = 1200,
    parameter smem_init = "smem_test.mem"
  )(
    input wire clock,

    input wire cpu_wr,
    input wire [w-1:0] cpu_addr,
    output wire [w-1:0] cpu_readdata,
    input wire [w-1:0] cpu_writedata,
    
    output logic [15:0] lights = 16'b0,
    output logic [w-1:0] seg_val,
    output logic [w-1:0] period = 32'b0,
    input wire [w-1:0] accel_val,
    input wire [w-1:0] keyb_char,
    
    input wire [$clog2(smem_size)-1:0] vga_addr,
    output wire [$clog2(Nchars)-1:0] vga_readdata
    );
   
    wire lights_wr;
    wire sound_wr;
    wire smem_wr;
    wire dmem_wr;
    wire seg_wr;
    
    wire [w-1:0] smem_readdata;
    wire [w-1:0] dmem_readdata;
     
    wire [$clog2(Nchars)-1 : 0] temp_smem;
    assign smem_readdata = {{32{1'b0}},temp_smem};
    
    memory_mapper my_memory_mapper(.cpu_wr(cpu_wr), .cpu_addr(cpu_addr),
    .cpu_readdata(cpu_readdata), .lights_wr(lights_wr), .sound_wr(sound_wr),
    .accel_val(accel_val), .keyb_char(keyb_char), .smem_wr(smem_wr),
    .smem_readdata(smem_readdata), .dmem_wr(dmem_wr), .dmem_readdata(dmem_readdata), .seg_wr(seg_wr), .seg_val(seg_val));
    
    
    always_ff @(posedge clock)
        if (lights_wr == 1)
            lights <= cpu_writedata[15:0]; 
    
    always_ff @(posedge clock)
        if (seg_wr == 1)
            seg_val <= cpu_writedata;
    
    always_ff @(posedge clock)
        if (sound_wr == 1)
            period <= cpu_writedata;
     
    ram2port_module #(.Nloc(smem_size), .Dbits($clog2(Nchars)), .initfile(smem_init)) 
    screenmem(.clock(clock), .wr(smem_wr),
    .addr1(cpu_addr[w-1:2]), .addr2(vga_addr), .din(cpu_writedata),
    .dout1(temp_smem), .dout2(vga_readdata));
    
    ram_module #(.Nloc(dmem_size), .Dbits(w), .initfile(dmem_init)) 
    datamem(.clock(clock), .wr(dmem_wr), 
    .addr(cpu_addr[w-1:2]), .din(cpu_writedata), .dout(dmem_readdata));
    
    
    
endmodule
