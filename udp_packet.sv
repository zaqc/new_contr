module udp_packet(
	input						rst_n,
	input						clk,
	
	output					o_tx_en,
	output	[7:0]			o_tx_data,
	
	input		[47:0]		i_src_mac,
	input		[47:0]		i_dst_mac,
	input		[31:0]		i_src_ip,
	input		[31:0]		i_dst_ip,
	input		[15:0]		i_src_port,
	input		[15:0]		i_dst_port,
	
	input		[15:0]		i_udp_len,
	
	input						i_enable
);

reg			[0:0]			prev_enable;
always_ff @ (posedge clk) prev_enable <= i_enable;

assign start = (~prev_enable & i_enable);

reg			[47:0]		src_mac;
reg			[47:0]		dst_mac;
reg			[31:0]		src_ip;
reg			[31:0]		dst_ip;
reg			[15:0]		src_port;
reg			[15:0]		dst_port;
reg			[15:0]		udp_len;

always_ff @ (posedge clk or negedge rst_n)
	if(~rst_n) begin
		src_mac = 48'h0023543c471b;
		dst_mac = 48'h0c54a5312485;
		src_ip <= 32'h0A000064;
		dst_ip <= 32'h0A000002;
		src_port <= 16'd5152;
		dst_port <= 16'd2179;
		udp_len <= 16'd1024;
	end
	else 
		if(i_enable) begin
			src_mac = i_src_mac;
			dst_mac = i_dst_mac;
			src_ip <= i_src_ip;
			dst_ip <= i_dst_ip;
			src_port <= i_src_port;
			dst_port <= i_dst_port;
			udp_len <= i_udp_len;
		end

reg			[3:0]			state;
reg			[3:0]			new_state;

always_ff @ (posedge clk or negedge rst_n)
	if(~rst_n)
		state <= 4'd0;
	else
		state <= new_state;
		
wire							fifo_rst;

always_comb begin
	new_state = state;
	fifo_rst = 1'b0;
	if(~|state) begin
		if(~rst_n) begin
			new_state = 4'd1;
			fifo_rst = 1'b1;
		end
	end 
	else 
		if(~|state[3:1] & state[0]) begin
			if(start) begin
				new_state = 4'd2;
				fifo_rst = 1'b1;
			end
		end
		else 
			if(~&state) 
				new_state = new_state + 1'd1; 
			else
				if(sender_ready)
					new_state = 4'd1;
end

// ===========================================================================
// IP/UDP parameters & header
// ===========================================================================

parameter	[3:0]			ip_header_ver = 4'h4;		// 4 - for IPv4
parameter	[3:0]			ip_header_size = 4'h5;		// size in 32bit word's
parameter	[7:0]			ip_DSCP_ECN = 8'h00;			// ?
wire			[15:0]		ip_pkt_size;
assign  ip_pkt_size = data_len + 16'h001C;	// 16'h002E size of UDP packet
wire			[31:0]		ip_hdr1;
assign ip_hdr1 = {ip_header_ver, ip_header_size, ip_DSCP_ECN, ip_pkt_size};

parameter	[15:0]		ip_pkt_id = 16'h0;			// pkt id
parameter	[2:0]			ip_pkt_flags = 3'h0;			// pkt flags
reg			[12:0]		ip_pkt_offset = 13'h0;		// pkt offset
wire			[31:0]		ip_hdr2;
assign ip_hdr2 = {ip_pkt_id, ip_pkt_flags, ip_pkt_offset};

parameter	[7:0]			ip_pkt_TTL = 8'hC8;			// pkt TTL
parameter	[7:0]			ip_pkt_type = 8'd17;			// pkt UDP == 17
wire			[15:0]		ip_pkt_CRC;						// pkt flags
wire			[31:0]		tmp_crc;
assign tmp_crc = ip_hdr1[31:16] + ip_hdr1[15:0] +
	ip_hdr2[31:16] + ip_hdr2[15:0] + ip_hdr3[31:16] + // ip_hdr3[15:0] +
	src_ip[31:16] + src_ip[15:0] + dst_ip[31:16] + dst_ip[15:0];
assign ip_pkt_CRC = ~(tmp_crc[31:16] + tmp_crc[15:0]);
wire			[31:0]	ip_hdr3;	
assign ip_hdr3 = {ip_pkt_TTL, ip_pkt_type, ip_pkt_CRC};

//----------------------------------------------------------------------------

wire			[31:0]		ds_data;
wire							ds_wrreq;
assign ds_wrreq = (state >= 5'h02 && state <= 5'h15) ?  1'b1 : 1'b0;

always_comb begin
	ds_data = 32'd0;
	case(state)
		case 4'h02: ds_data = dst_mac[47:32];
		case 4'h03: ds_data = dst_mac[31:16];
		case 4'h04: ds_data = dst_mac[16:0];
		
		case 4'h05: ds_data = src_mac[47:32];
		case 4'h06: ds_data = src_mac[31:16];
		case 4'h07: ds_data = src_mac[15:0];
		
		case 4'h08: ds_data = 16'h0800;
		
		case 4'h09: ds_data = ip_hdr1[31:15];
		case 4'h0A: ds_data = ip_hdr1[16:0];
		case 4'h0B: ds_data = ip_hdr2[31:15];
		case 4'h0C: ds_data = ip_hdr2[16:0];
		case 4'h0D: ds_data = ip_hdr3[31:15];
		case 4'h0E: ds_data = ip_hdr3[16:0];
		
		case 4'h0F: ds_data = src_ip[31:16];
		case 4'h10: ds_data = src_ip[15:0];
		
		case 4'h11: ds_data = dst_ip[31:16];
		case 4'h12: ds_data = dst_ip[15:0];
		
		case 4'h13: ds_data = dst_port;
		case 4'h14: ds_data = src_port;
		
		case 4'h0E: ds_data = udp_len;
		case 4'h0E: ds_data = udp_crc;
	endcase
end

//----------------------------------------------------------------------------

tx_fifo_out tx_fifo_out_unit(
	.aclr(~rst_n),
	
	.wrclk(clk),
	.data(ds_data),
	.wrreq(ds_wrreq),
	
	.rdclk(clk),
	.rdreq(1'b1),
	.q(fifo_tx_data),
	.empty(fifo_tx_empty)
);

wire							fifo_tx_empty;
wire			[7:0]			fifo_tx_data;
//assign o_tx_en = ~fifo_tx_empty;

// ===========================================================================
// CRC 32
// ===========================================================================
reg		[0:0]			calc_crc_flag;
always @ (posedge clk or negedge rst_n) begin
	if(1'b0 == rst_n)
		calc_crc_flag <= 1'b0;
	else
		if(new_state != state) begin
			if(new_state == SEND_DST_MAC)
				calc_crc_flag <= 1'b1;
			else 
				if(new_state == SEND_CRC32)
					calc_crc_flag <= 1'b0;
		end
end

wire		[31:0]		crc32;

calc_crc32 u_crc32(
	.rst_n(rst_n),
	.clk(clk),
	.i_calc(calc_crc_flag),
	.i_vl(tx_en),
	.i_data(tx_data),
	.o_crc32(crc32)
);

endmodule
