`timescale 1ns / 1ns
module ahb_tb;

	reg HCLK, HRESETn, READ_WRITE, TRANSFER;
	reg [31:0] HADDR_IN, HWDATA_IN;

	reg [2:0] HBURST_IN, HSIZE_IN;

	// Wires driven by master
	wire HSEL1, HSEL2, HSEL3, HSEL4, HWRITE, HMASTLOCK;
	wire [31:0] HADDR, HWDATA, HRDATA1 , HRDATA2 , HRDATA3, HRDATA4;
	wire [1:0] HTRANS;
	wire [2:0] HBURST, HSIZE;
	wire [3:0] HPROT;

	// Wires driven by slave
	wire HREADY1, HREADY2, HREADY3, HREADY4, HRESP;
	
	ahb_master master(
	.HRDATA(HRDATA),
	.HWDATA_IN(HWDATA_IN),
	.HADDR_IN(HADDR_IN),
	.HBURST_IN(HBURST_IN),
	.HSIZE_IN(HSIZE_IN),
	.HRESETn(HRESETn),
	.HCLK(HCLK),
	.READ_WRITE(READ_WRITE),
	.HSEL1(HSEL1),
	.HSEL2(HSEL2),
	.HSEL3(HSEL3),
	.HSEL4(HSEL4),
	.HADDR(HADDR),
	.HWRITE(HWRITE),
	.HWDATA(HWDATA),
	.TRANSFER(TRANSFER),
	.HREADY1(HREADY1),
	.HREADY2(HREADY2),
	.HREADY3(HREADY3),
	.HREADY4(HREADY4),
	.HRESP(HRESP),
	.HTRANS(HTRANS),
	.HBURST(HBURST),
	.HSIZE(HSIZE),
	.HPROT(HPROT),
	.HMASTLOCK(HMASTLOCK)
	);

	ahb_slave slave1(
	.HSELx(HSEL1),
	.HADDR(HADDR),
	.HWRITE(HWRITE),
	.HRESETn(HRESETn),
	.HCLK(HCLK),
	.HWDATA(HWDATA),
	.HRDATA(HRDATA1),
	.HREADY(HREADY1),
	.HRESP(HRESP),
	.HTRANS(HTRANS),
	.HBURST(HBURST),
	.HSIZE(HSIZE),
	.HPROT(HPROT),
	.HMASTLOCK(HMASTLOCK)
	);
	
	ahb_slave slave2(
	.HSELx(HSEL2),
	.HADDR(HADDR),
	.HWRITE(HWRITE),
	.HRESETn(HRESETn),
	.HCLK(HCLK),
	.HWDATA(HWDATA),
	.HRDATA(HRDATA2),
	.HREADY(HREADY2),
	.HRESP(HRESP),
	.HTRANS(HTRANS),
	.HBURST(HBURST),
	.HSIZE(HSIZE),
	.HPROT(HPROT),
	.HMASTLOCK(HMASTLOCK)
	);
	
	ahb_slave slave3(
	.HSELx(HSEL3),
	.HADDR(HADDR),
	.HWRITE(HWRITE),
	.HRESETn(HRESETn),
	.HCLK(HCLK),
	.HWDATA(HWDATA),
	.HRDATA(HRDATA3),
	.HREADY(HREADY3),
	.HRESP(HRESP),
	.HTRANS(HTRANS),
	.HBURST(HBURST),
	.HSIZE(HSIZE),
	.HPROT(HPROT),
	.HMASTLOCK(HMASTLOCK)
	);

	ahb_slave slave4(
	.HSELx(HSEL4),
	.HADDR(HADDR),
	.HWRITE(HWRITE),
	.HRESETn(HRESETn),
	.HCLK(HCLK),
	.HWDATA(HWDATA),
	.HRDATA(HRDATA4),
	.HREADY(HREADY4),
	.HRESP(HRESP),
	.HTRANS(HTRANS),
	.HBURST(HBURST),
	.HSIZE(HSIZE),
	.HPROT(HPROT),
	.HMASTLOCK(HMASTLOCK)
	);

	task initialization;
	begin
	   	HCLK=0;
	    	HRESETn = 1'b0;
    		TRANSFER = 1'b0;
		HWDATA_IN = 0;
		HADDR_IN = 0;
		HBURST_IN = 0;
		HSIZE_IN = 0;
		READ_WRITE = 0;
		#10 HRESETn = 1'b1;
		#20 HRESETn = 1'b0;
	end
	endtask
/*
	task reset;
	begin
		HRESETn = 1'b1;
		#10 HRESETn = 1'b0;
	end
	endtask
*/
	task write;
	begin
    		HADDR_IN = 3;
		HBURST_IN = 3'b011;
    		READ_WRITE = 1'b1;
		//HSIZE = ___;
		@(posedge HCLK);
		TRANSFER = 1'b1;
		@(posedge HCLK);
		TRANSFER = 1'b0;
		//#50;
		//wait(HREADY1 == 1);

		HWDATA_IN = 1;
		@(posedge HCLK);
		//TRANSFER = 1'b1;
		//@(posedge HCLK);
		//TRANSFER = 1'b0;
		//#50;

		HWDATA_IN = 2;
		@(posedge HCLK);
		//TRANSFER = 1'b1;
		//@(posedge HCLK);
		//TRANSFER = 1'b0;
		//#50;

		HWDATA_IN = 3;
		@(posedge HCLK);
		//TRANSFER = 1'b1;
		//@(posedge HCLK);
		//TRANSFER = 1'b0;
		//#50;

		HWDATA_IN = 4;
		@(posedge HCLK);
		//TRANSFER = 1'b1;
		//@(posedge HCLK);
		//TRANSFER = 1'b0;
		//#150;
		#50;

	end
	endtask

	task write2;
	begin
		HWDATA_IN = 30;
    		HADDR_IN = 12;
    		READ_WRITE = 1'b1;
		@(posedge HCLK);
		TRANSFER = 1'b1;
		@(posedge HCLK);
		TRANSFER = 1'b0;
		#50;
	end
	endtask

	task write3;
	begin
		HWDATA_IN = 9;
    		HADDR_IN = 29;
    		READ_WRITE = 1'b1;
		@(posedge HCLK);
		TRANSFER = 1'b1;
		@(posedge HCLK);
		TRANSFER = 1'b0;
		#50;
	end
	endtask

	task write4;
	begin
		HWDATA_IN = 69;
    		HADDR_IN = 31;
    		READ_WRITE = 1'b1;
		@(posedge HCLK);
		TRANSFER = 1'b1;
		@(posedge HCLK);
		TRANSFER = 1'b0;
		#50;
	end
	endtask

	task read;
	begin
    		HADDR_IN = 3;
		HBURST_IN = 3'b011;
    		READ_WRITE = 1'b0;
		@(posedge HCLK);
		TRANSFER = 1'b1;
		@(posedge HCLK);
		TRANSFER = 1'b0;
		//#50;
		wait(HREADY1 == 1);

		@(posedge HCLK);
		//TRANSFER = 1'b1;
		//@(posedge HCLK);
		//TRANSFER = 1'b0;
		//#50;

		@(posedge HCLK);
		//TRANSFER = 1'b1;
		//@(posedge HCLK);
		//TRANSFER = 1'b0;
		//#50;

		@(posedge HCLK);
		//TRANSFER = 1'b1;
		//@(posedge HCLK);
		//TRANSFER = 1'b0;
		#50;

	end
	endtask

	task read2;
	begin
    		HADDR_IN = 12;
    		READ_WRITE = 1'b0;
		@(posedge HCLK);
		TRANSFER = 1'b1;
		@(posedge HCLK);
		TRANSFER = 1'b0;
		#50;
	end
	endtask

	task read3;
	begin
    		HADDR_IN = 29;
    		READ_WRITE = 1'b0;
		@(posedge HCLK);
		TRANSFER = 1'b1;
		@(posedge HCLK);
		TRANSFER = 1'b0;
		#50;
	end
	endtask

	task read4;
	begin
    		HADDR_IN = 31;
    		READ_WRITE = 1'b0;
		@(posedge HCLK);
		TRANSFER = 1'b1;
		@(posedge HCLK);
		TRANSFER = 1'b0;
		#50;
	end
	endtask
	
	always
	#5 HCLK = !HCLK;

	initial begin
	//$display("");
	initialization;
	/*write4;
	read4;
	write3;
	read3;
	write2;
	read2;*/
	write;
	read;
	//$monitor("time=%0t HSEL=%b penable=%b HWDATA=0x%0h", $time, HSEL, PENABLE, HWDATA);
	end


endmodule
