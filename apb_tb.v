`timescale 1ns / 1ns
module apb_tb;
	/*reg PCLK, PRESETn, PREADY, PSLVERR, TRANSFER, READ_WRITE;
	reg [31:0] PADDR_IN, PRDATA;

	wire PSEL, PENABLE, PWRITE; //write = 1, read = 0
	wire [31:0] PWDATA, PADDR;
	wire [31:0] PRDATA_SLAVE;*/

	reg PCLK, PRESETn, READ_WRITE, TRANSFER;
	reg [31:0] PADDR_IN, PWDATA_IN;

	// Wires driven by master
	wire PSEL1, PSEL2, PSEL3, PSEL4, PENABLE, PWRITE;
	wire [31:0] PADDR, PWDATA, PRDATA1 , PRDATA2 , PRDATA3, PRDATA4;

	// Wires driven by slave
	wire PREADY1, PREADY2, PREADY3, PREADY4, PSLVERR;
	
	apb_master master(
	.PRDATA(PRDATA),
	.PWDATA_IN(PWDATA_IN),
	.PADDR_IN(PADDR_IN),
	.PRESETn(PRESETn),
	.PCLK(PCLK),
	.READ_WRITE(READ_WRITE),
	.PSEL1(PSEL1),
	.PSEL2(PSEL2),
	.PSEL3(PSEL3),
	.PSEL4(PSEL4),
	.PENABLE(PENABLE),
	.PADDR(PADDR),
	.PWRITE(PWRITE),
	.PWDATA(PWDATA),
	.TRANSFER(TRANSFER),
	.PREADY1(PREADY1),
	.PREADY2(PREADY2),
	.PREADY3(PREADY3),
	.PREADY4(PREADY4),
	.PSLVERR(PSLVERR)
	);

	apb_slave slave1(
	.PSELx(PSEL1),
	.PENABLE(PENABLE),
	.PADDR(PADDR),
	.PWRITE(PWRITE),
	.PRESETn(PRESETn),
	.PCLK(PCLK),
	.PWDATA(PWDATA),
	.PRDATA(PRDATA1),
	.PREADY(PREADY1),
	.PSLVERR(PSLVERR)
	);
	
	apb_slave slave2(
	.PSELx(PSEL2),
	.PENABLE(PENABLE),
	.PADDR(PADDR),
	.PWRITE(PWRITE),
	.PRESETn(PRESETn),
	.PCLK(PCLK),
	.PWDATA(PWDATA),
	.PRDATA(PRDATA2),
	.PREADY(PREADY2),
	.PSLVERR(PSLVERR)
	);
	
	apb_slave slave3(
	.PSELx(PSEL3),
	.PENABLE(PENABLE),
	.PADDR(PADDR),
	.PWRITE(PWRITE),
	.PRESETn(PRESETn),
	.PCLK(PCLK),
	.PWDATA(PWDATA),
	.PRDATA(PRDATA3),
	.PREADY(PREADY3),
	.PSLVERR(PSLVERR)
	);

	apb_slave slave4(
	.PSELx(PSEL4),
	.PENABLE(PENABLE),
	.PADDR(PADDR),
	.PWRITE(PWRITE),
	.PRESETn(PRESETn),
	.PCLK(PCLK),
	.PWDATA(PWDATA),
	.PRDATA(PRDATA4),
	.PREADY(PREADY4),
	.PSLVERR(PSLVERR)
	);

	task initialization;
	begin
	    PCLK=0;
	    PRESETn = 1'b0;
    	TRANSFER = 1'b0;
		PWDATA_IN = 0;
		PADDR_IN = 0;
		READ_WRITE = 0;
		#10 PRESETn = 1'b1;
		#20 PRESETn = 1'b0;
	end
	endtask
/*
	task reset;
	begin
		PRESETn = 1'b1;
		#10 PRESETn = 1'b0;
	end
	endtask
*/
	task write;
	begin
		PWDATA_IN = 2;
    	PADDR_IN = 3;
    	READ_WRITE = 1'b1;
		@(posedge PCLK);
		TRANSFER = 1'b1;
		@(posedge PCLK);
		TRANSFER = 1'b0;
		#50;
	end
	endtask

	task write2;
	begin
		PWDATA_IN = 30;
    	PADDR_IN = 12;
    	READ_WRITE = 1'b1;
		@(posedge PCLK);
		TRANSFER = 1'b1;
		@(posedge PCLK);
		TRANSFER = 1'b0;
		#50;
	end
	endtask

	task write3;
	begin
		PWDATA_IN = 9;
    	PADDR_IN = 29;
    	READ_WRITE = 1'b1;
		@(posedge PCLK);
		TRANSFER = 1'b1;
		@(posedge PCLK);
		TRANSFER = 1'b0;
		#50;
	end
	endtask

	task write4;
	begin
		PWDATA_IN = 69;
    	PADDR_IN = 31;
    	READ_WRITE = 1'b1;
		@(posedge PCLK);
		TRANSFER = 1'b1;
		@(posedge PCLK);
		TRANSFER = 1'b0;
		#50;
	end
	endtask

	task read;
	begin
    	PADDR_IN = 3;
    	READ_WRITE = 1'b0;
		@(posedge PCLK);
		TRANSFER = 1'b1;
		@(posedge PCLK);
		TRANSFER = 1'b0;
		#50;
	end
	endtask

	task read2;
	begin
    	PADDR_IN = 12;
    	READ_WRITE = 1'b0;
		@(posedge PCLK);
		TRANSFER = 1'b1;
		@(posedge PCLK);
		TRANSFER = 1'b0;
		#50;
	end
	endtask

	task read3;
	begin
    	PADDR_IN = 29;
    	READ_WRITE = 1'b0;
		@(posedge PCLK);
		TRANSFER = 1'b1;
		@(posedge PCLK);
		TRANSFER = 1'b0;
		#50;
	end
	endtask

	task read4;
	begin
    	PADDR_IN = 31;
    	READ_WRITE = 1'b0;
		@(posedge PCLK);
		TRANSFER = 1'b1;
		@(posedge PCLK);
		TRANSFER = 1'b0;
		#50;
	end
	endtask
	/*
	initial begin
    	PCLK = 0;
    	PWDATA_IN = 2;
    	PADDR_IN = 3;
    	READ_WRITE = 1'b1;
    	PRESETn = 1'b0;
    	TRANSFER = 1'b0;
    	#10 PRESETn = 1'b0;
    	#10 TRANSFER = 1'b1;
    	#20 TRANSFER = 1'b0;

    	#70 PWDATA_IN = 4;
    	#70 PADDR_IN = 5;
    	#70 READ_WRITE = 1'b0;
    	#70 PRESETn = 1'b0;
    	#70 TRANSFER = 1'b1;
    	#80 TRANSFER = 1'b0;

    	#130 PWDATA_IN = 6;
    	#130 PADDR_IN = 7;
    	#130 READ_WRITE = 1'b0;
    	#130 PRESETn = 1'b0;
    	#130 TRANSFER = 1'b1;
    	#140 TRANSFER = 1'b0;
    	end*/
	
	always
	#5 PCLK = !PCLK;

	initial begin
	//$display("");
	initialization;
	write4;
	read4;
	write3;
	read3;
	write2;
	read2;
	write;
	read;
	//$monitor("time=%0t psel=%b penable=%b PRDATA=0x%0h", $time, PSEL, PENABLE, PRDATA);
	end


endmodule
