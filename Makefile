VBOX_ID=.vagrant/machines/default/virtualbox/id

start_x11: aenea/ grammars/ grammars/aenea.json grammars/aenea create
	VBoxManage startvm `cat $(VBOX_ID)` --type headless
	make server_x11

create: ansible/config.yaml dragon-profiles/ dependencies $(VBOX_ID)

$(VBOX_ID):
	make bootstrap
	vagrant halt
	VBoxManage usbfilter add 0 --target `cat $(VBOX_ID)` --name Mic --manufacturer "Andrea Electronics"
	make provision
	vagrant halt
	make isolate

bootstrap:
	poetry run vagrant up --provision-with bootstrap

provision:
	poetry run vagrant up --provision

ansible/config.yaml:
	@echo
	@echo Please copy $@.example to $@ and adjust it as needed.
	@echo
	exit 1

dragon-profiles/:
	mkdir $@

dependencies:
	@cd windows && make

aenea/:
	git clone git@github.com:sol/aenea.git
	cd aenea && python generate_security_token.py

grammars/:
	mkdir grammars
	cp aenea/client/_hello_world_*.py grammars

grammars/aenea:
	ln -s ../aenea/client/aenea $@

grammars/aenea.json:
	cp aenea/aenea.json.example $@
	sed -i 's/C:\\\\NatLink\\\\NatLink\\\\MacroSystem/C:\\\\vagrant\\\\grammars/' $@

server_x11: aenea/server/linux_x11/config.py
	cd aenea/server/linux_x11 && poetry run python server_x11.py

aenea/server/linux_x11/config.py:
	cp $@.example $@

isolate:
	VBoxManage modifyvm `cat $(VBOX_ID)` --nic1 none --natpf1 delete rdp --natpf1 delete ssh --natpf1 delete winrm --natpf1 delete winrm-ssl

destroy:
	vagrant destroy
