module eth_rgmii ( 
	input					i_cmd_wr,
	input		[7:0]		i_cmd_addr,
	input		[31:0]	i_cmd_data,
	
	input		[7:0]  	i_rx_cmd_addr,
	output	[31:0]	o_rx_pkt_data,
	input					i_rx_pkt_rd,

	output				o_rx_rst_n,
	output				o_tx_rst_n,
	
	input					i_tx_wr,
	input		[7:0]		i_tx_wr_addr,
	input		[31:0]	i_tx_wr_data,

	input					i_rx_clk,
	input					i_rx_vl,
	input		[3:0]		i_rx_data,
	
	output				o_gtx_clk,	// to GTX pin
	output				o_tx_en,
	output	[3:0]		o_tx_data,
		
	output				o_irq_tx,
	output				o_irq_rx,
	
	output				o_pll_tx_clk,	// to TX NIOS MM-Avalon Cross Clocking 
	output				o_pll_rx_clk,	// to RX NIOS MM-Avalon Cross Clocking 
	
	output	[7:0]		o_green_led
);

//----------------------------------------------------------------------------

//gtx_out gtx_out_unit(
//		.datain_h(1'b1),
//		.datain_l(1'b0),
//		.outclock(pll_gtx_clk),
//		.dataout(o_gtx_clk)
//);

assign o_gtx_clk = pll_gtx_clk;

eth_pll eth_pll_unit(
	.inclk0(i_rx_clk),
	
	.c0(pll_clk_rx),		// 0
	.c1(pll_clk_tx),		// 90
	.c2(pll_gtx_clk),		// 180
	.locked(pll_locked)
);

wire							pll_clk_rx;
wire							pll_clk_tx;
wire							pll_gtx_clk;
wire							pll_locked;

//----------------------------------------------------------------------------

reg			[0:0]			tx_rst_n;
reg			[7:0]			tx_rst_cntr;
always_ff @ (posedge pll_clk_tx)
	if(~pll_locked) begin
		tx_rst_n <= 1'b0;
		tx_rst_cntr <= 8'd0;
	end
	else
		if(~&tx_rst_cntr) begin
			tx_rst_cntr <= tx_rst_cntr + 8'd1;
			tx_rst_n <= 1'b0;
		end
		else
			tx_rst_n <= 1'b1;
assign o_tx_rst_n = tx_rst_n;

//----------------------------------------------------------------------------

reg			[0:0]			rx_rst_n;
reg			[7:0]			rx_rst_cntr;
always_ff @ (posedge pll_clk_rx)
	if(~pll_locked) begin
		rx_rst_n <= 1'b0;
		rx_rst_cntr <= 8'd0;
	end
	else
		if(~&rx_rst_cntr) begin
			rx_rst_cntr <= rx_rst_cntr + 8'd1;
			rx_rst_n <= 1'b0;
		end
		else
			rx_rst_n <= 1'b1;
assign o_rx_rst_n = rx_rst_n;

//----------------------------------------------------------------------------

assign o_pll_tx_clk = pll_clk_tx;
assign o_pll_rx_clk = pll_clk_rx;

//----------------------------------------------------------------------------

eth_in eth_in_unit(
	.datain({i_rx_vl, i_rx_data[3:0]}),
	.inclock(pll_clk_rx),
	
	.dataout_h({rx_vl_h, rx_data[7:4]}),
	.dataout_l({rx_vl_l, rx_data[3:0]})
);

wire						rx_vl_h;
wire						rx_vl_l;
wire		[7:0]			rx_data;
wire						rx_dv;
assign rx_dv = rx_vl_h & rx_vl_l;

//----------------------------------------------------------------------------

wire		[7:0]			tx_data;
wire						tx_en;

eth_out eth_out_unit(
	.datain_h({tx_en, tx_data[3:0]}),
	.datain_l({tx_en, tx_data[7:4]}),
	
	.outclock(pll_clk_tx),
	.dataout({o_tx_en, o_tx_data[3:0]})
);

//----------------------------------------------------------------------------

eth_top eth_top_unit(
	.rst_n(pll_locked),

	.i_cmd_addr(i_cmd_addr),	// Clock PLL_TX
	.i_cmd_data(i_cmd_data),
	.i_cmd_wr(i_cmd_wr),

	.i_rx_cmd_addr(i_rx_cmd_addr),
	.o_rx_pkt_data(o_rx_pkt_data),
	.i_rx_pkt_rd(i_rx_pkt_rd),
	
	
	.i_tx_wr(i_tx_wr),
	.i_tx_wr_addr(i_tx_wr_addr),
	.i_tx_wr_data(i_tx_wr_data),


	.o_irq_tx(o_irq_tx),
	.o_irq_rx(o_irq_rx),
	
	.i_rx_clk(pll_clk_rx),
	.i_rx_data(rx_data),
	.i_rx_dv(rx_dv),
	
	.i_tx_clk(pll_clk_tx),
	.o_tx_data(tx_data),
	.o_tx_en(tx_en),
		
	.o_green_led(o_green_led)
);

//----------------------------------------------------------------------------


endmodule
