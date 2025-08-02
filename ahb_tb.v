`timescale 1ns / 1ns
module ahb_tb;

	reg HCLK, HRESETn, READ_WRITE, TRANSFER1, TRANSFER2, TRANSFER3, TRANSFER4;
	reg [31:0] HADDR_IN, HWDATA_IN;

	reg [2:0] HBURST_IN, HSIZE_IN;

	// Wires driven by master
	wire HSEL1, HSEL2, HSEL3, HSEL4, HWRITE, HMASTLOCK;
	wire [31:0] HADDR1, HADDR2, HADDR3, HADDR4, HWDATA1, HWDATA2, HWDATA3, HWDATA4, HRDATA1 , HRDATA2 , HRDATA3, HRDATA4, HRDATA;
	wire [1:0] HTRANS1, HTRANS2, HTRANS3, HTRANS4, HRESP1, HRESP2, HRESP3, HRESP4, HRESP;
	wire [2:0] HBURST1, HBURST2, HBURST3, HBURST4, HSIZE1, HSIZE2, HSIZE3, HSIZE4;
	wire [3:0] HPROT;
	wire HBUSREQ1, HBUSREQ2, HBUSREQ3, HBUSREQ4;
	wire TRANSCOMPLETE1, TRANSCOMPLETE2, TRANSCOMPLETE3, TRANSCOMPLETE4;

	//wire [1:0] HTRANS [3:0];
	wire [1:0] HTRANS;
	wire [2:0] HBURST, HSIZE;
	wire [3:0] HREADY;
	wire [31:0] HADDR, HWDATA;

	//Wires driven by slave
	wire HREADY1, HREADY2, HREADY3, HREADY4;
	
	// Wires driven by arbiter
	wire [3:0] HGRANT;
	wire [3:0] HBUSREQ;
	wire TRANSCOMPLETE;

	assign HRESP = (HRESP1 != 2'b00) ? HRESP1 :
               (HRESP2 != 2'b00) ? HRESP2 :
               (HRESP3 != 2'b00) ? HRESP3 :
               (HRESP4 != 2'b00) ? HRESP4 :
               2'b00;

	assign HREADY = {HREADY4, HREADY3, HREADY2, HREADY1};
	assign HBUSREQ = {HBUSREQ4, HBUSREQ3, HBUSREQ2, HBUSREQ1};
	assign TRANSCOMPLETE = (TRANSCOMPLETE4 || TRANSCOMPLETE3 || TRANSCOMPLETE2 || TRANSCOMPLETE1);
	assign HRDATA = (HREADY[0]) ? HRDATA1 :  
                (HREADY[1]) ? HRDATA2 :  
                (HREADY[2]) ? HRDATA3 :  
                (HREADY[3]) ? HRDATA4 :  
                32'b0;

	assign HTRANS = (HGRANT[0]) ? HTRANS1 :  
                (HGRANT[1]) ? HTRANS2 :  
                (HGRANT[2]) ? HTRANS3 :  
                (HGRANT[3]) ? HTRANS4 :  
                2'b00;
	assign HBURST = (HGRANT[0]) ? HBURST1 :  
                (HGRANT[1]) ? HBURST2 :  
                (HGRANT[2]) ? HBURST3 :  
                (HGRANT[3]) ? HBURST4 :  
                3'b00;

	assign HSIZE = (HGRANT[0]) ? HSIZE1 :  
                (HGRANT[1]) ? HSIZE2 :  
                (HGRANT[2]) ? HSIZE3 :  
                (HGRANT[3]) ? HSIZE4 :  
                3'b00;

	assign HADDR = (HGRANT[0]) ? HADDR1 :  
                (HGRANT[1]) ? HADDR2 :  
                (HGRANT[2]) ? HADDR3 :  
                (HGRANT[3]) ? HADDR4 :  
                31'b00;

	assign HWDATA = (HGRANT[0]) ? HWDATA1 :  
                (HGRANT[1]) ? HWDATA2 :  
                (HGRANT[2]) ? HWDATA3 :  
                (HGRANT[3]) ? HWDATA4 :  
                31'b00;

	ahb_master master1(
	.HRDATA(HRDATA),
	.HWDATA_IN(HWDATA_IN),
	.HADDR_IN(HADDR_IN),
	.HBURST_IN(HBURST_IN),
	.HSIZE_IN(HSIZE_IN),
	.HRESP1(HRESP1),
	.HRESP2(HRESP2),
	.HRESP3(HRESP3),
	.HRESP4(HRESP4),
	.HRESETn(HRESETn),
	.HCLK(HCLK),
	.READ_WRITE(READ_WRITE),
	.HADDR(HADDR1),
	.HWRITE(HWRITE),
	.HWDATA(HWDATA1),
	.TRANSFER(TRANSFER1),
	.HREADY1(HREADY1),
	.HREADY2(HREADY2),
	.HREADY3(HREADY3),
	.HREADY4(HREADY4),
	.HTRANS(HTRANS1),
	.HBURST(HBURST1),
	.HSIZE(HSIZE1),
	.HPROT(HPROT),
	.HMASTLOCK(HMASTLOCK),
	.HGRANTx(HGRANT[0]),
	.HBUSREQx(HBUSREQ1),
	.TRANSCOMPLETE(TRANSCOMPLETE1)
	);

	ahb_master master2(
	.HRDATA(HRDATA),
	.HWDATA_IN(HWDATA_IN),
	.HADDR_IN(HADDR_IN),
	.HBURST_IN(HBURST_IN),
	.HSIZE_IN(HSIZE_IN),
	.HRESP1(HRESP1),
	.HRESP2(HRESP2),
	.HRESP3(HRESP3),
	.HRESP4(HRESP4),
	.HRESETn(HRESETn),
	.HCLK(HCLK),
	.READ_WRITE(READ_WRITE),
	.HADDR(HADDR2),
	.HWRITE(HWRITE),
	.HWDATA(HWDATA2),
	.TRANSFER(TRANSFER2),
	.HREADY1(HREADY1),
	.HREADY2(HREADY2),
	.HREADY3(HREADY3),
	.HREADY4(HREADY4),
	.HTRANS(HTRANS2),
	.HBURST(HBURST2),
	.HSIZE(HSIZE2),
	.HPROT(HPROT),
	.HMASTLOCK(HMASTLOCK),
	.HGRANTx(HGRANT[1]),
	.HBUSREQx(HBUSREQ2),
	.TRANSCOMPLETE(TRANSCOMPLETE2)
	);

	ahb_master master3(
	.HRDATA(HRDATA),
	.HWDATA_IN(HWDATA_IN),
	.HADDR_IN(HADDR_IN),
	.HBURST_IN(HBURST_IN),
	.HSIZE_IN(HSIZE_IN),
	.HRESP1(HRESP1),
	.HRESP2(HRESP2),
	.HRESP3(HRESP3),
	.HRESP4(HRESP4),
	.HRESETn(HRESETn),
	.HCLK(HCLK),
	.READ_WRITE(READ_WRITE),
	.HADDR(HADDR3),
	.HWRITE(HWRITE),
	.HWDATA(HWDATA3),
	.TRANSFER(TRANSFER3),
	.HREADY1(HREADY1),
	.HREADY2(HREADY2),
	.HREADY3(HREADY3),
	.HREADY4(HREADY4),
	.HTRANS(HTRANS3),
	.HBURST(HBURST3),
	.HSIZE(HSIZE3),
	.HPROT(HPROT),
	.HMASTLOCK(HMASTLOCK),
	.HGRANTx(HGRANT[2]),
	.HBUSREQx(HBUSREQ3),
	.TRANSCOMPLETE(TRANSCOMPLETE3)
	);

	ahb_master master4(
	.HRDATA(HRDATA),
	.HWDATA_IN(HWDATA_IN),
	.HADDR_IN(HADDR_IN),
	.HBURST_IN(HBURST_IN),
	.HSIZE_IN(HSIZE_IN),
	.HRESP1(HRESP1),
	.HRESP2(HRESP2),
	.HRESP3(HRESP3),
	.HRESP4(HRESP4),
	.HRESETn(HRESETn),
	.HCLK(HCLK),
	.READ_WRITE(READ_WRITE),
	.HADDR(HADDR4),
	.HWRITE(HWRITE),
	.HWDATA(HWDATA4),
	.TRANSFER(TRANSFER4),
	.HREADY1(HREADY1),
	.HREADY2(HREADY2),
	.HREADY3(HREADY3),
	.HREADY4(HREADY4),
	.HTRANS(HTRANS4),
	.HBURST(HBURST4),
	.HSIZE(HSIZE4),
	.HPROT(HPROT),
	.HMASTLOCK(HMASTLOCK),
	.HGRANTx(HGRANT[3]),
	.HBUSREQx(HBUSREQ4),
	.TRANSCOMPLETE(TRANSCOMPLETE4)
	);

	ahb_arbiter arbiter(
		.HCLK(HCLK),
		.HRESETn(HRESETn),
		.HRESP(HRESP),
		.HADDR(HADDR),
		.HBUSREQ(HBUSREQ),
		.HLOCK(HLOCK),
		.HTRANS(HTRANS),
		.HSIZE(HSIZE),
		.HBURST(HBURST),
		.HGRANT(HGRANT),
		.HMASTER(HMASTER),
		.TRANSCOMPLETE(TRANSCOMPLETE)
	);

    ahb_decoder decoder(
    .HADDR(HADDR),
	.HTRANS(HTRANS),
	.HRESETn(HRESETn),
    .HSEL1(HSEL1),
    .HSEL2(HSEL2),
    .HSEL3(HSEL3),
    .HSEL4(HSEL4)
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
	.HRESP(HRESP1),
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
	.HRESP(HRESP2),
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
	.HRESP(HRESP3),
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
	.HRESP(HRESP4),
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
    	TRANSFER1 = 1'b0;
		TRANSFER2 = 1'b0;
		TRANSFER3 = 1'b0;
		TRANSFER4 = 1'b0;
		HWDATA_IN = 0;
		HADDR_IN = 0;
		HBURST_IN = 0;
		HSIZE_IN = 0;
		READ_WRITE = 0;
		#10 HRESETn = 1'b1;
		#20 HRESETn = 1'b0;
		#10;
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

	task write_wrap(input [5:0] beats, input [31:0] addr, input [2:0] hsize, input [1:0] transfer, input [31:0] a, input [31:0] b, input [31:0] c, input [31:0] d, input [31:0] e, input [31:0] f, input [31:0] g, input [31:0] h,
			  input [31:0] i, input [31:0] j, input [31:0] k, input [31:0] l, input [31:0] m, input [31:0] n, input [31:0] o, input [31:0] p);
	begin
		wait(HREADY1 == 0 && HREADY2 == 0 && HREADY3 == 0 && HREADY4 == 0 && TRANSCOMPLETE == 0);
		//wait(HREADY1 == 0 && HREADY2 == 0 && HREADY3 == 0 && HREADY4 == 0);
    		HADDR_IN = addr;
		case (beats)
			5'b00100: begin
				HBURST_IN = 3'b010;
			end
			5'b01000: begin
				HBURST_IN = 3'b100;
			end
			5'b10000: begin
				HBURST_IN = 3'b110;
			end
			default: begin
				HBURST_IN = 3'b010;
			end
		endcase
    		READ_WRITE = 1'b1;
		HSIZE_IN = hsize;
		//@(posedge HCLK);
		case (transfer)
			2'b00: begin
					TRANSFER1 = 1'b1;
					@(posedge HCLK);
					TRANSFER1 = 1'b0;
			end
			2'b01: begin
					TRANSFER2 = 1'b1;
					@(posedge HCLK);
					TRANSFER2 = 1'b0;
			end
			2'b10: begin
					TRANSFER3 = 1'b1;
					@(posedge HCLK);
					TRANSFER3 = 1'b0;
			end
			2'b11: begin
					TRANSFER4 = 1'b1;
					@(posedge HCLK);
					TRANSFER4 = 1'b0;
			end
		endcase
		
		wait(HREADY1|| HREADY2 || HREADY3 || HREADY4 || TRANSCOMPLETE);
		HWDATA_IN = a;
		@(posedge HCLK);
		
		HWDATA_IN = b;
		@(posedge HCLK);

		HWDATA_IN = c;
		@(posedge HCLK);

		HWDATA_IN = d;
		@(posedge HCLK);

		if( beats > 4) begin
			HWDATA_IN = e;
			@(posedge HCLK);

			HWDATA_IN = f;
			@(posedge HCLK);

			HWDATA_IN = g;
			@(posedge HCLK);

			HWDATA_IN = h;
			@(posedge HCLK);
		end
		if (beats > 8) begin
			HWDATA_IN = i;
			@(posedge HCLK);

			HWDATA_IN = j;
			@(posedge HCLK);

			HWDATA_IN = k;
			@(posedge HCLK);

			HWDATA_IN = l;
			@(posedge HCLK);
			
			HWDATA_IN = m;
			@(posedge HCLK);

			HWDATA_IN = n;
			@(posedge HCLK);

			HWDATA_IN = o;
			@(posedge HCLK);

			HWDATA_IN = p;
			@(posedge HCLK);
			end

	end
	endtask

	task write_incr(input [4:0] beats, input [31:0] addr, input [2:0] hsize, input [1:0] transfer, input [31:0] a, input [31:0] b, input [31:0] c, input [31:0] d, input [31:0] e, input [31:0] f, input [31:0] g, input [31:0] h,
			  input [31:0] i, input [31:0] j, input [31:0] k, input [31:0] l, input [31:0] m, input [31:0] n, input [31:0] o, input [31:0] p);
	begin
		wait(HREADY1 == 0 && HREADY2 == 0 && HREADY3 == 0 && HREADY4 == 0 && TRANSCOMPLETE == 0);
		//wait(HREADY1 == 0 && HREADY2 == 0 && HREADY3 == 0 && HREADY4 == 0);
    		HADDR_IN = addr;
		case (beats)
			5'b00100: begin
				HBURST_IN = 3'b011;
			end
			5'b01000: begin
				HBURST_IN = 3'b101;
			end
			5'b10000: begin
				HBURST_IN = 3'b111;
			end
			default: begin
				HBURST_IN = 3'b011;
			end
		endcase
    		READ_WRITE = 1'b1;
			HSIZE_IN = hsize;
		//@(posedge HCLK);
		case (transfer)
			2'b00: begin
					TRANSFER1 = 1'b1;
					@(posedge HCLK);
					TRANSFER1 = 1'b0;
			end
			2'b01: begin
					TRANSFER2 = 1'b1;
					@(posedge HCLK);
					TRANSFER2 = 1'b0;
			end
			2'b10: begin
					TRANSFER3 = 1'b1;
					@(posedge HCLK);
					TRANSFER3 = 1'b0;
			end
			2'b11: begin
					TRANSFER4 = 1'b1;
					@(posedge HCLK);
					TRANSFER4 = 1'b0;
			end
		endcase

		wait(HREADY1|| HREADY2 || HREADY3 || HREADY4 || TRANSCOMPLETE);
		HWDATA_IN = a;
		@(posedge HCLK);

		HWDATA_IN = b;
		@(posedge HCLK);

		HWDATA_IN = c;
		@(posedge HCLK);

		HWDATA_IN = d;
		@(posedge HCLK);
		
		if( beats == 5'b01000 || beats == 5'b10000) begin
			HWDATA_IN = e;
			@(posedge HCLK);

			HWDATA_IN = f;
			@(posedge HCLK);

			HWDATA_IN = g;
			@(posedge HCLK);

			HWDATA_IN = h;
			@(posedge HCLK);
		end
		if (beats == 5'b10000) begin
			HWDATA_IN = i;
			@(posedge HCLK);

			HWDATA_IN = j;
			@(posedge HCLK);

			HWDATA_IN = k;
			@(posedge HCLK);

			HWDATA_IN = l;
			@(posedge HCLK);
			
			HWDATA_IN = m;
			@(posedge HCLK);

			HWDATA_IN = n;
			@(posedge HCLK);

			HWDATA_IN = o;
			@(posedge HCLK);

			HWDATA_IN = p;
			@(posedge HCLK);
		end
		//#50;
	end
	endtask


	task read_wrap(input [5:0] beats, input [31:0] addr, input [2:0] hsize, input [1:0] transfer);
	integer x;
	begin
		@(posedge HCLK);
		wait(HREADY1 == 0 && HREADY2 == 0 && HREADY3 == 0 && HREADY4 == 0 && TRANSCOMPLETE == 0);
		//wait(HREADY1 == 0 && HREADY2 == 0 && HREADY3 == 0 && HREADY4 == 0);
		@(posedge HCLK);
    	HADDR_IN = addr;
		case (beats)
			5'b00100: begin
				HBURST_IN = 3'b010;
			end
			5'b01000: begin
				HBURST_IN = 3'b100;
			end
			5'b10000: begin
				HBURST_IN = 3'b110;
			end
			default: begin
				HBURST_IN = 3'b010;
			end
		endcase
    		READ_WRITE = 1'b0;
		HSIZE_IN = hsize;
		//@(posedge HCLK);
		case (transfer)
			2'b00: begin
					TRANSFER1 = 1'b1;
					@(posedge HCLK);
					TRANSFER1 = 1'b0;
			end
			2'b01: begin
					TRANSFER2 = 1'b1;
					@(posedge HCLK);
					TRANSFER2 = 1'b0;
			end
			2'b10: begin
					TRANSFER3 = 1'b1;
					@(posedge HCLK);
					TRANSFER3 = 1'b0;
			end
			2'b11: begin
					TRANSFER4 = 1'b1;
					@(posedge HCLK);
					TRANSFER4 = 1'b0;
			end
		endcase

		wait(HREADY1|| HREADY2 || HREADY3 || HREADY4 || TRANSCOMPLETE);
		for(x = 0; x<beats; x = x +1) begin
			@(posedge HCLK);
		end
		//#50;

	end
	endtask

	task read_incr(input [5:0] beats, input [31:0] addr, input [2:0] hsize, input [1:0] transfer);
	integer x;
	begin
		@(posedge HCLK);
		wait(HREADY1 == 0 && HREADY2 == 0 && HREADY3 == 0 && HREADY4 == 0 && TRANSCOMPLETE == 0);
		//wait(HREADY1 == 0 && HREADY2 == 0 && HREADY3 == 0 && HREADY4 == 0);
		@(posedge HCLK);
    		HADDR_IN = addr;
		case (beats)
			5'b00100: begin
				HBURST_IN = 3'b011;
			end
			5'b01000: begin
				HBURST_IN = 3'b101;
			end
			5'b10000: begin
				HBURST_IN = 3'b111;
			end
			default: begin
				HBURST_IN = 3'b011;
			end
		endcase
    		READ_WRITE = 1'b0;
		HSIZE_IN = hsize;
		//@(posedge HCLK);
		case (transfer)
			2'b00: begin
					TRANSFER1 = 1'b1;
					@(posedge HCLK);
					TRANSFER1 = 1'b0;
			end
			2'b01: begin
					TRANSFER2 = 1'b1;
					@(posedge HCLK);
					TRANSFER2 = 1'b0;
			end
			2'b10: begin
					TRANSFER3 = 1'b1;
					@(posedge HCLK);
					TRANSFER3 = 1'b0;
			end
			2'b11: begin
					TRANSFER4 = 1'b1;
					@(posedge HCLK);
					TRANSFER4 = 1'b0;
			end
		endcase

		wait(HREADY1|| HREADY2 || HREADY3 || HREADY4 || TRANSCOMPLETE);// || HRESP==2'b01);
		//if(HRESP != 2'b01) begin
			for(x = 0; x<beats; x = x +1) begin
				@(posedge HCLK);
			end
		//end

	end
	endtask

	always
	#5 HCLK = !HCLK;

	initial begin
	//$display(""); 
	initialization;
	
	write_incr(8, 0, 3'b001, 3, 8, 7, 6, 5, 4, 3, 2, 1, 5, 5, 5, 5, 5, 5, 5, 5);
	read_incr(8, 0, 3'b001, 3);
			// #, adr, hsize, m, data -->
	write_incr(4, 68, 3'b010, 2, 18, 7, 6, 11, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5);
	read_incr(4, 68, 3'b010, 2);
	write_incr(8, 4, 3'b100, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
	read_incr(8, 4, 3'b100, 0);
	//write_incr4(32, 11, 12, 13, 14);
	//read_incr4(32);
	write_wrap(16, 116, 3'b000, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
	read_wrap(16, 116, 3'b000, 1);
	
	//write_wrap4(2, 1, 2, 3, 4);
	//write_wrap4(68, 1, 2, 3, 4);
	//read_wrap4(2);
	//read_wrap4(68); 
	
	//test_parallel(4, 5, 6);
	//test_single_parallel2(24, 3, 5, 8, 12);
	//single(0, 2, 1);  
	//single(0, 2, 0);
	//$monitor("time=%0t HSEL=%b penable=%b HWDATA=0x%0h", $time, HSEL, PENABLE, HWDATA);
	end

endmodule
 
