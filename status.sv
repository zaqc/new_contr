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
	
	input		[1:0]		i_pkt_type
);

reg			[47:0]	dst_mac;
reg			[47:0]	src_mac;
reg			[1:0]		operation;
reg			[47:0]	SHA;
reg			[31:0]	SPA;
reg			[47:0]	THA;
reg			[31:0]	TPA;
	
reg			[1:0]		pkt_type;


always_ff @ (posedge clk or negedge rst_n)
	if(~rst_n) begin
		dst_mac <= 48'd0;
		src_mac <= 48'd0;
		operation <= 2'd0;
		SHA <= 48'd0;
		SPA <= 32'd0;
		THA <= 48'd0;
		TPA <= 32'd0;
	end
	else 
		if(|i_pkt_type) begin
			dst_mac <= i_dst_mac;
			src_mac <= i_src_mac;
			operation <= i_operation;
			SHA <= i_SHA;
			SPA <= i_SPA;
			THA <= i_THA;
			TPA <= i_TPA;
			pkt_type <= i_pkt_type;
		end


always_comb begin
	o_rx_pkt_data = 32'd0;
	case(i_rx_cmd_addr)
		8'h01: o_rx_pkt_data = dst_mac[31:0];
		8'h02: o_rx_pkt_data = {16'd0, dst_mac[47:32]};
		8'h03: o_rx_pkt_data = src_mac[31:0];
		8'h04: o_rx_pkt_data = {16'd0, src_mac[47:32]};
		8'h05: o_rx_pkt_data = {30'd0, operation};
		8'h06: o_rx_pkt_data = SHA[31:0];
		8'h07: o_rx_pkt_data = {16'd0, SHA[47:32]};
		8'h08: o_rx_pkt_data = SPA;
		8'h09: o_rx_pkt_data = THA[31:0];
		8'h0A: o_rx_pkt_data = {16'd0, THA[47:32]};
		8'h0B: o_rx_pkt_data = TPA;
		8'h0C: o_rx_pkt_data = {30'd0, pkt_type};
		default:
			o_rx_pkt_data = {i_rx_cmd_addr, i_rx_cmd_addr, i_rx_cmd_addr, i_rx_cmd_addr};
	endcase
end
	

endmodule
