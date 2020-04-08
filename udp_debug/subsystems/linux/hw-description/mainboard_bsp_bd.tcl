
################################################################
# This is a generated script based on design: mainboard_bsp
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source mainboard_bsp_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# BRAM_PORTB_CTRL, POWER_CTRL, ANGLE_SIMULATE, BRAM_PINGPANG_CTRL, BRAM_WRITE, DECODE

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z020clg400-1
}


# CHANGE DESIGN NAME HERE
set design_name mainboard_bsp

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: monitor
proc create_hier_cell_monitor { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_monitor() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -from 1 -to 0 addrb
  create_bd_pin -dir O -type clk clka
  create_bd_pin -dir I -type clk clkb
  create_bd_pin -dir O -from 31 -to 0 doutb
  create_bd_pin -dir I i_adc_sdo
  create_bd_pin -dir I -type clk i_clk
  create_bd_pin -dir I -type rst i_rst
  create_bd_pin -dir O o_adc_cs
  create_bd_pin -dir O o_adc_sdi
  create_bd_pin -dir O -from 0 -to 0 o_txn
  create_bd_pin -dir I -type rst rstb

  # Create instance: MONITOR_0, and set properties
  set MONITOR_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:MONITOR:2.7 MONITOR_0 ]

  # Create instance: blk_mem_gen_1, and set properties
  set blk_mem_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_1 ]
  set_property -dict [ list \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Always_Enabled} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Port_A_Write_Rate {50} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {0} \
CONFIG.Read_Width_A {16} \
CONFIG.Read_Width_B {32} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.Write_Depth_A {8} \
CONFIG.Write_Width_A {16} \
CONFIG.Write_Width_B {32} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_1

  # Create port connections
  connect_bd_net -net BRAM_PORTB_CTRL_0_o_txn_done [get_bd_pins rstb] [get_bd_pins blk_mem_gen_1/rstb]
  connect_bd_net -net BRAM_PORTB_CTRL_0_ov_monitor_addr [get_bd_pins addrb] [get_bd_pins blk_mem_gen_1/addrb]
  connect_bd_net -net MONITOR_0_o_adc_cs [get_bd_pins o_adc_cs] [get_bd_pins MONITOR_0/o_adc_cs]
  connect_bd_net -net MONITOR_0_o_adc_sclk [get_bd_pins clka] [get_bd_pins MONITOR_0/o_adc_sclk] [get_bd_pins blk_mem_gen_1/clka]
  connect_bd_net -net MONITOR_0_o_adc_sdi [get_bd_pins o_adc_sdi] [get_bd_pins MONITOR_0/o_adc_sdi]
  connect_bd_net -net MONITOR_0_o_txn [get_bd_pins o_txn] [get_bd_pins MONITOR_0/o_txn]
  connect_bd_net -net MONITOR_0_o_wea [get_bd_pins MONITOR_0/o_wea] [get_bd_pins blk_mem_gen_1/wea]
  connect_bd_net -net MONITOR_0_ov_addr [get_bd_pins MONITOR_0/ov_addr] [get_bd_pins blk_mem_gen_1/addra]
  connect_bd_net -net MONITOR_0_ov_data [get_bd_pins MONITOR_0/ov_data] [get_bd_pins blk_mem_gen_1/dina]
  connect_bd_net -net blk_mem_gen_1_doutb [get_bd_pins doutb] [get_bd_pins blk_mem_gen_1/doutb]
  connect_bd_net -net i_adc_sdo_1 [get_bd_pins i_adc_sdo] [get_bd_pins MONITOR_0/i_adc_sdo]
  connect_bd_net -net i_clk_1 [get_bd_pins i_clk] [get_bd_pins MONITOR_0/i_clk]
  connect_bd_net -net i_rst_1 [get_bd_pins i_rst] [get_bd_pins MONITOR_0/i_rst]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins clkb] [get_bd_pins blk_mem_gen_1/clkb]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lidar_data
proc create_hier_cell_lidar_data { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lidar_data() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk clkb
  create_bd_pin -dir I -type clk i_clk
  create_bd_pin -dir I -type clk i_clk1
  create_bd_pin -dir I i_pps
  create_bd_pin -dir I -type rst i_rst
  create_bd_pin -dir I i_txn_done
  create_bd_pin -dir I -from 15 -to 0 iv_azimuth_din
  create_bd_pin -dir I -from 8 -to 0 iv_raddr
  create_bd_pin -dir O o_txn
  create_bd_pin -dir O -from 31 -to 0 ov_rdata
  create_bd_pin -dir I receive_signal

  # Create instance: ANGLE_SIMULATE_0, and set properties
  set block_name ANGLE_SIMULATE
  set block_cell_name ANGLE_SIMULATE_0
  if { [catch {set ANGLE_SIMULATE_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ANGLE_SIMULATE_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: BRAM_PINGPANG_CTRL_0, and set properties
  set block_name BRAM_PINGPANG_CTRL
  set block_cell_name BRAM_PINGPANG_CTRL_0
  if { [catch {set BRAM_PINGPANG_CTRL_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $BRAM_PINGPANG_CTRL_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: BRAM_WRITE_0, and set properties
  set block_name BRAM_WRITE
  set block_cell_name BRAM_WRITE_0
  if { [catch {set BRAM_WRITE_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $BRAM_WRITE_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: DECODE_0, and set properties
  set block_name DECODE
  set block_cell_name DECODE_0
  if { [catch {set DECODE_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $DECODE_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: TIMESTAMPGEN_0, and set properties
  set TIMESTAMPGEN_0 [ create_bd_cell -type ip -vlnv YiFeng:YiFengIPRepository:TIMESTAMPGEN:2.7 TIMESTAMPGEN_0 ]
  set_property -dict [ list \
CONFIG.pps_in {true} \
 ] $TIMESTAMPGEN_0

  # Create instance: YF_CONSTANT_0, and set properties
  set YF_CONSTANT_0 [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:YF_CONSTANT:2.0 YF_CONSTANT_0 ]
  set_property -dict [ list \
CONFIG.DOUT0_VALUE {1} \
 ] $YF_CONSTANT_0

  # Create instance: blk_mem_gen_pang, and set properties
  set blk_mem_gen_pang [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_pang ]
  set_property -dict [ list \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Always_Enabled} \
CONFIG.Fill_Remaining_Memory_Locations {true} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {0} \
CONFIG.Read_Width_A {8} \
CONFIG.Read_Width_B {32} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Use_RSTB_Pin {false} \
CONFIG.Write_Depth_A {2048} \
CONFIG.Write_Width_A {8} \
CONFIG.Write_Width_B {32} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_pang

  # Create instance: blk_mem_gen_ping, and set properties
  set blk_mem_gen_ping [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_ping ]
  set_property -dict [ list \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Always_Enabled} \
CONFIG.Fill_Remaining_Memory_Locations {true} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {0} \
CONFIG.Read_Width_A {8} \
CONFIG.Read_Width_B {32} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Use_RSTB_Pin {false} \
CONFIG.Write_Depth_A {2048} \
CONFIG.Write_Width_A {8} \
CONFIG.Write_Width_B {32} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_ping

  # Create instance: data_send_0, and set properties
  set data_send_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:data_send:1.0 data_send_0 ]

  # Create port connections
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_o_wea_pang [get_bd_pins BRAM_PINGPANG_CTRL_0/o_wea_pang] [get_bd_pins blk_mem_gen_pang/wea]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_o_wea_ping [get_bd_pins BRAM_PINGPANG_CTRL_0/o_wea_ping] [get_bd_pins blk_mem_gen_ping/wea]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_raddr_pang [get_bd_pins BRAM_PINGPANG_CTRL_0/ov_raddr_pang] [get_bd_pins blk_mem_gen_pang/addrb]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_raddr_ping [get_bd_pins BRAM_PINGPANG_CTRL_0/ov_raddr_ping] [get_bd_pins blk_mem_gen_ping/addrb]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_rdata [get_bd_pins ov_rdata] [get_bd_pins BRAM_PINGPANG_CTRL_0/ov_rdata]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_waddr_pang [get_bd_pins BRAM_PINGPANG_CTRL_0/ov_waddr_pang] [get_bd_pins blk_mem_gen_pang/addra]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_waddr_ping [get_bd_pins BRAM_PINGPANG_CTRL_0/ov_waddr_ping] [get_bd_pins blk_mem_gen_ping/addra]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_wdata_pang [get_bd_pins BRAM_PINGPANG_CTRL_0/ov_wdata_pang] [get_bd_pins blk_mem_gen_pang/dina]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_wdata_ping [get_bd_pins BRAM_PINGPANG_CTRL_0/ov_wdata_ping] [get_bd_pins blk_mem_gen_ping/dina]
  connect_bd_net -net BRAM_WRITE_0_o_txn [get_bd_pins o_txn] [get_bd_pins BRAM_PINGPANG_CTRL_0/i_pingpang_sel] [get_bd_pins BRAM_WRITE_0/o_txn]
  connect_bd_net -net BRAM_WRITE_0_o_wea [get_bd_pins BRAM_PINGPANG_CTRL_0/i_wea] [get_bd_pins BRAM_WRITE_0/o_wea]
  connect_bd_net -net BRAM_WRITE_0_o_wea_another [get_bd_pins BRAM_PINGPANG_CTRL_0/i_wea_another] [get_bd_pins BRAM_WRITE_0/o_wea_another]
  connect_bd_net -net BRAM_WRITE_0_ov_addr [get_bd_pins BRAM_PINGPANG_CTRL_0/iv_waddr] [get_bd_pins BRAM_WRITE_0/ov_addr]
  connect_bd_net -net BRAM_WRITE_0_ov_addr_another [get_bd_pins BRAM_PINGPANG_CTRL_0/iv_addr_another] [get_bd_pins BRAM_WRITE_0/ov_addr_another]
  connect_bd_net -net BRAM_WRITE_0_ov_data [get_bd_pins BRAM_PINGPANG_CTRL_0/iv_wdata] [get_bd_pins BRAM_WRITE_0/ov_data]
  connect_bd_net -net DECODE_0_data_valid [get_bd_pins BRAM_WRITE_0/i_dvaild] [get_bd_pins DECODE_0/data_valid]
  connect_bd_net -net DECODE_0_distance_data [get_bd_pins BRAM_WRITE_0/iv_lidar_din] [get_bd_pins DECODE_0/distance_data]
  connect_bd_net -net TIMESTAMPGEN_0_ov_ch_dout [get_bd_pins BRAM_WRITE_0/iv_time_stamp_din] [get_bd_pins TIMESTAMPGEN_0/ov_ch_dout]
  connect_bd_net -net YF_CONSTANT_0_ov_dout0 [get_bd_pins TIMESTAMPGEN_0/i_ch_rd_en] [get_bd_pins YF_CONSTANT_0/ov_dout0]
  connect_bd_net -net blk_mem_gen_pang_doutb [get_bd_pins BRAM_PINGPANG_CTRL_0/iv_rdata_pang] [get_bd_pins blk_mem_gen_pang/doutb]
  connect_bd_net -net blk_mem_gen_ping_doutb [get_bd_pins BRAM_PINGPANG_CTRL_0/iv_rdata_ping] [get_bd_pins blk_mem_gen_ping/doutb]
  connect_bd_net -net i_clk1_1 [get_bd_pins i_clk1] [get_bd_pins TIMESTAMPGEN_0/i_clk]
  connect_bd_net -net i_clk_1 [get_bd_pins i_clk] [get_bd_pins ANGLE_SIMULATE_0/i_clk] [get_bd_pins BRAM_WRITE_0/i_clk] [get_bd_pins DECODE_0/clk] [get_bd_pins TIMESTAMPGEN_0/i_ch_rd_clk] [get_bd_pins blk_mem_gen_pang/clka] [get_bd_pins blk_mem_gen_ping/clka] [get_bd_pins data_send_0/clk]
  connect_bd_net -net i_pps_1 [get_bd_pins i_pps] [get_bd_pins TIMESTAMPGEN_0/i_pps]
  connect_bd_net -net i_rst_1 [get_bd_pins i_rst] [get_bd_pins BRAM_WRITE_0/i_rst] [get_bd_pins TIMESTAMPGEN_0/i_rst]
  connect_bd_net -net i_txn_done_1 [get_bd_pins i_txn_done] [get_bd_pins BRAM_WRITE_0/i_txn_done]
  connect_bd_net -net iv_azimuth_din_1 [get_bd_pins iv_azimuth_din] [get_bd_pins BRAM_WRITE_0/iv_azimuth_din]
  connect_bd_net -net iv_raddr_1 [get_bd_pins iv_raddr] [get_bd_pins BRAM_PINGPANG_CTRL_0/iv_raddr]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins clkb] [get_bd_pins blk_mem_gen_pang/clkb] [get_bd_pins blk_mem_gen_ping/clkb]
  connect_bd_net -net receive_signal_1 [get_bd_pins receive_signal] [get_bd_pins DECODE_0/receive_signal]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set ENCODER_ABZ [ create_bd_intf_port -mode Master -vlnv YiFeng:YFIPREPOSITORY:ENCODER_ABZ_rtl:1.0 ENCODER_ABZ ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set PWM3 [ create_bd_intf_port -mode Slave -vlnv YiFeng:YFIPREPOSITORY:PWM3_rtl:1.0 PWM3 ]

  # Create ports
  set clk_in1 [ create_bd_port -dir I -type clk clk_in1 ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {25000000} \
CONFIG.PHASE {0.000} \
 ] $clk_in1
  set i_adc_sdo [ create_bd_port -dir I i_adc_sdo ]
  set i_gps_spi [ create_bd_port -dir I i_gps_spi ]
  set i_pps [ create_bd_port -dir I i_pps ]
  set o_5v_ctrl [ create_bd_port -dir O -from 0 -to 0 o_5v_ctrl ]
  set o_adc_cs [ create_bd_port -dir O o_adc_cs ]
  set o_adc_sclk [ create_bd_port -dir O o_adc_sclk ]
  set o_adc_sdi [ create_bd_port -dir O o_adc_sdi ]
  set o_led5v_n [ create_bd_port -dir O o_led5v_n ]
  set o_led_top_n [ create_bd_port -dir O o_led_top_n ]
  set o_top_pwm_H [ create_bd_port -dir O o_top_pwm_H ]
  set o_top_pwm_L [ create_bd_port -dir O o_top_pwm_L ]
  set receive_signal [ create_bd_port -dir I receive_signal ]

  # Create instance: BRAM_PORTB_CTRL_0, and set properties
  set block_name BRAM_PORTB_CTRL
  set block_cell_name BRAM_PORTB_CTRL_0
  if { [catch {set BRAM_PORTB_CTRL_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $BRAM_PORTB_CTRL_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: MOTOR_0, and set properties
  set MOTOR_0 [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:MOTOR:9.0 MOTOR_0 ]
  set_property -dict [ list \
CONFIG.ANGLE_OUT0 {true} \
CONFIG.ANGLE_OUT1 {true} \
CONFIG.CORT_ANGLE {950} \
CONFIG.CORT_CODE {40} \
CONFIG.SPEED_OUT {true} \
 ] $MOTOR_0

  # Create instance: MULTIOUT_CONCAT_0, and set properties
  set MULTIOUT_CONCAT_0 [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:YF_CONSTANT:2.0 MULTIOUT_CONCAT_0 ]
  set_property -dict [ list \
CONFIG.DOUT0_WIDTH {3} \
 ] $MULTIOUT_CONCAT_0

  # Create instance: POWER_CTRL_0, and set properties
  set block_name POWER_CTRL
  set block_cell_name POWER_CTRL_0
  if { [catch {set POWER_CTRL_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $POWER_CTRL_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: YF_AXI_LITE_PERIPHERAL_0, and set properties
  set YF_AXI_LITE_PERIPHERAL_0 [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:YF_AXI_LITE_PERIPHERAL:2.0 YF_AXI_LITE_PERIPHERAL_0 ]
  set_property -dict [ list \
CONFIG.reg32_in_num {2} \
CONFIG.reg32_out_num {1} \
 ] $YF_AXI_LITE_PERIPHERAL_0

  # Create instance: YF_CONSTANT_0, and set properties
  set YF_CONSTANT_0 [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:YF_CONSTANT:2.0 YF_CONSTANT_0 ]
  set_property -dict [ list \
CONFIG.DOUT0_VALUE {1} \
 ] $YF_CONSTANT_0

  # Create instance: YF_CONSTANT_1, and set properties
  set YF_CONSTANT_1 [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:YF_CONSTANT:2.0 YF_CONSTANT_1 ]

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_0 ]
  set_property -dict [ list \
CONFIG.DATA_WIDTH {32} \
CONFIG.ECC_TYPE {Hamming} \
CONFIG.SINGLE_PORT_BRAM {1} \
CONFIG.SUPPORTS_NARROW_BURST {0} \
 ] $axi_bram_ctrl_0

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
CONFIG.C_ALL_INPUTS {1} \
CONFIG.C_ALL_OUTPUTS {0} \
CONFIG.C_ALL_OUTPUTS_2 {1} \
CONFIG.C_GPIO2_WIDTH {4} \
CONFIG.C_GPIO_WIDTH {3} \
CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_0 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.4 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {400.0} \
CONFIG.CLKOUT1_DRIVES {BUFG} \
CONFIG.CLKOUT1_JITTER {220.126} \
CONFIG.CLKOUT1_PHASE_ERROR {237.727} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125} \
CONFIG.CLKOUT2_DRIVES {BUFG} \
CONFIG.CLKOUT2_JITTER {226.965} \
CONFIG.CLKOUT2_PHASE_ERROR {237.727} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100} \
CONFIG.CLKOUT2_USED {true} \
CONFIG.CLKOUT3_DRIVES {BUFG} \
CONFIG.CLKOUT3_JITTER {356.129} \
CONFIG.CLKOUT3_PHASE_ERROR {237.727} \
CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {25} \
CONFIG.CLKOUT3_USED {true} \
CONFIG.CLKOUT4_DRIVES {BUFG} \
CONFIG.CLKOUT4_JITTER {415.604} \
CONFIG.CLKOUT4_PHASE_ERROR {237.727} \
CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {12} \
CONFIG.CLKOUT4_USED {true} \
CONFIG.CLKOUT5_DRIVES {BUFG} \
CONFIG.CLKOUT5_JITTER {448.479} \
CONFIG.CLKOUT5_PHASE_ERROR {237.727} \
CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {8} \
CONFIG.CLKOUT5_USED {true} \
CONFIG.CLKOUT6_DRIVES {BUFG} \
CONFIG.CLKOUT7_DRIVES {BUFG} \
CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
CONFIG.MMCM_CLKFBOUT_MULT_F {40} \
CONFIG.MMCM_CLKIN1_PERIOD {40.000} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {8} \
CONFIG.MMCM_CLKOUT1_DIVIDE {10} \
CONFIG.MMCM_CLKOUT2_DIVIDE {40} \
CONFIG.MMCM_CLKOUT3_DIVIDE {83} \
CONFIG.MMCM_CLKOUT4_DIVIDE {125} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.NUM_OUT_CLKS {5} \
CONFIG.PRIMITIVE {PLL} \
CONFIG.PRIM_IN_FREQ {25} \
CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: lidar_data
  create_hier_cell_lidar_data [current_bd_instance .] lidar_data

  # Create instance: monitor
  create_hier_cell_monitor [current_bd_instance .] monitor

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET0_RESET_ENABLE {0} \
CONFIG.PCW_ENET0_RESET_IO {<Select>} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {0} \
CONFIG.PCW_GPIO_MIO_GPIO_IO {<Select>} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_MIO_16_SLEW {fast} \
CONFIG.PCW_MIO_17_SLEW {fast} \
CONFIG.PCW_MIO_18_SLEW {fast} \
CONFIG.PCW_MIO_19_SLEW {fast} \
CONFIG.PCW_MIO_20_SLEW {fast} \
CONFIG.PCW_MIO_21_SLEW {fast} \
CONFIG.PCW_MIO_22_SLEW {fast} \
CONFIG.PCW_MIO_23_SLEW {fast} \
CONFIG.PCW_MIO_24_SLEW {fast} \
CONFIG.PCW_MIO_25_SLEW {fast} \
CONFIG.PCW_MIO_26_SLEW {fast} \
CONFIG.PCW_MIO_27_SLEW {fast} \
CONFIG.PCW_MIO_40_SLEW {slow} \
CONFIG.PCW_MIO_41_SLEW {slow} \
CONFIG.PCW_MIO_42_SLEW {slow} \
CONFIG.PCW_MIO_43_SLEW {slow} \
CONFIG.PCW_MIO_44_SLEW {slow} \
CONFIG.PCW_MIO_45_SLEW {slow} \
CONFIG.PCW_MIO_52_SLEW {fast} \
CONFIG.PCW_MIO_53_SLEW {fast} \
CONFIG.PCW_P2F_ENET0_INTR {0} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {20} \
CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {32} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_UART0_UART0_IO {<Select>} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART1_UART1_IO {MIO 36 .. 37} \
CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K128M16 JT-125} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_S_AXI_GP0 {0} \
CONFIG.PCW_USE_S_AXI_HP0 {0} \
 ] $processing_system7_0

  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {3} \
 ] $ps7_0_axi_periph

  # Create instance: reverse_concat_0, and set properties
  set reverse_concat_0 [ create_bd_cell -type ip -vlnv yifeng:YifengIpRepository:YF_SPLIT:2.0 reverse_concat_0 ]
  set_property -dict [ list \
CONFIG.DIN_WIDTH {4} \
CONFIG.NUM_PORTS {4} \
 ] $reverse_concat_0

  # Create instance: rst_ps7_0_50M, and set properties
  set rst_ps7_0_50M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_50M ]

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {13} \
CONFIG.IN1_WIDTH {19} \
CONFIG.IN2_WIDTH {1} \
CONFIG.IN3_WIDTH {29} \
CONFIG.NUM_PORTS {2} \
 ] $xlconcat_1

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {1} \
 ] $xlconstant_3

  # Create instance: xlconstant_4, and set properties
  set xlconstant_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_4 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
CONFIG.CONST_WIDTH {19} \
 ] $xlconstant_4

  # Create interface connections
  connect_bd_intf_net -intf_net MOTOR_0_ENCODER_ABZ [get_bd_intf_ports ENCODER_ABZ] [get_bd_intf_pins MOTOR_0/ENCODER_ABZ]
  connect_bd_intf_net -intf_net MOTOR_0_M_FifoRead_SetSpeed [get_bd_intf_pins MOTOR_0/M_FifoRead_SetSpeed] [get_bd_intf_pins YF_AXI_LITE_PERIPHERAL_0/d2pl_ch0]
  connect_bd_intf_net -intf_net PWM3_1 [get_bd_intf_ports PWM3] [get_bd_intf_pins MOTOR_0/PWM3]
  connect_bd_intf_net -intf_net YF_AXI_LITE_PERIPHERAL_0_d2ps_ch0 [get_bd_intf_pins MOTOR_0/S_FifoRead_SpeedOut] [get_bd_intf_pins YF_AXI_LITE_PERIPHERAL_0/d2ps_ch0]
  connect_bd_intf_net -intf_net YF_AXI_LITE_PERIPHERAL_0_d2ps_ch1 [get_bd_intf_pins MOTOR_0/S_FifoRead_AngleOut0] [get_bd_intf_pins YF_AXI_LITE_PERIPHERAL_0/d2ps_ch1]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins YF_AXI_LITE_PERIPHERAL_0/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]

  # Create port connections
  connect_bd_net -net BRAM_PORTB_CTRL_0_o_bram_portb_en [get_bd_pins BRAM_PORTB_CTRL_0/o_bram_portb_en] [get_bd_pins blk_mem_gen_0/enb]
  connect_bd_net -net BRAM_PORTB_CTRL_0_o_txn_done [get_bd_pins BRAM_PORTB_CTRL_0/o_txn_done] [get_bd_pins lidar_data/i_txn_done] [get_bd_pins monitor/rstb]
  connect_bd_net -net BRAM_PORTB_CTRL_0_o_txn_valid [get_bd_pins BRAM_PORTB_CTRL_0/o_txn_valid] [get_bd_pins processing_system7_0/IRQ_F2P]
  connect_bd_net -net BRAM_PORTB_CTRL_0_ov_bram_portb_addr [get_bd_pins BRAM_PORTB_CTRL_0/ov_bram_portb_addr] [get_bd_pins blk_mem_gen_0/addrb]
  connect_bd_net -net BRAM_PORTB_CTRL_0_ov_bram_portb_dwrite [get_bd_pins BRAM_PORTB_CTRL_0/ov_bram_portb_dwrite] [get_bd_pins blk_mem_gen_0/dinb]
  connect_bd_net -net BRAM_PORTB_CTRL_0_ov_bram_portb_we [get_bd_pins BRAM_PORTB_CTRL_0/ov_bram_portb_we] [get_bd_pins blk_mem_gen_0/web]
  connect_bd_net -net BRAM_PORTB_CTRL_0_ov_dram_addr [get_bd_pins BRAM_PORTB_CTRL_0/ov_lidar_addr] [get_bd_pins lidar_data/iv_raddr]
  connect_bd_net -net BRAM_PORTB_CTRL_0_ov_monitor_addr [get_bd_pins BRAM_PORTB_CTRL_0/ov_monitor_addr] [get_bd_pins monitor/addrb]
  connect_bd_net -net MONITOR_0_o_adc_cs [get_bd_ports o_adc_cs] [get_bd_pins monitor/o_adc_cs]
  connect_bd_net -net MONITOR_0_o_adc_sclk [get_bd_ports o_adc_sclk] [get_bd_pins monitor/clka]
  connect_bd_net -net MONITOR_0_o_adc_sdi [get_bd_ports o_adc_sdi] [get_bd_pins monitor/o_adc_sdi]
  connect_bd_net -net MONITOR_0_o_txn [get_bd_pins BRAM_PORTB_CTRL_0/i_monitor_txn] [get_bd_pins monitor/o_txn]
  connect_bd_net -net MULTIOUT_CONCAT_0_ov_dout0 [get_bd_pins MULTIOUT_CONCAT_0/ov_dout0] [get_bd_pins axi_gpio_0/gpio_io_i]
  connect_bd_net -net Net [get_bd_pins MOTOR_0/i_clk] [get_bd_pins YF_AXI_LITE_PERIPHERAL_0/i_d2pl_ch0_ref_clk] [get_bd_pins clk_wiz_0/clk_out2]
  connect_bd_net -net POWER_CTRL_0_o_led5v_n [get_bd_ports o_led5v_n] [get_bd_pins POWER_CTRL_0/o_led5v_n]
  connect_bd_net -net POWER_CTRL_0_o_led_top_n [get_bd_ports o_led_top_n] [get_bd_pins POWER_CTRL_0/o_led_top_n]
  connect_bd_net -net POWER_CTRL_0_o_top_pwm_H [get_bd_ports o_top_pwm_H] [get_bd_pins POWER_CTRL_0/o_top_pwm_H]
  connect_bd_net -net POWER_CTRL_0_o_top_pwm_L [get_bd_ports o_top_pwm_L] [get_bd_pins POWER_CTRL_0/o_top_pwm_L]
  connect_bd_net -net YF_CONSTANT_0_ov_dout0 [get_bd_pins MOTOR_0/i_angle_ch1_rd_en] [get_bd_pins YF_CONSTANT_0/ov_dout0]
  connect_bd_net -net axi_bram_ctrl_0_bram_addr_a [get_bd_pins axi_bram_ctrl_0/bram_addr_a] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net axi_bram_ctrl_0_bram_clk_a [get_bd_pins axi_bram_ctrl_0/bram_clk_a] [get_bd_pins blk_mem_gen_0/clka]
  connect_bd_net -net axi_bram_ctrl_0_bram_en_a [get_bd_pins axi_bram_ctrl_0/bram_en_a] [get_bd_pins blk_mem_gen_0/ena]
  connect_bd_net -net axi_bram_ctrl_0_bram_rst_a [get_bd_pins axi_bram_ctrl_0/bram_rst_a] [get_bd_pins blk_mem_gen_0/rsta]
  connect_bd_net -net axi_bram_ctrl_0_bram_we_a [get_bd_pins axi_bram_ctrl_0/bram_we_a] [get_bd_pins blk_mem_gen_0/wea]
  connect_bd_net -net axi_bram_ctrl_0_bram_wrdata_a [get_bd_pins axi_bram_ctrl_0/bram_wrdata_a] [get_bd_pins blk_mem_gen_0/dina]
  connect_bd_net -net axi_gpio_0_gpio2_io_o [get_bd_pins axi_gpio_0/gpio2_io_o] [get_bd_pins reverse_concat_0/iv_din]
  connect_bd_net -net blk_mem_gen_0_douta [get_bd_pins axi_bram_ctrl_0/bram_rddata_a] [get_bd_pins blk_mem_gen_0/douta]
  connect_bd_net -net blk_mem_gen_1_doutb [get_bd_pins BRAM_PORTB_CTRL_0/iv_monitor_data] [get_bd_pins monitor/doutb]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins MOTOR_0/i_angle_ch1_ref_clk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins lidar_data/i_clk]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins lidar_data/i_clk1] [get_bd_pins monitor/i_clk]
  connect_bd_net -net clk_wiz_0_clk_out4 [get_bd_pins POWER_CTRL_0/i_clk] [get_bd_pins clk_wiz_0/clk_out4]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins MOTOR_0/i_rst] [get_bd_pins POWER_CTRL_0/i_rst] [get_bd_pins clk_wiz_0/locked] [get_bd_pins lidar_data/i_rst] [get_bd_pins monitor/i_rst]
  connect_bd_net -net clock_rtl_1 [get_bd_ports clk_in1] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net i_adc_sdo_1 [get_bd_ports i_adc_sdo] [get_bd_pins monitor/i_adc_sdo]
  connect_bd_net -net i_pps_1 [get_bd_ports i_pps] [get_bd_pins lidar_data/i_pps]
  connect_bd_net -net iv_azimuth_din_1 [get_bd_pins MOTOR_0/ov_angle_ch1_dout] [get_bd_pins lidar_data/iv_azimuth_din]
  connect_bd_net -net lidar_data_o_txn [get_bd_pins BRAM_PORTB_CTRL_0/i_lidar_txn] [get_bd_pins lidar_data/o_txn]
  connect_bd_net -net lidar_data_ov_rdata [get_bd_pins BRAM_PORTB_CTRL_0/iv_lidar_data] [get_bd_pins lidar_data/ov_rdata]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins BRAM_PORTB_CTRL_0/i_clk] [get_bd_pins MOTOR_0/i_angle_ch0_ref_clk] [get_bd_pins MOTOR_0/i_speed_ch_ref_clk] [get_bd_pins YF_AXI_LITE_PERIPHERAL_0/s00_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins blk_mem_gen_0/clkb] [get_bd_pins lidar_data/clkb] [get_bd_pins monitor/clkb] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins rst_ps7_0_50M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_50M/ext_reset_in]
  connect_bd_net -net receive_signal_1 [get_bd_ports receive_signal] [get_bd_pins lidar_data/receive_signal]
  connect_bd_net -net reverse_concat_0_ov_dout0 [get_bd_pins POWER_CTRL_0/i_ps_top_ctrl] [get_bd_pins reverse_concat_0/ov_dout0]
  connect_bd_net -net reverse_concat_0_ov_dout1 [get_bd_pins MOTOR_0/i_motor_en] [get_bd_pins reverse_concat_0/ov_dout1]
  connect_bd_net -net reverse_concat_0_ov_dout2 [get_bd_pins BRAM_PORTB_CTRL_0/i_txn_ready] [get_bd_pins reverse_concat_0/ov_dout2]
  connect_bd_net -net reverse_concat_0_ov_dout3 [get_bd_pins MOTOR_0/i_oplop_en] [get_bd_pins reverse_concat_0/ov_dout3]
  connect_bd_net -net rst_ps7_0_50M_interconnect_aresetn [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins rst_ps7_0_50M/interconnect_aresetn]
  connect_bd_net -net rst_ps7_0_50M_peripheral_aresetn [get_bd_pins BRAM_PORTB_CTRL_0/i_rst] [get_bd_pins YF_AXI_LITE_PERIPHERAL_0/s00_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_ps7_0_50M/peripheral_aresetn]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins blk_mem_gen_0/addra] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins blk_mem_gen_0/rstb] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlconstant_4_dout [get_bd_pins xlconcat_1/In1] [get_bd_pins xlconstant_4/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs YF_AXI_LITE_PERIPHERAL_0/S00_AXI/S00_AXI_reg] SEG_YF_AXI_LITE_PERIPHERAL_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00002000 -offset 0x40000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


