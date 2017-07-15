// mac_ctrl.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module mac_ctrl (
		input  wire [7:0]  s0_address,     //    s0.address
		input  wire        s0_read,        //      .read
		output wire [31:0] s0_readdata,    //      .readdata
		input  wire        s0_write,       //      .write
		input  wire [31:0] s0_writedata,   //      .writedata
		output wire        s0_waitrequest, //      .waitrequest
		input  wire        clk,            // clock.clk
		input  wire        reset,          // reset.reset
		output wire        irq0_irq,       //  irq0.irq
		output wire [31:0] cmd_data,       //   cmd.export
		output wire        cmd_wr,         //      .export
		output wire [7:0]  cmd_addr,       //      .export
		input  wire [31:0] pkt_data,       //
		output wire        pkt_rd,         //
		input  wire        irq_wire        //
);

assign s0_waitrequest = s0_write ? 0 : wait_request;

reg			[0:0]			wait_request;

always @ (posedge clk or posedge reset)
	if(reset)
		wait_request <= 1'b1;
	else
		if(wait_request) begin
			if(s0_read)
				wait_request <= 1'b0;
		end
		else
			if(~s0_read)
				wait_request <= 1'b1;

assign s0_readdata = pkt_data;
assign pkt_rd = s0_read;

assign irq0_irq = irq_wire;

assign cmd_data = s0_writedata;
assign cmd_addr = s0_address;
assign cmd_wr = s0_write;

endmodule
