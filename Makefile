cc = gcc
debug_flags = -Wall -Wextra -Werror -O0 -g -MMD -MP -std=c17
debug_sanitizer_flags = -Wall -Wextra -Werror -O0 -fsanitize=undefined,address -march=native -MMD -MP -std=c17
optimized_flags = -Wall -Wextra -Werror -O3 -march=native -MMD -MP -std=c17
source = weather.c
target = weather

# Run make clean before switching between different types of
# a build, debug, sanitized, optimized, etc.

debug: $(source)
	$(cc) $(debug_flags) -c $(source)
	$(cc) -o $(target) *.o
	./$(target)
san: $(source)
	$(cc) $(debug_sanitizer_flags) -c $(source)
	$(cc) -o $(target) *.o -fsanitize=undefined,address
opt: $(source)
	$(cc) $(release_flags) -c $(source)
	$(cc) -o $(target) *.o
clean:
	rm *.d *.o $(target)
