#!/bin/bash
set -e

tmpfile=xsecurelock_saver_pixelate_screenshot

create() {
	local -r factor=$1

	vips shrink "/tmp/${tmpfile}.jpg" "/tmp/${tmpfile}-$factor.v" $factor $factor
	vips zoom "/tmp/${tmpfile}-$factor.v" "/tmp/${tmpfile}-$factor.jpg" $factor $factor
	rm -f "/tmp/${tmpfile}-$factor.v"
}

if [ ! -f "/tmp/${tmpfile}.jpg" ]; then
	scrot "/tmp/${tmpfile}.jpg" -q 100

	values=(1 2 4 11 18 23 26 28 29 30)
	for factor in "${values[@]}"; do
		create $factor &
	done

	wait
fi

XSECURELOCK_SHOW_DATETIME=1 \
	XSECURELOCK_SHOW_HOSTNAME=0 \
	XSECURELOCK_SHOW_USERNAME=1 \
	XSECURELOCK_SAVER=saver_pixelate \
	exec xsecurelock
