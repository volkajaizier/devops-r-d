1.Download and install latest VirtualBox
![Alt text](images/virtual_box_version.png)
2.Create new virtual machine
name: TestVM
type: Linux
version: Ubuntu(64 bit)
2GB RAM, 2 CPU, 20GB hard disk
![Alt text](images/disk_size.png)
![Alt text](images/amount_of_cpu.png)
3.Network setting bridge
![Alt text](images/bridge.png)
4.Install Ubuntu
![Alt text](images/os_version.png)
5.Snapshot
Create test file and test folder
![Alt text](images/test_files_before_snapshot.png)
take snapshot
![Alt text](images/take_snapshot.png)
remove files
![Alt text](images/remove_files_after_snapshot.png)
turn off machine
restore snapshot
![Alt text](images/restore_snapshot.png)
files is not removed
![Alt text](images/restored_state.png)
6.Change hard disk size
turn off machine
change the size of the disk with the command modifyhd(no option to change disk size in vb)

![Alt text](images/disk_resize.png)
disk was resized but couldn`t according to the VB interface but in Ubuntu I didn`t see it
also were not able to stretch filesystem size
7. Change CPU and RAM size
![Alt text](images/change_CPU.png)
![Alt text](images/change_RAM.png)
and result
![Alt text](images/increased_cpu.png)
![Alt text](images/increased_RAM.png)

8 create shared folder
go to setting and chosse share folder
add shared path, name folder, check checkbox auto-mount and Make permanent
turn on machine
mount shared folder
and result
![Alt text](images/shared_folder.png)
