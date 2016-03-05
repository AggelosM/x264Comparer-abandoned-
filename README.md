# x264Comparer
Automatically creates x264 test encodes and compares them with the source to find the best setting using MATLAB.

------------------DESCRIPTION:------------------

This script will make extremely easy for encoders to find what x264 settings give them the best results and transparency.
You'll end up with a text file giving you the top 5 x264 settings coming out from 1100 different tests from the following combinations:

--qcomp (0.60 to 0.80 by 0.05 increments)

--aq (-mode 1 to -mode 2)

--aq-strength (0.50 to 1 by 0.05 increments)

--psy-rd (0.90:0.00 to 1.15:0.00 by 0.05 increments)

--psy-rd (*:0.00 to *:0.10)

------------------WHAT YOU'LL NEED:------------------

1) MATLAB installed

2) AviSynth with plugins

3) AvsPmod

4) Know what CRF and REF frames you wish to use for your final encoding.

------------------HOW TO USE:------------------

1) Put all the files and folders in a folder, preferably your movie folder. Go to /mkvs and extract there the ffmpeg.zip

2) Edit source.avs by adding your video source with the desired cropping, fps, resolution and filters.

2) By using SelectRangeEvery choose 6-7 frames that you wish MATLAB to compare them with the source after the encoding. Choose some challenging ones (no black bars or few colors).

3) Press F5 and with right click Save Image As export each frame as png to your movie folder with the name "source_##.png"
4) Run RUN_THIS_ONLY.bat (give it a few seconds to initialize).

5) Follow the very simple instructions.

6) After about 20 or more minutes (depending on your machine, your source and how many frames you have choosen) a text will be created in your folder telling you what are the top 5 x264 settings that give the best results.

7) If you want open and edit comparison.avs to compare your source with the encodes (in the mkvs folder) which match the best settings (MATLAB will let you know what are these)

------------------NOTES:------------------

You can edit the *.settings.bat files by finding and replacing the following settings with your desired ones:

--deblock -2:-2
--partitions all
--me umh
--subme 9
--merange 24
--trellis 2
--8x8dct
--cqm flat
--deadzone-inter 21
--deadzone-intra 11
--no-fast-pskip
--threads 12
--lookahead-threads 1
--bframes 6
--b-pyramid normal
--b-adapt 2
--b-bias 0
--direct auto
--weightp 2
--keyint 250
--min-keyint 25
--scenecut 40
--rc-lookahead 50
--qpmin 0
--qpmax 69
--qpstep 4
--ipratio 1.40
--chroma-qp-offset 0

DO NOT CHANGE THE --CRF OR THE --REF settings. MATLAB will ask to fix these for you.

You can find all the tests from best to worst if you load and run the script directly from MATLAB, inside the "Back3" matrix in the first column.

The more frames you use in your source.avs script, the more accurate the result will be, but it will take much longer for many frames.
