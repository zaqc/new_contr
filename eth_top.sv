module eth_top(
	input					i_cmd_clk,
	input					i_cmd_rst_n,
	input		[7:0]		i_cmd_addr,		// control command from NIOS-II
	input		[31:0]	i_cmd_data,
	input					i_cmd_wr,
	
	input					i_pll_locked,
	
	output	[31:0]	o_pkt_data,		// packet data IP, MAC and so on to NIOS-II
	
	output				o_irq,
	output				o_irq_pin,
	
	input					i_rx_clk,
	input		[7:0]		i_rx_data,
	input					i_rx_dv,
	
	input					i_tx_clk,
	output	[7:0]		o_tx_data,
	output				o_tx_en,
		
	output	[7:0]		o_green_led
);

reg			[0:0]		int_flag;

always_ff @ (posedge i_rx_clk) begin
	if(prev_irq_pin & irq_pin)
		int_flag <= 1'b0;
	else
		if(o_green_led[0])
			int_flag <= 1'b1;
end

reg			[0:0]			prev_irq_pin;
reg			[0:0]			irq_pin;

always_ff @ (posedge i_rx_clk) begin
	prev_irq_pin <= irq_pin;
	irq_pin <= int_flag;
end

assign o_irq_pin = ~prev_irq_pin & irq_pin;

// ===========================================================================
// command
// ===========================================================================

wire						cmd_pipe_full;

cmd_pipe cmd_pipe_unit(
	.aclr(~i_cmd_rst_n),
	
	.wrclk(i_cmd_clk),
	.wrreq(i_cmd_wr & (~cmd_pipe_full)),
	.data({i_cmd_addr, i_cmd_data}),
	.wrfull(cmd_pipe_full),
	
	.rdclk(i_tx_clk),
	.rdreq(1'b1),
	.q({cmd_addr, cmd_data}),
	.rdempty(cmd_wr)
);

wire			[7:0]			cmd_addr;
wire			[31:0]		cmd_data;
wire							cmd_wr;

reg			[7:0]			led_reg;

always_ff @ (posedge i_cmd_clk or negedge i_cmd_rst_n)
	if(~i_cmd_rst_n)
		led_reg <= 8'hAA;
	else
		if(i_cmd_wr)
			led_reg <= i_cmd_addr;
			
// assign o_green_led = ~led_reg;

//----------------------------------------------------------------------------

command command_unit(
	.rst_n(i_pll_locked),
	.clk(i_tx_clk),
	
	.i_cmd_addr(cmd_addr),
	.i_cmd_data(cmd_data),
	.i_cmd_wr(~cmd_wr),
	
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
	.rst_n(i_pll_locked),
	.clk(i_rx_clk),
	
	.i_data(i_rx_data),
	.i_data_vl(i_rx_dv),
	
	.o_pkt_type(pkt_type)
);

wire			[1:0]			pkt_type;
reg			[7:0]			r_pkt_count;

always_ff @ (posedge i_rx_clk or negedge i_pll_locked)
	if(~i_pll_locked)
		r_pkt_count <= 8'd0;
	else
		if(|pkt_type)
			r_pkt_count <= r_pkt_count + 8'd1;

assign o_green_led = r_pkt_count;

//----------------------------------------------------------------------------

wire							irq_pipe_full;

irq_pipe irq_pipe_unit(
	.aclr(~i_pll_locked),
	
	.wrclk(i_rx_clk),
	.wrreq((|pkt_type) & (~irq_pipe_full)),
	.data(1'b1),
	.wrfull(irq_pipe_full),
	
	.rdclk(i_cmd_clk),
	.rdreq(1'b1),
	.q(irq_pipe_value),
	.rdempty(irq_pipe_empty)
);

wire						irq_pipe_value;
wire						irq_pipe_empty;

assign o_irq = 1'b0; //irq_pipe_empty ? 1'b0 : irq_pipe_value;

// ===========================================================================
// send frame
// ===========================================================================

eth_send eth_send_unit(
	.rst_n(i_pll_locked),
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
