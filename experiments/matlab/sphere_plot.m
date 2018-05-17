%% Plotting done in Matlab because of matplotlib's poor 3d plotting capabilities

load('sphere_312.mat');
tri = tri + 1;

% name = 'sphere_sdpkm_bm.mat';
name = 'sphere_copositive_bm.mat';

load(name);

colors = [
    228,26,28;
    55,126,184;
    77,175,74;
    152,78,163;
    255,127,0;
    255,255,51];

% mask = max(Y, [], 1) ~= 0;
% Y = Y(:, mask);

if strcmp(name, 'sphere_sdpkm_bm.mat')
%     bump_selection = round(linspace(1, size(Y, 2), 6));
    bump_selection = [1, 80, 12, 31, 60];
end
if strcmp(name, 'sphere_copositive_bm.mat')
%     bump_selection = round(linspace(1, size(Y, 2), 6));    
    bump_selection = [1, 9, 20, 22, 81];
end

hFig = figure;
set(hFig, 'Units', 'inches', 'Position',[0 0 8 8])
hFig.PaperUnits = 'inches';
hFig.PaperSize = [8, 8];
hFig.PaperPosition = [0 0 8 8];

azimuth_subplot = [30, 120, 210, 300];

for i_subplot = 1:4
    subplot(2, 2, i_subplot);
    
    u = linspace(0, 2 * pi, 50);
    v = linspace(0, pi, 50);
    surf(0.95 * cos(u)' * sin(v), ...
        0.95 * sin(u)' * sin(v), ...
        0.95 * ones(size(u, 2), 1) * cos(v), ...
        'FaceColor', 'w', 'EdgeColor', [.9, .9, .9]);
    hold on;

    scatter3(X(:, 1), X(:, 2), X(:, 3), 'MarkerEdgeColor','k');
    hold on;

    for i = 1:size(bump_selection, 2)
        ci = colors(i, :) / 255;

        loc = bump_selection(i);
        bump = Y(:, loc);
        bump = bump / max(bump);

        unique_values = unique(bump);
        for k = 1:size(unique_values, 1)
            if unique_values(k) == 0
                continue
            end
            mask = bump == unique_values(k);            
            fm = find(mask);
            tri_mask = zeros(size(tri, 1), 1, 'logical');
            for r = 1:size(tri, 1)
                tri_mask(r, 1) = length(intersect(tri(r, :), fm)) == 3;
            end
            tri_masked = tri(tri_mask, :);
            
            trisurf(tri_masked, X(:, 1), X(:, 2), X(:, 3), ...
                'FaceVertexCData', ci, 'FaceAlpha', 0.2);
            
            hold on;
            
            scatter3(X(mask, 1), X(mask, 2), X(mask, 3), 'filled', ...
                'MarkerFaceAlpha', unique_values(k), ...
                'MarkerEdgeColor','k', ...
                'MarkerFaceColor', ci);

            hold on;

        end
    end

    axis('equal', 'off');
    
    view(azimuth_subplot(1, i_subplot), 30);
end

filename = ['../../results/sphere_bm/', name, '_plot_Y_on_data_multiple'];
print(hFig, '-dpdf', [filename, '.pdf'], '-r0');
