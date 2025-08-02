module ahb_decoder (
	input [31:0] HADDR,
	input [1:0] HTRANS,
	input HRESETn,
	output reg HSEL1,
	output reg HSEL2,
	output reg HSEL3,
	output reg HSEL4
);

always @(*) begin
	if(HRESETn) begin
		HSEL1 = 0;
		HSEL2 = 0;
		HSEL3 = 0;
		HSEL4 = 0;
	end else begin 
		if (HTRANS == 2'b10 || HTRANS == 2'b11) begin
			HSEL1 = 0;
			HSEL2 = 0;
			HSEL3 = 0;
			HSEL4 = 0;
			case (HADDR [6:5]) 
				2'b00: begin
					HSEL1 = 1;
				end
				2'b01: begin 
					HSEL2 = 1;
				end
				2'b10: begin 
					HSEL3 = 1;
				end
				2'b11: begin
					HSEL4 = 1;
				end
			endcase
		end else if (HTRANS == 2'b00) begin
			HSEL1 = 0;
			HSEL2 = 0;
			HSEL3 = 0;
			HSEL4 = 0;
		end
	end
end
endmodule