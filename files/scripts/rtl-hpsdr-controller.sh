#!/bin/sh

#for rtl_hpsdr reception in cudaSDR
rtl_hpsdr -g 400 &
sleep 2
cudaSDR
killall rtl_hpsdr
