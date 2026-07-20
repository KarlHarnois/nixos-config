.PHONY: build-vm vm wipe-vm fresh-vm

build-vm:
	nix build .#vm

vm: build-vm
	@MONITOR=$$(hyprctl monitors -j 2>/dev/null | jq -c '[.[] | select(.focused)][0] // empty' 2>/dev/null); \
	XRES=$$(echo "$$MONITOR" | jq -r '.width' 2>/dev/null); \
	YRES=$$(echo "$$MONITOR" | jq -r '.height' 2>/dev/null); \
	SCALE=$$(echo "$$MONITOR" | jq -r '.scale' 2>/dev/null); \
	HZ=$$(echo "$$MONITOR" | jq -r '.refreshRate * 2' 2>/dev/null); \
	GDK_BACKEND=x11 GDK_SCALE=1 NIXOS_CONFIG_DIR="$(CURDIR)" \
	QEMU_OPTS="-device virtio-vga-gl,xres=$${XRES:-3440},yres=$${YRES:-1440}" \
	QEMU_KERNEL_PARAMS="hypr_res=$${XRES:-3440}x$${YRES:-1440} hypr_hz=$${HZ:-60} hypr_scale=$${SCALE:-1}" \
	nix run github:nix-community/nixGL#nixGLIntel -- ./result/bin/run-nixos-vm-vm

wipe-vm:
	rm -f nixos-vm.qcow2

fresh-vm: wipe-vm vm
