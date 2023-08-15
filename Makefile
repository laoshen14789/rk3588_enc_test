CROSS_COMPILE=aarch64-none-linux-gnu-
# CC=$(CROSS_COMPILE)gcc
CC=$(CROSS_COMPILE)gcc
CPP=$(CROSS_COMPILE)g++
AS=$(CROSS_COMPILE)as
LD=$(CROSS_COMPILE)ld
STRIP=$(CROSS_COMPILE)strip

#源文件，自动查找所有.c .cpp文件，并将目标定义为同名.o文件
DIRS :=$(shell find . -maxdepth 5 -type d)
SOURCE  := $(foreach dir,$(DIRS),$(wildcard $(dir)/*.c))

#SOURCE  := $(wildcard *.c) $(wildcard *.cpp)
OBJS    := $(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(SOURCE)))

ROOTDIR := .
SRCDIR := $(ROOTDIR)
INCLUDE := -I $(ROOTDIR)
INCLUDE += -I $(ROOTDIR)/include
INCLUDE += -I $(SRCDIR)/include/rockchip
INCLUDE += -I $(SRCDIR)/include/osal
INCLUDE += -I $(SRCDIR)/include/utils
# INCLUDE += -I $(SRCDIR)/hlcloud
# INCLUDE += -I $(SRCDIR)/json

LIBDIR := -L $(ROOTDIR)/lib
LIBDIR += -L /lib
LIB := $(LIBDIR) -losal -lutils -lrockchip_mpp -lrockchip_vpu -lpthread -ldl

#debug flag
# CFLAGS := $(INCLUDE) $(LIBDIR) -Wall -g -DCONSOLE
#release flag
CFLAGS := $(INCLUDE) $(LIBDIR) -Wall -O2 -ffunction-sections -fdata-sections -Wl,-Map=object.map,--cref,--gc-section -fvisibility=hidden
LDFLAGS:= $(LIB)
TARGET := test

$(TARGET) : ${OBJS}
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ ${OBJS} $(LIB)
	$(STRIP) $(TARGET)

.PHONY : clean

clean:
	@find . -name "*.o"  | xargs rm -f
	@rm -rf $(TARGET)
