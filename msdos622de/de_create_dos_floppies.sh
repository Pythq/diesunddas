#!/bin/bash
set -eu

EMPTY_FLOPPY=empty.vfd
DISK1=de_msdos_622_01.vfd
DISK2=de_msdos_622_02.vfd
DISK3=de_msdos_622_03.vfd

BOOT_FILES=(
	IO.SYS
	MSDOS.SYS
	COMMAND.COM
	DRVSPACE.BIN
)
DISK2_FILES=(
	ANSI.SY_
	APPEND.EX_
	CHKSTATE.SY_
	CHOICE.COM
	DBLWIN.HL_
	DELTREE.EX_
	DISKCOMP.CO_
	DISKCOPY.CO_
	DISPLAY.SY_
	DOSHELP.HL_
	DOSKEY.CO_
	DRIVER.SY_
	DRVSPACE.EXE
	DRVSPACE.HL_
	DRVSPACE.IN_
	DRVSPACE.SY_
	DRVSPACE.TX_
	EDIT.HL_
	FASTHELP.EX_
	FASTOPEN.EX_
	FC.EX_
	FIND.EX_
	GRAPHICS.CO_
	GRAPHICS.PR_
	HELP.COM
	HELP.HL_
	HIMEM.SY_
	INTERLNK.EX_
	INTERSVR.EX_
	LABEL.EX_
	LOADFIX.CO_
	MEMMAKER.EXE
	MEMMAKER.HL_
	MEMMAKER.IN_
	MODE.CO_
	MONOUMB.38_
	MORE.COM
	MOVE.EX_
	MSBACKUP.EX_
	MSBCONFG.HL_
	MSBCONFG.OVL
	MSTOOLS.DL_
	MWBACKR.DL_
	MWBACKUP.EX_
	POWER.EX_
	PRINT.EX_
	QBASIC.HL_
	RAMDRIVE.SY_
	SETVER.EX_
	SHARE.EX_
	SIZER.EX_
	SMARTDRV.EX_
	SMARTMON.EX_
	SMARTMON.HL_
	SORT.EX_
	SUBST.EX_
	TREE.CO_
	UNFORMAT.COM
	VFINTD.38_
	WINA20.38_
)
DISK3_FILES=(
	MSAV.EXE
	MSAV.HL_
	MSAVHELP.OV_
	MSAVIRUS.LS_
	MSBACKDB.OVL
	MSBACKDR.OVL
	MSBACKFB.OVL
	MSBACKFR.OVL
	MSBACKUP.HL_
	MSBACKUP.OVL
	MWAV.EX_
	MWAV.HL_
	MWAVABSI.DL_
	MWAVDLG.DL_
	MWAVDOSL.DL_
	MWAVDRVL.DL_
	MWAVMGR.DL_
	MWAVSCAN.DL_
	MWAVSOS.DL_
	MWAVTSR.EX_
	MWBACKF.DL_
	MWBACKUP.HL_
	MWGRAFIC.DL_
	MWUNDEL.EX_
	MWUNDEL.HL_
	UNDELETE.EXE
	VSAFE.CO_
)

copy() {
	TZ=UTC mcopy -msvi "$1" "$2" ::/"${3:-$2}"
}

remove_create_time() {
	for ((o=$(( 0x260D )); o<=$(( $2 )); o+=$(( 0x20 )))); do
		dd conv=notrunc bs=1 count=7 of="$1" seek=$o if=/dev/zero status=none
	done
}

add_volume_label() {
	echo -ne 'DISKETTE  '$2'\x08' | dd conv=notrunc bs=1 of="$1" seek=$(( $3 )) status=none
	# Set date to the same as the rest of the files
	echo -ne '\xC0\x12\xBF\x1C' | dd conv=notrunc bs=1 of="$1" seek=$(( $3 + 0x16 )) status=none
}

title() {
	echo '----------------------------------'
	echo 'Creating MS-DOS 6.22 DE DISKETTE '$1
	echo '----------------------------------'
}

disk1() {
	title 1
	cp "$EMPTY_FLOPPY" "$DISK1"
	chmod +w "$DISK1"
	for file in "${BOOT_FILES[@]}"; do
		copy "$DISK1" "$file"
	done
	# Set IO.SYS and MSDOS.SYS read-only
	echo -ne '\x21' \
		| dd conv=notrunc bs=1 count=1 of="$DISK1" \
		  seek=$(( 0x260B )) status=none
	echo -ne '\x21' \
		| dd conv=notrunc bs=1 count=1 of="$DISK1" \
		  seek=$(( 0x262B )) status=none
	copy "$DISK1" ATTRIB.EXE
	copy "$DISK1" AUTOEXEC.OEM AUTOEXEC.BAT
	copy "$DISK1" CHKDSK.EXE
	copy "$DISK1" CONFIG.OEM CONFIG.SYS
	copy "$DISK1" COUNTRY.SYS
	copy "$DISK1" DEBUG.EXE
	copy "$DISK1" DEFRAG.EXE
	copy "$DISK1" DEFRAG.HL_
	copy "$DISK1" SETUP144.OEM DOSSETUP.INI
	copy "$DISK1" EDIT.COM
	copy "$DISK1" EGA.CP_
	copy "$DISK1" EGA2.CP_
	copy "$DISK1" EGA3.CP_
	copy "$DISK1" EMM386.EX_
	copy "$DISK1" EXPAND.EXE
	copy "$DISK1" FDISK.EXE
	copy "$DISK1" FORMAT.COM
	copy "$DISK1" INFO.TXT
	copy "$DISK1" COUNTRY.TX_ INFO2.TX_
	copy "$DISK1" ISO.CP_
	copy "$DISK1" KEYB.COM
	copy "$DISK1" KEYBOARD.SYS
	copy "$DISK1" KEYBRD2.SY_
	copy "$DISK1" MEM.EX_
	copy "$DISK1" MSCDEX.EXE
	copy "$DISK1" MSD.EXE
	copy "$DISK1" NETZWERK.TXT
	copy "$DISK1" NLSFUNC.EXE
	copy "$DISK1" PACKING.14O PACKING.LST
	copy "$DISK1" QBASIC.EXE
	copy "$DISK1" REPLACE.EX_
	copy "$DISK1" RESTORE.EX_
	copy "$DISK1" SCANDISK.EXE
	copy "$DISK1" SCANDISK.INI
	copy "$DISK1" SETUP.OEM SETUP.EXE
	copy "$DISK1" SETUP.MSG
	copy "$DISK1" SYS.COM
	copy "$DISK1" XCOPY.EX_
	remove_create_time "$DISK1" 0x2B2D
	add_volume_label "$DISK1" 1 0x2B40
}

disk2() {
	title 2
	cp "$EMPTY_FLOPPY" "$DISK2"
	chmod +w "$DISK2"
	for file in "${DISK2_FILES[@]}"; do
		copy "$DISK2" "$file"
	done
	remove_create_time "$DISK2" 0x2D6D
	add_volume_label "$DISK2" 2 0x2D80
}

disk3() {
	title 3
	cp "$EMPTY_FLOPPY" "$DISK3"
	chmod +w "$DISK3"
	for file in "${DISK3_FILES[@]}"; do
		copy "$DISK3" "$file"
	done
	copy "$DISK3" BKUDAV.GR_ WNTOOLS.GR_
	remove_create_time "$DISK3" 0x296D
	add_volume_label "$DISK3" 3 0x2980
}

disk1
disk2
disk3
