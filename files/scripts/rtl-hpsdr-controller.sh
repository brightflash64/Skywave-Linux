#!/bin/sh

#for rtl_hpsdr reception in cudaSDR
rtl_hpsdr -g 160 &
sleep 2
cudaSDR
killall rtl_hpsdr
