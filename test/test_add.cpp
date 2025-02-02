#include "macros.h"
#include "add.h"

int main(int, char** argv) {
	TEST("Adds 2 and 5")
		int x = 3;
		int y = 5;
		int sum = x + y;
		ASSERT(add(x, y) == sum, "Incorrect sum")
	END_TEST
}
