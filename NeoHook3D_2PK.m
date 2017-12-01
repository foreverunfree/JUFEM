function [D,T,Sv]=NeoHook3D_2PK(H)
    global nu E K mu mu1 mu2
    
    del=[1 0 0 0 1 0 0 0 1]';
%     Bgrad = zeros(9,3*8);
%     Bgrad(1,1:3:end)=fix;
%     Bgrad(2,1:3:end)=fiy;
%     Bgrad(3,1:3:end)=fiz;
%     Bgrad(4,2:3:end)=fix;
%     Bgrad(5,2:3:end)=fiy;
%     Bgrad(6,2:3:end)=fiz;
%     Bgrad(7,3:3:end)=fix;
%     Bgrad(8,3:3:end)=fiy;
%     Bgrad(9,3:3:end)=fiz;
%     H=Bgrad*Ue;
    F=reshape(del+H,3,3)';
%     
%     BL=zeros(6,3*8);
%     BL(1,1:3:end)=F(1,1)*fix;
%     BL(1,2:3:end)=F(2,1)*fix;
%     BL(1,3:3:end)=F(3,1)*fix;
%     BL(2,1:3:end)=F(1,2)*fiy;
%     BL(2,2:3:end)=F(2,2)*fiy;
%     BL(2,3:3:end)=F(3,2)*fiy;
%     BL(3,1:3:end)=F(1,3)*fiz;
%     BL(3,2:3:end)=F(2,3)*fiz;
%     BL(3,3:3:end)=F(3,3)*fiz;
%     BL(4,1:3:end)=F(1,1)*fiy+F(1,2)*fix;
%     BL(4,2:3:end)=F(2,1)*fiy+F(2,2)*fix;
%     BL(4,3:3:end)=F(3,1)*fiy+F(3,2)*fix;
%     BL(5,1:3:end)=F(1,2)*fiz+F(1,3)*fiy;
%     BL(5,2:3:end)=F(2,2)*fiz+F(2,3)*fiy;
%     BL(5,3:3:end)=F(3,2)*fiz+F(3,3)*fiy;
%     BL(6,1:3:end)=F(1,3)*fix+F(1,1)*fiz;
%     BL(6,2:3:end)=F(2,3)*fix+F(2,1)*fiz;
%     BL(6,3:3:end)=F(3,3)*fix+F(3,1)*fiz;
    
    
    K1=mu1/2;
    K2=mu2/2;
    
    % order [s11,s22,s33,s12,s23,s13]
    C=F'*F;
    I1=C(1,1)+C(2,2)+C(3,3);
    %I2=C(1,1)*C(2,2)+C(2,2)*C(3,3)+C(3,3)*C(1,1)+C(1,2)^2+C(2,3)^2+C(3,1)^2;
    I2=-C(1,2)^2 - C(1,3)^2 - C(2,3)^2 + C(1,1)*C(2,2)  + C(1,1)*C(3,3) + C(2,2)*C(3,3);
    I3=det(C); % -C13^2*C22 + 2*C12*C13*C23 - C11*C23^2 - C12^2*C33 + C11*C22*C33
    J3=det(F);
    DI1DC=[1,1,1,0,0,0]';
    DI2DC=[C(3,3)+C(2,2);C(1,1)+C(3,3);C(2,2)+C(1,1);-C(1,2);-C(2,3);-C(1,3)];
    DI3DC=[C(2,2)*C(3,3)-C(2,3)^2;
        C(3,3)*C(1,1)-C(3,1)^2;
        C(1,1)*C(2,2)-C(1,2)^2;
        C(2,3)*C(3,1)-C(3,3)*C(1,2);
        C(3,1)*C(1,2)-C(1,1)*C(2,3);
        C(1,2)*C(2,3)-C(2,2)*C(3,1)];
    
    DJ1DC=I3^(-1/3)*DI1DC-(1/3)*I1*I3^(-4/3)*DI3DC; % J1=I1*I3^(-1/3)
    DJ2DC=I3^(-2/3)*DI2DC-(2/3)*I2*I3^(-5/3)*DI3DC; %J2=I2*I3^(-2/3)
    DJ3DC=(1/2)*I3^(-1/2)*DI3DC; % J3=I3^(1/2)
    D2I1DC2=zeros(6);
    D2I2DC2=[0,1,1,0,0,0;
        1,0,1,0,0,0;
        1,1,0,0,0,0;
        0,0,0,-1/2,0,0;
        0,0,0,0,-1/2,0;
        0,0,0,0,0,-1/2];
    D2I3DC2=[0,C(3,3),C(2,2),0,-C(2,3),0;
        C(3,3),0,C(1,1),0,0,-C(3,1);
        C(2,2),C(1,1),0,-C(1,2),0,0;
        0,0,-C(1,2),-C(3,3)/2,C(3,1)/2,C(2,3)/2;
        -C(2,3),0,0,C(3,1)/2,-C(1,1)/2,C(1,2)/2;
        0,-C(1,3),0,C(2,3)/2,C(1,2)/2,-C(2,2)/2];
    % order [s11,s22,s33,s12,s23,s13]
    
    D2J1DC2=I3^(-1/3)*D2I1DC2+(4/9)*I1*I3^(-7/3)*DI3DC*DI3DC'-...
        (1/3)*I3^(-4/3)*(DI1DC*DI3DC'+I1*D2I3DC2+DI3DC*DI1DC');
    
    D2J2DC2=I3^(-2/3)*D2I2DC2+(10/9)*I2*I3^(-8/3)*DI3DC*DI3DC'-...
        (2/3)*I3^(-5/3)*(DI2DC*DI3DC'+I2*D2I3DC2+DI3DC*DI2DC');
    
    D2J3DC2=(1/2)*I3^(-1/2)*D2I3DC2-(1/4)*I3^(-3/2)*DI3DC*DI3DC';
    
    D=4*(K1*D2J1DC2+K*(J3-1)*D2J3DC2+K*DJ3DC*DJ3DC');
    
    Sv=2*(K1*DJ1DC+K*(J3-1)*DJ3DC);

    
    
    S=[Sv(1),Sv(4),Sv(6);Sv(4),Sv(2),Sv(5);Sv(6),Sv(5),Sv(3)];
    p=F*S;
    P=[p(1,1) p(1,2) p(1,3) p(2,1) p(2,2) p(2,3) p(3,1) p(3,2) p(3,3)]';
    T=zeros(9,9);
    T(1:3,1:3)=S;T(4:6,4:6)=S;T(7:9,7:9)=S;
    
    
%     KL=BL'*D*BL;KNL=Bgrad'*T*Bgrad;
%     
%     Ke = KL+KNL;
%     Ge = Bgrad'*P;
%     
end