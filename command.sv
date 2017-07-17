module command(
	input						rst_n,
	input						clk,
	
	input		[7:0]			i_cmd_addr,
	input		[31:0]		i_cmd_data,
	input						i_cmd_wr,

	output 	[47:0]		o_dst_mac,
	output 	[47:0]		o_src_mac,
	output 	[1:0]			o_operation,
	output 	[47:0]		o_SHA,
	output 	[31:0]		o_SPA,
	output 	[47:0]		o_THA,
	output 	[31:0]		o_TPA,
	
	output	[31:0]		o_src_ip,
	output	[31:0]		o_dst_ip,
	
	output	[15:0]		o_src_port,
	output	[15:0]		o_dst_port,
	
	output	[15:0]		o_udp_data_len,
	
	output [1:0]			o_send_packet
);

//----------------------------------------------------------------------------

reg		[1:0]			send_packet;

always_ff @ (posedge clk or negedge rst_n)
	if(~rst_n)
		send_packet <= 2'd0;
	else
		if(i_cmd_wr && i_cmd_addr == 8'd2)
			send_packet <= i_cmd_data[1:0];
		else
			send_packet <= 2'd0;

assign o_send_packet = send_packet;

//----------------------------------------------------------------------------

assign o_dst_mac = dst_mac;
assign o_src_mac = src_mac;

assign o_operation = arp_operation;
assign o_SHA = arp_src_mac;
assign o_SPA = arp_src_ip;
assign o_THA = arp_dst_mac;
assign o_TPA = arp_dst_ip;

assign o_src_ip = src_ip;
assign o_dst_ip = dst_ip;
assign o_src_port = src_port;
assign o_dst_port = dst_port;
assign o_udp_data_len = udp_data_len;

reg		[47:0]		src_mac;
reg		[47:0]		dst_mac;

reg		[31:0]		src_ip;
reg		[31:0]		dst_ip;
reg		[15:0]		src_port;
reg		[15:0]		dst_port;
reg		[15:0]		udp_data_len;

reg		[1:0]			arp_operation;

reg		[47:0]		arp_dst_mac;
reg		[31:0]		arp_dst_ip;
reg		[47:0]		arp_src_mac;
reg		[31:0]		arp_src_ip;

always_ff @ (posedge clk or negedge rst_n)
	if(~rst_n) begin
		src_mac <= 48'd0;
		dst_mac <= 48'd0;
		src_ip <= 32'd0;
		dst_ip <= 32'd0;
		src_port <= 16'd0;
		dst_port <= 16'd0;
		udp_data_len <= 16'd0;
		arp_operation <= 2'd0;
		arp_src_mac <= 48'd0;
		arp_dst_mac <= 48'd0;
		arp_src_ip <= 32'd0;
		arp_dst_ip <= 32'd0;
	end
	else
		if(i_cmd_wr)
			case(i_cmd_addr[4:0])
				5'h03: src_mac[47:16] <= i_cmd_data[31:0];
				5'h04: src_mac[15:0] <= i_cmd_data[15:0];				
				5'h05: dst_mac[47:16] <= i_cmd_data[31:0];
				5'h06: dst_mac[15:0] <= i_cmd_data[15:0];
				
				5'h07: src_ip <= i_cmd_data[31:0];
				5'h08: dst_ip <= i_cmd_data[31:0];
				
				5'h09: src_port <= i_cmd_data[15:0];
				5'h0A: dst_port <= i_cmd_data[15:0];
				
				5'h0C: udp_data_len <= i_cmd_data[15:0];
				
				5'h0D: arp_operation <= i_cmd_data[1:0];
				
				5'h0E: arp_dst_mac[47:16] <= i_cmd_data[31:0];
				5'h0F: arp_dst_mac[15:0] <= i_cmd_data[15:0];
				5'h10: arp_dst_ip <= i_cmd_data[31:0];
				
				5'h11: arp_src_mac[47:16] <= i_cmd_data[31:0];
				5'h12: arp_src_mac[15:0] <= i_cmd_data[15:0];
				5'h13: arp_src_ip <= i_cmd_data[31:0];
			endcase

endmodule
