a=import("\source.avs").subtitle("Source", align=9).trim(0,0)
b=ffvideosource("\mkvs\1.mkv").subtitle("Encode", align=9)

interleave(a,b)