.PHONY: build-vm vm wipe-vm fresh-vm

build-vm:
	nix build .#vm

vm: build-vm
	@HOST_DISPLAY=$$(hyprctl monitors -j 2>/dev/null \
		| jq -r '[.[] | select(.focused)][0] // {} | "\(.width // 3440) \(.height // 1440) \(.scale // 1) \((.refreshRate // 30) * 2)"' 2>/dev/null); \
	set -- $${HOST_DISPLAY:-3440 1440 1 60}; \
	XRES=$$1; YRES=$$2; SCALE=$$3; HZ=$$4; \
	GDK_BACKEND=x11 GDK_SCALE=1 NIXOS_CONFIG_DIR="$(CURDIR)" \
	QEMU_OPTS="-device virtio-vga-gl,xres=$$XRES,yres=$$YRES" \
	QEMU_KERNEL_PARAMS="hypr_res=$${XRES}x$$YRES hypr_hz=$$HZ hypr_scale=$$SCALE" \
	nix run github:nix-community/nixGL#nixGLIntel -- ./result/bin/run-nixos-vm-vm

wipe-vm:
	rm -f nixos-vm.qcow2

fresh-vm: wipe-vm vm
