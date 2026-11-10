/* Two independent pages; archives are kept byte-for-byte as supplied.
 * Override any hosted ZIP with ?zip=other.zip&rom=minerva&ram=1024&speed=12.
 * An optional qlbox.json inside a ZIP supplies its own defaults. */
const preset = window.QLBOX_PRESET || 'frontier8';
window.QLBOX_CONFIG = {
  zip: preset + '.zip',
  title: preset === 'elite' ? 'Elite - Electron ported to the Sinclair QL' : 'Frontier 8 · eight-colour QL',
  rom: 'minerva', ram: 1024, speed: 1, timing: 'fast', run: ''
};
