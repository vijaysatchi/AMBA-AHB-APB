`timescale 1ns / 1ns
module ahb_slave(
    HSELx,
    //HENABLE,
    HADDR,
    HWRITE,
    HRESETn,
    HCLK,
    HWDATA,
    HRDATA,
    HREADY,
    HRESP,
    HTRANS,
    HSIZE,
    HBURST,
    HPROT,
    HMASTLOCK
);

input HSELx, HWRITE, HRESETn, HCLK;
input [31:0] HADDR, HWDATA;
input [1:0] HTRANS; //00 = idle, 01 = busy, 10 = nonseq (new sequence of burst), 11 = seq (continue burst)
input [2:0] HSIZE; // 000 = 1 byte, 001 = 2, 010 = 4, 011 = 8, 100 = 16, 101 = 32, 110 = 64, 111 = 128
input [2:0] HBURST; //000 = SINGLE, 001 = INCR, 010 = WRAP4, 011 = INCR4, 100 = WRAP8, 101 = INCR8, 110 = WRAP16, 111 = INCR16
input [3:0] HPROT; //bit 0 = instruction (0) or data (1) access, bit 1 = user (0) or privileged (1) access, bit 2 = bufferable transfer (1), bit 3 = cacheable transfer (1)
input HMASTLOCK;


output reg HREADY, HRESP;
output reg [31:0] HRDATA;

reg [31:0] MEMORY [31:0]; 
reg [31:0] HADDR_PREV = 0;
reg [2:0] HSIZE_PREV;
reg HWRITE_PREV;
reg state;

always @(posedge HCLK) begin
	if(HRESETn) begin
		HREADY <= 1'b0;
        HRDATA <= 32'b0;
        HADDR_PREV <= 32'b0;
		HSIZE_PREV <= 3'b0;
		HWRITE_PREV <= 1'b0;
		state <= 0;
	end else begin
		if(HSELx) begin //new address phase
			HWRITE_PREV <= HWRITE;
			HADDR_PREV <= HADDR;
			HSIZE_PREV <= HSIZE;
			state <= 1b'1;
		end else begin
			state <= 1'b0;
			HREADY <= 1'b0;
		end
		if(state) begin
			if (!HWRITE_PREV) begin //READ
	        	HRDATA <= MEMORY[HADDR_PREV];
			end else begin //WRITE
				MEMORY[HADDR_PREV] <= HWDATA;
			end
			HREADY <= 1'b1;
		end
	end
end
endmodule
