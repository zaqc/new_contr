module status(
	input					rst_n,
	input					clk,
	
	input		[7:0]		i_rx_cmd_addr,
	output	[31:0]	o_rx_pkt_data,
	input					i_rx_pkt_rd,

	input		[47:0]	i_dst_mac,
	input 	[47:0]	i_src_mac,
	input		[1:0]		i_operation,
	input		[47:0]	i_SHA,
	input		[31:0]	i_SPA,
	input		[47:0]	i_THA,
	input		[31:0]	i_TPA,
	
	input		[1:0]		i_packet_type
);
//
//always_comb begin
//	o_rx_pkt_data = 32'd0;
//	case(i_rx_cmd_addr)
//		8'h01: o_rx_pkt_data = i_dst_mac[31:0];
//		8'h02: o_rx_pkt_data = {16'd0, i_dst_mac[47:32]};
//		8'h03: o_rx_pkt_data = i_src_mac[31:0];
//		8'h04: o_rx_pkt_data = {16'd0, i_src_mac[47:32]};
//		8'h05: o_rx_pkt_data = {30'd0, i_operation};
//		8'h06: o_rx_pkt_data = i_SHA[31:0];
//		8'h07: o_rx_pkt_data = {16'd0, i_SHA[47:32]};
//		8'h08: o_rx_pkt_data = i_SPA;
//		8'h09: o_rx_pkt_data = i_THA[31:0];
//		8'h0A: o_rx_pkt_data = {16'd0, i_THA[47:32]};
//		8'h0B: o_rx_pkt_data = i_TPA;
//	endcase
//end
	

endmodule
