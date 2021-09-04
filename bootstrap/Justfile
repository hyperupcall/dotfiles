sharedDir := "./tests/shared/dots-bootstrap"

alias i := init

init:
	sudo mkosi build


sync:
	rm -rf {{ sharedDir }}
	mkdir -p {{ sharedDir }}
	cp -r pkg {{ sharedDir }}

	cp scripts/* {{ sharedDir }}
	cp package.sh {{ sharedDir }}

qemu: sync
	rm -f ./tests/data/mkosi/writable-image.qcow2
	qemu-img convert -f raw -O qcow2 ./tests/data/mkosi/image.raw ./tests/data/mkosi/writable-image.qcow2
	cd tests && bash ./scripts/disk.sh

	qemu-system-x86_64 \
		-name 'Arch Linux Install Test' \
		-machine accel=kvm \
		-smp 2 \
		-m 2G \
		-cpu host \
		-drive if=pflash,format=raw,readonly=on,file=/usr/share/ovmf/x64/OVMF_CODE.fd \
		-object rng-random,filename=/dev/urandom,id=rng0 \
		-device virtio-rng-pci,rng=rng0,id=rng-device0 \
		-drive format=qcow2,if=virtio,file=./tests/data/mkosi/writable-image.qcow2 \
		-drive format=raw,if=virtio,file=./tests/data/shared.raw
