all: clean obj/main.o obj/quadratic.o
	aarch64-linux-android-gcc -g -pie obj/main.o obj/quadratic.o -o bin/app
	adb push bin/app /data/local/tmp/.
	adb shell "./data/local/tmp/app"

obj/main.o:
	@aarch64-linux-android-gcc -g -c -O0 src/main.c -o obj/main.o

obj/quadratic.o:
	@aarch64-linux-android-gcc -g -c src/quadratic.s -o obj/quadratic.o

clean:
	@rm -rf obj/* bin/* 
	@adb shell "rm -rf ./data/local/tmp/app"
