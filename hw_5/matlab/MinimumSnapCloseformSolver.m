function poly_coef = MinimumSnapCloseformSolver(waypoints, ts, n_seg, n_order)
    start_cond = [waypoints(1), 0, 0, 0];
    end_cond = [waypoints(end), 0, 0, 0];
    %#####################################################
    % you have already finished this function in hw1
    Q = getQ(n_seg, n_order, ts);
    %#####################################################
    % STEP 1: compute M
    M = getM(n_seg, n_order, ts);
    %#####################################################
    % STEP 2: compute Ct
    Ct = getCt(n_seg, n_order);
    C = Ct';
    R = C * inv(M)' * Q * inv(M) * Ct;
    R_cell = mat2cell(R, [n_seg+7 3*(n_seg-1)], [n_seg+7 3*(n_seg-1)]);
    R_pp = R_cell{2, 2};
    R_fp = R_cell{1, 2};
    
    %#####################################################
    % STEP 3: compute dF
    dF = zeros(8+n_seg-1,1);
    dF(1) = waypoints(1); % p
    dF(2) = 0; % v0
    dF(3) = 0; % a0
    dF(4) = 0; % J0
    for i = 1:n_seg
        dF(4+i) = waypoints(i+1);
    end
    dF(end-2) = 0; % vk
    dF(end-1) = 0; % ak
    dF(end) = 0;   % Jk
    
    dP = -inv(R_pp) * R_fp' * dF;
    poly_coef = inv(M) * Ct * [dF;dP];
end
