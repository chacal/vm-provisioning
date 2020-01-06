MAKEFILE_DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
VM_BASE_DIR=/Users/jihartik/nonbackupped/vm
PACKER_BUILD=packer build -var-file packer-vars.json
CREATE_VMX=$(MAKEFILE_DIR)create-vmx.sh

include env
export

.SECONDEXPANSION:
VM_DIR=$(VM_BASE_DIR)/$$(VM_NAME)

buster-base: GUEST_OS=debian10-64
buster-base: VM_NAME=$(notdir $(basename $@))
buster-base: $(VM_DIR)/$$@.vmdk $(VM_DIR)/$$@.vmx

%.vmx:
	@$(CREATE_VMX) $(VM_NAME) $(GUEST_OS) > $@

%.vmdk: %.qcow2
	@qemu-img convert -f qcow2 -O vmdk $< $@

.PRECIOUS: %.qcow2
%.qcow2: $$(VM_NAME)/*
	@if [[ -f "$@" ]]; then rm -rf "$(dir $@)"; fi
	@$(PACKER_BUILD) $(VM_NAME)/$(VM_NAME).json
