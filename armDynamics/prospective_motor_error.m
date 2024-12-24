function [mean_error] = prospective_motor_error(m_desired,m_net,potent_start_ind, Ntrial)
    
    mean_error = 0;

    for i = 1:Ntrial
        
        if (potent_start_ind + 9999 <= length(m_net.m{i}))
            m_potent = m_net.m{i}(:,potent_start_ind:potent_start_ind + 9999);
        else
            pad_len = (potent_start_ind + 9999)-length(m_net.m{i});
            m_potent = [m_net.m{i}(:,potent_start_ind:length(m_net.m{i})) ...
                        zeros(2,pad_len)] ;
        end
        mean_error = mean_error + (norm(m_potent - m_desired.m{i})^2)/Ntrial;

    end

end