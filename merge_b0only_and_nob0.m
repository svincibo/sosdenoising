% Merges nifti images that were separated into their b0only and non-b0
% components for sos-denoising training.

clear all; clc;

% Set working directories.
rootDir = '/N/dc2/projects/lifebid/development/sos_denoising/';

% Set bl project id.
blprojectid = 'proj-5dc304237f55b8913bbd4cfd/';

% Set subjects.
sub = {'sub-001', 'sub-002', 'sub-003', 'sub-004'};

% Set training.
train = {'train001', 'train002', 'train003', 'train004'};

% Read in the sense data to use as baseline.
sense_sub001 = niftiRead(fullfile(rootDir, blprojectid, 'sub-001/dwi-first-sense-APPAb0/dwi.nii.gz'));
sense_sub002 = niftiRead(fullfile(rootDir, blprojectid, 'sub-002/dwi-first-sense-APPAb0/dwi.nii.gz'));
sense_sub003 = niftiRead(fullfile(rootDir, blprojectid, 'sub-003/dwi-first-sense-APPAb0/dwi.nii.gz'));
sense_sub004 = niftiRead(fullfile(rootDir, blprojectid, 'sub-004/dwi-first-sense-APPAb0/dwi.nii.gz'));
sense_panel = corr(cat(2, sense_sub001.data(:), sense_sub002.data(:), sense_sub003.data(:), sense_sub004.data(:)));

% Read in and merge denoised images.
for s = 1:length(sub)
    
    % Get location of bvals in orignal dwi data.
    sos_bval = dlmread(fullfile(rootDir, blprojectid, sub{s}, 'dwi-first-sos-APPAb0/dwi.bvals'));
    idx_nob0 = find(sos_bval >= 20);
    idx_b0 = find(sos_bval < 20);
       
    for t = 1:length(train)
        
        % Read in b0only and nob0 images.
        temp1 = niftiRead(fullfile(rootDir, blprojectid, sub{s}, ['denoised-first-APPAb0-' train{t} '-iter100-nob0/dwi.nii.gz']));
        temp2 = niftiRead(fullfile(rootDir, blprojectid, sub{s}, ['denoised-first-APPAb0-' train{t} '-iter100-b0only/dwi.nii.gz']));
        
        % Merge the bo and non-b0 volumes so that they are in the same order as the volumes in the dwi.
        c = NaN(size(sense_sub001.data));
        c(:, :, :, idx_nob0) = temp1.data;
        c(:, :, :, idx_b0) = temp2.data;
        temp1.data = c;
        
        % Make a directory for the merged data.
        mkdir(fullfile(rootDir, blprojectid, sub{s}, ['denoised-first-APPAb0-' train{t} '-iter100-merged/']))
        
        % Write the new nifti file for the merged dwi data.
        niftiWrite(temp1, fullfile(rootDir, blprojectid, sub{s}, ['denoised-first-APPAb0-' train{t} '-iter100-merged/dwi.nii.gz']));
        
        % Move over bvals file to be used for the merged data.
        copyfile(fullfile(rootDir, blprojectid, sub{s}, 'dwi-first-sos-APPAb0/dwi.bvals'), fullfile(rootDir, blprojectid, sub{s}, ['denoised-first-APPAb0-' train{t} '-iter100-merged/']));
        
        % Move over bvecs file to be used for the merged data.
        copyfile(fullfile(rootDir, blprojectid, sub{s}, 'dwi-first-sos-APPAb0/dwi.bvecs'), fullfile(rootDir, blprojectid, sub{s}, ['denoised-first-APPAb0-' train{t} '-iter100-merged/']));
        
        clear temp1 temp2 c
        
    end % end train
    
end % end sub
