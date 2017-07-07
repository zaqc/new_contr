// mac_control.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module mac_control #(
		parameter AUTO_CLOCK_CLOCK_RATE = "-1"
	) (
		input  wire [7:0]  s0_address,     //    s0.address
		input  wire        s0_read,        //      .read
		output wire [31:0] s0_readdata,    //      .readdata
		input  wire        s0_write,       //      .write
		input  wire [31:0] s0_writedata,   //      .writedata
		output wire        s0_waitrequest, //      .waitrequest
		input  wire        clk,            // clock.clk
		input  wire        reset,          // reset.reset
		output wire        irq0_irq,       //  irq0.irq
		output wire [31:0] out_data,       //   out.export
		output wire        out_wr,         //      .export
		output wire [7:0]  out_addr        //      .export
	);

	// TODO: Auto-generated HDL template

	assign s0_waitrequest = 1'b0;

	assign s0_readdata = 32'b00000000000000000000000000000000;

	assign irq0_irq = 1'b0;

	assign out_data = 32'b00000000000000000000000000000000;

	assign out_addr = 8'b00000000;

	assign out_wr = 1'b0;

endmodule
