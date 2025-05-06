`timescale 1ns / 100ps
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

reg [31:0] memory [31:0];

always @ (posedge PCLK) begin
    if (PSELx && !PRESETn) begin
	PREADY <= 1'b1;
    end 
end

always @ (posedge PCLK) begin
    if (PSELx && PENABLE && !PRESETn) begin
	if (PWRITE) begin
	    $display("W; ADDR=%d, DATA=%d", PADDR, PWDATA);
	    PRDATA <= PWDATA;
	end else begin
	    $display("R; ADDR=%d, DATA=%d", PADDR, PRDATA);
	end
    end
end

endmodule
