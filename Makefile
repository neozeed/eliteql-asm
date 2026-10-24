QCC ?= qdos-gcc
PYTHON ?= python3
SOURCES = src/navigation.s src/tactics.s src/combat.s src/dials.s src/scanner.s src/dashboard.s src/controls.s src/main.c src/line.s src/render.s src/models.s src/motion.s src/flight.s src/tidy.s
.PHONY: all clean
all: host/ELITEASM host/ELITEBEN host/ELITETST
host/ELITEBEN: $(SOURCES) tests/fixtures.h tools/qlmeta.py Makefile
	$(QCC) -O2 -fno-omit-frame-pointer -Wall $(SOURCES) -o $@
	$(PYTHON) tools/qlmeta.py $@
clean:
	rm -f host/ELITEASM host/ELITEBEN host/ELITETST host/ELITEMOT host/ELITEFLT host/ELITETDY host/ELITECTL host/ELITESCN host/ELITEDIL host/ELITECBT host/ELITETAC host/ELITEEXP

host/ELITETST: $(SOURCES) tests/fixtures.h tools/qlmeta.py Makefile
	$(QCC) -DASM_DIAGNOSTICS -O2 -fno-omit-frame-pointer -Wall $(SOURCES) -o $@
	$(PYTHON) tools/qlmeta.py $@

host/ELITEASM: src/shell.s src/save.s src/shop.s src/travel.s src/market.s src/docking.s src/planet.s src/equipment.s src/compass.s src/commander.s src/cargo.s src/target.s src/missile.s src/navigation.s src/tactics.s src/explosion.s src/combat.s src/controls.s src/dials.s src/scanner.s src/dashboard.s src/keyboard.s src/line.s src/render.s src/models.s src/motion.s src/flight.s src/tidy.s tools/qlmeta.py Makefile
	$(QCC) src/shell.s src/save.s src/shop.s src/travel.s src/market.s src/docking.s src/planet.s src/equipment.s src/compass.s src/commander.s src/cargo.s src/target.s src/missile.s src/navigation.s src/tactics.s src/explosion.s src/combat.s src/controls.s src/dials.s src/scanner.s src/dashboard.s src/keyboard.s src/line.s src/render.s src/models.s src/motion.s src/flight.s src/tidy.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITEMOT
host/ELITEMOT: tests/motion_test.c tests/motion_fixtures.h src/motion.s src/flight.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/motion_test.c src/motion.s src/flight.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITEFLT
host/ELITEFLT: tests/flight_test.c tests/flight_fixtures.h src/motion.s src/flight.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/flight_test.c src/motion.s src/flight.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITETDY
host/ELITETDY: tests/tidy_test.c tests/tidy_fixtures.h src/tidy.s src/motion.s src/flight.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/tidy_test.c src/tidy.s src/motion.s src/flight.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITECTL
host/ELITECTL: tests/controls_test.c tests/controls_fixtures.h src/controls.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/controls_test.c src/controls.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITESCN
host/ELITESCN: tests/scanner_test.c tests/scanner_fixtures.h src/scanner.s src/dashboard.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/scanner_test.c src/scanner.s src/dashboard.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITEDIL
host/ELITEDIL: tests/dials_test.c tests/dials_fixtures.h src/dials.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/dials_test.c src/dials.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITECBT
host/ELITECBT: tests/combat_test.c tests/combat_fixtures.h src/combat.s src/line.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/combat_test.c src/combat.s src/line.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITETAC
host/ELITETAC: tests/tactics_test.c tests/tactics_fixtures.h src/navigation.s src/tactics.s src/tidy.s src/combat.s src/motion.s src/line.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/tactics_test.c src/navigation.s src/tactics.s src/tidy.s src/combat.s src/motion.s src/line.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITEEXP
host/ELITEEXP: tests/explosion_test.c tests/explosion_fixtures.h src/explosion.s src/combat.s src/line.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/explosion_test.c src/explosion.s src/combat.s src/line.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITEMSL
host/ELITEMSL: tests/missile_test.c src/missile.s src/navigation.s src/tactics.s src/tidy.s src/combat.s src/motion.s src/line.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/missile_test.c src/missile.s src/navigation.s src/tactics.s src/tidy.s src/combat.s src/motion.s src/line.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITETGT
host/ELITETGT: tests/target_test.c tests/target_fixtures.h src/target.s src/navigation.s src/tactics.s src/tidy.s src/combat.s src/motion.s src/line.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/target_test.c src/target.s src/navigation.s src/tactics.s src/tidy.s src/combat.s src/motion.s src/line.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITENAV
host/ELITENAV: tests/navigation_test.c tests/navigation_fixtures.h src/navigation.s src/tactics.s src/tidy.s src/combat.s src/motion.s src/line.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/navigation_test.c src/navigation.s src/tactics.s src/tidy.s src/combat.s src/motion.s src/line.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITECRG
host/ELITECRG: tests/cargo_test.c tests/cargo_fixtures.h src/cargo.s src/combat.s src/line.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/cargo_test.c src/cargo.s src/combat.s src/line.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITECMD
host/ELITECMD: tests/commander_test.c tests/commander_fixtures.h src/commander.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/commander_test.c src/commander.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITEEQP host/ELITECMP
host/ELITEEQP: tests/equipment_test.c tests/equipment_fixtures.h src/equipment.s src/combat.s src/line.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/equipment_test.c src/equipment.s src/combat.s src/line.s -o $@
	$(PYTHON) tools/qlmeta.py $@
host/ELITECMP: tests/compass_test.c tests/compass_fixtures.h src/compass.s src/navigation.s src/tactics.s src/tidy.s src/combat.s src/motion.s src/line.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/compass_test.c src/compass.s src/navigation.s src/tactics.s src/tidy.s src/combat.s src/motion.s src/line.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITEPLN
host/ELITEPLN: tests/planet_test.c tests/planet_fixtures.h src/planet.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/planet_test.c src/planet.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITEMKT host/ELITEDCK
host/ELITEMKT: tests/market_test.c tests/market_fixtures.h src/market.s src/cargo.s src/combat.s src/line.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/market_test.c src/market.s src/cargo.s src/combat.s src/line.s -o $@
	$(PYTHON) tools/qlmeta.py $@
host/ELITEDCK: tests/docking_test.c tests/docking_fixtures.h src/docking.s src/navigation.s src/tactics.s src/tidy.s src/combat.s src/motion.s src/line.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/docking_test.c src/docking.s src/navigation.s src/tactics.s src/tidy.s src/combat.s src/motion.s src/line.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITETRV
host/ELITETRV: tests/travel_test.c tests/travel_fixtures.h src/travel.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/travel_test.c src/travel.s -o $@
	$(PYTHON) tools/qlmeta.py $@

all: host/ELITESHP
host/ELITESHP: tests/shop_test.c src/shop.s src/cargo.s src/combat.s src/line.s
	$(QCC) -O2 -fno-omit-frame-pointer -Wall tests/shop_test.c src/shop.s src/cargo.s src/combat.s src/line.s -o $@
	$(PYTHON) tools/qlmeta.py $@
