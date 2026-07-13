# nixos-config

Karl's NixOS configurations.

## Prerequisites

- x86_64 Linux with KVM access (`kvm` group)
- [Nix](https://nixos.org/download/) with flakes enabled
- GNU make

## Usage

```sh
make run-vm    # build and launch the VM
make fresh-vm  # same, from a clean disk
```

