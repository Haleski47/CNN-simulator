//WRITTEN BY: kkpaul@ncsu.edu
module mac (

input wire [15:0] A,
input wire [15:0] B,

output reg [31:0] C,
input wire enable,

input wire reset,
input wire clear,
input wire clk
);

reg [15:0] dataA;
reg [15:0] dataB;

always@(posedge clk or posedge reset)
begin
if(reset)
dataA <= 16'sh0000;
else if (~enable)
dataA <= 16'sh0000;
else
dataA <= A;
end

always@(posedge clk or posedge reset)
begin
if(reset)
dataB <= 16'sh0000;
else if (~enable)
dataB <= 16'sh0000;
else
dataB <= B;
end

wire [31:0] mult_prod;



always @ (posedge clk or posedge reset)
begin 
  if(reset)
  C <= 32'sh00000000;
  else if(clear)
  C <= 32'sh00000000;	     
  else
  C <= C+mult_prod;
 end



DW02_mult_3_stage#(16,16) U1 (.A(dataA), .B(dataB), .PRODUCT(mult_prod),.CLK(clk), .TC(1'b1));

endmodule

