module eth_top(
	input					rst_n,
	
	input		[7:0]		i_cmd_addr,		// control command from NIOS-II
	input		[31:0]	i_cmd_data,
	input					i_cmd_wr,
		
	input		[7:0]  	i_rx_cmd_addr,	// read status registers
	output	[31:0]	o_rx_pkt_data,
	input					i_rx_pkt_rd,

	output	[31:0]	o_pkt_data,		// packet data IP, MAC and so on to NIOS-II
	
	output				o_irq_tx,
	output				o_irq_rx,
	
	input					i_rx_clk,
	input		[7:0]		i_rx_data,
	input					i_rx_dv,
	
	input					i_tx_clk,
	output	[7:0]		o_tx_data,
	output				o_tx_en,
		
	output	[7:0]		o_green_led
);

assign o_irq_tx = 1'b0;

// ===========================================================================
// command
// ===========================================================================

command command_unit(
	.rst_n(rst_n),
	.clk(i_tx_clk),
	
	.i_cmd_addr(i_cmd_addr),
	.i_cmd_data(i_cmd_data),
	.i_cmd_wr(i_cmd_wr),
	
	.o_dst_mac(cmd_dst_mac),
	.o_src_mac(cmd_src_mac),
	.o_operation(cmd_operation),
	.o_SHA(cmd_SHA),
	.o_SPA(cmd_SPA),
	.o_THA(cmd_THA),
	.o_TPA(cmd_TPA),
	
	.o_send_packet(send_packet)
);

wire			[47:0]		cmd_dst_mac;
wire			[47:0]		cmd_src_mac;

wire			[1:0]			cmd_operation;
	
wire			[47:0]		cmd_SHA;
wire			[31:0]		cmd_SPA;
wire			[47:0]		cmd_THA;
wire			[31:0]		cmd_TPA;

wire			[1:0]			send_packet;

// ===========================================================================
// recv frame
// ===========================================================================

eth_recv eth_recv_unit(
	.rst_n(rst_n),
	.clk(i_rx_clk),
	
	.i_data(i_rx_data),
	.i_data_vl(i_rx_dv),
	
	.o_SHA(rx_SHA),
	.o_SPA(rx_SPA),
	.o_THA(rx_THA),
	.o_TPA(rx_TPA),
	
	.o_pkt_type(pkt_type)
);

wire			[47:0]		rx_SHA;
wire			[31:0]		rx_SPA;
wire			[47:0]		rx_THA;
wire			[31:0]		rx_TPA;

wire			[1:0]			pkt_type;
reg			[7:0]			r_pkt_count;

//----------------------------------------------------------------------------

status status_unit(
	.rst_n(rst_n),
	.clk(i_rx_clk),
	
	.i_rx_cmd_addr(i_rx_cmd_addr),
	.o_rx_pkt_data(o_rx_pkt_data),
	.i_rx_pkt_rd(i_rx_pkt_rd),
	
	.i_SHA(rx_SHA),
	.i_SPA(rx_SPA),
	.i_THA(rx_THA),
	.i_TPA(rx_TPA),
	
	.i_pkt_type(pkt_type)
);

//----------------------------------------------------------------------------

always_ff @ (posedge i_rx_clk or negedge rst_n)
	if(~rst_n)
		r_pkt_count <= 8'd0;
	else
		if(|pkt_type)
			r_pkt_count <= r_pkt_count + 8'd1;

assign o_green_led = r_pkt_count;

//----------------------------------------------------------------------------

assign o_irq_rx = 1'b0; //|pkt_type;

// ===========================================================================
// send frame
// ===========================================================================

eth_send eth_send_unit(
	.rst_n(rst_n),
	.clk(i_tx_clk),
	
	.i_dst_mac(cmd_dst_mac),
	.i_src_mac(cmd_src_mac),
	
	.i_operation(cmd_operation),
	
	.i_SHA(cmd_SHA),
	.i_SPA(cmd_SPA),
	.i_THA(cmd_THA),
	.i_TPA(cmd_TPA),

	.o_tx_data(o_tx_data),
	.o_tx_en(o_tx_en),
	
	.i_enable(send_packet == 2'b01)
	//.o_ready(o_arp_ready)
);

endmodule
