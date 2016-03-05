%REPLACE WITH THE RIGHT FILES/VALUES

MPEG2Source(\DVD.d2v", cpu=0)
TFM(d2v="\DVD.d2v", clip2=QTGMC().SelectEven())

%OR

FFVideoSource("\REMUX.mkv")


Crop(2, 0, -2, -0)
Spline36Resize(1024,576)
SelectRangeEvery(17450,1,2600)