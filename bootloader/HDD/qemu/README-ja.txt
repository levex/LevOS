QEMU on Windows

�@QEMU �́A�����CPU���G�~�����[�g����v���O�����ł��BWindows�ł�
�A���t�@�o�[�W�����i�J�������̃o�[�W�����j�ł��B

�@�_�u���n�C�t��"--"�́A�K�v�Ȃ��Ȃ�܂����B���ׂẴI�v�V�����ɃV���O���n�C�t����
�g���ĉ������B

1.�C���X�g�[��
�@zip�t�@�C����W�J���Ă��������B�C���X�g�[���[���g���K�v�͂���܂���B

2. qemu �̎��s
�@���s����̂ɂ́A�Q���@������܂��B

 2.1 �o�b�`�t�@�C�����g�����@
�@qemu-win.bat���_�u���N���b�N����ƁA�f�X�N�g�b�v���linux���N�����܂��B

�R�}���h�v�����v�g�iMS-DOS�v�����v�g�j��ł͎��̂悤�ɂ��܂��B

	qemu.exe -L . -hda linux.img

�@-L ���Abios�̈ʒu���A-hda ���n�[�h�f�B�X�N�̃C���[�W�t�@�C����
�w�肷��I�v�V�����ł��B

�@�}�E�X�J�[�\�����������Ƃ��́ACtrl��Alt�L�[�𓯎��ɉ����Ă��������BWindowsMe�ł́A
Alt��Tab���g���Ă��������B

�@linux���I������ɂ́ACtrl-Alt-2�̃L�[�𓯎��ɉ����܂��B(qemu)�v�����v�g���ł���A
quit�ƃ^�C�v���܂��B

        (qemu) quit

 2.2 �V���[�g�J�b�g���g�����@
�@qemu.exe�̃V���[�g�J�b�g�����܂��B�E�N���b�N���ăv���p�e�B��\�����A�����N��
�ɁA-L . -hda linux.img ��t�������܂��B�V���[�g�J�b�g���_�u���N���b�N�����
���s����܂��B

3. �m�F
�@��������Ă���linux.img�ɂ́Anbench�Ƃ����x���`�}�[�N���܂܂�Ă��܂��B
�N������ɂ́A���̂悤�ɂ��܂��B

	sh-2.05b# cd nbench
	sh-2.05b# ./nbench

�@INTEGER INDEX �� FLOATING-POINT INDEX �� Pentium 90MHz �Ƃ̔�r��\���܂��B

4. x86_64�̃G�~�����[�V����

�@qemu-x86_64.bat���_�u���N���b�N���Ă��A�f�X�N�g�b�v��Linux���N�����܂��B
�R�Q�r�b�g�ƂU�S�r�b�g��OS�𓮂������Ƃ��ł��܂��B

5. �n�[�h�f�B�X�N�C���[�W
�@qemu-img.exe���g���āA�n�[�h�f�B�X�N�̃C���[�W�t�@�C������邱�Ƃ��ł��܂��B
�P�OM�o�C�g�̃n�[�h�f�B�X�N�C���[�W�����ɂ́A���̂悤�ɂ��܂��B

�@qemu-img.exe create harddisk.img 10M

6. �t���b�s�[��CD-ROM
�@QEMU���j�^�[���g���āA�t���b�s�[��CD-ROM�C���[�W��ւ��邱�Ƃ��ł��܂��B
�@QEMU���j�^�[��\������ɂ́ACtrl,Alt,2�̃L�[�𓯎��ɉ����Ă��������BCtrl, Alt, 1
�𓯎��ɉ����ƁA�Q�X�gOS�̉�ʂɂ��ǂ�܂��B

�@�t���b�s�[��CD-ROM���g���ɂ́A�C���[�W�t�@�C���ɕϊ�����K�v������܂��B

�@�t���b�s�[�̃C���[�W���ɂ́ADiskExplore�ȂǍD�݂̂��̂��g���Ă��������B

�@CD-ROM�́Aiso�`���̃C���[�W�ɕϊ�����K�v������܂��BCD-R���C�e�B���O�\�t�g������΁A
���ꂪ�g����Ǝv���܂��B�Ȃ���΁Acdrtools�Ƃ����t���[�̃\�t�g�E�F�A������܂��B

�@�����𓯎��Ɏg���ɂ́A���̂悤�ɂ��܂��B

�@qemu.exe -L . -m 128 -boot a -fda floppy.img -hda harddisk.img -cdrom cdimage.iso

  -L : bios �̈ʒu
  -m : �������T�C�Y�iM�o�C�g�j
  -boot : �N������f�o�C�X�@�t���b�s�[(a)�A�n�[�h�f�B�X�N(c)�ACD-ROM(d)
  -fda : �t���b�s�[�C���[�W
  -hda : �n�[�h�f�B�X�N�C���[�W
  -cdrom : CD-ROM�C���[�W

�t���b�s�[��CD-ROM�C���[�W�����ւ������Ƃ��́AQEMU���j�^�[�Ŏ��̂悤�ɂ��܂��B
(qemu) change fda filename.img
�������́A
(qemu) change cdrom cdimage.iso

7. �A���C���X�g�[��
�@�W�J�����t�H���_���폜���Ă��������B�C���X�g�[�����g�����ꍇ�A���W�X�g�����g�p���Ă��܂��B


8. ����
�@�P�̃n�[�h�f�B�X�N�C���[�W�ŁA�Q�p�d�l�t�𓯎��ɓ������Ȃ��ł��������B�f�B�X�N
�C���[�W�����܂��B

9. ���C�Z���X
�@���zCPU�R�A���C�u���������PC�V�X�e���G�~�����[�^��LGPL���C�Z���X�ƂȂ��Ă��܂��B
License�t�H���_�ɂ���t�@�C�����������������B
�@�Ȃ��A�{�v���O�����̎g�p�ɂ����ɂ��ĕۏ؂͏o�����˂܂��̂ł��������������B

10. �����N
  QEMU
	http://fabrice.bellard.free.fr/qemu/
  Bochs BIOS
	http://bochs.sourceforge.net/ 
  VGA BIOS
	http://www.nongnu.org/vgabios/
  MinGW
	http://www.mingw.org/
  SDL Library
	http://www.libsdl.org/

kazu