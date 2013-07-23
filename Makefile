CXXFLAGS	= -O2 -fmessage-length=0

OBJS		= src/main.o src/scanner.o src/parser.o src/SymbolTable.o

LIBS 		= -ll -ly

TARGET		= PL0-Interpreter

$(TARGET): scanner $(OBJS)
	$(CXX) -o $(TARGET) $(OBJS) $(LIBS)

all: $(TARGET)

parser:
	bison -d src/parser.y

scanner: parser
	flex src/scanner.l


clean:
	rm -f $(OBJS) $(TARGET) src/parser.cpp src/parser.hpp src/scanner.cpp src/scanner.hpp