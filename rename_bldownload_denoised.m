
% Set working directories.
rootDir = '/N/dc2/projects/lifebid/development/sos_denoising/';

% Set bl project id.
blprojectid = 'proj-5dc304237f55b8913bbd4cfd/';

% Get contents of the directory where the images for this subject are stored.
contents = dir(fullfile(rootDir, blprojectid));

% Remove the '.' and '..' files.
contents = contents(arrayfun(@(x) x.name(1), contents) ~= '.');

% Keep only names that are subject folders.
contents = contents(arrayfun(@(x) x.name(1), contents) == 's');

% DWI
for i = 1:size(contents, 1)
    
    % Display current sub ID.
    disp(contents(i).name)
    
    % Get contents of the directory where the images for this subject are stored.
    sub_contents = dir(fullfile(contents(i).folder, contents(i).name, '/dt-neuro-dwi*/_info.json'));
    
    for j = 1:size(sub_contents, 1)
        
        % Get metadata for this subject.
        metadata = jsondecode(fileread(fullfile(sub_contents(j).folder, sub_contents(j).name)));
        
        % Determine condition and get new file name.
        if size(metadata.tags, 1) == 5
            if strcmp(metadata.tags{1, 1}, 'first') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'train-001') && strcmp(metadata.tags{4, 1}, 'iter-1000')
                fname = 'denoised-first-APPAb0-train001-iter1000';
            elseif strcmp(metadata.tags{1, 1}, 'first') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'train-001') && strcmp(metadata.tags{4, 1}, 'iter-1500')
                fname = 'denoised-first-APPAb0-train001-iter1500';
            elseif strcmp(metadata.tags{1, 1}, 'first') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'train-001') && strcmp(metadata.tags{4, 1}, 'iter-2000')
                fname = 'denoised-first-APPAb0-train001-iter2000';
            elseif strcmp(metadata.tags{1, 1}, 'first') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'train-001002') && strcmp(metadata.tags{4, 1}, 'iter-1000')
                fname = 'denoised-first-APPAb0-train001002-iter1000';
            elseif strcmp(metadata.tags{1, 1}, 'first') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'train-001002003') && strcmp(metadata.tags{4, 1}, 'iter-1000')
                fname = 'denoised-first-APPAb0-train001002003-iter1000';
            elseif strcmp(metadata.tags{1, 1}, 'first') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'train-001002003004') && strcmp(metadata.tags{4, 1}, 'iter-1000')
                fname = 'denoised-first-APPAb0-train001002003004-iter1000';
            elseif strcmp(metadata.tags{1, 1}, 'second') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'train-001') && strcmp(metadata.tags{4, 1}, 'iter-1000')
                fname = 'denoised-second-APPAb0-train001-iter1000';
            elseif strcmp(metadata.tags{1, 1}, 'second') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'train-001') && strcmp(metadata.tags{4, 1}, 'iter-1500')
                fname = 'denoised-second-APPAb0-train001-iter1500';
            elseif strcmp(metadata.tags{1, 1}, 'second') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'train-001') && strcmp(metadata.tags{4, 1}, 'iter-2000')
                fname = 'denoised-second-APPAb0-train001-iter2000';
            elseif strcmp(metadata.tags{1, 1}, 'second') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'train-001002') && strcmp(metadata.tags{4, 1}, 'iter-1000')
                fname = 'denoised-second-APPAb0-train001002-iter1000';
            elseif strcmp(metadata.tags{1, 1}, 'second') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'train-001002003') && strcmp(metadata.tags{4, 1}, 'iter-1000')
                fname = 'denoised-second-APPAb0-train001002003-iter1000';
            elseif strcmp(metadata.tags{1, 1}, 'second') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'train-001002003004') && strcmp(metadata.tags{4, 1}, 'iter-1000')
                fname = 'denoised-second-APPAb0-train001002003004-iter1000';
            end
        end
        
        % Rename file.
        if exist('fname')
            movefile(sub_contents(j).folder, fullfile(contents(i).folder, contents(i).name, fname));
            clear fname
        end
        
        clear metadata
        
    end % end j
    
end % end i

