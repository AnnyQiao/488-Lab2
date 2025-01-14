function ROItimeSeries = videoROIs2timeSeries(varargin)
%function ROItimeSeries = videoROIs2timeSeries 
% Pull time-series amplitude data from video
%   videoROIs2timeSeries(filepathname) queries the user for specific
%   pixel(s) in a video to extract time-series amplitude data from. It
%   saves these data to a file and into
%   ROItimeSeries(pixelIdx,frameNum,colorChannel), an NxMx3 array
% 2024-09: Written for ESE 488, by Matthew Lew

close all;

%% parameters
debug = true;
ROIradius = 0;  % grab ROI that includes center pixel +/- ROIradius

if nargin==1
    [infilepath,infilename,infileext] = fileparts(varargin);
else
    [file,location] = uigetfile({'*.mp4';'*.mj2';'*.*'},'Open video file for analysis');
    [infilepath,infilename,infileext] = fileparts([location file]);
end
v = VideoReader([infilepath filesep infilename  infileext]);
outfilePrefix = infilename + "_ROItimeSeries";

%% open video, ask user for ROIs

% create figure window that matches video size
figure('Position',[50 50 v.Width v.Height],"Color","black","DefaultAxesFontSize",20,"DefaultAxesXColor","white","DefaultAxesYColor","white","DefaultAxesColor","black");
axVideo = axes('position',[0 0 1 1]);
hImage = image(zeros(v.Height, v.Width, 3),"Parent",axVideo);
axis(axVideo,"image","off");
hText = text(0,0,"Frame #",...
        'color','g','FontSize',12,'VerticalAlignment','top','parent',axVideo);

% read initial frame
img = readFrame(v);

hImage.CData = img;
hText.String = "Click the center of each ROI, then press 'Return'.";
[ROIx,ROIy] = ginput;
ROIx = round(ROIx);       % round to the nearest pixel
ROIy = round(ROIy);

% mark ROI locations
hold on;
plot(ROIx,ROIy,'o');

%% read remaining frames
frameNum=1;
ROItimeSeries = zeros(size(ROIx,1),v.NumFrames,3);    % ROIs x frames x 3 colors

% read video, output data files
while v.hasFrame
    % calculate ROI mean values
    for a=1:size(ROIx,1)
        ROItimeSeries(a,frameNum,:) = mean(img(ROIy(a)+(-ROIradius:ROIradius),...
                                               ROIx(a)+(-ROIradius:ROIradius),:),[1 2],"double");
    end

    if v.hasFrame  
        % read next frame
        img = readFrame(v);
        frameNum=frameNum+1;
    
        % debug: show video being read
        if debug
            hImage.CData = img;
            hText.String = "Frame " + num2str(frameNum);
            drawnow limitrate nocallbacks;
        end
    end
end

% write data
save(outfilePrefix + ".mat","ROItimeSeries","ROIx","ROIy","infilepath","infilename","infileext");

%% plot ROI intensities
legendText="(" + num2str(ROIx) + "," + num2str(ROIy) + ")";

figure;
plot(ROItimeSeries(:,:,1)');
legend(legendText,"Location","best");
xlabel("Frame number");
ylabel("R values");
axis tight;

figure;
plot(ROItimeSeries(:,:,2)');
legend(legendText,"Location","best");
xlabel("Frame number");
ylabel("G values");
axis tight;

figure;
plot(ROItimeSeries(:,:,1)');
legend(legendText,"Location","best");
xlabel("Frame number");
ylabel("B values");
axis tight;
end