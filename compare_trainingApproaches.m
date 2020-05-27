% Scatter plot of denoised on x-axis and sense on y-axis.
% Draw line of equality.
% Fit a line to measure R2.
% Use R2 as a measure of how closely the denoising procedure got us back to
% the "gold standard" of sense.

clear all; clc;

% Set working directories.
rootDir = '/N/dc2/projects/lifebid/development/sosdenoising/';

% Set bl project id.
blprojectid = 'proj-5dc304237f55b8913bbd4cfd/';

% Read in the sense data to use as baseline.
sense_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/dwi-first-sense-APPAb0/dwi.nii.gz'));
sense_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/dwi-first-sense-APPAb0/dwi.nii.gz'));
sense_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/dwi-first-sense-APPAb0/dwi.nii.gz'));
sense_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/dwi-first-sense-APPAb0/dwi.nii.gz'));
sense_panel = corr(cat(2, sense_sub001.data(:), sense_sub002.data(:), sense_sub003.data(:), sense_sub004.data(:)));
sense = repmat(sense_panel, [4 4]);

%% 1. Do the results change with the number of iterations performed in the training procedure?
% METHOD: Equality plot and comparison of the correlation between sos-denoised and sense data between levels of iterations. 
% If the efficacy of the denoising changes with the number of iterations, then
% we should see a shift in the scatter of the data in the equality plot and
% we should see differences in the sos-denoised to sense correaltions between levels of iterations.

% Read in the sos-denoised data trained with 100 iterations.
denoised_iter100 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train001-iter100/dwi.nii.gz'));
% Read in the sos-denoised data trained with 1000 iterations.
denoised_iter1000 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train001-iter1000/dwi.nii.gz'));
% Read in the sos-denoised data trained with 1500 iterations.
denoised_iter1500 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train001-iter1500/dwi.nii.gz'));
% Read in the sos-denoised data trained with 2000 iterations.
denoised_iter2000 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train001-iter2000/dwi.nii.gz'));

% % Get this subject's mask.
% mask = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/mask-first-sense-APPAb0/mask.nii.gz'));

figure(1)
% 1000 iterations
alpha = .4;
x = denoised_iter1000.data(:); y = sense_sub001.data(:); 
scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.9290 0.6940 0.1250], 'MarkerFaceColor', [0.9290 0.6940 0.1250]) % yellow, Subsample to make plotting faster, for now.
% scatter(x, y, 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.9290 0.6940 0.1250], 'MarkerFaceColor', [0.9290 0.6940 0.1250]) % yellow, Subsample to make plotting faster, for now.
hold on;
c = corr(x, y);
disp(['Correlation between sos-denoised and sense at iter-1000: ' num2str(c)])

% 1500 iterations
x = denoised_iter1500.data(:); y = sense_sub001.data(:); 
scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4940 0.1840 0.5560], 'MarkerFaceColor', [0.4940 0.1840 0.5560]) % purple, Subsample to make plotting faster, for now.
% scatter(x, y, 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4940 0.1840 0.5560], 'MarkerFaceColor', [0.4940 0.1840 0.5560]) % purple, Subsample to make plotting faster, for now.
c = corr(x, y);
disp(['Correlation between sos-denoised and sense at iter-1500: ' num2str(c)])

% 2000 iterations
x = denoised_iter2000.data(:); y = sense_sub001.data(:); 
scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880]) % green, Subsample to make plotting faster, for now.
% scatter(x, y, 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880]) % green, Subsample to make plotting faster, for now.
c = corr(x, y);
disp(['Correlation between sos-denoised and sense at iter-2000: ' num2str(c)])

% 100 iterations
x = denoised_iter100.data(:); y = sense_sub001.data(:); 
scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [1 0 0], 'MarkerFaceColor', [1 0 0]) % red, Subsample to make plotting faster, for now.
% scatter(x, y, 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880]) % green, Subsample to make plotting faster, for now.
c = corr(x, y);
disp(['Correlation between sos-denoised and sense at iter-100: ' num2str(c)])

% Plot line of equality
xlim([0 14000]); ylim([0 14000]);
plot(1:max(xlim)/10:max(xlim), 1:max(ylim)/10:max(ylim), 'k')
legend({'iter-1000', 'iter-1500', 'iter-2000', 'iter-100'}, 'Location', 'northwest')
legend box off
xlabel('sos-denoised'); ylabel('sense');
% xtickformat('%5.0f'); ytickformat('%7.0f');
title({'Comparison of corrections'; 'among different iterations of training'})
pbaspect([1 1 1])
box off

% Save figure.
print(fullfile(rootDir, 'plots', 'plot_scatter_compareiterations'), '-dpng')
%print(fullfile(rootDir, 'plots', 'eps', 'plot_scatter_compareiterations'), '-depsc')

hold off;

% 2. Does the procedure make all subjects look like the subject on which the model was trained?
% METHOD: Cross-correlation matrix among values obtained by within- vs. between-subjects training datasets.
% If there is a bias towards making all corrections look like the training data set, 
% then we would expect that correlations will be higher 
% among sos-denoised datasets that were corrected using training data from the same subject than
% among sos-denoised data sets that were corrected using training data from different subjects.

% Read in the sos-denoised data trained with sub-001.
denoised_train001_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train001-iter100/dwi.nii.gz'));
denoised_train001_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train001-iter100/dwi.nii.gz'));
denoised_train001_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train001-iter100/dwi.nii.gz'));
denoised_train001_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train001-iter100/dwi.nii.gz'));

% Read in the sos-denoised data trained with sub-002.
denoised_train002_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train002-iter100/dwi.nii.gz'));
denoised_train002_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train002-iter100/dwi.nii.gz'));
denoised_train002_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train002-iter100/dwi.nii.gz'));
denoised_train002_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train002-iter100/dwi.nii.gz'));

% Read in the sos-denoised data trained with sub-003.
denoised_train003_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train003-iter100/dwi.nii.gz'));
denoised_train003_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train003-iter100/dwi.nii.gz'));
denoised_train003_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train003-iter100/dwi.nii.gz'));
denoised_train003_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train003-iter100/dwi.nii.gz'));

% Read in the sos-denoised data trained with sub-004.
denoised_train004_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train004-iter100/dwi.nii.gz'));
denoised_train004_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train004-iter100/dwi.nii.gz'));
denoised_train004_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train004-iter100/dwi.nii.gz'));
denoised_train004_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train004-iter100/dwi.nii.gz'));

c_all = corr(cat(2, denoised_train001_sub001.data(:), denoised_train001_sub002.data(:), denoised_train001_sub003.data(:), denoised_train001_sub004.data(:), ...
denoised_train002_sub001.data(:), denoised_train002_sub002.data(:), denoised_train002_sub003.data(:), denoised_train002_sub004.data(:), ...
denoised_train003_sub001.data(:), denoised_train003_sub002.data(:), denoised_train003_sub003.data(:), denoised_train003_sub004.data(:), ...
denoised_train004_sub001.data(:), denoised_train004_sub002.data(:), denoised_train004_sub003.data(:), denoised_train004_sub004.data(:)));

figure(2)
temp = c_all-sense
imagesc(temp);
colormap parula
h = colorbar;
caxis([-.12 0.07]);
% caxis([0.75 1]);
h.Position = [0.84 0.19 0.015 0.7357];
pbaspect([1 1 1])
hold on;

%plot([0 4.5], [0 0], 'LineWidth', 3, 'Color', 'k')
plot([0 8.5], [4.5, 4.5], 'LineWidth', 3, 'Color', 'k')
plot([4.5 12.5], [8.5, 8.5], 'LineWidth', 3, 'Color', 'k')
plot([8.5 16.5], [12.5, 12.5], 'LineWidth', 3, 'Color', 'k')
plot([4.5, 4.5], [0 8.5], 'LineWidth', 3, 'Color', 'k')
plot([8.5, 8.5], [4.5 12.5], 'LineWidth', 3, 'Color', 'k')
plot([12.5, 12.5], [8.5 16.5], 'LineWidth', 3, 'Color', 'k')
%plot([0 0], [0 4.5], 'LineWidth', 3, 'Color', 'k')
pbaspect([1 1 1])

ax = gca;
ax.XTick = 1:16;
ax.XTickLabel = {'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'};
ax.XTickLabelRotation = 90;
ax.YTick = 1:16;
ax.YTickLabel = {'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'};
set(gca,'TickLength',[0 0])
ax2 = axes('Position',ax.Position,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
ax2.XTick = [0.15 0.4 0.65 0.9];
ax2.XTickLabel = {'trn-1'; 'trn-2'; 'trn-3'; 'trn-4'};
ax2.YTick = [0.15 0.4 0.65 0.9];
ax2.YTickLabel = {'trn-4'; 'trn-3'; 'trn-2'; 'trn-1'};
ax2.YTickLabelRotation = 90;

% colormap parula
% h = colorbar;
ylabel(h, 'Correlation')
% caxis([min(c_all(:)-sense(:)) 1])

title('sos-denoised and sos-denoised correlations')
pbaspect([1 1 1])
box off 

% Save figure.
print(fullfile(rootDir, 'plots', 'plot_corrmat_iter100_sensethresholded'), '-dpng')
%print(fullfile(rootDir, 'plots', 'eps', 'plot_matrix_crosscorrelations'), '-depsc')

hold off;

%% 3. Is training with more subjects better than training with one? Does R2 increase as from sub-001 to sub-001002, sub001002003, and sub-001002003004?

denoised_train001_allsub = cat(1, denoised_train001_sub001.data(:), denoised_train001_sub002.data(:), denoised_train001_sub003.data(:), denoised_train001_sub004.data(:));

% Read in the sos-denoised data trained with sub-001 and sub-002.
denoised_train001002_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train001002-iter100/dwi.nii.gz'));
denoised_train001002_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train001002-iter100/dwi.nii.gz'));
denoised_train001002_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train001002-iter100/dwi.nii.gz'));
denoised_train001002_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train001002-iter100/dwi.nii.gz'));
denoised_train001002_allsub = cat(1, denoised_train001002_sub001.data(:), denoised_train001002_sub002.data(:), denoised_train001002_sub003.data(:), denoised_train001002_sub004.data(:)); 

% Read in the sos-denoised data trained with sub-001 and sub-002 and sub-003.
denoised_train001002003_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train001002003-iter100/dwi.nii.gz'));
denoised_train001002003_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train001002003-iter100/dwi.nii.gz'));
denoised_train001002003_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train001002003-iter100/dwi.nii.gz'));
denoised_train001002003_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train001002003-iter100/dwi.nii.gz'));
denoised_train001002003_allsub = cat(1, denoised_train001002003_sub001.data(:), denoised_train001002003_sub002.data(:), denoised_train001002003_sub003.data(:), denoised_train001002003_sub004.data(:)); 

% Read in the sos-denoised data trained with sub-001 and sub-002 and sub-003 and sub-004.
denoised_train001002003004_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train001002003004-iter100/dwi.nii.gz'));
denoised_train001002003004_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train001002003004-iter100/dwi.nii.gz'));
denoised_train001002003004_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train001002003004-iter100/dwi.nii.gz'));
denoised_train001002003004_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train001002003004-iter100/dwi.nii.gz'));
denoised_train001002003004_allsub = cat(1, denoised_train001002003004_sub001.data(:), denoised_train001002003004_sub002.data(:), denoised_train001002003004_sub003.data(:), denoised_train001002003004_sub004.data(:)); 

% Sense data.
sense_allsub = cat(1, sense_sub001.data(:), sense_sub002.data(:), sense_sub003.data(:), sense_sub004.data(:));

figure(3)
% 1000 iterations
alpha = .4;
x = denoised_train001_allsub; y = sense_allsub; 
scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.9290 0.6940 0.1250], 'MarkerFaceColor', [0.9290 0.6940 0.1250]) % yellow, Subsample to make plotting faster, for now.
% scatter(x, y, 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.9290 0.6940 0.1250], 'MarkerFaceColor', [0.9290 0.6940 0.1250]) % yellow, Subsample to make plotting faster, for now.
hold on;
c = corr(x, y);
disp(['Correlation between sos-denoised and sense at train-001: ' num2str(c)])

% 1000 iterations
x = denoised_train001002_allsub;
scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4940 0.1840 0.5560], 'MarkerFaceColor', [0.4940 0.1840 0.5560]) % purple, Subsample to make plotting faster, for now.
% scatter(x, y, 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4940 0.1840 0.5560], 'MarkerFaceColor', [0.4940 0.1840 0.5560]) % purple, Subsample to make plotting faster, for now.
c = corr(x, y);
disp(['Correlation between sos-denoised and sense at train-001002: ' num2str(c)])

% 1000 iterations
x = denoised_train001002003_allsub;
scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880]) % green, Subsample to make plotting faster, for now.
% scatter(x, y, 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880]) % green, Subsample to make plotting faster, for now.
c = corr(x, y);
disp(['Correlation between sos-denoised and sense at train-001002003: ' num2str(c)])

% 1000 iterations
x = denoised_train001002003004_allsub;
scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.6350 0.0780 0.1840], 'MarkerFaceColor', [0.4660 0.6740 0.1880]) % green, Subsample to make plotting faster, for now.
% scatter(x, y, 'Marker', '.', 'MarkerEdgeAlpha', alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880]) % green, Subsample to make plotting faster, for now.
c = corr(x, y);
disp(['Correlation between sos-denoised and sense at train-001002003004: ' num2str(c)])

% Plot line of equality
xlim([0 14000]); ylim([0 14000]);
plot(1:max(xlim)/10:max(xlim), 1:max(ylim)/10:max(ylim), 'k')
legend({'trn-1', 'trn-12', 'trn-123', 'trn-1234'}, 'Location', 'northwest')
legend box off
xlabel('sos-denoised'); ylabel('sense');
% xtickformat('%5.0f'); ytickformat('%7.0f');
title({'Comparison of corrections'; 'among different num subs in training'})
pbaspect([1 1 1])
box off

% Save figure.
% print(fullfile(rootDir, 'plots', 'plot_scatter_comparenumsubs'), '-dpng')
%print(fullfile(rootDir, 'plots', 'eps', 'plot_scatter_compareiterations'), '-depsc')

hold off;
