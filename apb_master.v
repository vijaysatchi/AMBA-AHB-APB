`timescale 1ns / 1ns
module apb_master(
    input PCLK,
    input PRESETn, //low active
    input [31:0] PRDATA,
    input [31:0] PWDATA_IN,
    input PREADY1,
    input PREADY2,
    input PREADY3,
    input PREADY4,
    input PSLVERR,
    input TRANSFER,
    input READ_WRITE,
    input reg [31:0] PADDR_IN,

    output reg [31:0] PADDR,
    output reg PSEL1,
    output reg PSEL2,	
    output reg PSEL3,
    output reg PSEL4,
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
                    PSEL1 <= 1'b0;
		    PSEL2 <= 1'b0;
		    PSEL3 <= 1'b0;
 		    PSEL4 <= 1'b0;
                    PENABLE <= 1'b0;
                    if (TRANSFER) begin
	                if (PADDR > 32'd30) begin
			    PSEL4 <= 1'b1;
			end else if (PADDR > 32'd20) begin
			    PSEL3 <= 1'b1;
			end else if (PADDR > 32'd10) begin
			    PSEL2 <= 1'b1;
		    	end else if (PADDR > 32'd0) begin
			    PSEL1 <= 1'b1;
		        end
                        state <= 2'b01;
                    end
                end
                2'b01: begin //SETUP
		    PENABLE <= 1'b0;
	            if (PADDR > 32'd30) begin
			PSEL4 <= 1'b1;
		    end else if (PADDR > 32'd20) begin
			PSEL3 <= 1'b1;
	            end else if (PADDR > 32'd10) begin
			PSEL2 <= 1'b1;
		    end else if (PADDR > 32'd0) begin
			PSEL1 <= 1'b1;
		    end
                    
    		    state <= 2'b10;   
		    PENABLE <= 1'b1; //i chnaged this too            
                end
                2'b10: begin //ACCESS
	            if (PADDR > 32'd30) begin
			PSEL4 <= 1'b1;
			$display("current slave number: 4");
		    end else if (PADDR > 32'd20) begin
			PSEL3 <= 1'b1;
			$display("current slave number: 3");
		    end else if (PADDR > 32'd10) begin
			PSEL2 <= 1'b1;
			$display("current slave number: 2");
		    end else if (PADDR > 32'd0) begin
			PSEL1 <= 1'b1;
			$display("current slave number: 1");
		    end

                    
 		    if (!TRANSFER && ((PREADY4 && PADDR > 32'd30) || (PREADY3 && PADDR <= 32'd30 && PADDR > 32'd20) || (PREADY2 && PADDR <= 32'd20 && PADDR > 32'd10) || (PREADY1 && PADDR <= 32'd10 && PADDR > 32'd0))) begin
                    	if (PADDR > 32'd30) begin
			    PSEL4 <= 1'b0;
		    	end else if (PADDR > 32'd20) begin
			     PSEL3 <= 1'b0;
	            	end else if (PADDR > 32'd10) begin
			     PSEL2 <= 1'b0;
		    	end else if (PADDR > 32'd0) begin
			     PSEL1 <= 1'b0;
		    	end
		    	PADDR <= 0;
		    	PWRITE <= 0;
		    	PWDATA <= 0;
		    	//PENABLE <= 1'b1;
                    	state <= 2'b00; // go idle
                    end else if (TRANSFER && ((PREADY4 && PADDR > 32'd30) || (PREADY3 && PADDR <= 32'd30 && PADDR > 32'd20) || (PREADY2 && PADDR <= 32'd20 && PADDR > 32'd10) || (PREADY1 && PADDR <= 32'd10 && PADDR > 32'd0))) begin
			state <= 2'b01;// go setup, begin assert pwrite, penable, paddr, pdata
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
                    end else if ((!PREADY4  && PADDR > 32'd30) || (!PREADY3 && PADDR <= 32'd30 && PADDR > 32'd20) || (!PREADY2 && PADDR <= 32'd20 && PADDR > 32'd10) || (!PREADY1 && PADDR <= 32'd10 && PADDR > 32'd0)) begin    
                        state <= 2'b10; //go access (loop access)
                    end
                end
            endcase
        end
    end    
endmodule