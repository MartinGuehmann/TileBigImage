filename = "/home/user/Images/Large_Image_0000.png"
open(filename)
getDimensions(width, height, channels, slices, frames)
run("Duplicate...", "title=master.png");
xsize=512
ysize=512

for (x=0;x<(width-xsize);x=x+256) {
    for (y=0;y<(height-ysize);y=y+256) {
        selectWindow("master.png");
        run("Duplicate...", "title=temp.png");
        selectWindow("temp.png");
        makeRectangle(x,y, xsize, ysize);
        run("Crop");

        saveAs("Tiff", "/home/user/Images/temp/"+x+"_"+y+"_0000.tif");
        saveAs("jpg", "/home/user/Images/temp/"+x+"_"+y+"_0000.jpg");
        saveAs("png", "/home/user/Images/temp/"+x+"_"+y+"_0000.png");

        close();
    }
}
