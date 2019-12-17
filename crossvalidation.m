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

% Read in the sense data to use as baseline.
sense_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/dwi-first-sense-APPAb0/dwi.nii.gz'));
sense_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/dwi-first-sense-APPAb0/dwi.nii.gz'));
sense_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/dwi-first-sense-APPAb0/dwi.nii.gz'));
sense_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/dwi-first-sense-APPAb0/dwi.nii.gz'));
sense_panel = corr(cat(2, sense_sub001.data(:), sense_sub002.data(:), sense_sub003.data(:), sense_sub004.data(:)));

%% Leave-one out

sense = repmat(sense_panel, [4 4]);

% 1. Train on 001-002-003, apply to 001, apply to 002, apply to 003, apply to *004*

denoised_train001002_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train001002003-iter1000/dwi.nii.gz'));
denoised_train001002_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train001002003-iter1000/dwi.nii.gz'));
denoised_train001002_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train001002003-iter1000/dwi.nii.gz'));
denoised_train001002_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train001002003-iter1000/dwi.nii.gz'));

% 2. Train on 002-003-004, apply to *001*, apply to 002, apply to 003, apply to 004

denoised_train001003_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train002003004-iter1000/dwi.nii.gz'));
denoised_train001003_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train002003004-iter1000/dwi.nii.gz'));
denoised_train001003_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train002003004-iter1000/dwi.nii.gz'));
denoised_train001003_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train002003004-iter1000/dwi.nii.gz'));

% 3. Train on 003-004-001, apply to 001, apply to *002*, apply to 003, apply to 004

denoised_train001004_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train003004001-iter1000/dwi.nii.gz'));
denoised_train001004_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train003004001-iter1000/dwi.nii.gz'));
denoised_train001004_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train003004001-iter1000/dwi.nii.gz'));
denoised_train001004_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train003004001-iter1000/dwi.nii.gz'));

% 4. Train on 004-001-002, apply to 001, apply to 002, apply to *003*, apply to 004

denoised_train002003_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train004001002-iter1000/dwi.nii.gz'));
denoised_train002003_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train004001002-iter1000/dwi.nii.gz'));
denoised_train002003_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train004001002-iter1000/dwi.nii.gz'));
denoised_train002003_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train004001002-iter1000/dwi.nii.gz'));

% % Sub-sample to reduce memory consumption.
% subsample = 1:2:size(denoised_train002003_sub004.data(:), 1);
% subsample = subsample';

% Assess cross-correlations for sos-denoised.
c_all = corr(cat(2, denoised_train001002_sub001.data(:), denoised_train001002_sub002.data(:), denoised_train001002_sub003.data(:), denoised_train001002_sub004.data(:), ...
denoised_train001003_sub001.data(:), denoised_train001003_sub002.data(:), denoised_train001003_sub003.data(:), denoised_train001003_sub004.data(:), ...
denoised_train001004_sub001.data(:), denoised_train001004_sub002.data(:), denoised_train001004_sub003.data(:), denoised_train001004_sub004.data(:), ...
denoised_train002003_sub001.data(:), denoised_train002003_sub002.data(:), denoised_train002003_sub003.data(:), denoised_train002003_sub004.data(:)));

figure(1)
temp = c_all-sense;
imagesc(temp);
colormap parula
h = colorbar;
caxis([-0.12 0.07]);
h.Position = [0.90 0.19 0.015 0.7357];
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
ax2.XTickLabel = {'trn-123'; 'trn-234'; 'trn-341'; 'trn-412'};
ax2.YTick = [0.15 0.4 0.65 0.9];
ax2.YTickLabel = {'trn-412'; 'trn-341'; 'trn-234'; 'trn-123'};
ax2.YTickLabelRotation = 90;

% colormap parula
% h = colorbar;
% ylabel(h, 'Correlation')
% h.Position = [0.84 0.19 0.015 0.7357];
% caxis([min(c_all(:)) 1])

title('sos-denoised and sos-denoised correlation, sense tresholded')
pbaspect([1 1 1])
box off 

% Save figure.
print(fullfile(rootDir, 'plots', 'plot_crossvalidation_leaveoneout_sensethresholded'), '-dpng')
%print(fullfile(rootDir, 'plots', 'eps', 'plot_matrix_crosscorrelations'), '-depsc')

hold off;

%% Split-half

clear sense
sense = repmat(sense_panel, [6 6]);

% 1. Train on 001-002, apply to 001, apply to 002, apply to *003*, apply to *004*

denoised_train001002_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train001002-iter1000/dwi.nii.gz'));
denoised_train001002_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train001002-iter1000/dwi.nii.gz'));
denoised_train001002_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train001002-iter1000/dwi.nii.gz'));
denoised_train001002_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train001002-iter1000/dwi.nii.gz'));

% 2. Train on 001-003, apply to *001*, apply to *002*, apply to 003, apply to 004

denoised_train001003_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train001003-iter1000/dwi.nii.gz'));
denoised_train001003_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train001003-iter1000/dwi.nii.gz'));
denoised_train001003_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train001003-iter1000/dwi.nii.gz'));
denoised_train001003_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train001003-iter1000/dwi.nii.gz'));

% 3. Train on 001-004, apply to 001, apply to *002*, apply to *003*, apply to 004

denoised_train001004_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train001004-iter1000/dwi.nii.gz'));
denoised_train001004_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train001004-iter1000/dwi.nii.gz'));
denoised_train001004_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train001004-iter1000/dwi.nii.gz'));
denoised_train001004_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train001004-iter1000/dwi.nii.gz'));

% 4. Train on 002-003, apply to 001, apply to *002*, apply to *003*, apply to 004

denoised_train002003_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train002003-iter1000/dwi.nii.gz'));
denoised_train002003_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train002003-iter1000/dwi.nii.gz'));
denoised_train002003_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train002003-iter1000/dwi.nii.gz'));
denoised_train002003_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train002003-iter1000/dwi.nii.gz'));

% 5. Train on 002-004, apply to 001, apply to *002*, apply to 003, apply to *004*

denoised_train002004_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train002004-iter1000/dwi.nii.gz'));
denoised_train002004_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train002004-iter1000/dwi.nii.gz'));
denoised_train002004_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train002004-iter1000/dwi.nii.gz'));
denoised_train002004_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train002004-iter1000/dwi.nii.gz'));

% 6. Train on 003-004, apply to 001, apply to 002, apply to *003*, apply to *004*

denoised_train003004_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/denoised-first-APPAb0-train003004-iter1000/dwi.nii.gz'));
denoised_train003004_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/denoised-first-APPAb0-train003004-iter1000/dwi.nii.gz'));
denoised_train003004_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/denoised-first-APPAb0-train003004-iter1000/dwi.nii.gz'));
denoised_train003004_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/denoised-first-APPAb0-train003004-iter1000/dwi.nii.gz'));

% % Sub-sample to reduce memory consumption.
% subsample = 1:2:size(denoised_train001004_sub004.data(:), 1);
% subsample = subsample';

% Assess cross-correlations for sos-denoised, subsample data.
clear c_all
c_all = corr(cat(2, denoised_train001002_sub001.data(:), denoised_train001002_sub002.data(:), denoised_train001002_sub003.data(:), denoised_train001002_sub004.data(:), ...
denoised_train001003_sub001.data(:), denoised_train001003_sub002.data(:), denoised_train001003_sub003.data(:), denoised_train001003_sub004.data(:), ...
denoised_train001004_sub001.data(:), denoised_train001004_sub002.data(:), denoised_train001004_sub003.data(:), denoised_train001004_sub004.data(:), ...
denoised_train002003_sub001.data(:), denoised_train002003_sub002.data(:), denoised_train002003_sub003.data(:), denoised_train002003_sub004.data(:), ...
denoised_train002004_sub001.data(:), denoised_train002004_sub002.data(:), denoised_train002004_sub003.data(:), denoised_train002004_sub004.data(:), ...
denoised_train003004_sub001.data(:), denoised_train003004_sub002.data(:), denoised_train003004_sub003.data(:), denoised_train003004_sub004.data(:)));

figure(2)
temp = c_all-sense;
imagesc(temp);
colormap parula
h = colorbar;
caxis([-0.12 0.07]);
h.Position = [0.90 0.19 0.015 0.7357];
pbaspect([1 1 1])
hold on;

% x
%plot([0 4.5], [0 0], 'LineWidth', 3, 'Color', 'k')
plot([0 8.5], [4.5, 4.5], 'LineWidth', 3, 'Color', 'k')
plot([4.5 12.5], [8.5, 8.5], 'LineWidth', 3, 'Color', 'k')
plot([8.5 16.5], [12.5, 12.5], 'LineWidth', 3, 'Color', 'k')
plot([12.5 20.5], [16.5, 16.5], 'LineWidth', 3, 'Color', 'k')
plot([16.5 24.5], [20.5, 20.5], 'LineWidth', 3, 'Color', 'k')
% y
plot([4.5, 4.5], [0 8.5], 'LineWidth', 3, 'Color', 'k')
plot([8.5, 8.5], [4.5 12.5], 'LineWidth', 3, 'Color', 'k')
plot([12.5, 12.5], [8.5 16.5], 'LineWidth', 3, 'Color', 'k')
plot([16.5, 16.5], [12.5 20.5], 'LineWidth', 3, 'Color', 'k')
plot([20.5, 20.5], [16.5 24.5], 'LineWidth', 3, 'Color', 'k')
%plot([0 0], [0 4.5], 'LineWidth', 3, 'Color', 'k')
pbaspect([1 1 1])

ax = gca;
ax.XTick = 1:24;
ax.XTickLabel = {'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'};
ax.XTickLabelRotation = 90;
ax.YTick = 1:24;
ax.YTickLabel = {'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'; 'sub-1'; 'sub-2'; 'sub-3'; 'sub-4'};
set(gca,'TickLength',[0 0])
ax2 = axes('Position',ax.Position,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
ax2.XTick = [0.10 0.26 0.42 0.58 0.74 0.90];
ax2.XTickLabel = {'trn-12'; 'trn-13'; 'trn-14'; 'trn-23'; 'trn-24'; 'trn-34'};
ax2.YTick = [0.08 0.26 0.42 0.58 0.74 0.91];
ax2.YTickLabel = {'trn-34'; 'trn-24'; 'trn-23'; 'trn-14'; 'trn-13'; 'trn-12'};
ax2.YTickLabelRotation = 90;

% colormap parula
% h = colorbar;
% ylabel(h, 'Correlation')
% h.Position = [0.84 0.19 0.015 0.7357];
% caxis([min(c_all(:)) 1])

title('sos-denoised and sos-denoised correlation, sense tresholded')
pbaspect([1 1 1])
box off 

% Save figure.
print(fullfile(rootDir, 'plots', 'plot_crossvalidation_splithalf_sensethresholded'), '-dpng')
%print(fullfile(rootDir, 'plots', 'eps', 'plot_matrix_crosscorrelations'), '-depsc')

hold off;
