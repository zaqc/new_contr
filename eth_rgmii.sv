module eth_rgmii ( 
	input					i_rx_clk,
	input					i_rx_vl,
	input		[3:0]		i_rx_data,
	
	output				o_gtx_clk,
	output				o_tx_en,
	output	[3:0]		o_tx_data,
	
	input					i_cmd_clk,
	input					i_cmd_wr,
	input					i_cmd_addr,
	input					i_cmd_data
);

//----------------------------------------------------------------------------

eth_pll eth_pll_unit(
	.inclk0(i_rx_clk),
	
	.c0(pll_clk_rx),	// 0
	.c1(pll_clk_tx),		// 90
	.c2(pll_gtx_clk),		// 180
	.locked(pll_locked)
);

wire							pll_clk_rx;
wire							pll_clk_tx;
wire							pll_gtx_clk;
wire							pll_locked;

assign o_gtx_clk = pll_gtx_clk;

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
	.rst_n(cmd_reset_n),
	
	.clk(i_cmd_clk),
	.i_cmd_addr(i_cmd_addr),
	.i_cmd_data(i_cmd_data),
	.i_cmd_wr(i_cmd_wr),
	
	//.o_irq(irq),
	
	.i_rx_clk(pll_clk_rx),
	.i_rx_data(rx_data),
	.i_rx_dv(rx_dv),
	
	.i_tx_clk(pll_clk_tx),
	.o_tx_data(tx_data),
	.o_tx_en(tx_en) //,
		
	//.o_green_led(LEDG[8:1])
);

//----------------------------------------------------------------------------


endmodule
