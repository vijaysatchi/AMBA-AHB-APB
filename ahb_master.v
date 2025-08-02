
`timescale 1ns / 1ns
module ahb_master(
    input HCLK,
    input HRESETn, //low active
    input [31:0] HRDATA,
    input [31:0] HWDATA_IN,
    input [2:0] HBURST_IN,
    input [2:0] HSIZE_IN,
	input [1:0] HRESP1,
	input [1:0] HRESP2,
	input [1:0] HRESP3,
	input [1:0] HRESP4, 
	input HREADY1,
    input HREADY2,
    input HREADY3,
    input HREADY4,
    input TRANSFER,
    input READ_WRITE,
    input reg [31:0] HADDR_IN,
	input HGRANTx,

    output reg [31:0] HADDR,
    //output reg HSEL1,
    //output reg HSEL2,	
    //output reg HSEL3,
    //output reg HSEL4,
    //output reg HENABLE,
    output reg HWRITE, //write = 1, read = 0
    output reg [31:0] HWDATA,
   
    output reg [1:0] HTRANS, //00 = idle, 01 = busy, 10 = nonseq (new sequence of burst), 11 = seq (continue burst)
    output reg [2:0] HSIZE, // 000 = 1 byte, 001 = 2, 010 = 4, 011 = 8, 100 = 16, 101 = 32, 110 = 64, 111 = 128
    output reg [2:0] HBURST, //000 = SINGLE, 001 = INCR, 010 = WRAP4, 011 = INCR4, 100 = WRAP8, 101 = INCR8, 110 = WRAP16, 111 = INCR16  
    output reg [3:0] HPROT, //bit 0 = instruction (0) or data (1) access, bit 1 = user (0) or privileged (1) access, bit 2 = bufferable transfer (1), bit 3 = cacheable transfer (1)
    output reg HMASTLOCK,
	output reg HBUSREQx,
	output reg TRANSCOMPLETE
	//add HLOCK later

);

	// parameter [1:0] IDLE = 2'b00, ADDRESS = 2'b01, DATA = 2'b10;
    // reg [1:0] state, next_state = IDLE; //00 = idle, 01 = address & control signals, 02 = data    
    reg state;

	reg [5:0] beat_count, burst_total;
	reg [31:0] address_incr;
	reg [1:0] HGRANT_count;
	wire [1:0] HRESP;

	assign HRESP = (HRESP1 != 2'b00) ? HRESP1 :
               (HRESP2 != 2'b00) ? HRESP2 :
               (HRESP3 != 2'b00) ? HRESP3 :
               (HRESP4 != 2'b00) ? HRESP4 :
               2'b00;
	always @(posedge HCLK) begin
		if(HRESP == 2'b01 && TRANSCOMPLETE == 1'b0) begin
			TRANSCOMPLETE <= 1'b1;
			HBUSREQx <= 1'b0;
			HTRANS <= 2'b00;
			HGRANT_count <= 2'b10;
			beat_count <= 6'b1;
			state <= 2'b00;
		end
		if(HRESETn) begin// || HRESP == 2'b01) begin
			//RESET EVERYTHING
			HSIZE <= 3'b0;
			HTRANS <= 2'b0;
			HBURST <= 3'b0;
			HPROT <= 4'b0;
			HMASTLOCK <= 1'b0;
			HADDR <= 32'b0;
			HWRITE <= 1'b0;
			//HSEL1 <= 1'b0;
			//HSEL2 <= 1'b0;
			//HSEL3 <= 1'b0;
			//HSEL4 <= 1'b0;
			HWDATA <= 32'b0;
			burst_total <= 6'b0;
			beat_count <= 6'b1;
			HGRANT_count <= 2'b10;
			HBUSREQx <= 1'b0;
			TRANSCOMPLETE <= 1'b0;
			state <= 2'b0;
			$display("RESETTING, %t, %d, %d", $time, HRESETn, HRESP1);
		end else begin
			if(state == 2'b0) begin //TRANSFER && 
				if (TRANSFER) begin
					HBUSREQx <= 1'b1;
					TRANSCOMPLETE <= 0;
					//HGRANT_count <= 2'b00;
				end
				if (HGRANT_count < 2'b10) begin
					HGRANT_count <= HGRANT_count + 1;
				end
				if (HGRANTx && HGRANT_count == 2) begin 
					$display("addy phase");
					/*
					explanation of this if block:
					- when: happens when any transfer, single or burst first begins
					- sets addr + ctrl signals then does state <= 1 to begin the data phase in the next cycle
					- 
					*/					
					//HSEL1 <= 1; //temp until multiple slaves working ***
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
					$display("TRYING: %d, %d, %d, %d", HADDR_IN, HADDR_IN[4:0], 2**HSIZE,  burst_total);
					if((HBURST_IN[0] == 1 && HADDR_IN[4:0] + 2**HSIZE < 32 && HADDR_IN[4:0] % (2**HSIZE) == 0 && HADDR_IN[4:0] + burst_total*2**HSIZE < 32) || HBURST_IN[0] == 0) begin
						state <= 2'b01;
						//INITIAL ADDRESS + CONTROL PHASE
						HSIZE <= HSIZE_IN;
						HTRANS <= 2'b10;
						HBURST <= HBURST_IN;
						HPROT <= 4'b0; //idk this doesnt matter lmao
						HADDR <= HADDR_IN; 
						HWRITE <= READ_WRITE;
						$display("INSTRUCTION PASSED");
					end
					else begin
						$display("INSTRUCTION FAILED: OUT OF BOUNDS --> %d, %d, %d", HADDR_IN[4:0] + 2**HSIZE, HADDR_IN[4:0] % (2**HSIZE), HADDR_IN[4:0] + burst_total*2**HSIZE);
						TRANSCOMPLETE <= 1'b1;
					end
				end
			end
			//$display("HTRANS is %d, state is %d, beat count is %d, burst total is %d ", HTRANS, state, beat_count, burst_total);
			if (state == 2'b01 && (HREADY1 | HREADY2 | HREADY3 | HREADY4)) begin
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
					//HSEL1 <= 1;
					if(TRANSFER) begin 
						HTRANS <= 2'b10;
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
					end else begin //this happens if (beat_count < burst_total) == TRUE 
						HTRANS <= 2'b11;
						beat_count <= beat_count + 1;
						HADDR <= HADDR + 2**HSIZE_IN;
						if ((HBURST_IN % 2) == 0) begin
							if ((HADDR + 2**HSIZE_IN) % (2**HSIZE_IN * burst_total) == 0) begin
								HADDR <= (HADDR + 2**HSIZE_IN) - (2**HSIZE_IN * burst_total);
							end
						end
					end
				end else if (beat_count == burst_total) begin 
					$display("beat = burst total, back to state 0");
					state <= 2'b00;
					//HSEL1 <= 0; //need this
					//HADDR <= 0;
					beat_count <= 1;
					HTRANS <= 0;
					TRANSCOMPLETE <= 1;
					HGRANT_count <= 2'b00;
					//if (!HLOCK) begin
						HBUSREQx <= 0'b0;
					//end
				end
				
			end
			if (!HGRANTx) begin
				TRANSCOMPLETE <= 0;
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
