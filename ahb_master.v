
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

	// parameter [1:0] IDLE = 2'b00, ADDRESS = 2'b01, DATA = 2'b10;
    // reg [1:0] state, next_state = IDLE; //00 = idle, 01 = address & control signals, 02 = data    
    reg state;

	reg [5:0] beat_count, burst_total;
	reg [31:0] address_incr;

	always @(posedge HCLK) begin
		if(HRESETn) begin
			//RESET EVERYTHING
			HSIZE <= 3'b0;
			HTRANS <= 2'b0;
			HBURST <= 3'b0;
			HPROT <= 4'b0;
			HMASTLOCK <= 1'b0;
			HADDR <= 32'b0;
			HWRITE <= 1'b0;
			HSEL1 <= 1'b0;
			HSEL2 <= 1'b0;
			HSEL3 <= 1'b0;
			HSEL4 <= 1'b0;
			HWDATA <= 32'b0;
			burst_total <= 6'b0;
			beat_count <= 6'b1;
			state <= 2'b0;
		end else begin
			if(TRANSFER && state == 2'b00) begin
				/*
				explanation of this if block:
				- when: happens when any transfer, single or burst first begins
				- sets addr + ctrl signals then does state <= 1 to begin the data phase in the next cycle
				- 
				*/
				state <= 2'b01;
				//INITIAL ADDRESS + CONTROL PHASE
				HSIZE <= HSIZE_IN;
				HTRANS <= 2'b10;
				HBURST <= HBURST_IN;
				HPROT <= 4'b0; //idk this doesnt matter lmao
				HADDR <= HADDR_IN;
				HWRITE <= READ_WRITE;
				HSEL1 <= 1; //temp until multiple slaves working
				case (HBURST_IN)
					3'b000: begin //SINGLE
						burst_total = 1;
					end
					3'b010, //WRAP4
					3'b011: begin //INCR4
						burst_total = 4;
					end	
					3'b100, //WRAP8
					3'b101: begin //INCR8
						burst_total = 8;
					end	
					3'b110, //WRAP16
					3'b111: begin //INCR16
						burst_total = 16;
					end	
					default: begin //INCR
						burst_total = 2; //putting 2 here temporarily maybe we need an extra input signal for this idk
					end
				endcase
			end
			if(state == 2'b01) begin
				/*
				explanation of this if block:
				- when: this is the data phase, but it also sets the addy + ctrl signals for the next transfer IF:
					- if ( part of a burst OR a new transfer is to happen)
				- 
				*/
				//DATA PHASE 
				if(READ_WRITE) HWDATA <= HWDATA_IN;
				if(beat_count < burst_total || TRANSFER) begin 
					HSIZE <= HSIZE_IN;
					HBURST <= HBURST_IN;
					HPROT <= 4'b0; //idk this doesnt matter lmao
					HADDR <= HADDR_IN;
					HWRITE <= READ_WRITE;
					HSEL1 <= 1;
					if(TRANSFER) HTRANS <= 2'b10;
					else begin //this happens if (beat_count < burst_total) == TRUE 
						HTRANS <= 2'b11;
						beat_count <= beat_count + 1;
						HADDR <= HADDR + 4; //temp until hsize working
						/*case (HBURST_IN)
							3'b010, //WRAP4
							3'b011: begin //INCR4
								HADDR <= HADDR + 4;
							end	
							3'b100, //WRAP8
							3'b101: begin //INCR8
								HADDR <= HADDR + 8;
							end	
							3'b110, //WRAP16
							3'b111: begin //INCR16
								HADDR <= HADDR + 16;
							end	
							default: begin //INCR
								HADDR <= HADDR + 2; //putting 2 here temporarily maybe we need an extra input signal for this idk
							end
						endcase*/
					end
				end else if (beat_count == burst_total) begin 
					state <= 2'b00;
					HSEL1 <= 0;
					//HADDR <= 0;
					beat_count <= 1;
					HTRANS <= 0;
				end
				
			end
		end
	end
endmodule

//	always @(*) begin
//		if(!HRESETN) begin
//			next_state <= 2'b00;
//		end else begin
//			case(state)
//				IDLE: begin
//					if(TRANSFER) next_state <= ADDRESS;
//				end
//				ADDRESS: begin
//					next_state <= DATA; 
//				end
//				DATA: begin
//					
//				end
//		end
//	end
//
//	always @(posedge HCLK) begin
//		state <= next_state;
//		case(state)
//			IDLE: begin
//				//idk what to do here lmao
//			end
//			ADDRESS: begin
//				
//			end
//			DATA: begin
//				
//			end
//	end
