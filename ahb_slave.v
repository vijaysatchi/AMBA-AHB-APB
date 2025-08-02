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

output reg HREADY;
output reg [1:0] HRESP;
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
		HRESP <= 2'b00;
        state <= 0;
    end else begin
		if(HSELx) begin //new address phase
			if(HRESP == 2'b01 && HADDR[4:0] + 2**HSIZE < 32 && HADDR[4:0] % (2**HSIZE) == 0) begin
				HRESP <= 2'b00;
				HREADY <= 1'b0;
			end else if(HADDR[4:0] + 2**HSIZE > 32 || HADDR[4:0] % (2**HSIZE) != 0) begin
				$display("slave operation cancel at %d", HADDR);
				HRESP = 2'b01;
				state = 1'b0;
				HREADY = 1'b0;
			end else begin
	            HWRITE_PREV <= HWRITE;
	            HADDR_PREV <= HADDR[4:0];
	            HSIZE_PREV <= HSIZE;
	            state <= 1'b1;
	            HREADY <= 1'b1;
				HRESP <= 2'b00;
			end
        end else begin
            state <= 1'b0;
            HREADY <= 1'b0;
			HRESP <= 2'b00;
        end
        if(state) begin
            if (!HWRITE_PREV) begin //READ
                HRDATA <= MEMORY[HADDR_PREV];
				$display("slave read");
            end else begin //WRITE
                MEMORY[HADDR_PREV[4:0]] <= HWDATA;
				$display("slave write");
            end

        end
    end
end
endmodule


/*
always @ (posedge HCLK) begin
    if(HRESETn) begin
        HREADY <= 1'b0;
        HRDATA <= 32'b0;
        HADDR_PREV <= 32'b0;
		HSIZE_PREV <= 3'b0;
		HWRITE_PREV <= 1'b0;
		state <= 0;
    end else begin 
		if (HTRANS != 2'b00 && HTRANS != 2'b01) begin
        end else if (HSELx) begin
			if(state == 1'b0) begin //ADDRESS PHASE
				HWRITE_PREV <= HWRITE;
				HADDR_PREV <= HADDR;
				HSIZE_PREV <= HSIZE;
				state <= 1'b1;
			end else begin //DATA PHASE
				//ONCE SPECIFICS ABOUT HSIZE HAVE BEEN DETERMINED, MAKE IT AFFECT WHAT HAPPENS IN THIS BLOCK
				
	            if (!HWRITE_PREV) begin //READ
	                HRDATA <= MEMORY[HADDR_PREV];
	                HREADY <= 1'b1;
	            end else begin //WRITE
	                MEMORY[HADDR_PREV] <= HWDATA;
	                HREADY <= 1'b1;
	            end
				if(HADDR_PREV != HADDR || HSIZE_PREV != HSIZE || HWRITE_PREV != HWRITE) begin
					//^ this means a new transfer has been scheduled to happen after the current data phase,
					//	therefore, we should stay in this state.
						// but then youll be thinking "ermmm but what if theyre writing to da same address with diff data"
						// ok but we retain the same ctrl/address signals from previous trnsfr so it wont mess it up
					HWRITE_PREV <= HWRITE;
					HADDR_PREV <= HADDR;
					HSIZE_PREV <= HSIZE;
					state <= 1'b1;					
				end else begin
					state <= 1'b0;
				end
			end
        end else begin
            HREADY <= 1'b0;
			state <= 1'b0;
        end
    end
end
*/

	                //$display("R; ADDR=%d, DATA=%d", HADDR_PREV, HRDATA);
	                //$display("W; ADDR=%d, DATA=%d", HADDR_PREV, HWDATA);
/*
problem: 
	need to know if the current data phase is pipelining the next transfers address phase or not
*/
