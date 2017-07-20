module eth_top(
	input					rst_n,
	
	input		[7:0]		i_cmd_addr,		// control command from NIOS-II
	input		[31:0]	i_cmd_data,
	input					i_cmd_wr,
		
	input		[7:0]  	i_rx_cmd_addr,	// read status registers
	output	[31:0]	o_rx_pkt_data,
	input					i_rx_pkt_rd,
	
	input					i_tx_wr,
	input		[7:0]		i_tx_wr_addr,
	input		[31:0]	i_tx_wr_data,

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
// recv frame
// ===========================================================================

eth_recv eth_recv_unit(
	.rst_n(rst_n),
	.clk(i_rx_clk),
	
	.i_data(i_rx_data),
	.i_data_vl(i_rx_dv),
	
	.o_dst_mac(recv_dst_mac),
	.o_src_mac(recv_src_mac),
	.o_SHA(recv_SHA),
	.o_SPA(recv_SPA),
	.o_THA(recv_THA),
	.o_TPA(recv_TPA),
	
	.o_pkt_type(recv_pkt_type)
);

wire			[47:0]		recv_dst_mac;
wire			[47:0]		recv_src_mac;

wire			[47:0]		recv_SHA;
wire			[31:0]		recv_SPA;
wire			[47:0]		recv_THA;
wire			[31:0]		recv_TPA;

wire			[1:0]			recv_pkt_type;
reg			[7:0]			r_pkt_count;

//----------------------------------------------------------------------------

status status_unit(
	.rst_n(rst_n),
	.clk(i_rx_clk),
	
	.i_rx_cmd_addr(i_rx_cmd_addr),
	.o_rx_pkt_data(o_rx_pkt_data),
	.i_rx_pkt_rd(i_rx_pkt_rd),
	
	.i_dst_mac(recv_dst_mac),
	.i_src_mac(recv_src_mac),	
	.i_SHA(recv_SHA),
	.i_SPA(recv_SPA),
	.i_THA(recv_THA),
	.i_TPA(recv_TPA),
	
	.i_pkt_type(recv_pkt_type)
);

//----------------------------------------------------------------------------

always_ff @ (posedge i_rx_clk or negedge rst_n)
	if(~rst_n)
		r_pkt_count <= 8'd0;
	else
		if(|recv_pkt_type)
			r_pkt_count <= r_pkt_count + 8'd1;

assign o_green_led = r_pkt_count;

//----------------------------------------------------------------------------

assign o_irq_rx = |recv_pkt_type;

// ===========================================================================
// send frame
// ===========================================================================

reg			[1:0]			send_pkt_type;

//wire			[7:0]			arp_tx_data;
//wire							arp_tx_en;
wire			[7:0]			udp_tx_data;
wire							udp_tx_en;

assign o_tx_data = udp_tx_data;
//(send_pkt_type == 2'b01) ? arp_tx_data : 
//((send_pkt_type == 2'b10) ? udp_tx_data : 8'd0);
assign o_tx_en = udp_tx_en;
//(send_pkt_type == 2'b01) ? arp_tx_en : 
//((send_pkt_type == 2'b10) ? udp_tx_en : 1'b0);

always_ff @ (posedge i_tx_clk or negedge rst_n)
	if(~rst_n)
		send_pkt_type <= 2'd0;
	else
		if(i_cmd_wr && i_cmd_addr == 8'd2)
			send_pkt_type <= i_cmd_data[1:0];

//----------------------------------------------------------------------------

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
	
	.o_src_ip(cmd_src_ip),
	.o_dst_ip(cmd_dst_ip),
	.o_src_port(cmd_src_port),
	.o_dst_port(cmd_dst_port),
	.o_udp_data_len(cmd_udp_data_len),
	
	.o_send_packet(send_packet)
);

wire			[47:0]		cmd_dst_mac;
wire			[47:0]		cmd_src_mac;

wire			[1:0]			cmd_operation;
	
wire			[47:0]		cmd_SHA;
wire			[31:0]		cmd_SPA;
wire			[47:0]		cmd_THA;
wire			[31:0]		cmd_TPA;

wire			[31:0]		cmd_src_ip;
wire			[31:0]		cmd_dst_ip;
wire			[15:0]		cmd_src_port;
wire			[15:0]		cmd_dst_port;
wire			[15:0]		cmd_udp_data_len;

wire			[1:0]			send_packet;

reg			[1:0]			dd_send_packet;

always_ff @ (posedge i_tx_clk or negedge rst_n)
	if(~rst_n)
		dd_send_packet <= 2'd0;
	else
		dd_send_packet <= send_packet;
		
reg			[0:0]			send_arp;
always_ff @ (posedge i_tx_clk) send_arp <= (dd_send_packet == 2'b01) ? 1'b1 : 1'b0;

reg			[0:0]			send_udp;
always_ff @ (posedge i_tx_clk) send_udp <= (dd_send_packet == 2'b10) ? 1'b1 : 1'b0;

//----------------------------------------------------------------------------

//reg			[47:0]		arp_src_mac;
//always_latch
//	if(send_packet == 2'b01) 
//		arp_src_mac = cmd_src_mac;

//reg			[47:0]		udp_src_mac;
//always_latch 
//	if(send_packet == 2'b10) 
//		udp_src_mac = cmd_src_mac;

/*
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

	.o_tx_data(arp_tx_data),
	.o_tx_en(arp_tx_en),
	
	.i_enable(send_arp)
	//.o_ready(o_arp_ready)
);
*/
reg			[7:0]			udp_stream_data;
wire							udp_stream_rd;

always_ff @ (posedge i_tx_clk or negedge rst_n)
	if(~rst_n)
		udp_stream_data <= 8'd0;
	else
		if(udp_stream_rd)
			udp_stream_data <= udp_stream_data + 8'd1;

reg		[47:0]		src_mac;
reg		[47:0]		dst_mac;
reg		[31:0]		src_ip;
reg		[31:0]		dst_ip;
reg		[15:0]		src_port;
reg		[15:0]		dst_port;
reg		[15:0]		udp_data_len;

always_ff @ (posedge i_tx_clk or negedge rst_n)
	if(~rst_n) begin
		src_mac = 48'h0023543c471b;
		dst_mac = 48'h0c54a5312485;
		src_ip <= 32'h0A000064;
		dst_ip <= 32'h0A000002;
		src_port <= 16'd5152;
		dst_port <= 16'd2179;
		udp_data_len <= 16'd1024;
	end
	else
		if(i_tx_wr)
			case(i_tx_wr_addr)
				8'd24: src_mac[47:16] = i_tx_wr_data[31:0];
				8'd28: src_mac[15:0] = i_tx_wr_data[15:0];				
				8'd32: dst_mac[47:16] = i_tx_wr_data[31:0];
				8'd36: dst_mac[15:0] = i_tx_wr_data[15:0];
				
				8'd40: src_ip <= i_tx_wr_data;
				8'd44: dst_ip <= i_tx_wr_data;
				
				8'd48: src_port <= i_tx_wr_data[15:0];
				8'd52: dst_port <= i_tx_wr_data[15:0];
				
				8'd60: udp_data_len <= i_tx_wr_data[15:0];
			endcase

udp_send usp_send_unit(
	.rst_n(rst_n),
	.clk(i_tx_clk),

	.i_dst_mac(dst_mac),	
	.i_src_mac(src_mac),
	.i_src_ip(src_ip),
	.i_dst_ip(dst_ip),
	.i_src_port(src_port),
	.i_dst_port(dst_port),
	.i_data_len(udp_data_len),

//	.i_dst_mac(cmd_dst_mac),	// 00:23:54:3c:47:1b
//	.i_src_mac(cmd_src_mac),	//	0c:54:a5:31:24:85
//	.i_src_ip(cmd_src_ip),
//	.i_dst_ip(cmd_dst_ip),
//	.i_src_port(cmd_src_port),
//	.i_dst_port(cmd_dst_port),
//	.i_data_len(cmd_udp_data_len),
	
	.i_in_data(udp_stream_data),
	.o_rd(udp_stream_rd),
	
//	.i_dst_mac(48'h0c54a5312485),
//	.i_src_mac(48'h0023543c471b),
//	.i_src_ip(32'h0A000064),
//	.i_dst_ip(32'h0A000002),
//	.i_src_port(16'd5152),
//	.i_dst_port(16'd2179),
//	.i_data_len(16'd1024),
	
	.o_tx_data(udp_tx_data),
	.o_tx_en(udp_tx_en),
	
	.i_enable(send_udp)
);

endmodule
