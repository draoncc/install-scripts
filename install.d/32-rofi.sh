#!/bin/bash
set -e
SCRIPT_PATH="$(dirname "$(readlink -f "$BASH_SOURCE")")"
SCRIPT_NAME="$(basename "$BASH_SOURCE")"

if dpkg -s rofi &>/dev/null; then
	log_info "rofi is already installed"
else
	sudo apt -y install rofi

	cd $(mktemp -d)
	git clone https://github.com/davatorium/rofi-themes && cd rofi-themes

	xdg=${XDG_DATA_HOME:-${HOME}/.local/share}
	DIRECTORY="${xdg}/rofi/themes/"

	if [ ! -d "${DIRECTORY}" ]; then
		echo "Creating theme directory: ${DIRECTORY}"
		mkdir -p "${DIRECTORY}"
	fi

	for themefile in **/*.rasi; do
		if [ -f "${themefile}" ] && [ ${ia} -eq 0 ]; then
			echo "+Overwriting '${themefile}'"
		else
			echo "+Installing '${themefile}'"
		fi

		install "${themefile}" "${DIRECTORY}"
	done
fi

if [ -f /usr/lib/x86_64-linux-gnu/rofi/calc.so ]; then
	log_info "rofi-calc is already installed"
else
	sudo apt -y install rofi-dev qalc libqalculate-dev

	cd $(mktemp -d)
	git clone https://github.com/svenstaro/rofi-calc && cd rofi-calc
	autoreconf -i
	mkdir build && cd build
	../configure
	make && sudo make install

	tee $HOME/.local/bin/run-rofi-calc.sh <<EOF >/dev/null
#!/bin/bash
set -e

exec rofi -show calc -modi calc -no-show-match -no-sort \
  -calc-command "echo '{result}' | head -c -1 | xsel -i -b"
EOF
	chmod 755 $HOME/.local/bin/run-rofi-calc.sh
fi

if assert_is_installed rofi-screenshot; then
	log_info "rofi-screenshot is already installed"
else
	sudo apt -y install ffmpeg xclip slop

	cd $(mktemp -d)
	git clone --recursive https://github.com/lolilolicon/FFcast && cd FFcast
	./bootstrap
	./configure --enable-xrectsel
	make && sudo make install

	curl -L https://git.io/rofi-screenshot >$HOME/.local/bin/rofi-screenshot
	chmod 755 $HOME/.local/bin/rofi-screenshot
fi

if assert_is_installed rofimoji; then
	log_info "rofimoji is already installed"
else
	sudo apt -y install xdotool pipx
	pipx install rofimoji
fi
