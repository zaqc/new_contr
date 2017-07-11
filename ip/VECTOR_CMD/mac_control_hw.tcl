# TCL File Generated by Component Editor 13.1
# Tue Jul 11 21:17:49 MSD 2017
# DO NOT MODIFY


# 
# mac_ctrl "ethernet MAC control" v1.0
#  2017.07.11.21:17:49
# 
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module mac_ctrl
# 
set_module_property DESCRIPTION ""
set_module_property NAME mac_ctrl
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "ethernet MAC control"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL mac_ctrl
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file mac_ctrl.v VERILOG PATH mac_ctrl.v TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point s0
# 
add_interface s0 avalon end
set_interface_property s0 addressUnits WORDS
set_interface_property s0 associatedClock clock
set_interface_property s0 associatedReset reset
set_interface_property s0 bitsPerSymbol 8
set_interface_property s0 burstOnBurstBoundariesOnly false
set_interface_property s0 burstcountUnits WORDS
set_interface_property s0 explicitAddressSpan 0
set_interface_property s0 holdTime 0
set_interface_property s0 linewrapBursts false
set_interface_property s0 maximumPendingReadTransactions 0
set_interface_property s0 readLatency 1
set_interface_property s0 readWaitTime 1
set_interface_property s0 setupTime 0
set_interface_property s0 timingUnits Cycles
set_interface_property s0 writeWaitTime 0
set_interface_property s0 ENABLED true
set_interface_property s0 EXPORT_OF ""
set_interface_property s0 PORT_NAME_MAP ""
set_interface_property s0 CMSIS_SVD_VARIABLES ""
set_interface_property s0 SVD_ADDRESS_GROUP ""

add_interface_port s0 s0_address address Input 8
add_interface_port s0 s0_read read Input 1
add_interface_port s0 s0_readdata readdata Output 32
add_interface_port s0 s0_write write Input 1
add_interface_port s0 s0_writedata writedata Input 32
add_interface_port s0 s0_waitrequest waitrequest Output 1
set_interface_assignment s0 embeddedsw.configuration.isFlash 0
set_interface_assignment s0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment s0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment s0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point irq0
# 
add_interface irq0 interrupt end
set_interface_property irq0 associatedAddressablePoint s0
set_interface_property irq0 associatedClock clock
set_interface_property irq0 associatedReset reset
set_interface_property irq0 bridgedReceiverOffset 0
set_interface_property irq0 bridgesToReceiver ""
set_interface_property irq0 ENABLED true
set_interface_property irq0 EXPORT_OF ""
set_interface_property irq0 PORT_NAME_MAP ""
set_interface_property irq0 CMSIS_SVD_VARIABLES ""
set_interface_property irq0 SVD_ADDRESS_GROUP ""

add_interface_port irq0 irq0_irq irq Output 1


# 
# connection point cmd
# 
add_interface cmd conduit end
set_interface_property cmd associatedClock clock
set_interface_property cmd associatedReset reset
set_interface_property cmd ENABLED true
set_interface_property cmd EXPORT_OF ""
set_interface_property cmd PORT_NAME_MAP ""
set_interface_property cmd CMSIS_SVD_VARIABLES ""
set_interface_property cmd SVD_ADDRESS_GROUP ""

add_interface_port cmd cmd_data export Output 32
add_interface_port cmd cmd_wr export Output 1
add_interface_port cmd cmd_addr export Output 8


# 
# connection point pkt
# 
add_interface pkt conduit end
set_interface_property pkt associatedClock clock
set_interface_property pkt associatedReset reset
set_interface_property pkt ENABLED true
set_interface_property pkt EXPORT_OF ""
set_interface_property pkt PORT_NAME_MAP ""
set_interface_property pkt CMSIS_SVD_VARIABLES ""
set_interface_property pkt SVD_ADDRESS_GROUP ""

add_interface_port pkt pkt_data export Input 32
add_interface_port pkt pkt_rd export Output 1


# 
# connection point irq
# 
add_interface irq conduit end
set_interface_property irq associatedClock clock
set_interface_property irq associatedReset reset
set_interface_property irq ENABLED true
set_interface_property irq EXPORT_OF ""
set_interface_property irq PORT_NAME_MAP ""
set_interface_property irq CMSIS_SVD_VARIABLES ""
set_interface_property irq SVD_ADDRESS_GROUP ""

add_interface_port irq irq_wire export Input 1

