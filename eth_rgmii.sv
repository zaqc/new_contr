module eth_rgmii ( 
	input					i_cmd_rst_n,
	input					i_cmd_clk,
	input					i_cmd_wr,
	input		[7:0]		i_cmd_addr,
	input		[31:0]	i_cmd_data,
	
	output				o_pll_locked,
	
	input					i_rx_clk,
	input					i_rx_vl,
	input		[3:0]		i_rx_data,
	
	output				o_gtx_clk,	// to GTX pin
	output				o_tx_en,
	output	[3:0]		o_tx_data,
		
	output				o_irq,
	output				o_irq_pin,
	
	output				o_pll_tx_clk,	// to TX NIOS MM-Avalon Cross Clocking 
	output				o_pll_rx_clk,	// to RX NIOS MM-Avalon Cross Clocking 
	
	output	[7:0]		o_green_led
);

//----------------------------------------------------------------------------

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

assign o_gtx_clk = pll_gtx_clk;
assign o_pll_locked = pll_locked;
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

	.i_cmd_addr(i_cmd_addr),
	.i_cmd_data(i_cmd_data),
	.i_cmd_wr(i_cmd_wr),
		
	.o_irq(o_irq),
	.o_irq_pin(o_irq_pin),
	
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
