AS = /usr/local/qdos/bin/qdos-as
LD = /usr/local/qdos/bin/qdos-ld

OBJS = shell.o universe_list.o presentation.o release.o sound.o \
screen_store.o dust.o dust_generated.o bulbs.o views.o station_ai.o  \
planet_view.o station.o encounters.o universe.o save.o shop.o travel.o \
market.o docking.o planet.o equipment.o compass.o commander.o cargo.o \
target.o missile.o navigation.o tactics.o explosion.o combat.o controls.o \
dials.o scanner.o dashboard.o keyboard.o line.o render_game.o \
models_game.o motion.o flight.o tidy.o

elite: $(OBJS)
	$(LD) -o elite $(OBJS)

clean:
	rm -f $(OBJS) elite
