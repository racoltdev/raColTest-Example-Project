TARGET := raColTest-example

BUILD_DIR := build/
SOURCE_DIR := src/
TEST_DIR := test/
TEST_BINDIR := testbin/

CXXFLAGS := --std=c++20 -g3 -Wall -Wextra -Wpedantic -Wconversion -fPIC
CXXFLAGS += -MMD -MP -I$(SOURCE_DIR)
INCLUDE := -I./include
LINK := -l:lib_raColTest.so

THIS_MAKEFILE := $(firstword $(MAKEFILE_LIST))
SOURCES != find $(SOURCE_DIR) -name '*.cpp' ! -wholename 'src/main.cpp'
OBJECTS := ${SOURCES:%.cpp=$(BUILD_DIR)%.o}
TEST_SOURCES != find $(TEST_DIR) -name '*.cpp'
TESTS := ${TEST_SOURCES:$(TEST_DIR)%.cpp=$(TEST_BINDIR)%}
DEPFILES := ${OBJECTS:%.o=%.d}
-include $(DEPFILES)

$(BUILD_DIR)%.o: %.cpp $(THIS_MAKEFILE)
	@mkdir -p "${@D}"
	@echo "[CXX] ${@F}"
	@$(CXX) $(CXXFLAGS) -c "$<" -o "$@" $(INCLUDE)

$(TEST_BINDIR)%: $(BUILD_DIR)$(TEST_DIR)%.o $(OBJECTS)
	@echo "[CXX] ${@F}"
	@mkdir -p $(TEST_BINDIR)
	$(CXX) $^ $(CXXFLAGS) -o $@ $(LINK)

$(TARGET): $(OBJECTS) $(BUILD_DIR)src/main.o
	@echo "[LD] ${@F}"
	@$(CXX) $^ $(CXXFLAGS) -o $(TARGET) $(LINK)

all: $(TARGET) $(TESTS)

clean:
	rm -rf $(TARGET)
	rm -rf $(BUILD_DIR)
	rm -rf $(TEST_BINDIR)

.PHONY: clean all
