//WRITTEN BY: kkpaul@ncsu.edu
module controller(

            //---------------------------------------------------------------------------
            // Control
            //
            output reg                  dut__xxx__finish   ,
            input  wire                 xxx__dut__go       ,  

            //---------------------------------------------------------------------------
            // b-vector memory 
            //
            output reg  [ 9:0]          dut__bvm__address  ,
            output reg                  dut__bvm__enable   ,
            output reg                  dut__bvm__write    ,
            //---------------------------------------------------------------------------
            // Input data memory 
            //
            output reg  [ 8:0]          dut__dim__address  ,
            output reg                  dut__dim__enable   ,
            output reg                  dut__dim__write    ,
            //---------------------------------------------------------------------------
            // Output data memory 
            //
            output reg  [ 2:0]          dut__dom__address  ,
            output reg                  dut__dom__enable   ,
            output reg                  dut__dom__write    ,


            //-------------------------------
            // General
            //
            input  wire                 clk             ,
            input  wire                 reset,  

	    output reg                  enableq1,
	    output reg                  enableq2,
	    output reg                  enableq3,
	    output reg                  enableq4,
            //output reg                  enablef1,

            output 		        clear,
            output reg [3:0] 		quad_count
            //output                      clearB
            );



reg counter_start;
reg [11:0] sys_counter;

always@(*)
begin
if(counter_start == 1'b1)
dut__xxx__finish=1'b0;
else
dut__xxx__finish = 1'b1;
end


always @ (posedge clk)
begin
  if(reset)
      counter_start <= 1'b0;  
  else if (xxx__dut__go)
      counter_start <= 1'b1;
  else if (sys_counter == 'd1511)
      counter_start <= 1'b0;
  else
      counter_start <= counter_start;
end


always @ (posedge clk)
begin
  if(~counter_start)
      sys_counter <= 'd0;
  else
      sys_counter <= sys_counter + 1'd1;
end

reg [7:0] block_counter;

always @ (posedge clk)
begin
   if(~counter_start)
       block_counter <= 'd0;
   else if(block_counter == 'd239)
       block_counter <= 'd0;
   else
       block_counter <= block_counter+1'd1;
end

reg [3:0] filter_counter;

always @ (posedge clk)
begin
  if(~counter_start)
      filter_counter <= 'd0;
  else if (filter_counter == 'd14)
      filter_counter <= 'd0;
  else
      filter_counter <= filter_counter+'d1;
end

reg [7:0] filter2_counter;

always @ (posedge clk)
begin 
   if(sys_counter < 960)
       filter2_counter <= 'd0;
   else if(filter2_counter == 'd68)
       filter2_counter <= 'd0;
   else 
       filter2_counter <= filter2_counter + 1'b1;
end


reg [1:0] array_counter;

always @ (posedge clk)
begin
  if(~counter_start)
      array_counter <= 'd0;
  else if (array_counter == 'd2)
      array_counter <= 'd0;
  else
      array_counter <= array_counter+'d1;
end

reg [8:0]  write_address;

always @ (posedge clk)
begin
  if(~counter_start)
      write_address <= 9'h100;
  else if(filter_counter == 'd14)
      write_address <= write_address + 1'b1;
  else
      write_address <= write_address;
end

//reg [3:0] quad_count;

always @ (posedge clk)
begin
  if(~counter_start)
      quad_count <= 4'h0;
  else if(block_counter == 'd239)
      quad_count <= 4'h0;
  else if(dut__dim__write)
      quad_count <= quad_count + 1'b1;
  else
      quad_count <= quad_count;
end


 
reg [8:0] temp_dut_dim_address;

wire [9:0] add_dim_1;
wire [9:0] add_dim_2;
wire [9:0] add_dim_3;
wire [9:0] add_dim_4;

assign add_dim_1 = temp_dut_dim_address + 3'h5;
assign add_dim_2 = temp_dut_dim_address - 5'h1F;
assign add_dim_3 = dut__dim__address + 4'hE;
assign add_dim_4 = dut__dim__address + 1'b1;

always @ (posedge clk)
begin
 if(sys_counter < 959)
  begin
  if(~counter_start)
      begin
      dut__dim__address <= 9'h000;
      temp_dut_dim_address <= 9'h000;
      end
  else if(block_counter == 'd239)
      begin
      dut__dim__address <= 9'h000;
      temp_dut_dim_address <= 9'h000;
      end
  else if(block_counter == 'd59 || block_counter == 'd119 || block_counter == 'd179)
      dut__dim__address <= add_dim_1;
  else if (filter_counter == 'd8 || filter_counter == 'd9 || filter_counter == 'd10 || filter_counter =='d11 || filter_counter == 'd12)
      temp_dut_dim_address <= dut__dim__address;
  else if (filter_counter == 'd13)
      dut__dim__address <= write_address;      
  else if (filter_counter == 'd14)
      dut__dim__address <= add_dim_2;
  else if  (array_counter == 'd2)
      dut__dim__address <= add_dim_3;
  else
      dut__dim__address <= add_dim_4;
  end
 else
  begin
  if(sys_counter == 959 || sys_counter == 1028 || sys_counter == 1097 || sys_counter == 1166 || sys_counter == 1235 || sys_counter == 1304 || sys_counter == 1373 || sys_counter == 1442)
      dut__dim__address <= 9'h100;
  else
      dut__dim__address <= dut__dim__address + 1'b1;
  end 
end

reg [9:0] temp_dut_bvm_address;

always @ (posedge clk)
begin
 if(sys_counter <'d959)
  begin
  if(~counter_start)
      begin
      dut__bvm__address <= 9'h000;
      temp_dut_bvm_address <= 9'h000;
      end
  else if(sys_counter == 'd239)
      begin
      dut__bvm__address <= 9'h010;
      temp_dut_bvm_address <= 9'h010;
      end
  else if(sys_counter == 'd479)
      begin
      dut__bvm__address <= 9'h020;
      temp_dut_bvm_address <= 9'h020;
      end
  else if(sys_counter == 'd719)
      begin
      dut__bvm__address <=9'h030;
      temp_dut_bvm_address <= 9'h030;
      end
  else if(filter_counter == 'd8 || filter_counter == 'd9 || filter_counter == 'd10 || filter_counter =='d11 || filter_counter == 'd12 || filter_counter == 'd13)
      begin
      temp_dut_bvm_address <= temp_dut_bvm_address;
      dut__bvm__address <= dut__bvm__address;
      end
  else if(filter_counter == 'd14)
      dut__bvm__address <= temp_dut_bvm_address;
  else
      begin
      dut__bvm__address <=dut__bvm__address +1'b1;
      temp_dut_bvm_address <= temp_dut_bvm_address;
      end
  end
 else
  begin
  if(sys_counter == 'd959)
      dut__bvm__address <= 10'h040;
  else if(filter2_counter == 'd63 || filter2_counter =='d64 || filter2_counter == 'd65 || filter2_counter == 'd66 || filter2_counter == 'd67)
      dut__bvm__address <= dut__bvm__address;
  else
      dut__bvm__address <=dut__bvm__address +1'b1;
  end
end

  reg[2:0] current_state;
  reg[2:0] next_state;
  parameter [2:0]
  S0=3'b000,
  S1=3'b001,
  S2=3'b010,
  S3=3'b011,
  S4=3'b100,
  S5=3'b101;
 

always@(posedge clk or posedge reset)
begin
 if(reset)
  dut__dom__address <= 3'b000;
 else if(dut__dom__write)
  dut__dom__address <= dut__dom__address + 1'b1;
 else
  dut__dom__address <= dut__dom__address;
end
 
  always@(posedge clk or posedge reset)
    begin
    if(reset)
      current_state<=S0;
  else
      current_state<=next_state;
    end

 always@(*)
    begin 
              dut__dim__enable   = 1'b0;
              dut__dim__write = 1'b0;
              dut__bvm__enable   = 1'b0;
              dut__bvm__write = 1'b0;
              dut__dom__enable   = 1'b0;
              dut__dom__write = 1'b0;
              next_state = S0;
      case(current_state)
        S0: begin
             if(~counter_start)
       	      next_state = S0;
	     else
	      begin
              next_state = S1;
	      dut__dim__enable   = 1'b1;
              dut__bvm__enable   = 1'b1;     
	      end              
            end
        S1: begin
             if(filter_counter == 'd9)
              begin
              next_state=S2;
              end
             else
              begin
              next_state=S1;
              dut__dim__enable = 1'b1;
              dut__bvm__enable = 1'b1;
              end
            end 
        S2: begin
             if(filter_counter == 'd14)
              begin
               if(sys_counter == 'd959)
                begin
                next_state=S3;
                dut__dim__enable = 1'b1;
                dut__dim__write = 1'b1;
                end
               else
                begin
                next_state=S1;
                dut__dim__enable = 1'b1;
                dut__dim__write = 1'b1;
               end
              end
             else
              begin
              next_state=S2;
              end
            end
        S3: begin
             if(filter2_counter == 'd64)
              begin
              next_state=S4;
              end
             else
              begin
              next_state=S3;
              dut__dim__enable = 1'b1;
              dut__bvm__enable = 1'b1;
              end
            end
        S4: begin
             if(filter2_counter == 'd68)
              begin
               if(sys_counter == 'd1511)
                begin
                next_state=S0;
                dut__dom__enable = 1'b1;
                dut__dom__write = 1'b1;
                end
               else
                begin
                next_state=S3;
                dut__dom__enable = 1'b1;
                dut__dom__write = 1'b1;
               end
              end
             else
              begin
              next_state=S4;
              end      
            end		       
        default:next_state=S0;
      endcase
end


//assign clearB=dut__dom__write;
assign clear=dut__dim__write | dut__dom__write;

always @ (*)
begin
  if(sys_counter<959 & ((quad_count=='d0)||(quad_count=='d1)||(quad_count=='d4)||(quad_count=='d5)))
  begin
  if(filter_counter<=9)
   enableq1 = dut__dim__enable;
  else
   enableq1 = 1'b0;
  end
  else if(sys_counter>959)
  begin
  if(filter2_counter<=64)
   enableq1 = dut__dim__enable;
  else
   enableq1 = 1'b0;
  end
  else
  enableq1 = 1'b0;
end

always @ (*)
begin
  if(sys_counter<959 & ((quad_count=='d2)||(quad_count=='d3)||(quad_count=='d6)||(quad_count=='d7)))
  begin
  if(filter_counter<=9)
   enableq2 = dut__dim__enable;
  else
   enableq2 = 1'b0;
  end
  else
  enableq2 = 1'b0;
  
end

always @ (*)
begin
  if(sys_counter<959 & ((quad_count=='d8)||(quad_count=='d9)||(quad_count=='d12)||(quad_count=='d13)))
  begin
  if(filter_counter<=9)
   enableq3 = dut__dim__enable;
  else
   enableq3 = 1'b0;
  end
  else
  enableq3 = 1'b0;  
end

always @ (*)
begin
  if(sys_counter<959 & ((quad_count=='d10)||(quad_count=='d11)||(quad_count=='d14)||(quad_count=='d15)))
  begin
  if(filter_counter<=9)
   enableq4 = dut__dim__enable;
  else
   enableq4 = 1'b0;
  end
  else
  enableq4 = 1'b0;  
end

endmodule
