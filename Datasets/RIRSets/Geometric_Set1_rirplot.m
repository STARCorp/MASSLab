
rt60 = {'100 ms','150 ms', '200 ms'};
rirset = {'RIR_GS1_4x4_RT60-0.1s.mat','RIR_GS1_4x4_RT60-0.15s.mat','RIR_GS1_4x4_RT60-0.2s.mat'};

for kk=1: numel(rirset)
    load(rirset{kk});
    [N,Q,P] = size(RIR);
    
    maxy = max(RIR(:));
    miny = min(RIR(:));
    
    figure(10+kk)
    m=1;
    for qq=1:Q
        for pp=1:P
            subplot(Q,P,m)
            plot(0:N-1,RIR(:,qq,pp));
            set(gca, 'FontSize', 12);
            grid minor
            xlim([0 2000]); ylim(1.01*[miny maxy]);
            legend(['a_{' num2str(qq) num2str(pp) '}(\kappa)' ], 'Location','NorthEast');
            if mod(pp,Q)==1, ylabel('Amplitude', 'FontWeight','bold'); end 
            if qq == Q, xlabel('\kappa, Lag (samples)', 'FontWeight','bold'); end   
            m=m+1;
        end
    end
    
end