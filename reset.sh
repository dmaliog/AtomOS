#!/bin/sh
rm -rf "work" "out"
rm airootfs/root/packages/*.pkg.tar.zst
rm airootfs/root/packages/*.pkg.tar.zst.sig
rm -rf airootfs/root/atomicos-skel-liveuser/pkg
rm airootfs/root/atomicos-skel-liveuser/*.pkg.tar.zst
rm aiso*.log
