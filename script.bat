@echo off

nasm hello.nasm -o hello.bin
VBoxManage convertfromraw hello.bin hello.vdi --format VDI

vboxmanage controlvm test_os poweroff
vboxmanage unregistervm test_os --delete

VBoxManage createvm --name "test_os" --register
VBoxManage modifyvm "test_os" --memory 512 --boot1 floppy --boot2 disk
VBoxManage storagectl "test_os" --name "IDE" --add ide
VBoxManage storageattach "test_os" --storagectl "IDE" --port 0 --device 0 --type hdd --medium C:\Users\dieum\Documents\programmation\mini_os\hello.vdi