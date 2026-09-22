/*
 * Tile_512x512.ijm
 *
 * ImageJ/Fiji macro that splits one large image into a grid of overlapping
 * 512x512 tiles and saves each tile to disk as TIFF, JPG, and PNG.
 *
 * Use case: large images (e.g. whole-slide or aerial/satellite images) are
 * often too big to feed directly into tools such as YOLO for training or
 * inference. This macro cuts such an image into fixed-size tiles that are
 * small enough to process, using a sliding window with 50% overlap
 * (256 px stride for a 512 px tile) so that objects near tile borders
 * still appear whole in at least one neighboring tile.
 *
 * How it works:
 *   1. Open the source image and duplicate it as "master.png", which is
 *      kept untouched and used as the source for every crop.
 *   2. Slide a 512x512 window across the image in steps of 256 px, both
 *      horizontally (x) and vertically (y).
 *   3. For each window position, duplicate "master.png" again as
 *      "temp.png", crop it to the current window (x, y, xsize, ysize),
 *      and save the resulting tile in three formats, named after its
 *      top-left corner: "<x>_<y>_0000.<ext>".
 *   4. Close the temporary tile window before moving to the next position.
 *
 * Requirements / before running:
 *   - Update `filename` (line below) to point to the source image.
 *   - Update the output path in the saveAs(...) calls to an existing
 *     directory (the macro does not create directories automatically).
 *   - The output directory should be empty of unrelated files, since tiles
 *     are named only by their (x, y) offset and would otherwise collide.
 *
 * Known limitations:
 *   - Tiles are only produced while the window fully fits inside the
 *     image: the loop bounds `x < width - xsize` / `y < height - ysize`
 *     mean a strip of up to 511 px along the right and bottom edges is
 *     never covered and gets dropped.
 *   - xsize/ysize (tile size) and the loop step (overlap) are hardcoded
 *     below; edit them together if you need a different tile size or
 *     overlap fraction.
 *   - No check is made that width/height are larger than xsize/ysize.
 */

// Path to the large source image to be tiled.
filename = "/home/user/Images/Large_Image_0000.png"
open(filename)
getDimensions(width, height, channels, slices, frames)

// Keep an untouched full-size copy ("master.png") to crop each tile from,
// since cropping is destructive on the active image.
run("Duplicate...", "title=master.png");

// Tile size in pixels (width x height of each exported tile).
xsize=512
ysize=512

// Slide a 512x512 window over the image in 256 px steps (50% overlap) in
// both directions; each iteration produces one tile.
for (x=0;x<(width-xsize);x=x+256) {
    for (y=0;y<(height-ysize);y=y+256) {
        // Grab a fresh copy of the full image to crop for this tile...
        selectWindow("master.png");
        run("Duplicate...", "title=temp.png");
        selectWindow("temp.png");
        // ...and crop it down to the current window.
        makeRectangle(x,y, xsize, ysize);
        run("Crop");

        // Save the tile in three formats, named by its top-left offset
        // (x_y_0000) so tiles can be reassembled or matched back later.
        saveAs("Tiff", "/home/user/Images/temp/"+x+"_"+y+"_0000.tif");
        saveAs("jpg", "/home/user/Images/temp/"+x+"_"+y+"_0000.jpg");
        saveAs("png", "/home/user/Images/temp/"+x+"_"+y+"_0000.png");

        // Discard the temporary tile window before the next iteration.
        close();
    }
}
