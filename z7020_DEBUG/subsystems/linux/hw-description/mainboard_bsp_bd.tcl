
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
# POWER_CTRL, BRAM_PINGPANG_CTRL, BRAM_WRITE

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


# Hierarchical cell: pack
proc create_hier_cell_pack { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_pack() - Empty argument(s)!"}
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
  create_bd_pin -dir I -type clk clka
  create_bd_pin -dir I -type clk clkb
  create_bd_pin -dir I i_debug
  create_bd_pin -dir I i_fr_empty
  create_bd_pin -dir I -type rst i_rst
  create_bd_pin -dir I -from 15 -to 0 iv_azimuth
  create_bd_pin -dir I -from 59 -to 0 iv_fr_data
  create_bd_pin -dir I -from 8 -to 0 iv_raddr
  create_bd_pin -dir I -from 31 -to 0 iv_time_stamp
  create_bd_pin -dir O o_fr_en
  create_bd_pin -dir O o_txn
  create_bd_pin -dir O -from 31 -to 0 ov_rdata

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
  
  # Create instance: blk_mem_pang, and set properties
  set blk_mem_pang [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_pang ]
  set_property -dict [ list \
CONFIG.Algorithm {Minimum_Area} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Always_Enabled} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Read_Width_A {8} \
CONFIG.Read_Width_B {32} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Write_Depth_A {2048} \
CONFIG.Write_Width_A {8} \
CONFIG.Write_Width_B {32} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_pang

  # Create instance: blk_mem_ping, and set properties
  set blk_mem_ping [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_ping ]
  set_property -dict [ list \
CONFIG.Algorithm {Minimum_Area} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Always_Enabled} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Read_Width_A {8} \
CONFIG.Read_Width_B {32} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Write_Depth_A {2048} \
CONFIG.Write_Width_A {8} \
CONFIG.Write_Width_B {32} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_ping

  # Create port connections
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_o_wea_pang [get_bd_pins BRAM_PINGPANG_CTRL_0/o_wea_pang] [get_bd_pins blk_mem_pang/wea]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_o_wea_ping [get_bd_pins BRAM_PINGPANG_CTRL_0/o_wea_ping] [get_bd_pins blk_mem_ping/wea]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_raddr_pang [get_bd_pins BRAM_PINGPANG_CTRL_0/ov_raddr_pang] [get_bd_pins blk_mem_pang/addrb]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_raddr_ping [get_bd_pins BRAM_PINGPANG_CTRL_0/ov_raddr_ping] [get_bd_pins blk_mem_ping/addrb]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_rdata [get_bd_pins ov_rdata] [get_bd_pins BRAM_PINGPANG_CTRL_0/ov_rdata]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_waddr_pang [get_bd_pins BRAM_PINGPANG_CTRL_0/ov_waddr_pang] [get_bd_pins blk_mem_pang/addra]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_waddr_ping [get_bd_pins BRAM_PINGPANG_CTRL_0/ov_waddr_ping] [get_bd_pins blk_mem_ping/addra]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_wdata_pang [get_bd_pins BRAM_PINGPANG_CTRL_0/ov_wdata_pang] [get_bd_pins blk_mem_pang/dina]
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_wdata_ping [get_bd_pins BRAM_PINGPANG_CTRL_0/ov_wdata_ping] [get_bd_pins blk_mem_ping/dina]
  connect_bd_net -net BRAM_WRITE_0_o_drw_wea [get_bd_pins BRAM_PINGPANG_CTRL_0/i_wea] [get_bd_pins BRAM_WRITE_0/o_drw_wea]
  connect_bd_net -net BRAM_WRITE_0_o_fr_en [get_bd_pins o_fr_en] [get_bd_pins BRAM_WRITE_0/o_fr_en]
  connect_bd_net -net BRAM_WRITE_0_o_pingpang_sel [get_bd_pins BRAM_PINGPANG_CTRL_0/i_pingpang_sel] [get_bd_pins BRAM_WRITE_0/o_pingpang_sel]
  connect_bd_net -net BRAM_WRITE_0_o_txn [get_bd_pins o_txn] [get_bd_pins BRAM_WRITE_0/o_txn]
  connect_bd_net -net BRAM_WRITE_0_ov_drw_addr [get_bd_pins BRAM_PINGPANG_CTRL_0/iv_waddr] [get_bd_pins BRAM_WRITE_0/ov_drw_addr]
  connect_bd_net -net BRAM_WRITE_0_ov_drw_data [get_bd_pins BRAM_PINGPANG_CTRL_0/iv_wdata] [get_bd_pins BRAM_WRITE_0/ov_drw_data]
  connect_bd_net -net DECODER_0_o_fr_empty [get_bd_pins i_fr_empty] [get_bd_pins BRAM_WRITE_0/i_fr_empty]
  connect_bd_net -net DECODER_0_ov_fr_data [get_bd_pins iv_fr_data] [get_bd_pins BRAM_WRITE_0/iv_fr_data]
  connect_bd_net -net Net1 [get_bd_pins clka] [get_bd_pins BRAM_WRITE_0/i_clk] [get_bd_pins blk_mem_pang/clka] [get_bd_pins blk_mem_ping/clka]
  connect_bd_net -net Net2 [get_bd_pins i_rst] [get_bd_pins BRAM_WRITE_0/i_rst]
  connect_bd_net -net TIMESTAMPGEN_0_ov_timestamp [get_bd_pins iv_time_stamp] [get_bd_pins BRAM_WRITE_0/iv_time_stamp]
  connect_bd_net -net blk_mem_pang_doutb [get_bd_pins BRAM_PINGPANG_CTRL_0/iv_rdata_pang] [get_bd_pins blk_mem_pang/doutb]
  connect_bd_net -net blk_mem_ping_doutb [get_bd_pins BRAM_PINGPANG_CTRL_0/iv_rdata_ping] [get_bd_pins blk_mem_ping/doutb]
  connect_bd_net -net clkb_1 [get_bd_pins clkb] [get_bd_pins blk_mem_pang/clkb] [get_bd_pins blk_mem_ping/clkb]
  connect_bd_net -net i_debug_1 [get_bd_pins i_debug] [get_bd_pins BRAM_WRITE_0/i_debug]
  connect_bd_net -net iv_azimuth_1 [get_bd_pins iv_azimuth] [get_bd_pins BRAM_WRITE_0/iv_azimuth]
  connect_bd_net -net iv_raddr_1 [get_bd_pins iv_raddr] [get_bd_pins BRAM_PINGPANG_CTRL_0/iv_raddr]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: lidar
proc create_hier_cell_lidar { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_lidar() - Empty argument(s)!"}
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
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I -type clk clkb
  create_bd_pin -dir I i_debug
  create_bd_pin -dir I i_pps
  create_bd_pin -dir I -type rst i_rst
  create_bd_pin -dir I -from 15 -to 0 iv_azimuth
  create_bd_pin -dir I -from 8 -to 0 iv_raddr
  create_bd_pin -dir O o_txn
  create_bd_pin -dir O -from 31 -to 0 ov_rdata
  create_bd_pin -dir I -type clk rd_clk
  create_bd_pin -dir I receive_signal

  # Create instance: DECODER_0, and set properties
  set DECODER_0 [ create_bd_cell -type ip -vlnv YiFeng:YiFengIpRepository:DECODER:1.2 DECODER_0 ]
  set_property -dict [ list \
CONFIG.BIT_CNT_WITH {7} \
CONFIG.CAMPLE_PERIOD {6} \
CONFIG.DIS_SHAKE_NUM {2} \
 ] $DECODER_0

  # Create instance: TIMESTAMPGEN_0, and set properties
  set TIMESTAMPGEN_0 [ create_bd_cell -type ip -vlnv YiFeng:YiFengIPRepository:TIMESTAMPGEN:3.0 TIMESTAMPGEN_0 ]
  set_property -dict [ list \
CONFIG.INPUT_CLK_MHZ {100} \
CONFIG.pps_in {true} \
 ] $TIMESTAMPGEN_0

  # Create instance: pack
  create_hier_cell_pack $hier_obj pack

  # Create port connections
  connect_bd_net -net BRAM_PINGPANG_CTRL_0_ov_rdata [get_bd_pins ov_rdata] [get_bd_pins pack/ov_rdata]
  connect_bd_net -net BRAM_WRITE_0_o_fr_en [get_bd_pins DECODER_0/i_fr_en] [get_bd_pins pack/o_fr_en]
  connect_bd_net -net BRAM_WRITE_0_o_txn [get_bd_pins o_txn] [get_bd_pins pack/o_txn]
  connect_bd_net -net DECODER_0_o_fr_empty [get_bd_pins DECODER_0/o_fr_empty] [get_bd_pins pack/i_fr_empty]
  connect_bd_net -net DECODER_0_ov_fr_data [get_bd_pins DECODER_0/ov_fr_data] [get_bd_pins pack/iv_fr_data]
  connect_bd_net -net Net1 [get_bd_pins rd_clk] [get_bd_pins DECODER_0/i_fr_clk] [get_bd_pins TIMESTAMPGEN_0/i_clk] [get_bd_pins pack/clka]
  connect_bd_net -net Net2 [get_bd_pins i_rst] [get_bd_pins DECODER_0/i_rst] [get_bd_pins TIMESTAMPGEN_0/i_rst] [get_bd_pins pack/i_rst]
  connect_bd_net -net TIMESTAMPGEN_0_ov_timestamp [get_bd_pins TIMESTAMPGEN_0/ov_timestamp] [get_bd_pins pack/iv_time_stamp]
  connect_bd_net -net clk_1 [get_bd_pins clk] [get_bd_pins DECODER_0/i_clk]
  connect_bd_net -net clkb_1 [get_bd_pins clkb] [get_bd_pins pack/clkb]
  connect_bd_net -net i_debug_1 [get_bd_pins i_debug] [get_bd_pins pack/i_debug]
  connect_bd_net -net i_pps_1 [get_bd_pins i_pps] [get_bd_pins TIMESTAMPGEN_0/i_pps]
  connect_bd_net -net iv_azimuth_1 [get_bd_pins iv_azimuth] [get_bd_pins pack/iv_azimuth]
  connect_bd_net -net iv_raddr_1 [get_bd_pins iv_raddr] [get_bd_pins pack/iv_raddr]
  connect_bd_net -net receive_signal_1 [get_bd_pins receive_signal] [get_bd_pins DECODER_0/i_sig]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: POWER
proc create_hier_cell_POWER { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_POWER() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:acc_fifo_read_rtl:1.0 INA219_FIFO_READ
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_ina219

  # Create pins
  create_bd_pin -dir I -type clk i_clk
  create_bd_pin -dir I -type clk i_fifo_rd_clk
  create_bd_pin -dir I i_ps_top_ctrl
  create_bd_pin -dir I -type rst i_rst
  create_bd_pin -dir O o_led5v_n
  create_bd_pin -dir O o_led_top_n
  create_bd_pin -dir O o_top_pwm_H
  create_bd_pin -dir O o_top_pwm_L

  # Create instance: CLOCK_DIVDE_0, and set properties
  set CLOCK_DIVDE_0 [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:CLOCK_DIVDE:2.0 CLOCK_DIVDE_0 ]
  set_property -dict [ list \
CONFIG.CLK_DIV_NUM {100} \
 ] $CLOCK_DIVDE_0

  # Create instance: INA219_DRIVE_0, and set properties
  set INA219_DRIVE_0 [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:INA219_DRIVE:5.1 INA219_DRIVE_0 ]

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
  
  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins iic_ina219] [get_bd_intf_pins INA219_DRIVE_0/iic_ina219]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins INA219_FIFO_READ] [get_bd_intf_pins INA219_DRIVE_0/INA219_FIFO_READ]

  # Create port connections
  connect_bd_net -net CLOCK_DIVDE_0_o_clk [get_bd_pins CLOCK_DIVDE_0/o_clk] [get_bd_pins INA219_DRIVE_0/i_clk]
  connect_bd_net -net CLOCK_DIVDE_0_o_rst [get_bd_pins CLOCK_DIVDE_0/o_rst] [get_bd_pins INA219_DRIVE_0/i_rst]
  connect_bd_net -net POWER_CTRL_0_o_led5v_n [get_bd_pins o_led5v_n] [get_bd_pins POWER_CTRL_0/o_led5v_n]
  connect_bd_net -net POWER_CTRL_0_o_led_top_n [get_bd_pins o_led_top_n] [get_bd_pins POWER_CTRL_0/o_led_top_n]
  connect_bd_net -net POWER_CTRL_0_o_top_pwm_H [get_bd_pins o_top_pwm_H] [get_bd_pins POWER_CTRL_0/o_top_pwm_H]
  connect_bd_net -net POWER_CTRL_0_o_top_pwm_L [get_bd_pins o_top_pwm_L] [get_bd_pins POWER_CTRL_0/o_top_pwm_L]
  connect_bd_net -net SPLIT_ov_dout0 [get_bd_pins i_ps_top_ctrl] [get_bd_pins POWER_CTRL_0/i_ps_top_ctrl]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins i_clk] [get_bd_pins CLOCK_DIVDE_0/i_clk] [get_bd_pins POWER_CTRL_0/i_clk]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins i_rst] [get_bd_pins CLOCK_DIVDE_0/i_rst] [get_bd_pins POWER_CTRL_0/i_rst]
  connect_bd_net -net i_fifo_rd_clk_1 [get_bd_pins i_fifo_rd_clk] [get_bd_pins INA219_DRIVE_0/i_fifo_rd_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: MOTOR
proc create_hier_cell_MOTOR { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_MOTOR() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv YiFeng:YFIPREPOSITORY:ENCODER_ABZ_rtl:1.0 ENCODER_ABZ
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:acc_fifo_read_rtl:1.0 M_FR_ACRK
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:acc_fifo_read_rtl:1.0 M_FR_ASRK
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:acc_fifo_read_rtl:1.0 M_FR_DZAG
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:acc_fifo_read_rtl:1.0 M_FR_PRD
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:acc_fifo_read_rtl:1.0 M_FR_SETSPD
  create_bd_intf_pin -mode Slave -vlnv YiFeng:YFIPREPOSITORY:PWM3_rtl:1.0 PWM3
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:acc_fifo_read_rtl:1.0 S_FR_AMGLE
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:acc_fifo_read_rtl:1.0 S_FR_POWER
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:acc_fifo_read_rtl:1.0 S_FR_SPD
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_24cxx
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_ina219

  # Create pins
  create_bd_pin -dir I -type clk i_clk
  create_bd_pin -dir I i_debug_en
  create_bd_pin -dir I i_motor_en
  create_bd_pin -dir I i_oplop_en
  create_bd_pin -dir I -type rst i_rst
  create_bd_pin -dir I -type clk i_speed_ch_ref_clk
  create_bd_pin -dir I i_wopt24c_en
  create_bd_pin -dir O o_direction_flag
  create_bd_pin -dir O o_wopt24c_done
  create_bd_pin -dir O -from 15 -to 0 ov_angle_ch1_dout

  # Create instance: CLOCK_DIVDE_0, and set properties
  set CLOCK_DIVDE_0 [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:CLOCK_DIVDE:2.0 CLOCK_DIVDE_0 ]
  set_property -dict [ list \
CONFIG.CLK_DIV_NUM {100} \
 ] $CLOCK_DIVDE_0

  # Create instance: INA219_DRIVE_0, and set properties
  set INA219_DRIVE_0 [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:INA219_DRIVE:5.1 INA219_DRIVE_0 ]

  # Create instance: M24CXX_0, and set properties
  set M24CXX_0 [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:M24CXX:1.40 M24CXX_0 ]
  set_property -dict [ list \
CONFIG.PAGE_WRITE_BYTES {17} \
 ] $M24CXX_0

  # Create instance: MOTOR_0, and set properties
  set MOTOR_0 [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:MOTOR:11.11 MOTOR_0 ]
  set_property -dict [ list \
CONFIG.ANGLE_OUT0 {true} \
CONFIG.ANGLE_OUT1 {true} \
CONFIG.MODE_OUT {true} \
CONFIG.SPEED_OUT {true} \
 ] $MOTOR_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins iic_24cxx] [get_bd_intf_pins M24CXX_0/iic_24cxx]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins iic_ina219] [get_bd_intf_pins INA219_DRIVE_0/iic_ina219]
  connect_bd_intf_net -intf_net MOTOR_0_ENCODER_ABZ [get_bd_intf_pins ENCODER_ABZ] [get_bd_intf_pins MOTOR_0/ENCODER_ABZ]
  connect_bd_intf_net -intf_net MOTOR_0_M_FR_ACRK [get_bd_intf_pins M_FR_ACRK] [get_bd_intf_pins MOTOR_0/M_FR_ACRK]
  connect_bd_intf_net -intf_net MOTOR_0_M_FR_ASRK [get_bd_intf_pins M_FR_ASRK] [get_bd_intf_pins MOTOR_0/M_FR_ASRK]
  connect_bd_intf_net -intf_net MOTOR_0_M_FR_DZAG [get_bd_intf_pins M_FR_DZAG] [get_bd_intf_pins MOTOR_0/M_FR_DZAG]
  connect_bd_intf_net -intf_net MOTOR_0_M_FR_INA219 [get_bd_intf_pins INA219_DRIVE_0/INA219_FIFO_READ] [get_bd_intf_pins MOTOR_0/M_FR_INA219]
  connect_bd_intf_net -intf_net MOTOR_0_M_FR_M24C [get_bd_intf_pins M24CXX_0/ROPT_FIFO_RD] [get_bd_intf_pins MOTOR_0/M_FR_M24C]
  connect_bd_intf_net -intf_net MOTOR_0_M_FR_PRD [get_bd_intf_pins M_FR_PRD] [get_bd_intf_pins MOTOR_0/M_FR_PRD]
  connect_bd_intf_net -intf_net MOTOR_0_M_FR_SETSPD [get_bd_intf_pins M_FR_SETSPD] [get_bd_intf_pins MOTOR_0/M_FR_SETSPD]
  connect_bd_intf_net -intf_net MOTOR_0_M_FW_M24C [get_bd_intf_pins M24CXX_0/WOPT_FIFO_WR] [get_bd_intf_pins MOTOR_0/M_FW_M24C]
  connect_bd_intf_net -intf_net PWM3_1 [get_bd_intf_pins PWM3] [get_bd_intf_pins MOTOR_0/PWM3]
  connect_bd_intf_net -intf_net S_FR_AMGLE_1 [get_bd_intf_pins S_FR_AMGLE] [get_bd_intf_pins MOTOR_0/S_FR_AMGLE]
  connect_bd_intf_net -intf_net S_FR_POWER_1 [get_bd_intf_pins S_FR_POWER] [get_bd_intf_pins MOTOR_0/S_FR_POWER]
  connect_bd_intf_net -intf_net S_FR_SPD_1 [get_bd_intf_pins S_FR_SPD] [get_bd_intf_pins MOTOR_0/S_FR_SPD]

  # Create port connections
  connect_bd_net -net CLOCK_DIVDE_0_o_clk [get_bd_pins CLOCK_DIVDE_0/o_clk] [get_bd_pins INA219_DRIVE_0/i_clk] [get_bd_pins M24CXX_0/i_clk]
  connect_bd_net -net CLOCK_DIVDE_0_o_rst [get_bd_pins CLOCK_DIVDE_0/o_rst] [get_bd_pins INA219_DRIVE_0/i_rst] [get_bd_pins M24CXX_0/i_rst]
  connect_bd_net -net M24CXX_0_o_opt_busy [get_bd_pins M24CXX_0/o_opt_busy] [get_bd_pins MOTOR_0/i_opt24c_busy]
  connect_bd_net -net MOTOR_0_o_direction_flag [get_bd_pins o_direction_flag] [get_bd_pins MOTOR_0/o_direction_flag]
  connect_bd_net -net MOTOR_0_o_wopt24c_done [get_bd_pins o_wopt24c_done] [get_bd_pins MOTOR_0/o_wopt24c_done]
  connect_bd_net -net MOTOR_0_ov_angle_ch1_dout [get_bd_pins ov_angle_ch1_dout] [get_bd_pins MOTOR_0/ov_angle_ch1_dout]
  connect_bd_net -net Net [get_bd_pins i_clk] [get_bd_pins CLOCK_DIVDE_0/i_clk] [get_bd_pins INA219_DRIVE_0/i_fifo_rd_clk] [get_bd_pins M24CXX_0/i_rfifo_clk] [get_bd_pins M24CXX_0/i_wfifo_clk] [get_bd_pins MOTOR_0/i_angle_ch1_ref_clk] [get_bd_pins MOTOR_0/i_clk]
  connect_bd_net -net i_debug_en_1 [get_bd_pins i_debug_en] [get_bd_pins MOTOR_0/i_debug_en]
  connect_bd_net -net i_motor_en_1 [get_bd_pins i_motor_en] [get_bd_pins MOTOR_0/i_motor_en]
  connect_bd_net -net i_oplop_en_1 [get_bd_pins i_oplop_en] [get_bd_pins MOTOR_0/i_oplop_en]
  connect_bd_net -net i_rst_1 [get_bd_pins i_rst] [get_bd_pins CLOCK_DIVDE_0/i_rst] [get_bd_pins MOTOR_0/i_rst]
  connect_bd_net -net i_speed_ch_ref_clk_1 [get_bd_pins i_speed_ch_ref_clk] [get_bd_pins MOTOR_0/i_angle_ch0_ref_clk] [get_bd_pins MOTOR_0/i_power_ch_ref_clk] [get_bd_pins MOTOR_0/i_speed_ch_ref_clk]
  connect_bd_net -net i_wopt24c_en_1 [get_bd_pins i_wopt24c_en] [get_bd_pins MOTOR_0/i_wopt24c_en]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins MOTOR_0/i_angle_ch1_rd_en] [get_bd_pins xlconstant_0/dout]

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
  set AD7928_CFG [ create_bd_intf_port -mode Master -vlnv YiFeng:YiFeng_IP_Perository:AD7928_CFG_rtl:1.0 AD7928_CFG ]
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set ENCODER_ABZ [ create_bd_intf_port -mode Master -vlnv YiFeng:YFIPREPOSITORY:ENCODER_ABZ_rtl:1.0 ENCODER_ABZ ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set PWM3 [ create_bd_intf_port -mode Slave -vlnv YiFeng:YFIPREPOSITORY:PWM3_rtl:1.0 PWM3 ]
  set iic_24cxx [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_24cxx ]
  set iic_motor_power [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_motor_power ]
  set iic_power [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_power ]

  # Create ports
  set clk_in1 [ create_bd_port -dir I -type clk clk_in1 ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {25000000} \
CONFIG.PHASE {0.000} \
 ] $clk_in1
  set i_gps_spi [ create_bd_port -dir I i_gps_spi ]
  set i_pps [ create_bd_port -dir I i_pps ]
  set o_led5v_n [ create_bd_port -dir O o_led5v_n ]
  set o_led_top_n [ create_bd_port -dir O o_led_top_n ]
  set o_top_pwm_H [ create_bd_port -dir O o_top_pwm_H ]
  set o_top_pwm_L [ create_bd_port -dir O o_top_pwm_L ]
  set receive_signal [ create_bd_port -dir I receive_signal ]

  # Create instance: CLOCK_DIVDE_0, and set properties
  set CLOCK_DIVDE_0 [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:CLOCK_DIVDE:2.0 CLOCK_DIVDE_0 ]
  set_property -dict [ list \
CONFIG.CLK_DIV_NUM {64} \
 ] $CLOCK_DIVDE_0

  # Create instance: GPS, and set properties
  set GPS [ create_bd_cell -type ip -vlnv xilinx.com:user:GPS:3.3 GPS ]

  # Create instance: MONITOR_0, and set properties
  set MONITOR_0 [ create_bd_cell -type ip -vlnv YiFeng:YiFeng_IP_Repository:MONITOR:2.8 MONITOR_0 ]
  set_property -dict [ list \
CONFIG.CH0_OUT {true} \
CONFIG.CH1_OUT {false} \
CONFIG.CH4_OUT {true} \
CONFIG.CH6_OUT {false} \
CONFIG.CH7_OUT {true} \
CONFIG.INPUT_CLK_MHZ {100} \
 ] $MONITOR_0

  # Create instance: MOTOR
  create_hier_cell_MOTOR [current_bd_instance .] MOTOR

  # Create instance: POWER
  create_hier_cell_POWER [current_bd_instance .] POWER

  # Create instance: SPLIT, and set properties
  set SPLIT [ create_bd_cell -type ip -vlnv yifeng:YifengIpRepository:YF_SPLIT:2.0 SPLIT ]
  set_property -dict [ list \
CONFIG.DIN_WIDTH {6} \
CONFIG.NUM_PORTS {6} \
 ] $SPLIT

  # Create instance: YF_AXILITE_GPS, and set properties
  set YF_AXILITE_GPS [ create_bd_cell -type ip -vlnv YiFeng:YiFengIpRepository:YF_AXILITE_SDRAM_RBUS:1.5 YF_AXILITE_GPS ]
  set_property -dict [ list \
CONFIG.C_S_AXI_ADDR_WIDTH {8} \
CONFIG.SDRAM_DEPTH {64} \
 ] $YF_AXILITE_GPS

  # Create instance: YF_AXILITE_LIDAR, and set properties
  set YF_AXILITE_LIDAR [ create_bd_cell -type ip -vlnv YiFeng:YiFengIpRepository:YF_AXILITE_SDRAM_RBUS:1.5 YF_AXILITE_LIDAR ]
  set_property -dict [ list \
CONFIG.C_S_AXI_ADDR_WIDTH {11} \
CONFIG.SDRAM_DEPTH {512} \
 ] $YF_AXILITE_LIDAR

  # Create instance: YF_AXI_LITE_MONITOR, and set properties
  set YF_AXI_LITE_MONITOR [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:YF_AXI_LITE_PERIPHERAL:2.0 YF_AXI_LITE_MONITOR ]
  set_property -dict [ list \
CONFIG.reg32_in_num {4} \
CONFIG.reg32_out_num {0} \
 ] $YF_AXI_LITE_MONITOR

  # Create instance: YF_AXI_LITE_MOTOR, and set properties
  set YF_AXI_LITE_MOTOR [ create_bd_cell -type ip -vlnv YiFeng:YifengIpRepository:YF_AXI_LITE_PERIPHERAL:2.0 YF_AXI_LITE_MOTOR ]
  set_property -dict [ list \
CONFIG.reg32_in_num {3} \
CONFIG.reg32_out_num {5} \
 ] $YF_AXI_LITE_MOTOR

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
CONFIG.C_ALL_INPUTS {0} \
CONFIG.C_ALL_INPUTS_2 {1} \
CONFIG.C_ALL_OUTPUTS {1} \
CONFIG.C_GPIO2_WIDTH {3} \
CONFIG.C_GPIO_WIDTH {6} \
CONFIG.C_INTERRUPT_PRESENT {0} \
CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.4 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {400.0} \
CONFIG.CLKOUT1_DRIVES {BUFG} \
CONFIG.CLKOUT1_JITTER {200.536} \
CONFIG.CLKOUT1_PHASE_ERROR {237.727} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {250} \
CONFIG.CLKOUT1_USED {true} \
CONFIG.CLKOUT2_DRIVES {BUFG} \
CONFIG.CLKOUT2_JITTER {226.965} \
CONFIG.CLKOUT2_PHASE_ERROR {237.727} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100} \
CONFIG.CLKOUT2_USED {true} \
CONFIG.CLKOUT3_DRIVES {BUFG} \
CONFIG.CLKOUT3_JITTER {432.034} \
CONFIG.CLKOUT3_PHASE_ERROR {237.727} \
CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {9.83} \
CONFIG.CLKOUT3_USED {true} \
CONFIG.CLKOUT4_DRIVES {BUFG} \
CONFIG.CLKOUT4_JITTER {319.115} \
CONFIG.CLKOUT4_PHASE_ERROR {222.305} \
CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {9.83} \
CONFIG.CLKOUT4_USED {false} \
CONFIG.CLKOUT5_DRIVES {BUFG} \
CONFIG.CLKOUT5_JITTER {220.126} \
CONFIG.CLKOUT5_PHASE_ERROR {237.727} \
CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {125} \
CONFIG.CLKOUT5_USED {false} \
CONFIG.CLKOUT6_DRIVES {BUFG} \
CONFIG.CLKOUT7_DRIVES {BUFG} \
CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
CONFIG.MMCM_CLKFBOUT_MULT_F {40} \
CONFIG.MMCM_CLKIN1_PERIOD {40.000} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {4} \
CONFIG.MMCM_CLKOUT1_DIVIDE {10} \
CONFIG.MMCM_CLKOUT2_DIVIDE {102} \
CONFIG.MMCM_CLKOUT3_DIVIDE {1} \
CONFIG.MMCM_CLKOUT4_DIVIDE {1} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.NUM_OUT_CLKS {3} \
CONFIG.PRIMITIVE {PLL} \
CONFIG.PRIM_IN_FREQ {25} \
CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: lidar
  create_hier_cell_lidar [current_bd_instance .] lidar

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666666} \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
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
CONFIG.PCW_MIO_52_SLEW {fast} \
CONFIG.PCW_MIO_53_SLEW {fast} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_UART0_UART0_IO {<Select>} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART1_UART1_IO {MIO 36 .. 37} \
CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit} \
CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333333} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K128M16 JT-125} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
 ] $processing_system7_0

  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {5} \
 ] $ps7_0_axi_periph

  # Create instance: rst_ps7_0_100M, and set properties
  set rst_ps7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_100M ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {3} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net MONITOR_0_AD7928_CFG [get_bd_intf_ports AD7928_CFG] [get_bd_intf_pins MONITOR_0/AD7928_CFG]
  connect_bd_intf_net -intf_net MOTOR_ENCODER_ABZ [get_bd_intf_ports ENCODER_ABZ] [get_bd_intf_pins MOTOR/ENCODER_ABZ]
  connect_bd_intf_net -intf_net MOTOR_M_FR_ACRK [get_bd_intf_pins MOTOR/M_FR_ACRK] [get_bd_intf_pins YF_AXI_LITE_MOTOR/d2pl_ch3]
  connect_bd_intf_net -intf_net MOTOR_M_FR_ASRK [get_bd_intf_pins MOTOR/M_FR_ASRK] [get_bd_intf_pins YF_AXI_LITE_MOTOR/d2pl_ch2]
  connect_bd_intf_net -intf_net MOTOR_M_FR_DZAG [get_bd_intf_pins MOTOR/M_FR_DZAG] [get_bd_intf_pins YF_AXI_LITE_MOTOR/d2pl_ch4]
  connect_bd_intf_net -intf_net MOTOR_M_FR_PRD [get_bd_intf_pins MOTOR/M_FR_PRD] [get_bd_intf_pins YF_AXI_LITE_MOTOR/d2pl_ch1]
  connect_bd_intf_net -intf_net MOTOR_M_FR_SETSPD [get_bd_intf_pins MOTOR/M_FR_SETSPD] [get_bd_intf_pins YF_AXI_LITE_MOTOR/d2pl_ch0]
  connect_bd_intf_net -intf_net MOTOR_iic_24cxx [get_bd_intf_ports iic_24cxx] [get_bd_intf_pins MOTOR/iic_24cxx]
  connect_bd_intf_net -intf_net MOTOR_iic_ina219 [get_bd_intf_ports iic_motor_power] [get_bd_intf_pins MOTOR/iic_ina219]
  connect_bd_intf_net -intf_net POWER_iic_ina219 [get_bd_intf_ports iic_power] [get_bd_intf_pins POWER/iic_ina219]
  connect_bd_intf_net -intf_net PWM3_1 [get_bd_intf_ports PWM3] [get_bd_intf_pins MOTOR/PWM3]
  connect_bd_intf_net -intf_net YF_AXI_LITE_MONITOR_d2ps_ch0 [get_bd_intf_pins POWER/INA219_FIFO_READ] [get_bd_intf_pins YF_AXI_LITE_MONITOR/d2ps_ch0]
  connect_bd_intf_net -intf_net YF_AXI_LITE_MONITOR_d2ps_ch1 [get_bd_intf_pins MONITOR_0/ch0_dout] [get_bd_intf_pins YF_AXI_LITE_MONITOR/d2ps_ch1]
  connect_bd_intf_net -intf_net YF_AXI_LITE_MONITOR_d2ps_ch2 [get_bd_intf_pins MONITOR_0/ch4_dout] [get_bd_intf_pins YF_AXI_LITE_MONITOR/d2ps_ch2]
  connect_bd_intf_net -intf_net YF_AXI_LITE_MONITOR_d2ps_ch3 [get_bd_intf_pins MONITOR_0/ch7_dout] [get_bd_intf_pins YF_AXI_LITE_MONITOR/d2ps_ch3]
  connect_bd_intf_net -intf_net YF_AXI_LITE_PERIPHERAL_0_d2ps_ch0 [get_bd_intf_pins MOTOR/S_FR_SPD] [get_bd_intf_pins YF_AXI_LITE_MOTOR/d2ps_ch0]
  connect_bd_intf_net -intf_net YF_AXI_LITE_PERIPHERAL_0_d2ps_ch1 [get_bd_intf_pins MOTOR/S_FR_AMGLE] [get_bd_intf_pins YF_AXI_LITE_MOTOR/d2ps_ch1]
  connect_bd_intf_net -intf_net YF_AXI_LITE_PERIPHERAL_0_d2ps_ch2 [get_bd_intf_pins MOTOR/S_FR_POWER] [get_bd_intf_pins YF_AXI_LITE_MOTOR/d2ps_ch2]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins YF_AXILITE_GPS/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins YF_AXILITE_LIDAR/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins YF_AXI_LITE_MOTOR/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M04_AXI [get_bd_intf_pins YF_AXI_LITE_MONITOR/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M04_AXI]

  # Create port connections
  connect_bd_net -net CLOCK_DIVDE_0_o_clk [get_bd_pins CLOCK_DIVDE_0/o_clk] [get_bd_pins GPS/i_clk]
  connect_bd_net -net CLOCK_DIVDE_0_o_rst [get_bd_pins CLOCK_DIVDE_0/o_rst] [get_bd_pins GPS/i_rst]
  connect_bd_net -net GPS_1_o_vaild [get_bd_pins GPS/o_vaild] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net GPS_1_ov_bram_doutb [get_bd_pins GPS/ov_bram_doutb] [get_bd_pins YF_AXILITE_GPS/iv_sdram_rdata]
  connect_bd_net -net MOTOR_o_direction_flag [get_bd_pins MOTOR/o_direction_flag] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net MOTOR_o_wopt24c_done [get_bd_pins MOTOR/o_wopt24c_done] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net MOTOR_ov_angle_ch1_dout [get_bd_pins MOTOR/ov_angle_ch1_dout] [get_bd_pins lidar/iv_azimuth]
  connect_bd_net -net POWER_CTRL_0_o_led5v_n [get_bd_ports o_led5v_n] [get_bd_pins POWER/o_led5v_n]
  connect_bd_net -net POWER_CTRL_0_o_led_top_n [get_bd_ports o_led_top_n] [get_bd_pins POWER/o_led_top_n]
  connect_bd_net -net POWER_CTRL_0_o_top_pwm_H [get_bd_ports o_top_pwm_H] [get_bd_pins POWER/o_top_pwm_H]
  connect_bd_net -net POWER_CTRL_0_o_top_pwm_L [get_bd_ports o_top_pwm_L] [get_bd_pins POWER/o_top_pwm_L]
  connect_bd_net -net SPLIT_ov_dout0 [get_bd_pins POWER/i_ps_top_ctrl] [get_bd_pins SPLIT/ov_dout0]
  connect_bd_net -net SPLIT_ov_dout1 [get_bd_pins MOTOR/i_motor_en] [get_bd_pins SPLIT/ov_dout1]
  connect_bd_net -net SPLIT_ov_dout3 [get_bd_pins MOTOR/i_oplop_en] [get_bd_pins SPLIT/ov_dout3]
  connect_bd_net -net SPLIT_ov_dout4 [get_bd_pins MOTOR/i_wopt24c_en] [get_bd_pins SPLIT/ov_dout4]
  connect_bd_net -net SPLIT_ov_dout5 [get_bd_pins MOTOR/i_debug_en] [get_bd_pins SPLIT/ov_dout5] [get_bd_pins lidar/i_debug]
  connect_bd_net -net YF_AXILITE_SDRAM_RBUS_1_ov_sdram_addr [get_bd_pins GPS/iv_bram_addrb] [get_bd_pins YF_AXILITE_GPS/ov_sdram_addr]
  connect_bd_net -net YF_AXILITE_SDRAM_RBUS_2_ov_sdram_addr [get_bd_pins YF_AXILITE_LIDAR/ov_sdram_addr] [get_bd_pins lidar/iv_raddr]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins SPLIT/iv_din] [get_bd_pins axi_gpio_0/gpio_io_o]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins lidar/clk]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins MONITOR_0/i_clk] [get_bd_pins MOTOR/i_clk] [get_bd_pins POWER/i_clk] [get_bd_pins YF_AXI_LITE_MOTOR/i_d2pl_ch0_ref_clk] [get_bd_pins YF_AXI_LITE_MOTOR/i_d2pl_ch1_ref_clk] [get_bd_pins YF_AXI_LITE_MOTOR/i_d2pl_ch2_ref_clk] [get_bd_pins YF_AXI_LITE_MOTOR/i_d2pl_ch3_ref_clk] [get_bd_pins YF_AXI_LITE_MOTOR/i_d2pl_ch4_ref_clk] [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins lidar/rd_clk]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins CLOCK_DIVDE_0/i_clk] [get_bd_pins clk_wiz_0/clk_out3]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins CLOCK_DIVDE_0/i_rst] [get_bd_pins MONITOR_0/i_rst] [get_bd_pins MOTOR/i_rst] [get_bd_pins POWER/i_rst] [get_bd_pins clk_wiz_0/locked] [get_bd_pins lidar/i_rst]
  connect_bd_net -net clock_rtl_1 [get_bd_ports clk_in1] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net i_gps_spi_1 [get_bd_ports i_gps_spi] [get_bd_pins GPS/i_gps_spi]
  connect_bd_net -net i_pps_1 [get_bd_ports i_pps] [get_bd_pins lidar/i_pps]
  connect_bd_net -net lidar_o_txn [get_bd_pins lidar/o_txn] [get_bd_pins processing_system7_0/IRQ_F2P]
  connect_bd_net -net lidar_ov_rdata [get_bd_pins YF_AXILITE_LIDAR/iv_sdram_rdata] [get_bd_pins lidar/ov_rdata]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins GPS/i_bram_rd_clkb] [get_bd_pins MONITOR_0/i_ch0_rd_clk] [get_bd_pins MONITOR_0/i_ch4_rd_clk] [get_bd_pins MONITOR_0/i_ch7_rd_clk] [get_bd_pins MOTOR/i_speed_ch_ref_clk] [get_bd_pins POWER/i_fifo_rd_clk] [get_bd_pins YF_AXILITE_GPS/S_AXI_ACLK] [get_bd_pins YF_AXILITE_LIDAR/S_AXI_ACLK] [get_bd_pins YF_AXI_LITE_MONITOR/s00_axi_aclk] [get_bd_pins YF_AXI_LITE_MOTOR/s00_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins lidar/clkb] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/M04_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins rst_ps7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_100M/ext_reset_in]
  connect_bd_net -net receive_signal_1 [get_bd_ports receive_signal] [get_bd_pins lidar/receive_signal]
  connect_bd_net -net rst_ps7_0_100M_interconnect_aresetn [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins rst_ps7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins YF_AXILITE_GPS/S_AXI_ARESETN] [get_bd_pins YF_AXILITE_LIDAR/S_AXI_ARESETN] [get_bd_pins YF_AXI_LITE_MONITOR/s00_axi_aresetn] [get_bd_pins YF_AXI_LITE_MOTOR/s00_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/M04_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_ps7_0_100M/peripheral_aresetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins axi_gpio_0/gpio2_io_i] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs YF_AXILITE_GPS/S_AXI/reg0] SEG_YF_AXILITE_SDRAM_RBUS_1_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs YF_AXILITE_LIDAR/S_AXI/reg0] SEG_YF_AXILITE_SDRAM_RBUS_2_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x43C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs YF_AXI_LITE_MONITOR/S00_AXI/S00_AXI_reg] SEG_YF_AXI_LITE_MONITOR_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs YF_AXI_LITE_MOTOR/S00_AXI/S00_AXI_reg] SEG_YF_AXI_LITE_PERIPHERAL_0_S00_AXI_reg
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


