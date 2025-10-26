cc = gcc

src_dir = src
debug_objects_dir = dbg
san_objects_dir = san
opt_objects_dir = opt

src = $(wildcard $(src_dir)/*.c)
debug_objects      = $(patsubst $(src_dir)/%.c,$(debug_objects_dir)/%.o,$(src))
debug_dependencies = $(patsubst $(src_dir)/%.c,$(debug_objects_dir)/%.d,$(src))
san_objects        = $(patsubst $(src_dir)/%.c,$(san_objects_dir)/%.o,$(src))
san_dependencies   = $(patsubst $(src_dir)/%.c,$(san_objects_dir)/%.d,$(src))
opt_objects        = $(patsubst $(src_dir)/%.c,$(opt_objects_dir)/%.o,$(src))
opt_dependencies   = $(patsubst $(src_dir)/%.c,$(opt_objects_dir)/%.o,$(src))

debug_flags = -Wall -Wextra -Werror -O0 -g -MMD -MP -std=c17
debug_sanitizer_flags = -Wall -Wextra -Werror -O0 -fsanitize=undefined,address -march=native -MMD -MP -std=c17
optimized_flags = -Wall -Wextra -Werror -O3 -march=native -MMD -MP -std=c17
debug_target = weather_dbg
san_target = weather_san
opt_target = weather_opt

debug: $(debug_target)
	./$<

$(debug_target): $(debug_objects)
	$(cc) -o $@ $^

$(debug_objects_dir)/%.o: $(src_dir)/%.c
	@mkdir -p $(debug_objects_dir)
	$(cc) $(debug_flags) -c $< -o $@
	-include $(debug_dependencies)

san: $(san_target)
	./$<

$(san_target): $(san_objects)
	@mkdir -p $(san_objects_dir)
	$(cc) -o $@ $^ -fsanitize=undefined,address

$(san_objects_dir)/%.o: $(src_dir)/%.c
	@mkdir -p $(san_objects_dir)
	$(cc) $(debug_sanitizer_flags) -c $< -o $@
	-include $(san_dependencies)

opt: $(opt_target)
	./$<

$(opt_target): $(opt_objects)
	@mkdir -p $(opt_objects_dir)
	$(cc) -o $@ $^

$(opt_objects_dir)/%.o: $(src_dir)/%.c
	@mkdir -p $(opt_objects_dir)
	$(cc) $(optimized_flags) -c $< -o $@
	-include $(opt_dependencies)

clean:
	rm -rf $(debug_objects_dir) $(san_objects_dir) $(opt_objects_dir) \
	$(debug_target) $(san_target) $(opt_target)
