%% Timing consistency
% Load the video file
videoObj = VideoReader("2024-10-01 13.50 video.mj2");


frameRate = videoObj.FrameRate;
expected_interval = 1 / frameRate;  

timestamps = zeros(floor(videoObj.Duration * videoObj.FrameRate), 1);
frameIndex = 1;

while hasFrame(videoObj)
    readFrame(videoObj);  
    timestamps(frameIndex) = videoObj.CurrentTime;  
    frameIndex = frameIndex + 1;
end

time_differences = diff(timestamps);

figure;
plot(time_differences);
hold on;
yline(expected_interval, '--r', 'Expected Interval');
xlabel('Frame Number');
ylabel('Time Difference (s)');
title('Frame-to-Frame Timing Consistency');
