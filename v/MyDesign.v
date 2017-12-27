// WRITTEN BY: kkpaul@ncsu.edu
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
// DUT
// synopsys translate_off
`include "/afs/eos.ncsu.edu/dist/synopsys2013/syn/dw/sim_ver/DW02_mult_3_stage.v"
//synopsys translate_on
`include "mac.v"
`include "controller.v"
module MyDesign (

            //---------------------------------------------------------------------------
            // Control
            //
            output wire                  dut__xxx__finish   ,
            input  wire                 xxx__dut__go       ,  

            //---------------------------------------------------------------------------
            // b-vector memory 
            //
            output wire  [ 9:0]          dut__bvm__address  ,
            output wire                  dut__bvm__enable   ,
            output wire                  dut__bvm__write    ,
            output wire  [15:0]          dut__bvm__data     ,  // write data
            input  wire [15:0]          bvm__dut__data     ,  // read data
            
            //---------------------------------------------------------------------------
            // Input data memory 
            //
            output wire  [ 8:0]          dut__dim__address  ,
            output wire                  dut__dim__enable   ,
            output wire                  dut__dim__write    ,
            output reg  [15:0]          dut__dim__data     ,  // write data
            input  wire [15:0]          dim__dut__data     ,  // read data


            //---------------------------------------------------------------------------
            // Output data memory 
            //
            output wire  [ 2:0]          dut__dom__address  ,
            output reg  [15:0]          dut__dom__data     ,  // write data
            output wire                  dut__dom__enable   ,
            output wire                  dut__dom__write    ,


            //-------------------------------
            // General
            //
            input  wire                 clk             ,
            input  wire                 reset  

            );



wire enableq1;
wire enableq2;
wire enableq3;
wire enableq4;
wire clear;


wire [31:0] sop_q1;
wire [31:0] sop_q2;
wire [31:0] sop_q3;
wire [31:0] sop_q4;
reg [15:0] sop;
wire [3:0] quad_count;

always @ (*)
begin
if((quad_count=='d0)||(quad_count=='d1)||(quad_count=='d4)||(quad_count=='d5))
  sop =  sop_q1[31:16];
else if((quad_count=='d2)||(quad_count=='d3)||(quad_count=='d6)||(quad_count=='d7))
  sop =  sop_q2[31:16];
else if((quad_count=='d8)||(quad_count=='d9)||(quad_count=='d12)||(quad_count=='d13))
 sop = sop_q3[31:16];
else if((quad_count=='d10)||(quad_count=='d11)||(quad_count=='d14)||(quad_count=='d15))
 sop = sop_q4[31:16];
else
 sop = 32'h0000;
end


always@(posedge clk or posedge reset)
begin
if(reset)
dut__dim__data<=16'h0000;
else if(sop[15]==0)
dut__dim__data<= sop[15:0];
else
dut__dim__data<=16'h0000;
end


always@(posedge clk or posedge reset)
begin
if(reset)
dut__dom__data<=16'h0000;
else if(sop_q1[31]==0)
dut__dom__data <= sop_q1[31:16];
else
dut__dom__data <= 16'h0000;
end


controller CONTROL(.dut__xxx__finish(dut__xxx__finish), .xxx__dut__go(xxx__dut__go), .dut__bvm__address(dut__bvm__address), .dut__bvm__enable(dut__bvm__enable), .dut__bvm__write(dut__bvm__write), .dut__dim__address(dut__dim__address), .dut__dim__enable(dut__dim__enable), .dut__dim__write(dut__dim__write), .dut__dom__address(dut__dom__address), .dut__dom__enable(dut__dom__enable), .dut__dom__write(dut__dom__write), .clk(clk), .reset(reset), .enableq1(enableq1), .enableq2(enableq2), .enableq3(enableq3), .enableq4(enableq4), .clear(clear), .quad_count(quad_count));

mac FILTER1_Q1(.A(dim__dut__data),.B(bvm__dut__data),.C(sop_q1),.enable(enableq1),.reset(reset),.clk(clk),.clear(clear));
mac FILTER1_Q2(.A(dim__dut__data),.B(bvm__dut__data),.C(sop_q2),.enable(enableq2),.reset(reset),.clk(clk),.clear(clear));
mac FILTER1_Q3(.A(dim__dut__data),.B(bvm__dut__data),.C(sop_q3),.enable(enableq3),.reset(reset),.clk(clk),.clear(clear));
mac FILTER1_Q4(.A(dim__dut__data),.B(bvm__dut__data),.C(sop_q4),.enable(enableq4),.reset(reset),.clk(clk),.clear(clear));




endmodule
