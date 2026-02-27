.PHONY: help bootloaders debian arch uki rescatux rescapp adapt clean

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  %-16s %s\n", $$1, $$2}'

# === Standalone Builders ===

bootloaders: ## Package Debian bootloaders into bootloaders.tar.gz
	cd bootloaders && bash create-bootloaders

debian: ## Build Debian-based rescue ISO (requires root, debootstrap)
	cd builders/debian && sudo ./make

arch: ## Build Arch-based rescue ISO (requires mkarchiso)
	cd builders/arch && sudo mkarchiso -v -w /tmp/archiso-work -o out .

uki: ## Build UKI rescue EFI image (requires mkosi, systemd-ukify)
	cd builders/uki && mkosi build

rescatux: ## Build Rescatux ISO (requires live-build, root)
	cd builders/rescatux && sudo ./make-rescatux.sh

rescapp: ## Install rescapp (requires Python3, PyQt5, kdialog)
	cd tools/rescapp && sudo make install

# === Adapter (layer recovery onto penguins-eggs naked ISOs) ===

adapt: ## Layer recovery onto naked ISO. Usage: make adapt INPUT=<iso> [OUTPUT=<iso>] [RESCAPP=1] [SECUREBOOT=1] [GUI=minimal|touch|full]
	@if [ -z "$(INPUT)" ]; then echo "Usage: make adapt INPUT=path/to/naked.iso [OUTPUT=recovery.iso] [RESCAPP=1] [SECUREBOOT=1] [GUI=minimal|touch|full]"; exit 1; fi
	sudo ./adapters/adapter.sh --input "$(INPUT)" \
		$(if $(OUTPUT),--output "$(OUTPUT)") \
		$(if $(RESCAPP),--with-rescapp) \
		$(if $(SECUREBOOT),--secureboot) \
		$(if $(GUI),--gui "$(GUI)")

clean: ## Remove build artifacts
	rm -rf bootloaders/bootloaders bootloaders/bootloaders.tar.gz
	rm -rf builders/debian/rootdir builders/debian/*.iso
	rm -rf builders/arch/work builders/arch/out
	rm -rf builders/uki/mkosi.builddir builders/uki/mkosi.cache
	rm -rf builders/rescatux/rescatux-release
	rm -rf recovery-manager/target
	rm -rf /tmp/penguins-recovery-work
