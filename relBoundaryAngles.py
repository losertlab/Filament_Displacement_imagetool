import numpy as np

def relBoundaryAngles(LoGOutput, CellBoundary):
    # INPUTS:
    # LoG input
    # CellBoundary - generally created using functions such as
    # findCellandBulkBoundary.m as well as MATLAB's built-in boundarymask
    # function

    filIdx = np.where(~np.isnan(LoGOutput))
    boundR = CellBoundary[:, 0]
    boundC = CellBoundary[:, 1]
    numX, numY, _ = LoGOutput.shape
    relAngIm = np.full((numX, numY), np.nan)

    for fil in range(len(filIdx[0])):
        row, col = np.unravel_index(filIdx[0][fil], (numX, numY))

        filament_measure = np.sqrt((row - boundR)**2 + (col - boundC)**2)
        min_dist = np.min(filament_measure)
        min_index = np.where(filament_measure == min_dist)[0][0]

        min_boundary_rindex = boundR[min_index]
        min_boundary_cindex = boundC[min_index]

        # angle calculation
        rel_ang_val = np.nan

        angle_filament = LoGOutput[row, col]

        # relative to the filament point
        y_difference = min_boundary_rindex - row
        x_difference = min_boundary_cindex - col
        angle_boundary = np.arctan2(y_difference, x_difference)

        if x_difference < 0:
            boundary_temp = np.pi - (np.sign(y_difference) * np.sign(x_difference)) * np.abs(angle_boundary)
            temp_rel = np.abs(boundary_temp - angle_filament)
            rel_ang_val = min(2 * np.pi - temp_rel, temp_rel)
        elif x_difference > 0:
            boundary_temp = (-1 * np.sign(y_difference) * np.sign(x_difference)) * np.abs(angle_boundary)
            temp_rel = np.abs(angle_filament - boundary_temp)
            rel_ang_val = min(2 * np.pi - temp_rel, temp_rel)
        else:
            boundary_temp = np.pi - angle_boundary
            temp_rel = np.abs(angle_filament - boundary_temp)
            rel_ang_val = min(2 * np.pi - temp_rel, temp_rel)

        if rel_ang_val > np.pi / 2:
            rel_ang_val = np.pi - rel_ang_val

        relAngIm[row, col] = np.pi / 2 - rel_ang_val

    return relAngIm
