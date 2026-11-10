# RC1 verification results

ELITEASM and ELITEDEV:54,952 bytes each; QDOS data space7,726 bytes.
Build completed. All retained native diagnostics plus ELITEPRE passed.
ELITEPRE compares2,048 population/productivity/radius cases and4,096 short-chart
positions. Population/productivity and positions come from executed original
TT24/MULTU and TT182..TT186 instructions. Radius is checked against TT25's
explicit seed-byte expression. Inhabitant text uses the TT25 bitfield tables.

Full direct-job and BASIC EXEC_W development suites pass at128/640 KB:
RC1-INTEGRATION.log and RC1-BASIC.log. Active solo flight measured50 updates in
250 50-Hz ticks (10 updates/sec) at both sizes. BASIC largest free blocks after
startup were22,016 bytes at128 KB and537,088 bytes at640 KB. These measurements
are for the emulated fixture configuration and compressible BASIC screen.

Separate production tests pass at128/640 KB through BASIC EXEC_W and direct job:
RC1-PRODUCTION.log and RC1-PRODUCTION-DIRECT.log. They verify stock equipment and
cash, docked startup, commander/market/data/local chart, cursor selection/home,
buy/sell, save/load path, launch without free upgrades, disabled development keys,
hyperspace, real station generation/approach/docking and exit. Station approach
uses a deterministic planet pose to avoid a long manual flight; docking still
runs the movement/contact code. Rare combat/death/escape branches remain covered
by the full development suites, not claimed as naturally earned in this run.

Captures RC1-start.png, RC1-system.png and RC1-local.png show the actual production
job. Source references and the final audit document the limits of these checks.
