`timescale 1ns / 1ns
module ahb_arbiter(
    input HCLK,
    input HRESETn, //low active
    input [1:0] HRESP,    
    input [31:0] HADDR,
    input [3:0] HBUSREQ, //1 bit for each master
    input [3:0] HLOCK, //prevents interrupts from other master if = 1
    input [1:0] HTRANS, //00 = idle, 01 = busy, 10 = nonseq (new sequence of burst), 11 = seq (continue burst)
    input [2:0] HSIZE, // 000 = 1 byte, 001 = 2, 010 = 4, 011 = 8, 100 = 16, 101 = 32, 110 = 64, 111 = 128
    input [2:0] HBURST, //000 = SINGLE, 001 = INCR, 010 = WRAP4, 011 = INCR4, 100 = WRAP8, 101 = INCR8, 110 = WRAP16, 111 = INCR16  
	input TRANSCOMPLETE, //1 bit for each master

    output reg [3:0] HGRANT, 
    output [3:0] HMASTER
);

	reg [3:0] HBUSREQ_PREV, ADDTOFIFO;
    reg [3:0] master [3:0]; //0000 = nothing in this position, 0001 = master 1, 0010 = master 2, 0100 = master 3, 1000 = master 4
    integer i;
    reg [3:0] queue_count;
	reg [3:0] lock; //1 bit for each master in queue, shift right every time a master is done

    always @(posedge HCLK) begin

		if(HRESETn || HRESP == 2'b01) begin
        	master[0] <= 4'b0;
        	master[1] <= 4'b0;
        	master[2] <= 4'b0;
        	master[3] <= 4'b0;
			HGRANT <= 4'b0;
	    	queue_count <= 4'b0;
			lock <= 4'b0;
		end else begin
	    	for (i = 0; i < 4; i = i + 1) begin
	        	if (HBUSREQ[i] && master[3] == 4'b0) begin //add to queue if not already in,    might not need the master[3] = 4'b0
					if (!(master[0] == 1 << i || master[1] == 1 << i || master[2] == 1 << i || master[3] == 1 << i)) begin
		   				master[queue_count] <= 1 << i; //shift left by i to select a master to add to queue
		    			
		    			if (HLOCK[i]) begin 
		 					lock[queue_count] <= 1'b1;
		    			end 
						queue_count <= queue_count + 1;
					end
	        	end

	    	end
			if(master[0] != 0) begin
				
				if(HTRANS == 2'b00 && queue_count > 0 && !lock[0]) begin
					HGRANT <= master[0];
					lock <= lock >> 1;
					for (i = 0; i < 3; i = i + 1) begin
						master[i] <= master[i+1];
					end
					queue_count <= queue_count - 1;		
				end 
			end else if (TRANSCOMPLETE && !lock[0]) begin
				HGRANT <= 4'b0;
			end
    	end
	end
endmodule
