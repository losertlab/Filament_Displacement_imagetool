function relAngIm = relBoundaryAngles(LoGOutput,CellBoundary)
% INPUTS:
% LoG input
% CellBoundary - generally created using functions such as
% findCellandBulkBoundary.m as well as MATLAB's built-in boundarymask
% function

    filIdx = find(~isnan(LoGOutput));
    boundR = CellBoundary(:,1); boundC = CellBoundary(:,2);
    [numX, numY, ~] = size(LoGOutput);
    relAngIm = NaN(numX, numY);
    for fil = 1:length(filIdx)
        [row, col] = ind2sub([numX, numY],filIdx(fil));


        filament_measure = sqrt((row-boundR).^2+(col-boundC).^2);
        min_dist = min(filament_measure(:));
%         if length(min_dist)>1
%             min_index = find(filament_measure==min_dist(1));
%         else
%             min_index = find(filament_measure==mind_dist);
%         end
%         alt_min = min(alt_meas(:));
        min_index = find(filament_measure==min_dist);
%         alt_ind = find(alt_meas==alt_min);


        min_boundary_rindex = boundR(min_index(1));
        min_boundary_cindex = boundC(min_index(1));

        %angle calculation
        rel_ang_val = NaN;
%         if min_boundary_rindex<972 && min_boundary_cindex<972
        angle_filament = LoGOutput(filIdx(fil));
        
        % relative to the filament point
        y_difference = min_boundary_rindex - row;
        x_difference = min_boundary_cindex - col;
        angle_boundary = atan(y_difference/x_difference);
        if sign(x_difference)<0
         
            boundary_temp = pi-(sign(y_difference)*sign(x_difference))*abs(angle_boundary);
            temp_rel = abs(boundary_temp-angle_filament);
            rel_ang_val = min(2*pi-temp_rel,temp_rel);

        elseif sign(x_difference)>0
            
            boundary_temp = (-1*sign(y_difference)*sign(x_difference))*abs(angle_boundary);
            temp_rel = abs(angle_filament-boundary_temp);
            rel_ang_val = min(2*pi-temp_rel,temp_rel);
        else
            boundary_temp = pi-angle_boundary;
            temp_rel = abs(angle_filament-boundary_temp);
            rel_ang_val = min(2*pi-temp_rel,temp_rel);
        end
        if rel_ang_val >pi/2
            rel_ang_val = pi-rel_ang_val;
        end
        relAngIm(filIdx(fil))=pi/2-rel_ang_val;
    end
end

