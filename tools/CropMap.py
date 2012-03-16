import os, shutil, glob
for file in glob.glob("*.jpg"):
    print "processing %s..." % file
    try:
        shutil.rmtree(file[:-4])
    except:
        pass
    os.mkdir(file[:-4])
    os.system("convert.exe -crop 512x512 -quality 75%% -scene 1 %s %s\%%d.jpg" % (file, file[:-4]))