`timescale 1ns / 1ns
module apb_slave(
	PSELx,
	PENABLE,
	PADDR,
	PWRITE,
	PRESETn,
	PCLK,
	PWDATA,
	PRDATA,
	PREADY,
	PSLVERR
);

input PSELx, PENABLE, PWRITE, PRESETn, PCLK;
input [31:0] PADDR, PWDATA;
output reg PREADY, PSLVERR;
output reg [31:0] PRDATA;

reg [31:0] MEMORY [31:0]; 

always @ (posedge PCLK) begin
	if(PRESETn) begin
		PREADY <= 1'b0;
		PRDATA <= 32'b0;
    end else begin 
		if (PSELx && PENABLE) begin
			if (!PWRITE) begin
	    		PRDATA <= MEMORY[PADDR];
				PREADY <= 1'b1;
				$display("R; ADDR=%d, DATA=%d", PADDR, PRDATA);
			end else begin
				MEMORY[PADDR] <= PWDATA;
				PREADY <= 1'b1;
	   			$display("W; ADDR=%d, DATA=%d", PADDR, PWDATA);
			end
		end else begin
			PREADY <= 1'b0;
		end
    end
end

/*
always @ (posedge PCLK) begin
	if (PRESETn) begin
		PREADY <= 1'b0;
	end
end*/

endmodule
