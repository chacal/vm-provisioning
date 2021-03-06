MAKEFILE_DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
VM_BASE_DIR=/Users/jihartik/nonbackupped/vm
PACKER_BUILD=packer build -on-error=ask -var-file packer-vars.json
CREATE_VMX=$(MAKEFILE_DIR)create-vmx.sh

include env
export

.SECONDEXPANSION:
VM_DIR=$(VM_BASE_DIR)/$$(VM_NAME)

buster-base: GUEST_OS=debian10-64
buster-base: VM_NAME=$(notdir $(basename $@))
buster-base: $(VM_DIR)/$$@.vmdk $(VM_DIR)/$$@.vmx

focal-base: GUEST_OS=ubuntu-64
focal-base: VM_NAME=$(notdir $(basename $@))
focal-base: $(VM_DIR)/$$@.vmdk $(VM_DIR)/$$@.vmx

openthread-builder: GUEST_OS=debian10-64
openthread-builder: VM_NAME=$(notdir $(basename $@))
openthread-builder: $(VM_DIR)/$$@.vmdk $(VM_DIR)/$$@.vmx

docker-arm-builder: GUEST_OS=debian10-64
docker-arm-builder: VM_NAME=$(notdir $(basename $@))
docker-arm-builder: $(VM_DIR)/$$@.vmdk $(VM_DIR)/$$@.vmx

.PHONY: ha.chacal.fi
ha.chacal.fi: VM_NAME=$@
ha.chacal.fi:
	@$(PACKER_BUILD) $(VM_NAME)/$(VM_NAME).json

%.vmx:
	@$(CREATE_VMX) $(VM_NAME) $(GUEST_OS) > $@

%.vmdk: %.qcow2 create-vmx.sh
	@qemu-img convert -f qcow2 -O vmdk $< $@

.PRECIOUS: %.qcow2
%.qcow2: $$(VM_NAME)/* scripts/* env packer-vars.json
	@if [[ -f "$@" ]]; then rm -rf "$(dir $@)"; fi
	@$(PACKER_BUILD) $(VM_NAME)/$(VM_NAME).json
