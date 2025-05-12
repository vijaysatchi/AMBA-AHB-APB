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
    input [31:0] PADDR_IN,

    output reg [31:0] PADDR,
    output reg PSEL1,
    output reg PSEL2,	
    output reg PSEL3,
    output reg PSEL4,
    output reg PENABLE,
    output reg PWRITE, //write = 1, read = 0
    output reg [31:0] PWDATA
    
);
    reg [1:0] current_state, next_state; //00 = idle, 01 = setup, 02 = access
	wire PREADY;
    parameter [1:0] IDLE = 2'b00, SETUP = 2'b01, ACCESS = 2'b10;

	assign PREADY = PREADY1 || PREADY2 || PREADY3 || PREADY4;


	always @(*) begin
		case (current_state)
			IDLE: begin
				if(TRANSFER)  begin
					next_state = SETUP;
				end else begin
					next_state = IDLE;
				end
			end
			SETUP: begin
				next_state = ACCESS;
			end
			ACCESS: begin
				if(PREADY && TRANSFER) begin
					next_state = SETUP;
				end else if (PREADY && !TRANSFER) begin
					next_state = IDLE;
				end else begin
					next_state = ACCESS;
				end
			end
			default:
				next_state = IDLE;
		endcase
	end

always @ (posedge PCLK) begin
	if(!PRESETn) begin
		current_state <= IDLE;
		PENABLE <= 0;
		PSEL1 <= 0;
		PSEL2 <= 0;
		PSEL3 <= 0;
		PSEL4 <= 0;
		PADDR <= 0;
		PWDATA <= 0;
		PWRITE <= 0;
	end else begin
		current_state <= next_state;
		case(current_state)
			IDLE: begin
				PENABLE <= 0;
				PSEL1 <= 0;
				PSEL2 <= 0;
				PSEL3 <= 0;
				PSEL4 <= 0;
			end
			SETUP: begin
				PENABLE <= 0;
				PADDR <= PADDR_IN;
				PWRITE <= READ_WRITE;
				if(READ_WRITE) 
					PWDATA <= PWDATA_IN;
				if(PADDR_IN > 32'd23) begin
					PSEL1 <= 0;
					PSEL2 <= 0;
					PSEL3 <= 0;
					PSEL4 <= 1;
				end else if(PADDR_IN > 32'd15) begin
					PSEL1 <= 0;
					PSEL2 <= 0;
					PSEL3 <= 1;
					PSEL4 <= 0;
				end else if(PADDR_IN > 32'd7) begin
					PSEL1 <= 0;
					PSEL2 <= 1;
					PSEL3 <= 0;
					PSEL4 <= 0;
				end else begin
					PSEL1 <= 1;
					PSEL2 <= 0;
					PSEL3 <= 0;
					PSEL4 <= 0;
				end
			end
			ACCESS: begin
				PENABLE <= 1;
			end
		endcase
	end
end
endmodule
