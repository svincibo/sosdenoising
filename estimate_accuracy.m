% Scatter plot of denoised on x-axis and sense on y-axis.
% Draw line of equality.
% Fit a line to measure R2.
% Use R2 as a measure of how closely the denoising procedure got us back to
% the "gold standard" of sense.

clear all; clc;

% Set working directories.
rootDir = '/N/dc2/projects/lifebid/development/sos_denoising/';

% Set bl project id.
blprojectid = 'proj-5dc304237f55b8913bbd4cfd/';

sub = {'sub-001', 'sub-002', 'sub-003', 'sub-004'};

for i = 1:length(sub)
    
    % Read in the sos-denoised data trained with 1000 iterations.
    denoised_1 = niftiRead(fullfile(rootDir, blprojectid, [sub{i} '/denoised-first-APPAb0-train001-iter100-merged/dwi.nii.gz']));

    % Read in the sense data to use as baseline.
    sense_1 = niftiRead(fullfile(rootDir, blprojectid, [sub{i} '/dwi-first-sense-APPAb0/dwi.nii.gz']));
    sense_2 = niftiRead(fullfile(rootDir, blprojectid, [sub{i} '/dwi-second-sense-APPAb0/dwi.nii.gz']));
        
%     % Read in the first sense mask.
%     mask_1 = niftiRead(fullfile(rootDir, blprojectid, [sub{i} '/mask-first-sense-APPAb0/mask.nii.gz']));
%     mask = typecast(repmat(mask_1.data(:), [87 1]), 'single');
%     
%     % Apply mask.
%     denoised_1.data = denoised_1.data(:).*mask;
%     sense_1.data = sense_1.data(:).*mask;
%     sense_2.data = sense_2.data(:).*mask;

    figure(i)
    alpha = .4;
    x = sense_1.data(:); y = sense_2.data(:);
    c_baseline = corr(sense_1.data(:), sense_2.data(:));
    disp(['sense1-sense2: ' num2str(c_baseline, '%2.2f')])
    scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4940 0.1840 0.5560], 'MarkerFaceColor', [0.4940 0.1840 0.5560]) % purple, Subsample to make plotting faster, for now.
    % scatter(x, y, 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.9290 0.6940 0.1250], 'MarkerFaceColor', [0.9290 0.6940 0.1250]) % yellow, Subsample to make plotting faster, for now.
    hold on;
    [r_baseline, ~] = plotcorr2(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), [0.4940 0.1840 0.5560]);
    
    x = sense_1.data(:); y = denoised_1.data(:);
    c = corr(sense_1.data(:), denoised_1.data(:));
    disp(['sense1-sosdenoised1: ' num2str(c, '%2.2f')])
    scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880]) % green, Subsample to make plotting faster, for now.
    % scatter(x, y, 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.9290 0.6940 0.1250], 'MarkerFaceColor', [0.9290 0.6940 0.1250]) % yellow, Subsample to make plotting faster, for now.
    [r, ~] = plotcorr2(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), [0.4660 0.6740 0.1880]);
    
    % Plot line of equality
    xlim([0 14000]); ylim([0 14000]);
    plot(1:max(xlim)/10:max(xlim), 1:max(ylim)/10:max(ylim), 'k')
    legend({'sense1 and sense2 ', ['r = ' num2str(r_baseline, '%2.2f')], 'sense1 and sosdenoised1', ['r = ' num2str(r, '%2.2f')]}, 'Location', 'northwest')
    legend box off
    xlabel('sense'); ylabel('comparison image');
    title(sub{i})
    % xtickformat('%5.0f'); ytickformat('%7.0f');
    pbaspect([1 1 1])
    box off
    
    % Save figure.
    print(fullfile(rootDir, 'plots', ['plot_scatter_accuracy_' sub{i} 'merged']), '-dpng')
    %print(fullfile(rootDir, 'plots', 'eps', 'plot_scatter_compareiterations'), '-depsc')
    
    hold off;
    
    clear denoised_1 sense_1 sense_2
    
end
