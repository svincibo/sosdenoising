
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
    sub_contents = dir(fullfile(contents(i).folder, contents(i).name, '/dt-neuro-dwi.id*/_info.json'));
    
    for j = 1:size(sub_contents, 1)
        
        % Get metadata for this subject.
        metadata = jsondecode(fileread(fullfile(sub_contents(j).folder, sub_contents(j).name)));
        
        % Determine condition and get new file name.
        if size(metadata.tags, 1) == 3
            if strcmp(metadata.tags{1, 1}, 'first') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'sense')
                fname = 'dwi-first-sense-APPAb0';
            elseif strcmp(metadata.tags{1, 1}, 'first') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'sos')
                fname = 'dwi-first-sos-APPAb0';
            elseif strcmp(metadata.tags{1, 1}, 'first') && strcmp(metadata.tags{2, 1}, 'AP-PAfull') && strcmp(metadata.tags{3, 1}, 'sense')
                fname = 'dwi-first-sense-APPAfull';
            elseif strcmp(metadata.tags{1, 1}, 'first') && strcmp(metadata.tags{2, 1}, 'AP-PAfull') && strcmp(metadata.tags{3, 1}, 'sos')
                fname = 'dwi-first-sos-APPAfull';
            elseif strcmp(metadata.tags{1, 1}, 'second') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'sense')
                fname = 'dwi-second-sense-APPAb0';
            elseif strcmp(metadata.tags{1, 1}, 'second') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'sos')
                fname = 'dwi-second-sos-APPAb0';
            elseif strcmp(metadata.tags{1, 1}, 'second') && strcmp(metadata.tags{2, 1}, 'AP-PAfull') && strcmp(metadata.tags{3, 1}, 'sense')
                fname = 'dwi-second-sense-APPAfull';
            elseif strcmp(metadata.tags{1, 1}, 'second') && strcmp(metadata.tags{2, 1}, 'AP-PAfull') && strcmp(metadata.tags{3, 1}, 'sos')
                fname = 'dwi-second-sos-APPAfull';
            end
        end
        
        % Rename file.
        if exist('fname')
            movefile(sub_contents(j).folder, fullfile(contents(i).folder, contents(i).name, fname));
% %             clear fname
        end
        
        clear metadata
        
    end % end j
    
end % end i

% MASK
for i = 1:size(contents, 1)
    
    % Display current sub ID.
    disp(contents(i).name)
    
    % Get contents of the directory where the images for this subject are stored.
    sub_contents = dir(fullfile(contents(i).folder, contents(i).name, '/dt-neuro-mask.id*/_info.json'));
    
    for j = 1:size(sub_contents, 1)
        
        % Get metadata for this subject.
        metadata = jsondecode(fileread(fullfile(sub_contents(j).folder, sub_contents(j).name)));
        
        % Determine condition and get new file name.
        if size(metadata.tags, 1) == 3
            if strcmp(metadata.tags{1, 1}, 'first') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'sense')
                fname = 'mask-first-sense-APPAb0';
            elseif strcmp(metadata.tags{1, 1}, 'first') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'sos')
                fname = 'mask-first-sos-APPAb0';
            elseif strcmp(metadata.tags{1, 1}, 'first') && strcmp(metadata.tags{2, 1}, 'AP-PAfull') && strcmp(metadata.tags{3, 1}, 'sense')
                fname = 'mask-first-sense-APPAfull';
            elseif strcmp(metadata.tags{1, 1}, 'first') && strcmp(metadata.tags{2, 1}, 'AP-PAfull') && strcmp(metadata.tags{3, 1}, 'sos')
                fname = 'mask-first-sos-APPAfull';
            elseif strcmp(metadata.tags{1, 1}, 'second') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'sense')
                fname = 'mask-second-sense-APPAb0';
            elseif strcmp(metadata.tags{1, 1}, 'second') && strcmp(metadata.tags{2, 1}, 'AP-PAb0') && strcmp(metadata.tags{3, 1}, 'sos')
                fname = 'mask-second-sos-APPAb0';
            elseif strcmp(metadata.tags{1, 1}, 'second') && strcmp(metadata.tags{2, 1}, 'AP-PAfull') && strcmp(metadata.tags{3, 1}, 'sense')
                fname = 'mask-second-sense-APPAfull';
            elseif strcmp(metadata.tags{1, 1}, 'second') && strcmp(metadata.tags{2, 1}, 'AP-PAfull') && strcmp(metadata.tags{3, 1}, 'sos')
                fname = 'mask-second-sos-APPAfull';
            end
        end
        
        % Rename file.
        if exist('fname')
            movefile(sub_contents(j).folder, fullfile(contents(i).folder, contents(i).name, fname));
% %             clear fname
        end
        
        clear metadata
        
    end % end j
    
end % end i
