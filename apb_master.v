`timescale 1ns / 1ns
module apb_master(
    input PCLK,
    input PRESETn, //low active
    input [31:0] PRDATA,
    input [31:0] PWDATA_IN,
    input PREADY,
    input PSLVERR,
    input TRANSFER,
    input READ_WRITE,
    input reg [31:0] PADDR_IN,

    output reg [31:0] PADDR,
    output reg PSEL,
    output reg PENABLE,
    output reg PWRITE, //write = 1, read = 0
    output reg [31:0] PWDATA
    
);
    reg [1:0] state; //00 = idle, 01 = setup, 02 = access    
    

	/*
    initial begin
        state <= 2'b00;
    end

    
	might be worse to have this in another process 
	but who knows at least it look kinda cleaner maybe kinda
	*/
	always @ (posedge PCLK) begin
    	if(state == 2'b01) begin
			if (!READ_WRITE) begin 
				//READ
				PADDR <= PADDR_IN;
				PWRITE <= 1'b0;
			end else begin
				//WRITE
				PADDR <= PADDR_IN;
				PWDATA <= PWDATA_IN;
				PWRITE <= 1'b1;	
	        end
	    end
	end
	
    
    always @(posedge PCLK) begin 
        if (PRESETn == 1'b1) begin
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin //no transfer, IDLE
                    PSEL <= 1'b0;
                    PENABLE <= 1'b0;
                    if (TRANSFER) begin
                        state <= 2'b01;
                    end
                end
                2'b01: begin //SETUP
                    PSEL <= 1'b1;
                    PENABLE <= 1'b0;
		    		state <= 2'b10;            
                end
                2'b10: begin //ACCESS
                    PSEL <= 1'b1; //i changed this
                    PENABLE <= 1'b1; //i chnaged this too    
                    if (PREADY && !TRANSFER) begin
						PADDR <= 0;
						PWRITE <= 0;
						PWDATA <= 0;
						PENABLE <= 1'b0;
						PSEL <= 1'b0;
                        state <= 2'b00; // go idle
                    end else if (PREADY && TRANSFER) begin    
                        state <= 2'b01; // go setup, begin assert pwrite, penable, paddr, pdata						
						/*
						if (!READ_WRITE) begin 
							//READ
							PADDR <= PADDR_IN;
							PWRITE <= 1'b0;
						end else begin
							//WRITE
							PADDR <= PADDR_IN;
							PWDATA <= PWDATA_IN;
							PWRITE <= 1'b1;	
				        end */
                    end else if (!PREADY) begin    
                        state <= 2'b10; //go access (loop access)
                    end
                end
            endcase
        end
    end    
endmodule    
