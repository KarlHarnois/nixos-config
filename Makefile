.PHONY: build-vm run-vm wipe-vm fresh-vm

build-vm:
	nix build .#nixosConfigurations.vm.config.system.build.vm

run-vm: build-vm
	GDK_SCALE=1 nix run github:nix-community/nixGL#nixGLIntel -- ./result/bin/run-nixos-vm-vm

wipe-vm:
	rm -f nixos-vm.qcow2

fresh-vm: wipe-vm run-vm
