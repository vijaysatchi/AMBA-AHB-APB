`timescale 1ns / 1ns
module ahb_master(
    input HCLK,
    input HRESETn, //low active
    input [31:0] HRDATA,
    input [31:0] HWDATA_IN,
	input [2:0] HBURST_IN,
	input [2:0] HSIZE_IN,
    input HREADY1,
    input HREADY2,
    input HREADY3,
    input HREADY4,
    input HRESP,
    input TRANSFER,
    input READ_WRITE,
    input reg [31:0] HADDR_IN,

    output reg [31:0] HADDR,
    output reg HSEL1,
    output reg HSEL2,	
    output reg HSEL3,
    output reg HSEL4,
    //output reg HENABLE,
    output reg HWRITE, //write = 1, read = 0
    output reg [31:0] HWDATA,
   
    output reg [1:0] HTRANS, //00 = idle, 01 = busy, 10 = nonseq (new sequence of burst), 11 = seq (continue burst)
    output reg [2:0] HSIZE, // 000 = 1 byte, 001 = 2, 010 = 4, 011 = 8, 100 = 16, 101 = 32, 110 = 64, 111 = 128
    output reg [2:0] HBURST, //000 = SINGLE, 001 = INCR, 010 = WRAP4, 011 = INCR4, 100 = WRAP8, 101 = INCR8, 110 = WRAP16, 111 = INCR16
    output reg [3:0] HPROT, //bit 0 = instruction (0) or data (1) access, bit 1 = user (0) or privileged (1) access, bit 2 = bufferable transfer (1), bit 3 = cacheable transfer (1)
    output reg HMASTLOCK

);
    reg [1:0] state, next_state = 2'b00; //00 = idle, 01 = address & control signals, 02 = data    

always @(*) begin
	if (HRESETn == 1'b1) begin
		next_state = 2'b00;
	end else begin
	case(state) begin
		2'b00: begin
			if(TRANSFER) begin
				next_state = 2'b01;
			end
		end
		2'b01: begin //address phase
			next_state = 2'b10; //address phase must always be 1 cycle
		end
		2'b10: begin
			/*if(HREADY) begin 
				next_state = 2'b00;
			end*/
		end
	end
end


always @(posedge HCLK) begin
	/*	
	if (HRESETn == 1'b1) begin
		state <= 2'b00;
	end else begin*/
	state <= next_state;
	case(state)
		2'b00: begin
			if(TRANSFER) begin
				//state <= 2'b01;
				//begin address phase assuming hready is not set
				HADDR <= HADDR_IN;
				HWRITE <= READ_WRITE;
				HBURST <= HBURST_IN;
				HTRANS <= 2'b10;
				HSIZE <= HSIZE_IN;
			end
		end
		2'b01: begin
			state <= 2'b10;
			if(READ_WRITE) begin
				HWDATA <= HWDATA_IN;
			end
			if(TRANSFER) begin
				HADDR <= HADDR_IN;
				HWRITE <= READ_WRITE;
				HBURST <= HBURST_IN;
				HTRANS <= 2'b10;
				HSIZE <= HSIZE_IN;
			end
		end
	end
end
