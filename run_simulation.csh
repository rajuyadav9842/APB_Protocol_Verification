#!/bin/csh

source /home/install/cshrc

xrun \
-clean \
-input probe.tcl \
-uvm \
./Apb.sv testbench.sv \
-access \
+rwc
exit
