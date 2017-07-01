module new_cntr_som(
//общесистемные
	clk,
	reset_n,
	alt_rdy,		//загрузка завершена "1"
//датчик пути
	a_dp,
	b_dp,
	z_dp,
//отметчики
	kni,
//джойстик
	joy,
//кнопки
	iok,
//I2C датчик температуры
	sda_t,
	scl_t,
//I2C акселерометр
	sda_s,
	scl_s,
	int1_s,
//GPIO разъем расширени¤
	gpio,
//светодиоды
	leds_n,
//звуковые ÷јѕ
	clk_dac,
	synca_n,		//звук строб
	dac_a,			//звук данные
	syncv_n,		//громкость строб
	dac_v,			//громкость данные
//озу 256K x 32
	addr,
	data,
	ramcs_n,
	be_n,
	xwe_n,
	xrd_n,
//интерфейс дефектоскопов
	def_on,			//включение питани¤ дефектоскопов
	clkx,
	din,
	dout,
//иммитаци¤ буксы дл¤ путемера
	imit,
//channal link input
	lvrx,
	lvrxclk,
//channal link output (display 3)
	lvtx,
	lvtxclk,
//управление диспле¤ми
	dps,			//"0" normal scan, "1" reverse scan
	frc,			//"0" - 18 bit, "1" - 24 bit
	msl,			//"0" - map A (JEIDA) включа¤ 18 bit, "1" - map B (VESA) только 24 bit 
//управление драйвером подсветки экрана
	en_bkl,			//включение/сброс драйвера
	pwm_bkl,		//шим регулировка ¤ркости 
	pwm_bl_som,		//шим регулировка ¤ркости от SOM
//интерфейс VAR-SOM-MX6
//-------------------------------------------------------
	reset_m_n,
	gpio5_12,
	gpio5_13,
	gpio5_16,
	gpio5_17,
	spi_clk_in,
	spi_clk_out,
	spi_mosi,
	spi_miso,
	spi_cs0_n,
	uart1_rx,
	uart1_tx,
	uart1_rts,
	uart1_cts,
	uart3_rx,
	uart3_tx,
	uart3_rts,
	uart3_cts,
	uart5_rx,
	uart5_tx,
//-------------------------------------------------------
//интерфейс FT2232H
	clkus,
	dus,
	rd_n,
	wr_n,
	oe_n,
	rxf_n,
	txe_n,
	usres_n,
	siwu,
	suspend_n,
	pwren_n,
//управление USB
	usb_en_n,		//включение питани¤ USB
	host_oce_n,		//флаг перегрузки питани¤
	host_oc_n,		//флаг перегрузки дл¤ SOM
//интерфейс PHY
	mdc,
	mdio,
	int_n,
	gtx_clk,
	tx_clk,
	tx_en,
	tx_er,
	txd,
	rx_clk,
	rx_col,
	rx_crs,
	rx_dv,
	rx_er,
	rxd,
	phyrst_n,
	led_100,
//COM порты внешние
//COM1 отладочный (LVTTL)
	com1_rx,
	com1_tx,
	com1_rts,
	com1_cts,
//COM2 RS422/485
	com2_rx,
	com2_tx,
	com2_dir,
//COM3 RS232 путемер
	com3_rx,
	com3_tx,
//GPS (LVTTL)
	gps_rx,
	gps_tx,
//COM5 RS232
	com5_rx,
	com5_tx,
//SATA состо¤ние
	sata_pres,
	sata_act
);

//system
input	clk;
input	reset_n;
output	alt_rdy;		//load complete must be "1"
assign alt_rdy = 1;
//way sensor
input	a_dp;
input	b_dp;
input	z_dp;
//way point keys
input 	[3:0] kni;
//joystik
input	[5:0] joy;
//keyboard
inout	[7:0] iok;
//I2C temp sensor
inout	sda_t;
output	scl_t;
//I2C acselerometer
inout	sda_s;
output	scl_s;
input	int1_s;
//GPIO extension connector
inout	[35:0] gpio;
//user leds
output	[7:0] leds_n;
//sound DACs
output	clk_dac;
output	synca_n;		//sound strobe
output	dac_a;			//sound data
output	syncv_n;		//volume strobe
output	dac_v;			//volume data
//RAM 256K x 32
output	[17:0] addr;
inout	[31:0] data;
output	[1:0] ramcs_n;
output	[3:0] be_n;
output	xwe_n;
output	xrd_n;
//defectoscopes interface
output	def_on;			//defectoscopes power on
input	[1:0] clkx;
input	[1:0] din;
output	[1:0] dout;
//way sensor immitation for waymeter
output	[1:0] imit;
//channal link input
input	[3:0] lvrx;
input	lvrxclk;
//channal link output (display 3)
output	[3:0] lvtx;
output	lvtxclk;
//displays control
output	[2:0] dps;			//"0" normal scan, "1" reverse scan
output	[2:0] frc;			//"0" - 18 bit, "1" - 24 bit
output	[2:0] msl;			//"0" - map A (JEIDA) include 18 bit, "1" - map B (VESA) 24 bit only
//backlight driver control
output	en_bkl;			//enable/reset backlight
output	pwm_bkl;		//pwm brightness control 
input	pwm_bl_som;		//pwm brightness control from SOM
//VAR-SOM-MX6 interface
//-------------------------------------------------------
output	reset_m_n;		//SOM reset
inout	gpio5_12;
inout	gpio5_13;
inout	gpio5_16;
inout	gpio5_17;
input	spi_clk_in;
inout	spi_clk_out;	//disable for slave mode
inout	spi_mosi;
inout	spi_miso;
input	spi_cs0_n;
//SOM uarts signals 
inout	uart1_rx;
input	uart1_tx;
inout	uart1_rts;
input	uart1_cts;
inout	uart3_rx;
input	uart3_tx;
inout	uart3_rts;
input	uart3_cts;
output	uart5_rx;
input	uart5_tx;
//-------------------------------------------------------
//FT2232H interface
input	clkus;
inout	[7:0] dus;
output	rd_n;
output	wr_n;
output	oe_n;
input	rxf_n;
input	txe_n;
output	usres_n;
output	siwu;
input	suspend_n;
input	pwren_n;
//USB power controls
output	usb_en_n;		//USB power on
input	host_oce_n;		//USB power fault flag
output	host_oc_n;		//USB power fault flag to SOM
//PHY interface
output	mdc;
inout	mdio;
input	int_n;
output	gtx_clk;
input	tx_clk;
output	tx_en;
output	tx_er;
output	[3:0] txd;
input	rx_clk;
input	rx_col;
input	rx_crs;
input	rx_dv;
input	rx_er;
input	[3:0] rxd;
output	phyrst_n;
input	led_100;

assign phyrst_n = 1'b1;

//COM external ports
//COM1 debugging (LVTTL)
input	com1_rx;
output	com1_tx;
input	com1_rts;
output	com1_cts;
//COM2 RS422/485
input	com2_rx;
output	com2_tx;
output	com2_dir;		//"1" transmitter enable (RS485 mode)
//COM3 RS232 waymeter
input	com3_rx;
output	com3_tx;
//GPS (LVTTL)
input	gps_rx;
output	gps_tx;
//COM5 RS232
input	com5_rx;
output	com5_tx;
//SATA state signals
input	sata_pres;
input	sata_act;

//prog loading finished
assign	alt_rdy = 1'b1;

//SOM debug port initialisation 
assign	uart1_rx = reset_n ? com1_rx : 1'bz;
assign	uart1_rts = reset_n ? com1_rts : 1'bz;
assign	com1_tx = uart1_tx;
assign	com1_cts = uart1_cts;
//uart 3 reset tristate and connect to com3
assign	uart3_rx = reset_n ? com3_rx : 1'bz;
assign	uart3_rts = 1'bz;
assign	com3_tx = uart3_tx;
//uart 5 connect to com5
assign	uart5_rx = com5_rx;
assign	com5_tx = uart5_tx;
//spi slave mode
assign	spi_clk_out = 1'bz;
//displays control initialisation
//normal scan, map A (JEIDA), 24 bit
assign	dps = 3'b000;
assign	frc = 3'b111;
assign	msl = 3'b000;
//backlight on, brightness pwm translate from SOM
assign	en_bkl = reset_n;
assign	pwm_bkl = pwm_bl_som;
//USB power fault flag translate to SOM
assign	host_oc_n = host_oce_n;
//ft2232 off change this bit if use usb
wire	usb_off = 1'b1;
assign	usb_en_n = usb_off ? 1'b1 : 1'b0;
assign	usres_n = usb_off ? 1'b0 : reset_n;
//translate reset to SOM
assign	reset_m_n = reset_n;
//defectoscopes power on
assign	def_on = 1'b1;
//dac volume & sound clock assign to clk
assign	clk_dac = clk;

//control transmitters, reference clock clkx[n] use dcfifo to convert to clk
wire	[31:0] cntr_data [0:1];	//command to transmit
wire	[1:0] cntr_valid;		//command valid
wire	[1:0] cntrtr_ready;		//transmitter ready
//channal 0
transmitter cnttr0(
	.clk(clkx[0]),
	.res_n(reset_n),
	.din(cntr_data[0]),
	.validin(cntr_valid[0]),
	.readyin(cntrtr_ready[0]),
	.d_tr(dout[0])
);
//channal 1
transmitter cnttr1(
	.clk(clkx[1]),
	.res_n(reset_n),
	.din(cntr_data[1]),
	.validin(cntr_valid[1]),
	.readyin(cntrtr_ready[1]),
	.d_tr(dout[1])
);
//data receivers, reference clock clkx[n] use dcfifo to convert to clk
wire	[35:0] rsv_data[0:1];	//received data
wire	[1:0] data_valid;		//data valid
//channal 0
receiver_dd drsv0(
	.res_n(reset_n),
	.d_rs(din[0]),
	.clk_rs(clkx[0]),
	.dout(rsv_data[0]),
	.validout(data_valid[0])
);
//channal 1
receiver_dd drsv1(
	.res_n(reset_n),
	.d_rs(din[1]),
	.clk_rs(clkx[1]),
	.dout(rsv_data[1]),
	.validout(data_valid[1])
);

//set volume data
wire	[7:0] volume_data;
wire	volume_valid;
wire	voldac_ready;
assign	voldac_ready = syncv_n;

spi_dac vol_dac(
	.clk(clk),
	.data_spi(volume_data),
	.valid(volume_valid),
	.dout(dac_v),
	.dsync_n(syncv_n)
);
//set sound data
wire	[7:0] sound_data;
wire	sound_valid;
wire	snddac_ready;
assign	snddac_ready = synca_n;

spi_dac snd_dac(
	.clk(clk),
	.data_spi(sound_data),
	.valid(sound_valid),
	.dout(dac_a),
	.dsync_n(synca_n)
);


//test leds

reg	[31:0] tcounter;
assign leds_n = ~tcounter[31:24];

always@(posedge rx_clk)
begin
	tcounter <= tcounter + 1'b1;
end


// test
/*assign	volume_data = 8'h55;
assign	sound_data = 8'haa;
assign	sound_valid = snddac_ready;
assign	volume_valid = voldac_ready;
*/
/*assign	cntr_valid = cntrtr_ready;
assign	cntr_data[0] = 32'h55555555;
assign	cntr_data[1] = 32'h55555555;
reg		[35:0] rsdata [0:1];
assign	gpio = rsdata[0] & rsdata[1];

always@(posedge clkx[0])
begin
	if(data_valid[0]) rsdata[0] <= rsv_data[0];
	else rsdata[0] <= rsdata[0];
end
always@(posedge clkx[1])
begin
	if(data_valid[1]) rsdata[1] <= rsv_data[1];
	else rsdata[1] <= rsdata[1];
end*/

endmodule
