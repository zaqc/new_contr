module eth_top(
	input					clk,
	input					rst_n,
	
	input		[7:0]		i_cmd_addr,		// control command from NIOS-II
	input		[31:0]	i_cmd_data,
	input					i_cmd_wr,
	
	output	[31:0]	o_pkt_data,		// packet data IP, MAC and so on to NIOS-II
	
	output				o_irq,
	
	input					i_rx_clk,
	input		[7:0]		i_rx_data,
	input					i_rx_dv,
	
	input					i_tx_clk,
	output	[7:0]		o_tx_data,
	output				o_tx_en,
		
	output	[7:0]		o_green_led
);

// ===========================================================================
// command
// ===========================================================================

wire						cmd_pipe_full;

cmd_pipe cmd_pipe_unit(
	.aclr(~rst_n),
	
	.wrclk(clk),
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

//----------------------------------------------------------------------------

command command_unit(
	.rst_n(rst_n),
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
	.rst_n(rst_n),
	.clk(i_rx_clk),
	
	.i_data(i_rx_data),
	.i_data_vl(i_rx_dv),
	
	.o_pkt_type(pkt_type)
);

reg			[7:0]			r_pkt_count;
reg			[0:0]			recv_irq;

always_ff @ (posedge i_rx_clk or negedge rst_n)
	if(~rst_n) begin
		r_pkt_count <= 8'd0;
		recv_irq <= 1'b0;
	end
	else
		if(|pkt_type) begin
			r_pkt_count <= r_pkt_count + 8'd1;
			recv_irq <= 1'b1;
		end
		else
			recv_irq <= 1'b0;

wire			[1:0]			pkt_type;

assign o_green_led = r_pkt_count;

//----------------------------------------------------------------------------

wire							irq_pipe_full;

irq_pipe irq_pipe_unit(
	.aclr(~rst_n),
	
	.wrclk(i_rx_clk),
	.wrreq((|pkt_type) & (~irq_pipe_full)),
	.data(1'b1),
	.wrfull(irq_pipe_full),
	
	.rdclk(clk),
	.rdreq(1'b1),
	.q(irq_pipe_value),
	.rdempty(irq_pipe_empty)
);

wire						irq_pipe_value;
wire						irq_pipe_empty;

assign o_irq = irq_pipe_empty ? 1'b0 : irq_pipe_value;

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
