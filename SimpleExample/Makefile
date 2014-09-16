# Makefile
# Generic Makefile for making cuda programs
#
BIN               := program
 
# flags
CUDA_INSTALL_PATH := /usr/local/cuda-5.5
#CUDA_SDK_PATH     := /home/pli/NVIDIA_GPU_Computing_SDK
JDK_PATH	  := $(JAVA_HOME)
#INCLUDES += -I. -I$(CUDA_INSTALL_PATH)/include -I$(CUDA_SDK_PATH)/C/common/inc -I$(JDK_PATH)/include -I$(JDK_PATH)/include/linux
INCLUDES += -I. -I$(CUDA_INSTALL_PATH)/include -I$(CUDA_INSTALL_PATH)/samples/common/inc -I$(JDK_PATH)/include -I$(JDK_PATH)/include/linux
LIBS              := -L$(CUDA_INSTALL_PATH)/lib64 -L.
CFLAGS            := -O2 -m64 -fPIC -MMD -MP
LDFLAGS           := -lrt -lm -lcudart -lcuda 
# compilers
JAVAC		  := javac
JAVAH		  := javah
NVCC              := nvcc
CC                := gcc
LINKER            := gcc
# files
J_SOURCES	  := $(wildcard *.java)
C_SOURCES         := $(wildcard *.c)
#CLASS_FILES	  := $(patsubst %.java, %.class, $(J_SOURCES))
CLASS_FILES	  := $(wildcard *.class)
CU_SOURCES        := $(wildcard *.cu)
HEADERS           := $(wildcard *.h)
C_OBJS            := $(patsubst %.c, %.o, $(C_SOURCES))
CU_OBJS           := $(patsubst %.cu, %.o, $(CU_SOURCES))
ALL_OBJS	  := $(wildcard *.o)
 
$(BIN):	$(C_OBJS) $(CU_OBJS) $(HEADERS)
	$(LINKER) -m64 -shared -fPIC -o $(BIN).so *.o $(LDFLAGS) $(INCLUDES) $(LIBS) #$(ALL_OBJS)
 
$(C_OBJS): $(C_SOURCES) $(HEADERS) $(CU_OBJS)
	$(CC) *.c -c $(CFLAGS) $(INCLUDES) #-MF libProxy.o.d $(C_SOURCES) 
 
$(CU_OBJS): $(CU_SOURCES) $(HEADERS)
	$(NVCC) -O3 -shared -c *.cu $(INCLUDES) -Xcompiler -fPIC
	#$(NVCC) -c -deviceemu *.cu $(INCLUDES) #$(CU_SOURCES) 
 
java: clean $(J_SOURCES)
	$(JAVAC) $(J_SOURCES)
	$(JAVAH) -jni -classpath ./ Main #$(CLASS_FILES)

clean:
	rm -f $(BIN) Main.h *.d *.o *.so *~ *.o.d *.class
