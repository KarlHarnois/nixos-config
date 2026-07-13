.PHONY: build-vm run-vm wipe-vm fresh-vm

build-vm:
	nix build .#nixosConfigurations.vm.config.system.build.vm

run-vm: build-vm
	@RES=$$(hyprctl monitors -j 2>/dev/null | jq -r '[.[] | select(.focused)][0] | "xres=\(.width / .scale | round),yres=\(.height / .scale | round)"' 2>/dev/null); \
	GDK_SCALE=1 QEMU_OPTS="-device virtio-vga-gl,$${RES:-xres=2752,yres=1152}" \
	nix run github:nix-community/nixGL#nixGLIntel -- ./result/bin/run-nixos-vm-vm

wipe-vm:
	rm -f nixos-vm.qcow2

fresh-vm: wipe-vm run-vm
