% Scatter plot of denoised on x-axis and sense on y-axis.
% Draw line of equality.
% Fit a line to measure R2.
% Use R2 as a measure of how closely the denoising procedure got us back to
% the "gold standard" of sense.

clear all; close all; clc;

% Set working directories.
rootDir = '/Volumes/240/sosdenoising/';

% Set bl project id.
blprojectid = 'proj-5ee1659ec5972b1b5fb443d3';

testsub = {'sub-002'};
trainsub = {'sub-003', 'sub-004'};

% Set threshold for binarization of masks.
bin_thresh = 0.50;

% Set counter for figures, for ease.
figcount = 0;

count =0;
for i = 1:length(testsub)
    
    for j = 1:length(trainsub)
        
        count = count + 1;
        
        disp('=======')
        disp(['Test: ' testsub{i} ', Train: ' trainsub{j}])
        disp('-----WM')
        
        %% Read in data.
        
        % Read in the sense mask (same for 1 and 2 bc 2 was coregistered to 1).
        mask = niftiRead(fullfile(rootDir, blprojectid, [testsub{i} '/dt-neuro-mask.tag-5tt_masks.id-first/mask_dwispace.nii.gz']));
        gm = single(imbinarize(mask.data(:, :, :, 1), bin_thresh));
        wm = single(imbinarize(mask.data(:, :, :, 3), bin_thresh));
        csf = single(imbinarize(mask.data(:, :, :, 4), bin_thresh));
        
        % Read in the sos-denoised data: FA. Apply gm and wm masks.
        denoised_fa_1 = niftiRead(fullfile(rootDir, blprojectid, [testsub{i} '/dt-neuro-tensor.id-first-trn-' trainsub{j} '/fa.nii.gz']));
        denoised_fa_1_gm = denoised_fa_1.data.*gm; denoised_fa_1_wm = denoised_fa_1.data.*wm;
        % Read in the sense data to use as baseline FA. Apply gm and wm masks.
        sense_fa_1 = niftiRead(fullfile(rootDir, blprojectid, [testsub{i} '/dt-neuro-tensor.id-first-sense/fa.nii.gz']));
        sense_fa_1_gm = sense_fa_1.data.*gm; sense_fa_1_wm = sense_fa_1.data.*wm;
        sense_fa_2 = niftiRead(fullfile(rootDir, blprojectid, [testsub{i} '/dt-neuro-tensor.id-second-sense/fa.nii.gz']));
        sense_fa_2_gm = sense_fa_2.data.*gm; sense_fa_2_wm = sense_fa_2.data.*wm;
        
        % Read in the sos-denoised data: ODI. Apply gm and wm masks.
        denoised_odi_1 = niftiRead(fullfile(rootDir, blprojectid, [testsub{i} '/dt-neuro-noddi.id-first-trn-' trainsub{j} '/odi.nii.gz']));
        denoised_odi_1_gm = denoised_odi_1.data.*gm; denoised_odi_1_wm = denoised_odi_1.data.*wm;
        % Read in the sense data to use as baseline ODI. Apply gm and wm masks.
        sense_odi_1 = niftiRead(fullfile(rootDir, blprojectid, [testsub{i} '/dt-neuro-noddi.id-first-sense/odi.nii.gz']));
        sense_odi_1_gm = sense_odi_1.data.*gm; sense_odi_1_wm = sense_odi_1.data.*wm;
        sense_odi_2 = niftiRead(fullfile(rootDir, blprojectid, [testsub{i} '/dt-neuro-noddi.id-second-sense/odi.nii.gz']));
        sense_odi_2_gm = sense_odi_2.data.*gm; sense_odi_2_wm = sense_odi_2.data.*wm;
        
        % Read in the sos-denoised data: NDI. Apply gm and wm masks.
        denoised_ndi_1 = niftiRead(fullfile(rootDir, blprojectid, [testsub{i} '/dt-neuro-noddi.id-first-trn-' trainsub{j} '/ndi.nii.gz']));
        denoised_ndi_1_gm = denoised_ndi_1.data.*gm; denoised_ndi_1_wm = denoised_ndi_1.data.*wm;
        % Read in the sense data to use as baseline NDI. Apply gm and wm masks.
        sense_ndi_1 = niftiRead(fullfile(rootDir, blprojectid, [testsub{i} '/dt-neuro-noddi.id-first-sense/ndi.nii.gz']));
        sense_ndi_1_gm = sense_ndi_1.data.*gm; sense_ndi_1_wm = sense_ndi_1.data.*wm;
        sense_ndi_2 = niftiRead(fullfile(rootDir, blprojectid, [testsub{i} '/dt-neuro-noddi.id-second-sense/ndi.nii.gz']));
        sense_ndi_2_gm = sense_ndi_2.data.*gm; sense_ndi_2_wm = sense_ndi_2.data.*wm;
        
        %% Plot: FA.

        figcount = figcount + 1;
        figure(figcount)
        alpha = .4;
        yticklength = 0;
        xticklength = 0.05;
        ytickvalues = [0 0.5 1.0];
        fontname = 'Arial';
        fontsize = 16;
        fontangle = 'italic';
        
        x_lim_lo = 0; x_mid = 0.5; x_lim_hi = 1;
        y_lim_lo = 0; y_mid = 0.5; y_lim_hi = 1;
        
        % FA, WM
        subplot(1, 2, 1)
        
        % FA, WM, baseline
        x = sense_fa_1_wm(:); y = sense_fa_2_wm(:);
        c_baseline = corr(x, y);
        disp(['Baseline: sense1-sense2, wm: ' num2str(c_baseline, '%2.2f')])
        scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', ...
            alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4940 0.1840 0.5560], 'MarkerFaceColor', [0.4940 0.1840 0.5560]) % purple, Subsample to make plotting faster, for now.
        hold on;
        [r_baseline_wm, ~] = plotcorr2(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), [0.4940 0.1840 0.5560]);
        
        % FA, WM, test corr
        x = sense_fa_1_wm(:); y = denoised_fa_1_wm(:);
        c = corr(x, y);
        disp(['sense1-sosdenoised1, wm: ' num2str(c, '%2.2f')])
        scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', ...
            alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880]) % green, Subsample to make plotting faster, for now.
        [r_wm, ~] = plotcorr2(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), [0.4660 0.6740 0.1880]);
        
        % Plot line of equality
        plot([0 1], [0 1], 'k')
        
        % Set x and y limits.
        xlim([x_lim_lo x_lim_hi]); ylim([y_lim_lo y_lim_hi]);
        
        % Format.
        % yaxis
        yax = get(gca,'yaxis');
        yax.Limits = [y_lim_lo y_lim_hi];
        yax.TickValues = ytickvalues;
        yax.TickDirection = 'out';
        yax.TickLength = [yticklength yticklength];
        yax.TickLabels = {num2str(y_lim_lo, '%1.2f'), num2str(y_mid, '%1.2f'), num2str(y_lim_hi, '%1.2f')};
        yax.FontName = fontname;
        yax.FontSize = fontsize;
        
        % xaxis
        xax = get(gca, 'xaxis');
        xax.Limits = [x_lim_lo x_lim_hi];
        xax.TickValues = [x_lim_lo x_mid x_lim_hi];
        xax.TickDirection = 'out';
        xax.TickLength = [xticklength xticklength];
        xax.TickLabels = {num2str(x_lim_lo, '%1.2f'), num2str(x_mid, '%1.2f'), num2str(x_lim_hi, '%1.2f')};
        xax.FontName = fontname;
        xax.FontSize = fontsize;
        xax.FontAngle = fontangle;
        
        lgd = legend({'Baseline: sense1 and sense2 ', ['r = ' num2str(r_baseline_wm, '%2.2f')], 'sense1 and sosdenoised1', ['r = ' num2str(r_wm, '%2.2f')]}, 'Location', 'southoutside');
        lgd.FontSize = 15;
        legend box off
        xlabel('sense1'); ylabel({'comparison image'; '(sense2 or sosdenoised1)'});
        title('White Matter')
        pbaspect([1 1 1])
        box off
        
        hold off;
        
        disp('-----GM')
 
        % FA, GM
        subplot(1, 2, 2)
        
        % FA, GM, baseline
        x = sense_fa_1_gm(:); y = sense_fa_2_gm(:);
        c_baseline = corr(x, y);
        disp(['Baseline: sense1-sense2, gm: ' num2str(c_baseline, '%2.2f')])
        scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', ...
            alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4940 0.1840 0.5560], 'MarkerFaceColor', [0.4940 0.1840 0.5560]) % purple, Subsample to make plotting faster, for now.
        hold on;
        [r_baseline_gm, ~] = plotcorr2(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), [0.4940 0.1840 0.5560]);
        
        % FA, GM, test corr
        x = sense_fa_1_gm(:); y = denoised_fa_1_gm(:);
        c = corr(x, y);
        disp(['sense1-sosdenoised1, gm: ' num2str(c, '%2.2f')])
        scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', ...
            alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880]) % green, Subsample to make plotting faster, for now.
        [r_gm, ~] = plotcorr2(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), [0.4660 0.6740 0.1880]);
        
        % Plot line of equality
        plot([0 1], [0 1], 'k')
        
        % Set x and y limits.
        xlim([x_lim_lo x_lim_hi]); ylim([y_lim_lo y_lim_hi]);
        
        % Format.
        % yaxis
        yax = get(gca,'yaxis');
        yax.Limits = [y_lim_lo y_lim_hi];
        yax.TickValues = ytickvalues;
        yax.TickDirection = 'out';
        yax.TickLength = [yticklength yticklength];
        yax.TickLabels = {num2str(y_lim_lo, '%1.2f'), num2str(y_mid, '%1.2f'), num2str(y_lim_hi, '%1.2f')};
        yax.FontName = fontname;
        yax.FontSize = fontsize;
        
        % xaxis
        xax = get(gca, 'xaxis');
        xax.Limits = [x_lim_lo x_lim_hi];
        xax.TickValues = [x_lim_lo x_mid x_lim_hi];
        xax.TickDirection = 'out';
        xax.TickLength = [xticklength xticklength];
        xax.TickLabels = {num2str(x_lim_lo, '%1.2f'), num2str(x_mid, '%1.2f'), num2str(x_lim_hi, '%1.2f')};
        xax.FontName = fontname;
        xax.FontSize = fontsize;
        xax.FontAngle = fontangle;
        
        
        lgd = legend({'Baseline: sense1 and sense2 ', ['r = ' num2str(r_baseline_gm, '%2.2f')], 'sense1 and sosdenoised1', ['r = ' num2str(r_gm, '%2.2f')]}, 'Location', 'southoutside');
        lgd.FontSize = 15;
        legend box off
        xlabel('sense1'); ylabel({'comparison image'; '(sense2 or sosdenoised1)'});
        title('Gray Matter')
        pbaspect([1 1 1])
        box off
        
        sgt = sgtitle({'Fractional Anisotropy'; ['TEST: ' testsub{i} ', TRAIN: ' trainsub{j}]});
        sgt.FontSize = 15;
        sgt.FontWeight = 'bold';
        
        % Save figure.
        print(fullfile(rootDir, 'plots', ['plot_scatter_accuracy_fa_test-' testsub{i} '_train-' trainsub{j}]), '-dpng')
        
        hold off;
        
        % Save some images for investigating subject effect outside of loop.
        fa(count).sense1.gm = sense_fa_1_gm(:);
        fa(count).sense1.wm = sense_fa_1_wm(:);
        fa(count).sense2.gm = sense_fa_2_gm(:);
        fa(count).sense2.wm = sense_fa_2_wm(:);
        fa(count).denoised1.gm = denoised_fa_1_gm(:);
        fa(count).denoised1.wm = denoised_fa_1_wm(:);
        fa(count).testsub = testsub{i};
        fa(count).trainsub = trainsub{j};
        
        %% Plot: ODI.
        
        figcount = figcount + 1;
        figure(figcount)

        ytickvalues = [0 0.5 1];        
        x_lim_lo = 0; x_mid = 0.5; x_lim_hi = 1;
        y_lim_lo = 0; y_mid = 0.5; y_lim_hi = 1;
        
        % ODI, WM
        subplot(1, 2, 1)
        
        % ODI, WM, baseline
        x = sense_odi_1_wm(:); y = sense_odi_2_wm(:);
        c_baseline = corr(x, y);
        disp(['Baseline: sense1-sense2, wm: ' num2str(c_baseline, '%2.2f')])
        scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', ...
            alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4940 0.1840 0.5560], 'MarkerFaceColor', [0.4940 0.1840 0.5560]) % purple, Subsample to make plotting faster, for now.
        hold on;
        [r_baseline_wm, ~] = plotcorr2(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), [0.4940 0.1840 0.5560]);
        
        % ODI, WM, test corr
        x = sense_odi_1_wm(:); y = denoised_odi_1_wm(:);
        c = corr(x, y);
        disp(['sense1-sosdenoised1, wm: ' num2str(c, '%2.2f')])
        scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', ...
            alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880]) % green, Subsample to make plotting faster, for now.
        [r_wm, ~] = plotcorr2(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), [0.4660 0.6740 0.1880]);
        
        % Plot line of equality
        plot([0 1], [0 1], 'k')
        
        % Set x and y limits.
        xlim([x_lim_lo x_lim_hi]); ylim([y_lim_lo y_lim_hi]);
        
        % Format.
        % yaxis
        yax = get(gca,'yaxis');
        yax.Limits = [y_lim_lo y_lim_hi];
        yax.TickValues = ytickvalues;
        yax.TickDirection = 'out';
        yax.TickLength = [yticklength yticklength];
        yax.TickLabels = {num2str(y_lim_lo, '%1.2f'), num2str(y_mid, '%1.2f'), num2str(y_lim_hi, '%1.2f')};
        yax.FontName = fontname;
        yax.FontSize = fontsize;
        
        % xaxis
        xax = get(gca, 'xaxis');
        xax.Limits = [x_lim_lo x_lim_hi];
        xax.TickValues = [x_lim_lo x_mid x_lim_hi];
        xax.TickDirection = 'out';
        xax.TickLength = [xticklength xticklength];
        xax.TickLabels = {num2str(x_lim_lo, '%1.2f'), num2str(x_mid, '%1.2f'), num2str(x_lim_hi, '%1.2f')};
        xax.FontName = fontname;
        xax.FontSize = fontsize;
        xax.FontAngle = fontangle;
        
        lgd = legend({'Baseline: sense1 and sense2 ', ['r = ' num2str(r_baseline_wm, '%2.2f')], 'sense1 and sosdenoised1', ['r = ' num2str(r_wm, '%2.2f')]}, 'Location', 'southoutside');
        lgd.FontSize = 15;
        legend box off
        xlabel('sense1'); ylabel({'comparison image'; '(sense2 or sosdenoised1)'});
        title('White Matter')
        pbaspect([1 1 1])
        box off
        
        hold off;
        
        disp('-----GM')
 
        % ODI, GM
        subplot(1, 2, 2)
        
        % ODI, GM, baseline
        x = sense_odi_1_gm(:); y = sense_odi_2_gm(:);
        c_baseline = corr(x, y);
        disp(['Baseline: sense1-sense2, gm: ' num2str(c_baseline, '%2.2f')])
        scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', ...
            alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4940 0.1840 0.5560], 'MarkerFaceColor', [0.4940 0.1840 0.5560]) % purple, Subsample to make plotting faster, for now.
        hold on;
        [r_baseline_gm, ~] = plotcorr2(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), [0.4940 0.1840 0.5560]);
        
        % ODI, GM, test corr
        x = sense_odi_1_gm(:); y = denoised_odi_1_gm(:);
        c = corr(x, y);
        disp(['sense1-sosdenoised1, gm: ' num2str(c, '%2.2f')])
        scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', ...
            alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880]) % green, Subsample to make plotting faster, for now.
        [r_gm, ~] = plotcorr2(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), [0.4660 0.6740 0.1880]);
        
        % Plot line of equality
        plot([0 1], [0 1], 'k')
        
        % Set x and y limits.
        xlim([x_lim_lo x_lim_hi]); ylim([y_lim_lo y_lim_hi]);
        
        % Format.
        % yaxis
        yax = get(gca,'yaxis');
        yax.Limits = [y_lim_lo y_lim_hi];
        yax.TickValues = ytickvalues;
        yax.TickDirection = 'out';
        yax.TickLength = [yticklength yticklength];
        yax.TickLabels = {num2str(y_lim_lo, '%1.2f'), num2str(y_mid, '%1.2f'), num2str(y_lim_hi, '%1.2f')};
        yax.FontName = fontname;
        yax.FontSize = fontsize;
        
        % xaxis
        xax = get(gca, 'xaxis');
        xax.Limits = [x_lim_lo x_lim_hi];
        xax.TickValues = [x_lim_lo x_mid x_lim_hi];
        xax.TickDirection = 'out';
        xax.TickLength = [xticklength xticklength];
        xax.TickLabels = {num2str(x_lim_lo, '%1.2f'), num2str(x_mid, '%1.2f'), num2str(x_lim_hi, '%1.2f')};
        xax.FontName = fontname;
        xax.FontSize = fontsize;
        xax.FontAngle = fontangle;
        
        
        lgd = legend({'Baseline: sense1 and sense2 ', ['r = ' num2str(r_baseline_gm, '%2.2f')], 'sense1 and sosdenoised1', ['r = ' num2str(r_gm, '%2.2f')]}, 'Location', 'southoutside');
        lgd.FontSize = 15;
        legend box off
        xlabel('sense1'); ylabel({'comparison image'; '(sense2 or sosdenoised1)'});
        title('Gray Matter')
        pbaspect([1 1 1])
        box off
        
        sgt = sgtitle({'Orientation Dispersion Index'; ['TEST: ' testsub{i} ', TRAIN: ' trainsub{j}]});
        sgt.FontSize = 15;
        sgt.FontWeight = 'bold';
        
        % Save figure.
        print(fullfile(rootDir, 'plots', ['plot_scatter_accuracy_odi_test-' testsub{i} '_train-' trainsub{j}]), '-dpng')
        
        hold off;
        
        % Save some images for investigating subject effect outside of loop.
        odi(count).sense1.gm = sense_odi_1_gm(:);
        odi(count).sense1.wm = sense_odi_1_wm(:);
        odi(count).sense2.gm = sense_odi_2_gm(:);
        odi(count).sense2.wm = sense_odi_2_wm(:);
        odi(count).denoised1.gm = denoised_odi_1_gm(:);
        odi(count).denoised1.wm = denoised_odi_1_wm(:);
        odi(count).testsub = testsub{i};
        odi(count).trainsub = trainsub{j};
        
        %% Plot: NDI.
        
        figcount = figcount + 1;
        figure(figcount)

        ytickvalues = [0 0.5 1];        
        x_lim_lo = 0; x_mid = 0.5; x_lim_hi = 1;
        y_lim_lo = 0; y_mid = 0.5; y_lim_hi = 1;
        
        % NDI, WM
        subplot(1, 2, 1)
        
        % NDI, WM, baseline
        x = sense_ndi_1_wm(:); y = sense_ndi_2_wm(:);
        c_baseline = corr(x, y);
        disp(['Baseline: sense1-sense2, wm: ' num2str(c_baseline, '%2.2f')])
        scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', ...
            alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4940 0.1840 0.5560], 'MarkerFaceColor', [0.4940 0.1840 0.5560]) % purple, Subsample to make plotting faster, for now.
        hold on;
        [r_baseline_wm, ~] = plotcorr2(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), [0.4940 0.1840 0.5560]);
        
        % NDI, WM, test corr
        x = sense_ndi_1_wm(:); y = denoised_ndi_1_wm(:);
        c = corr(x, y);
        disp(['sense1-sosdenoised1, wm: ' num2str(c, '%2.2f')])
        scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', ...
            alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880]) % green, Subsample to make plotting faster, for now.
        [r_wm, ~] = plotcorr2(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), [0.4660 0.6740 0.1880]);
        
        % Plot line of equality
        plot([0 1], [0 1], 'k')
        
        % Set x and y limits.
        xlim([x_lim_lo x_lim_hi]); ylim([y_lim_lo y_lim_hi]);
        
        % Format.
        % yaxis
        yax = get(gca,'yaxis');
        yax.Limits = [y_lim_lo y_lim_hi];
        yax.TickValues = ytickvalues;
        yax.TickDirection = 'out';
        yax.TickLength = [yticklength yticklength];
        yax.TickLabels = {num2str(y_lim_lo, '%1.2f'), num2str(y_mid, '%1.2f'), num2str(y_lim_hi, '%1.2f')};
        yax.FontName = fontname;
        yax.FontSize = fontsize;
        
        % xaxis
        xax = get(gca, 'xaxis');
        xax.Limits = [x_lim_lo x_lim_hi];
        xax.TickValues = [x_lim_lo x_mid x_lim_hi];
        xax.TickDirection = 'out';
        xax.TickLength = [xticklength xticklength];
        xax.TickLabels = {num2str(x_lim_lo, '%1.2f'), num2str(x_mid, '%1.2f'), num2str(x_lim_hi, '%1.2f')};
        xax.FontName = fontname;
        xax.FontSize = fontsize;
        xax.FontAngle = fontangle;
        
        lgd = legend({'Baseline: sense1 and sense2 ', ['r = ' num2str(r_baseline_wm, '%2.2f')], 'sense1 and sosdenoised1', ['r = ' num2str(r_wm, '%2.2f')]}, 'Location', 'southoutside');
        lgd.FontSize = 15;
        legend box off
        xlabel('sense1'); ylabel({'comparison image'; '(sense2 or sosdenoised1)'});
        title('White Matter')
        pbaspect([1 1 1])
        box off
        
        hold off;
        
        disp('-----GM')
 
        % NDI, GM
        subplot(1, 2, 2)
        
        % NDI, GM, baseline
        x = sense_ndi_1_gm(:); y = sense_ndi_2_gm(:);
        c_baseline = corr(x, y);
        disp(['Baseline: sense1-sense2, gm: ' num2str(c_baseline, '%2.2f')])
        scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', ...
            alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4940 0.1840 0.5560], 'MarkerFaceColor', [0.4940 0.1840 0.5560]) % purple, Subsample to make plotting faster, for now.
        hold on;
        [r_baseline_gm, ~] = plotcorr2(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), [0.4940 0.1840 0.5560]);
        
        % NDI, GM, test corr
        x = sense_ndi_1_gm(:); y = denoised_ndi_1_gm(:);
        c = corr(x, y);
        disp(['sense1-sosdenoised1, gm: ' num2str(c, '%2.2f')])
        scatter(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), 'Marker', '.', 'MarkerEdgeAlpha', ...
            alpha, 'MarkerFaceAlpha', alpha, 'MarkerEdgeColor', [0.4660 0.6740 0.1880], 'MarkerFaceColor', [0.4660 0.6740 0.1880]) % green, Subsample to make plotting faster, for now.
        [r_gm, ~] = plotcorr2(x(1:ceil(length(x)/100000):length(x)), y(1:ceil(length(y)/100000):length(y)), [0.4660 0.6740 0.1880]);
        
        % Plot line of equality
        plot([0 1], [0 1], 'k')
        
        % Set x and y limits.
        xlim([x_lim_lo x_lim_hi]); ylim([y_lim_lo y_lim_hi]);
        
        % Format.
        % yaxis
        yax = get(gca,'yaxis');
        yax.Limits = [y_lim_lo y_lim_hi];
        yax.TickValues = ytickvalues;
        yax.TickDirection = 'out';
        yax.TickLength = [yticklength yticklength];
        yax.TickLabels = {num2str(y_lim_lo, '%1.2f'), num2str(y_mid, '%1.2f'), num2str(y_lim_hi, '%1.2f')};
        yax.FontName = fontname;
        yax.FontSize = fontsize;
        
        % xaxis
        xax = get(gca, 'xaxis');
        xax.Limits = [x_lim_lo x_lim_hi];
        xax.TickValues = [x_lim_lo x_mid x_lim_hi];
        xax.TickDirection = 'out';
        xax.TickLength = [xticklength xticklength];
        xax.TickLabels = {num2str(x_lim_lo, '%1.2f'), num2str(x_mid, '%1.2f'), num2str(x_lim_hi, '%1.2f')};
        xax.FontName = fontname;
        xax.FontSize = fontsize;
        xax.FontAngle = fontangle;
        
        
        lgd = legend({'Baseline: sense1 and sense2 ', ['r = ' num2str(r_baseline_gm, '%2.2f')], 'sense1 and sosdenoised1', ['r = ' num2str(r_gm, '%2.2f')]}, 'Location', 'southoutside');
        lgd.FontSize = 15;
        legend box off
        xlabel('sense1'); ylabel({'comparison image'; '(sense2 or sosdenoised1)'});
        title('Gray Matter')
        pbaspect([1 1 1])
        box off
        
        sgt = sgtitle({'Neurite Density Index'; ['TEST: ' testsub{i} ', TRAIN: ' trainsub{j}]});
        sgt.FontSize = 15;
        sgt.FontWeight = 'bold';
        
        % Save figure.
        print(fullfile(rootDir, 'plots', ['plot_scatter_accuracy_ndi_test-' testsub{i} '_train-' trainsub{j}]), '-dpng')
        
        hold off;
        
        % Save some images for investigating subject effect outside of loop.
        ndi(count).sense1.gm = sense_ndi_1_gm(:);
        ndi(count).sense1.wm = sense_ndi_1_wm(:);
        ndi(count).sense2.gm = sense_ndi_2_gm(:);
        ndi(count).sense2.wm = sense_ndi_2_wm(:);
        ndi(count).denoised1.gm = denoised_ndi_1_gm(:);
        ndi(count).denoised1.wm = denoised_ndi_1_wm(:);
        ndi(count).testsub = testsub{i};
        ndi(count).trainsub = trainsub{j};
        
    end % train sub
    
end % test sub

% What is the correlation between data from the same test subject (sub-002)
% denoised from models trained on different subjects (i.e., train subject
% sub-004 and train subject sub-003)?
disp('======')
disp('-----WM')

c = corr(fa(1).denoised1.wm, fa(2).denoised1.wm);
disp(['FA: Correlation between test002-train003 and test002-train004: ' num2str(c)]);

c = corr(odi(1).denoised1.wm, odi(2).denoised1.wm);
disp(['ODI: Correlation between test002-train003 and test002-train004: ' num2str(c)]);

c = corr(ndi(1).denoised1.wm, ndi(2).denoised1.wm);
disp(['NDI: Correlation between test002-train003 and test002-train004: ' num2str(c)]);

disp('-----GM')
c = corr(fa(1).denoised1.gm, fa(2).denoised1.gm);
disp(['FA: Correlation between test002-train003 and test002-train004: ' num2str(c)]);

c = corr(odi(1).denoised1.gm, odi(2).denoised1.gm);
disp(['ODI: Correlation between test002-train003 and test002-train004: ' num2str(c)]);

c = corr(ndi(1).denoised1.gm, ndi(2).denoised1.gm);
disp(['NDI: Correlation between test002-train003 and test002-train004: ' num2str(c)]);
