# TileBigImage

An ImageJ/Fiji macro that splits one large image into a grid of overlapping
512x512 tiles and saves each tile to disk as TIFF, JPG, and PNG.

## Why

Large images (e.g. whole-slide or aerial/satellite images) are often too big
to feed directly into tools such as YOLO for training or inference. This
macro cuts such an image into fixed-size tiles small enough to process,
using a sliding window with 50% overlap (256 px stride for a 512 px tile)
so objects near a tile border still appear whole in at least one
neighboring tile.

## Files

- `Tile_512x512.ijm` — the macro. See the comment header inside for a
  detailed step-by-step explanation.
- `LICENSE.md` — MIT license.

## Requirements

- [ImageJ](https://imagej.net/) or [Fiji](https://fiji.sc/).

## Usage

1. Open `Tile_512x512.ijm` in the ImageJ/Fiji macro editor.
2. Edit the hardcoded paths at the top and in the `saveAs(...)` calls:
   - `filename` — path to the source image to tile.
   - the output directory used in the three `saveAs(...)` calls — must
     already exist, since the macro does not create directories.
3. Run the macro (Run in the macro editor).

Each tile is written three times, named after its top-left offset in the
source image: `<x>_<y>_0000.tif`, `<x>_<y>_0000.jpg`, `<x>_<y>_0000.png`.

## Known limitations

This macro was written for a few one-off tiling jobs and is kept here as-is
(unmodified, only documented) rather than generalized further:

- Tiles are only produced while the 512x512 window fully fits inside the
  image, so a strip of up to 511 px along the right and bottom edges is
  never covered and gets dropped.
- Tile size (512x512) and step size (256 px, i.e. 50% overlap) are
  hardcoded and coupled; changing one without the other changes the
  overlap fraction.
- No check is made that the source image is even larger than the tile
  size.
- Output paths are hardcoded and must be edited in the macro before each
  run.

## License

MIT, see [LICENSE.md](LICENSE.md).
