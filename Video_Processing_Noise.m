%% Processing Noises in two
close all;
%% Analysis for absence of optical signal
% dark_stat = load("Dark_Image\2024-10-02 16.09_videoMetadata.mat");
% dark_ROI = load("Dark_Image\2024-10-02 16.09 video_ROItimeSeries.mat");
% dark_video = VideoReader("Dark_Image\2024-10-02 16.09 video.mj2");
dark_video = VideoReader("Constant_Light_Source.mj2");
% expecting every thing to be 0 for= all pixel since not optical signal
% comming

frameRate = dark_video.FrameRate;
duration = dark_video.Duration;
width = dark_video.Width;
height = dark_video.Height;

fprintf('Frame Rate: %.2f fps\n', frameRate);
fprintf('Duration: %.2f seconds\n', duration);
fprintf('Resolution: %dx%d\n', width, height);

numFrames = floor(dark_video.Duration * dark_video.FrameRate); % Total number of frames
std_per_frame = zeros(numFrames, 1);
SNR_per_frame = zeros(numFrames,1);
frameIndex = 1; 

standard_val = readFrame(dark_video);
while hasFrame(dark_video)
    frame = readFrame(dark_video); 
    
    frame_pixels = reshape(frame, [], size(frame, 3));  % Flatten the frame into a 2D matrix
    
    std_per_frame(frameIndex) = std(double(frame_pixels(:)));  
    SNR_per_frame(frameIndex) = snr(single(standard_val),single(frame));
    frameIndex = frameIndex + 1;  
end

figure;
subplot(2,1,1);
plot(std_per_frame);
xlabel('Frame Number');
ylabel('Standard Deviation');
title('Standard Deviation of Pixel Values per Frame');

subplot(2,1,2);
plot(SNR_per_frame);
xlabel('Frame Number');
ylabel('SNR');
title('SNR of Pixel Values per Frame');





%% constant light source
% row and col of interest.
% col = round(width/3);
% row = round(height/3);
% 
% frameCount = 0;
% rgb_changes = []; 
% 
% while hasFrame(dark_video)
%     frame = readFrame(dark_video);  
%     pixel_rgb = squeeze(frame(row, col, :));  % Extract RGB values for the pixel
%     rgb_changes = [rgb_changes; pixel_rgb'];
%     frameCount = frameCount + 1;
% end
% 
% bit_changes = zeros(size(rgb_changes)); 
% %reading the changees in bit
% for i = 2:frameCount
%     prev_rgb_bin = dec2bin(rgb_changes(i-1,:), 8); 
%     curr_rgb_bin = dec2bin(rgb_changes(i,:), 8);    
%     bit_changes(i,:) = sum(prev_rgb_bin ~= curr_rgb_bin, 2);
% end
% 
% figure;
% plot(1:frameCount, bit_changes(:, 1), 'r', 'DisplayName', 'Red Channel');
% hold on;
% plot(1:frameCount, bit_changes(:, 2), 'g', 'DisplayName', 'Green Channel');
% plot(1:frameCount, bit_changes(:, 3), 'b', 'DisplayName', 'Blue Channel');
% xlabel('Frame Number');
% ylabel('Bit Changes');
% title('Bit Changes in RGB Values Across Frames');
% legend show;
% hold off;





