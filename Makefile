VENDOR_SDK_VERSION = 1.4.0
GMP_VERSION = 6.0.0a
MPFR_VERSION = 3.1.2
MPC_VERSION = 1.0.2


TOP = $(PWD)
TARGET = xtensa-lx106-elf
TOOLCHAIN = $(TOP)/$(TARGET)

XTTC = $(TOOLCHAIN)
XTBP = $(TOP)/build
XTDLP = $(TOP)/dl

GMP_TAR = gmp-$(GMP_VERSION).tar.bz2
MPFR_TAR = mpfr-$(MPFR_VERSION).tar.bz2
MPC_TAR = mpc-$(MPC_VERSION).tar.gz

GMP_DIR = gmp-$(GMP_VERSION)
MPFR_DIR = mpfr-$(MPFR_VERSION)
MPC_DIR = mpc-$(MPC_VERSION)

GCC_DIR = gcc-xtensa
NEWLIB_DIR = esp-newlib
BINUTILS_DIR = esp-binutils


UNZIP = unzip -q -o
UNTAR = tar -xf


VENDOR_SDK_ZIP = $(VENDOR_SDK_ZIP_$(VENDOR_SDK_VERSION))
VENDOR_SDK_DIR = $(VENDOR_SDK_DIR_$(VENDOR_SDK_VERSION))

VENDOR_SDK_ZIP_1.4.0 = esp_iot_sdk_v1.4.0_15_09_18.zip
VENDOR_SDK_DIR_1.4.0 = esp_iot_sdk_v1.4.0
VENDOR_SDK_ZIP_1.3.0 = esp_iot_sdk_v1.3.0_15_08_08.zip
VENDOR_SDK_DIR_1.3.0 = esp_iot_sdk_v1.3.0
VENDOR_SDK_ZIP_1.2.0 = esp_iot_sdk_v1.2.0_15_07_03.zip
VENDOR_SDK_DIR_1.2.0 = esp_iot_sdk_v1.2.0
VENDOR_SDK_ZIP_1.1.2 = esp_iot_sdk_v1.1.2_15_06_12.zip
VENDOR_SDK_DIR_1.1.2 = esp_iot_sdk_v1.1.2
VENDOR_SDK_ZIP_1.1.1 = esp_iot_sdk_v1.1.1_15_06_05.zip
VENDOR_SDK_DIR_1.1.1 = esp_iot_sdk_v1.1.1
VENDOR_SDK_ZIP_1.1.0 = esp_iot_sdk_v1.1.0_15_05_26.zip
VENDOR_SDK_DIR_1.1.0 = esp_iot_sdk_v1.1.0
# MIT-licensed version was released without changing version number
#VENDOR_SDK_ZIP_1.1.0 = esp_iot_sdk_v1.1.0_15_05_22.zip
#VENDOR_SDK_DIR_1.1.0 = esp_iot_sdk_v1.1.0
VENDOR_SDK_ZIP_1.0.1 = esp_iot_sdk_v1.0.1_15_04_24.zip
VENDOR_SDK_DIR_1.0.1 = esp_iot_sdk_v1.0.1
VENDOR_SDK_ZIP_1.0.1b2 = esp_iot_sdk_v1.0.1_b2_15_04_10.zip
VENDOR_SDK_DIR_1.0.1b2 = esp_iot_sdk_v1.0.1_b2
VENDOR_SDK_ZIP_1.0.1b1 = esp_iot_sdk_v1.0.1_b1_15_04_02.zip
VENDOR_SDK_DIR_1.0.1b1 = esp_iot_sdk_v1.0.1_b1
VENDOR_SDK_ZIP_1.0.0 = esp_iot_sdk_v1.0.0_15_03_20.zip
VENDOR_SDK_DIR_1.0.0 = esp_iot_sdk_v1.0.0
VENDOR_SDK_ZIP_0.9.6b1 = esp_iot_sdk_v0.9.6_b1_15_02_15.zip
VENDOR_SDK_DIR_0.9.6b1 = esp_iot_sdk_v0.9.6_b1
VENDOR_SDK_ZIP_0.9.5 = esp_iot_sdk_v0.9.5_15_01_23.zip
VENDOR_SDK_DIR_0.9.5 = esp_iot_sdk_v0.9.5
VENDOR_SDK_ZIP_0.9.4 = esp_iot_sdk_v0.9.4_14_12_19.zip
VENDOR_SDK_DIR_0.9.4 = esp_iot_sdk_v0.9.4
VENDOR_SDK_ZIP_0.9.3 = esp_iot_sdk_v0.9.3_14_11_21.zip
VENDOR_SDK_DIR_0.9.3 = esp_iot_sdk_v0.9.3
VENDOR_SDK_ZIP_0.9.2 = esp_iot_sdk_v0.9.2_14_10_24.zip
VENDOR_SDK_DIR_0.9.2 = esp_iot_sdk_v0.9.2
STANDALONE = y

.PHONY: toolchain libhal libcirom sdk

# all: esptool libcirom standalone sdk sdk_patch $(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr/lib/libhal.a $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc
all: $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc
	@echo ok
# 	@echo
# 	@echo "Xtensa toolchain is built, to use it:"
# 	@echo
# 	@echo 'export PATH=$(TOOLCHAIN)/bin:$$PATH'
# 	@echo
# ifneq ($(STANDALONE),y)
# 	@echo "Espressif ESP8266 SDK is installed. Toolchain contains only Open Source components"
# 	@echo "To link external proprietary libraries add:"
# 	@echo
# 	@echo "xtensa-lx106-elf-gcc -I$(TOP)/sdk/include -L$(TOP)/sdk/lib"
# 	@echo
# else
# 	@echo "Espressif ESP8266 SDK is installed, its libraries and headers are merged with the toolchain"
# 	@echo
# endif

esptool: toolchain
	@echo "esptool copied"

$(TOOLCHAIN)/xtensa-lx106-elf/sysroot/lib/libcirom.a: $(TOOLCHAIN)/xtensa-lx106-elf/sysroot/lib/libc.a $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc
	@echo "Creating irom version of libc..."
	$(TOOLCHAIN)/bin/xtensa-lx106-elf-objcopy --rename-section .text=.irom0.text \
		--rename-section .literal=.irom0.literal $(<) $(@);

libcirom: $(TOOLCHAIN)/xtensa-lx106-elf/sysroot/lib/libcirom.a

sdk_patch: .sdk_patch_$(VENDOR_SDK)

.sdk_patch_1.4.0:
	patch -N -d $(VENDOR_SDK_DIR_1.4.0) -p1 < c_types-c99.patch
	@touch $@

.sdk_patch_1.3.0:
	patch -N -d $(VENDOR_SDK_DIR_1.3.0) -p1 < c_types-c99.patch
	@touch $@

.sdk_patch_1.2.0: lib_mem_optimize_150714.zip libssl_patch_1.2.0-2.zip empty_user_rf_pre_init.o
	#$(UNZIP) libssl_patch_1.2.0-2.zip
	#$(UNZIP) libsmartconfig_2.4.2.zip
	$(UNZIP) lib_mem_optimize_150714.zip
	#mv libsmartconfig_2.4.2.a $(VENDOR_SDK_DIR_1.2.0)/lib/libsmartconfig.a
	mv libssl.a libnet80211.a libpp.a libsmartconfig.a $(VENDOR_SDK_DIR_1.2.0)/lib/
	patch -N -f -d $(VENDOR_SDK_DIR_1.2.0) -p1 < c_types-c99.patch
	$(TOOLCHAIN)/bin/xtensa-lx106-elf-ar r $(VENDOR_SDK_DIR_1.2.0)/lib/libmain.a empty_user_rf_pre_init.o
	@touch $@

.sdk_patch_1.1.2: scan_issue_test.zip 1.1.2_patch_02.zip empty_user_rf_pre_init.o
	$(UNZIP) scan_issue_test.zip
	$(UNZIP) 1.1.2_patch_02.zip
	mv libmain.a libnet80211.a libpp.a $(VENDOR_SDK_DIR_1.1.2)/lib/
	patch -N -f -d $(VENDOR_SDK_DIR_1.1.2) -p1 < c_types-c99.patch
	$(TOOLCHAIN)/bin/xtensa-lx106-elf-ar r $(VENDOR_SDK_DIR_1.1.2)/lib/libmain.a empty_user_rf_pre_init.o
	@touch $@

.sdk_patch_1.1.1: empty_user_rf_pre_init.o
	patch -N -f -d $(VENDOR_SDK_DIR_1.1.1) -p1 < c_types-c99.patch
	$(TOOLCHAIN)/bin/xtensa-lx106-elf-ar r $(VENDOR_SDK_DIR_1.1.1)/lib/libmain.a empty_user_rf_pre_init.o
	@touch $@

.sdk_patch_1.1.0: lib_patch_on_sdk_v1.1.0.zip empty_user_rf_pre_init.o
	$(UNZIP) $<
	mv libsmartconfig_patch_01.a $(VENDOR_SDK_DIR_1.1.0)/lib/libsmartconfig.a
	mv libmain_patch_01.a $(VENDOR_SDK_DIR_1.1.0)/lib/libmain.a
	mv libssl_patch_01.a $(VENDOR_SDK_DIR_1.1.0)/lib/libssl.a
	patch -N -f -d $(VENDOR_SDK_DIR_1.1.0) -p1 < c_types-c99.patch
	$(TOOLCHAIN)/bin/xtensa-lx106-elf-ar r $(VENDOR_SDK_DIR_1.1.0)/lib/libmain.a empty_user_rf_pre_init.o
	@touch $@

empty_user_rf_pre_init.o: empty_user_rf_pre_init.c $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc
	$(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc -O2 -c $<

.sdk_patch_1.0.1: libnet80211.zip esp_iot_sdk_v1.0.1/.dir
	$(UNZIP) $<
	mv libnet80211.a $(VENDOR_SDK_DIR_1.0.1)/lib/
	patch -N -f -d $(VENDOR_SDK_DIR_1.0.1) -p1 < c_types-c99.patch
	@touch $@

.sdk_patch_1.0.1b2: libssl.zip esp_iot_sdk_v1.0.1_b2/.dir
	$(UNZIP) $<
	mv libssl/libssl.a $(VENDOR_SDK_DIR_1.0.1b2)/lib/
	patch -N -d $(VENDOR_SDK_DIR_1.0.1b2) -p1 < c_types-c99.patch
	@touch $@

.sdk_patch_1.0.1b1:
	patch -N -d $(VENDOR_SDK_DIR_1.0.1b1) -p1 < c_types-c99.patch
	@touch $@

.sdk_patch_1.0.0:
	patch -N -d $(VENDOR_SDK_DIR_1.0.0) -p1 < c_types-c99.patch
	@touch $@

.sdk_patch_0.9.6b1:
	patch -N -d $(VENDOR_SDK_DIR_0.9.6b1) -p1 < c_types-c99.patch
	@touch $@

.sdk_patch_0.9.5: sdk095_patch1.zip esp_iot_sdk_v0.9.5/.dir
	$(UNZIP) $<
	mv libmain_fix_0.9.5.a $(VENDOR_SDK_DIR)/lib/libmain.a
	mv user_interface.h $(VENDOR_SDK_DIR)/include/
	patch -N -d $(VENDOR_SDK_DIR_0.9.5) -p1 < c_types-c99.patch
	@touch $@

.sdk_patch_0.9.4:
	patch -N -d $(VENDOR_SDK_DIR_0.9.4) -p1 < c_types-c99.patch
	@touch $@

.sdk_patch_0.9.3: esp_iot_sdk_v0.9.3_14_11_21_patch1.zip esp_iot_sdk_v0.9.3/.dir
	$(UNZIP) $<
	@touch $@

.sdk_patch_0.9.2: FRM_ERR_PATCH.rar esp_iot_sdk_v0.9.2/.dir 
	unrar x -o+ $<
	cp FRM_ERR_PATCH/*.a $(VENDOR_SDK_DIR)/lib/
	@touch $@

standalone: sdk sdk_patch toolchain
ifeq ($(STANDALONE),y)
	@echo "Installing vendor SDK headers into toolchain sysroot"
	@cp -Rf sdk/include/* $(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr/include/
	@echo "Installing vendor SDK libs into toolchain sysroot"
	@cp -Rf sdk/lib/* $(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr/lib/
	@echo "Installing vendor SDK linker scripts into toolchain sysroot"
	@sed -e 's/\r//' sdk/ld/eagle.app.v6.ld | sed -e s@../ld/@@ >$(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr/lib/eagle.app.v6.ld
	@sed -e 's/\r//' sdk/ld/eagle.rom.addr.v6.ld >$(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr/lib/eagle.rom.addr.v6.ld
endif

FRM_ERR_PATCH.rar:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=10"
esp_iot_sdk_v0.9.3_14_11_21_patch1.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=73"
sdk095_patch1.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=190"
libssl.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=316"
libnet80211.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=361"
lib_patch_on_sdk_v1.1.0.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=432"
scan_issue_test.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=525"
1.1.2_patch_02.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=546"
libssl_patch_1.2.0-1.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=583" -O $@
libssl_patch_1.2.0-2.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=586" -O $@
libsmartconfig_2.4.2.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=585"
lib_mem_optimize_150714.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=594"

sdk: $(VENDOR_SDK_DIR)/.dir
	ln -snf $(VENDOR_SDK_DIR) sdk

$(VENDOR_SDK_DIR)/.dir: $(VENDOR_SDK_ZIP)
	$(UNZIP) $^
	-mv License $(VENDOR_SDK_DIR)
	touch $@

esp_iot_sdk_v1.4.0_15_09_18.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=838"

esp_iot_sdk_v1.3.0_15_08_08.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=664"

esp_iot_sdk_v1.2.0_15_07_03.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=564"

esp_iot_sdk_v1.1.2_15_06_12.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=521"

esp_iot_sdk_v1.1.1_15_06_05.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=484"

esp_iot_sdk_v1.1.0_15_05_26.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=425"

esp_iot_sdk_v1.1.0_15_05_22.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=423"

esp_iot_sdk_v1.0.1_15_04_24.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=325"

esp_iot_sdk_v1.0.1_b2_15_04_10.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=293"

esp_iot_sdk_v1.0.1_b1_15_04_02.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=276"

esp_iot_sdk_v1.0.0_15_03_20.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=250"

esp_iot_sdk_v0.9.6_b1_15_02_15.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=220"

esp_iot_sdk_v0.9.5_15_01_23.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=189"

esp_iot_sdk_v0.9.4_14_12_19.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=111"

esp_iot_sdk_v0.9.3_14_11_21.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=72"

esp_iot_sdk_v0.9.2_14_10_24.zip:
	wget --content-disposition "http://bbs.espressif.com/download/file.php?id=9"

$(XTDLP)/$(GMP_TAR):
	wget -c http://ftp.gnu.org/gnu/gmp/$(GMP_TAR) -O $(XTDLP)/$(GMP_TAR)	



$(XTDLP)/$(MPC_TAR):
	wget -c http://ftp.gnu.org/gnu/mpfr/$(MPC_TAR) -O $(XTDLP)/$(MPC_TAR)




$(XTDLP)/$(MPFR_TAR):
	wget -c http://ftp.gnu.org/gnu/mpfr/$(MPFR_TAR) -O $(XTDLP)/$(MPFR_TAR)


$(XTDLP)/$(GCC_DIR):
	git clone https://github.com/jcmvbkbc/gcc-xtensa.git $(XTDLP)/$(GCC_DIR)



$(XTDLP)/$(NEWLIB_DIR):
	git clone -b xtensa https://github.com/jcmvbkbc/newlib-xtensa.git $(XTDLP)/$(NEWLIB_DIR)

$(XTDLP)/$(BINUTILS_DIR):
	git clone https://github.com/fpoussin/esp-binutils.git $(XTDLP)/$(BINUTILS_DIR)

libhal: $(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr/lib/libhal.a

$(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr/lib/libhal.a: $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc
	make -C lx106-hal -f ../Makefile _libhal

_libhal:
	autoreconf -i
	PATH=$(TOOLCHAIN)/bin:$(PATH) ./configure --host=xtensa-lx106-elf --prefix=$(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr
	PATH=$(TOOLCHAIN)/bin:$(PATH) make
	PATH=$(TOOLCHAIN)/bin:$(PATH) make install


toolchain: $(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc

$(TOOLCHAIN)/bin/xtensa-lx106-elf-gcc: $(XTDLP) build_gmp

$(XTDLP):
	mkdir -p $(XTDLP)

$(XTDLP)/$(GMP_DIR): $(XTDLP)/$(GMP_TAR)
	mkdir -p $(XTDLP)/$(GMP_DIR)
	$(UNTAR) $(XTDLP)/$(GMP_TAR) -C $(XTDLP)/$(GMP_DIR)
	mv $(XTDLP)/$(GMP_DIR)/gmp-*/* $(XTDLP)/$(GMP_DIR)

$(XTDLP)/$(GMP_DIR)/build: $(XTDLP)/$(GMP_DIR)
	mkdir -p $(XTDLP)/$(GMP_DIR)/build/
	$(XTDLP)/$(GMP_DIR)/build/../configure --prefix=$(XTBP)/gmp --disable-shared --enable-static
	
$(XTDLP)/$(MPFR_DIR): $(XTDLP)/$(MPFR_TAR)
	mkdir -p $(XTDLP)/$(MPFR_DIR)
	$(UNTAR) $(XTDLP)/$(MPFR_DIR) -C $(XTDLP)/$(MPFR_DIR)
	mv $(XTDLP)/$(MPFR_DIR)/mpfr-*/* $(XTDLP)/$(MPFR_DIR)

$(XTDLP)/$(MPFR_DIR)/build: $(XTDLP)/$(MPFR_DIR)
	mkdir -p $(XTDLP)/$(MPFR_DIR)
	$(UNTAR) $(XTDLP)/$(MPFR_DIR) -C $(XTDLP)/$(MPFR_DIR)
	mv $(XTDLP)/$(MPFR_DIR)/mpfr-*/* $(XTDLP)/$(MPFR_DIR)
	
$(XTDLP)/$(MPC_DIR): $(XTDLP)/$(MPC_TAR)
	mkdir -p $(XTDLP)/$(MPC_DIR)
	$(UNTAR) $(XTDLP)/$(MPC_DIR) -C $(XTDLP)/$(MPC_DIR)
	mv $(XTDLP)/$(MPC_DIR)/mpc-*/* $(XTDLP)/$(MPC_DIR)


build_gmp: $(XTDLP)/$(GMP_DIR)/build



clean: clean-sdk
	-rm -rf $(TOOLCHAIN)	

clean-sdk:
	rm -rf $(VENDOR_SDK_DIR)
	rm -f sdk
	rm -f .sdk_patch_$(VENDOR_SDK)
	rm -rf dl

clean-sysroot:
	rm -rf $(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr/lib/*
	rm -rf $(TOOLCHAIN)/xtensa-lx106-elf/sysroot/usr/include/*