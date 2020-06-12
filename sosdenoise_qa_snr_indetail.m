% This script reads in SNR values and plots them according to session (pre-
% vs post-training) and group (expert=3, beginner=2, control=1).

clear all; close all; clc
format shortG


% Set working directories.
rootDir = '/Volumes/240/sosdenoising/';

% Get bl project foldername.
blprojectid = 'proj-5ee1659ec5972b1b5fb443d3';

subs = {'sub-002', 'sub-003', 'sub-004'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load in snr b0 measures.  
count = 0;
for s = 1:length(subs)
    
    % Get subID.
    subID{s} = subs{s}; 
       
    % Get SNR for sos1.
    count = count + 1;
    snr_sos1 = jsondecode(fileread(fullfile(rootDir, blprojectid, subID{s}, '/dt-raw.tag-snr-cc.id-first-sos/output/snr.json')));
    b0_sos1(s) = str2num(snr_sos1.SNRInB0_X_Y_Z{1});
    m_sos1(s) = mean([str2num(snr_sos1.SNRInB0_X_Y_Z{2}), str2num(snr_sos1.SNRInB0_X_Y_Z{3}), str2num(snr_sos1.SNRInB0_X_Y_Z{4})]);
    sd_m_sos1(s) = std([str2num(snr_sos1.SNRInB0_X_Y_Z{2}), str2num(snr_sos1.SNRInB0_X_Y_Z{3}), str2num(snr_sos1.SNRInB0_X_Y_Z{4})]);
    snr_group(count) = 1; %sos1
    
    % Get SNR for sense1.
    count = count + 1;
    snr_sense1 = jsondecode(fileread(fullfile(rootDir, blprojectid, subID{s}, '/dt-raw.tag-snr-cc.id-first-sense/output/snr.json')));
    b0_sense1(s) = str2num(snr_sense1.SNRInB0_X_Y_Z{1});
    m_sense1(s) = mean([str2num(snr_sense1.SNRInB0_X_Y_Z{2}), str2num(snr_sense1.SNRInB0_X_Y_Z{3}), str2num(snr_sense1.SNRInB0_X_Y_Z{4})]);
    sd_m_sense1(s) = std([str2num(snr_sense1.SNRInB0_X_Y_Z{2}), str2num(snr_sense1.SNRInB0_X_Y_Z{3}), str2num(snr_sense1.SNRInB0_X_Y_Z{4})]);
    snr_group(count) = 2; %sense1
    
    % Get SNR for sense2.
    count = count + 1;
    snr_sense2 = jsondecode(fileread(fullfile(rootDir, blprojectid, subID{s}, '/dt-raw.tag-snr-cc.id-second-sense/output/snr.json')));
    b0_sense2(s) = str2num(snr_sense2.SNRInB0_X_Y_Z{1});
    m_sense2(s) = mean([str2num(snr_sense2.SNRInB0_X_Y_Z{2}), str2num(snr_sense2.SNRInB0_X_Y_Z{3}), str2num(snr_sense2.SNRInB0_X_Y_Z{4})]);
    sd_m_sense2(s) = std([str2num(snr_sense2.SNRInB0_X_Y_Z{2}), str2num(snr_sense2.SNRInB0_X_Y_Z{3}), str2num(snr_sense2.SNRInB0_X_Y_Z{4})]);
    snr_group(count) = 3; %sense2
    
    lab{count} = subs{s};
        
end
     
% Concatenate for plotting.
m = [m_sos1 m_sense1 m_sense2];
b0 = [b0_sos1 b0_sense1 b0_sense2];
sd = [sd_m_sos1 sd_m_sense1 sd_m_sense2];

figure
hold on;
capsize = 0;
marker = 'o';
linewidth = 1.5;
linestyle = 'none';
markersize = 10;
fontname = 'Arial';
fontsize = 20;
fontangle = 'italic';
xticklength = 0;
alphablend = .8;
yc_color = [0.6350 0.0780 0.1840]; %red
oc_color = [0 0.4470 0.7410]; %blue
a_color = [0.41176 0.41176 0.41176]; %gray

gscatter(m, 1:size(m, 2), snr_group, [yc_color; oc_color; a_color], '.', 20)
hold on;
gscatter(b0, 1:size(b0, 2), snr_group, [yc_color; oc_color; a_color], 'x', 10)

for p = 1:length(m)
    
    if snr_group(p) == 1
        
        plot([m(p) - abs(sd(p)) m(p) + abs(sd(p))], [p p], 'Color', yc_color)
        
    elseif snr_group(p) == 2
        
        plot([m(p) - abs(sd(p)) m(p) + abs(sd(p))], [p p], 'Color', oc_color)
        
    elseif snr_group(p) == 3
        
        plot([m(p) - abs(sd(p)) m(p) + abs(sd(p))], [p p], 'Color', a_color)
              
    end
    
end

% xaxis
xax = get(gca, 'xaxis');
xax.Limits = [5 65];
xax.TickValues = floor(min([b0 m - sd])):10:ceil(max([b0 m + sd]));
xax.TickDirection = 'out';
xax.TickLength = [xticklength xticklength];
xax.FontName = fontname;
xax.FontSize = fontsize;
xax.FontAngle = fontangle;

% yaxis
yax = get(gca,'yaxis');
yax.Limits = [0 10];
yax.TickValues = 2:3:length(lab);
yax.TickDirection = 'out';
yax.TickLabels = subID;
yax.FontName = fontname;
yax.FontSize = fontsize;

% general
a = gca;
%     a.TitleFontWeight = 'normal';
box off

legend({'sos1', 'sense1', 'sense2'}, 'Location', 'southeast');
legend box off

a.XLabel.String = 'SNR';
a.XLabel.FontSize = fontsize;
pbaspect([1 1 1])

print(fullfile(rootDir, 'plots', 'plot_snr'), '-dpng')

hold off;