QCC ?= qdos-gcc
PYTHON ?= python3
SOURCES = src/main.c src/line.s src/render.s src/models.s src/motion.s src/flight.s
.PHONY: all clean
all: host/ELITEASM host/ELITEBEN host/ELITETST
host/ELITEBEN: $(SOURCES) tests/fixtures.h tools/qlmeta.py Makefile
	$(QCC) -O2 -fno-omit-frame-pointer -Wall $(SOURCES) -o $@
	$(PYTHON) tools/qlmeta.py $@
clean:
	rm -f host/ELITEASM host/ELITEBEN host/ELITETST host/ELITEMOT host/ELITEFLT

host/ELITETST: $(SOURCES) tests/fixtures.h tools/qlmeta.py Makefile
	$(QCC) -DASM_DIAGNOSTICS -O2 -fno-omit-frame-pointer -Wall $(SOURCES) -o $@
	$(PYTHON) tools/qlmeta.py $@

host/ELITEASM: src/shell.s src/line.s src/render.s src/models.s src/motion.s src/flight.s tools/qlmeta.py Makefile
	$(QCC) src/shell.s src/line.s src/render.s src/models.s src/motion.s src/flight.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITEMOT
host/ELITEMOT: tests/motion_test.c tests/motion_fixtures.h src/motion.s src/flight.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/motion_test.c src/motion.s src/flight.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITEFLT
host/ELITEFLT: tests/flight_test.c tests/flight_fixtures.h src/motion.s src/flight.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/flight_test.c src/motion.s src/flight.s -o $@
	$(PYTHON) tools/qlmeta.py $@
