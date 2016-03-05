clear all;clc;
sourcechoice = menu('Is the source from BluRay or DVD?','BluRay','DVD');

if sourcechoice == 1
    copyfile('BluRay.settings.bat','settings.bat');
else
    copyfile('DVD.settings.bat','settings.bat');
end

refchoice = menu('Choose the number of ref frames:','4','5','6','7','8','9','10','11','12','13','14');
ref=refchoice+3;
if refchoice ==0
    ref=9;
end
crfchoice = menu('Choose CRF:','14','14.5','15','15.5','16','16.5','17','17.5','18','18.5','19','19.5','20');


if crfchoice ==1
    crf=14;
    elseif crfchoice ==2
    crf=14.5;
    elseif crfchoice ==3
    crf=15;
    elseif crfchoice ==4
    crf=15.5;
    elseif crfchoice ==5
    crf=16;
    elseif crfchoice ==6
    crf=16.5;
    elseif crfchoice ==7
    crf=17;
    elseif crfchoice ==8
    crf=17.5;
    elseif crfchoice ==9
    crf=18;
    elseif crfchoice ==10
    crf=18.5;
    elseif crfchoice ==11
    crf=19;
    elseif crfchoice ==12
    crf=19.5;
    elseif crfchoice ==13
crf=20;
else
crf=17;
end

find_and_replace('settings.bat', '--ref 9', ['--ref ' num2str(ref)]);
find_and_replace('settings.bat', '--crf 17.0', ['--crf ' num2str(crf)]);
find_and_replace('settings.bat', 'PATH', strrep(pwd, '\', '\\'))

dos('settings.bat');
clc;
cd mkvs;
copyfile('batch.bat','batch.new.bat');
find_and_replace('batch.new.bat', 'PATH', strrep(pwd, '\', '\\'))
dos('batch.new.bat');clc;disp('Indexing pictures...')
cd ../;cd pngs;
movefile('../mkvs/*.png');
cd ../

DIR0=('-\pngs\*.png');
NOF0=('-\pngs\1.*.png');
myFolder0=('-\pngs');
SourceFolder0=('-\');
textfile0=('-\final_settings.txt');
textfile=strrep(textfile0, '-', pwd);

DIR=dir(strrep(DIR0, '-', pwd));
NOF=length(dir(strrep(NOF0, '-', pwd)));
myFolder=(strrep(myFolder0, '-', pwd));
SourceFolder=(strrep(SourceFolder0, '-', pwd));
filePattern = fullfile(myFolder, '*.png');
SourcefilePattern = fullfile(SourceFolder, '*.png');
pngFiles=dir(filePattern);
SourcepngFiles=dir(SourcefilePattern);
pngset=fullfile(myFolder, '-.mkv_*.png');
sourceset=fullfile(SourceFolder, 'source_*.png');
NOP=length(dir(fullfile(myFolder, '*.mkv_00001.png')));
for i=1:NOP
   for k=1:NOF    
        while 1
            pngsetnew=strrep(pngset, '-', num2str(i));
            pngfileset=dir(pngsetnew);
            if isempty(pngfileset) == 1
                Zeros(i,1:NOF)=0;
                i=i+1;                
            else
                break
            end
        end
    pngsetnew=strrep(pngset, '-', num2str(i));
    pngfileset=dir(pngsetnew);
    sourcefileset=dir(sourceset);
    baseFileName=pngfileset(k).name;   
    sourceFileName=sourcefileset(k).name;   
    fullPngName=fullfile(myFolder, baseFileName);
    fulldir(i,k)={fullPngName};
    fullSourceName=fullfile(SourceFolder, sourceFileName); 
    s=imread(fullSourceName);
    p=imread(fullPngName);
    D=imabsdiff(s,p);
    Zeros(i,k)=sum(D(:)==0);
   end
   clc;pause(0.0000001);fprintf('Matching pictures... %d percent',round(100*i/NOP))
end

Back=Zeros;
for l=1:NOP
    for m=1:NOF
    [num col] = max(Zeros(:,m));
    mat1(l,m)=num;
    mat2(l,m)=col;    
    Zeros(col,m)=-1;
    end
end

flipmat2=flipud(mat2);
for e=1:NOP
    sums(e)=sum(find(flipmat2==flipmat2(e,1)));
end
flipmat2(:,2:NOF)=[];
flipmat2(:,2)=sums;


Back2=flipmat2;
for f=1:NOP
    [num2 col2] = max(flipmat2(:,2));
    eikona(f)=flipmat2(col2,1);
    score(f)=num2;
    
 for f1=f
    mat1b(f,1)=eikona(f);   
 end   
 
  for f2=f
    mat1b(f,2)=score(f);   
  end   
    flipmat2(col2,2)=-1;
end


Back3=mat1b;
for f=1:5
    [top5(f) col3(f)] = max(mat1b(f,1));
    mat1b(f,1)=-1;
end

%//GET CORRECT LINES
fid=fopen('settings.bat');
q = textscan(fid, '%s', 'Delimiter', '\n');
first_setting=q{1}{top5(1)};
second_setting=q{1}{top5(2)};
third_setting=q{1}{top5(3)};
forth_setting=q{1}{top5(4)};
fifth_setting=q{1}{top5(5)};

%//WRITE CORRECT LINES
fid = fopen('final_settings.txt','wt');
fprintf(fid, '%s\n%s\n%s\n%s\n%s', first_setting, second_setting, third_setting, forth_setting, fifth_setting);
fclose(fid);

clc;
disp('The top 5 mkvs are:')
top5
disp('The top 5 settings are now printed in the file final_settings.txt on your directory.')
