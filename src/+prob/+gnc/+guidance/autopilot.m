function [psi_d,k_dot] = autopilot(p, u, v, k_in, path, settings)
    k = min(max(floor(k_in), 1), size(path,2));
    R = settings.R;
    if k >= 6
        
    end
    if k < size(path,2)
        p_k = path(:,k);
        p_k1 = path(:,k+1);
    else
        p_k = path(:,end-1);
        p_k1 = path(:,end);
    end
    psi_d = prob.gnc.guidance.heading(p, u, v, p_k, p_k1, settings);
    k_dot = ((p_k1(1)-p(1,:)).^2 + (p_k1(2)-p(2,:)).^2 <= R^2)/1;
end