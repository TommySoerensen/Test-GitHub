%=========================================================================
% Read, plot and calculate blade planform parameters.
%=========================================================================
disp('Analyzing data in YAML file.');

yaml_file = 'EN-15X-ER01_a01_s00_planform.yml'
PlanformData = ReadYaml(yaml_file);

P = [PlanformData.xPrebend{:}];
C = [PlanformData.chord{:}];
Tw = [PlanformData.twist{:}];
RT = [PlanformData.relativeThickness{:}];
AT = C.*RT;
TET = [PlanformData.trailingEdgeThickness{:}];
CLX = [PlanformData.airfoilCenterEdgewise{:}];
CLY = [PlanformData.airfoilCenterFlapwise{:}];
S = [PlanformData.ySweep{:}];
Cant = [PlanformData.cant{:}];
Toe = [PlanformData.toe{:}];
TEC_r = [PlanformData.dsReplaceTEClosure{:}];
TEC_w = [PlanformData.cornerWeightTEClosure{:}];
TEC_a = [PlanformData.surfaceAngleTEClosure{:}];
Z = [PlanformData.zSpan{:}];
stepsize = Z(2)-Z(1);

% Calc mold tilt angle
Moldtilt = (360/(2*pi))*atan(-P(length(P))/Z(length(Z)));
% Calc bow height
alpha = (P(length(P))-P(1))/(Z(length(Z))-Z(1));
D = zeros(1,length(Z));
d_max = 0;
d_max_i = 0;
for i = 1:length(Z)
    z=Z(i);
    p=P(i);
    y=alpha*z;
    D(i)=y-p;
    d=y-p;
    if (-d > -d_max) %Prebend is negative
        d_max = d;
        d_max_i = i;
    end
end
fprintf('Max bow height is: %4.2fm located %4.2fm (%4.2f%%) from root with a mold tilt of %4.2f°. \n',-((alpha*Z(d_max_i))-(P(d_max_i))),Z(d_max_i),(Z(d_max_i)/Z(length(Z)))*100,Moldtilt); 

% %%%%%%%%%%%%%%%%%%%%%%
Param = D;
% %%%%%%%%%%%%%%%%%%%%%%

% first derivative
Param_1st = diff(Param)/stepsize;
Param_1st = [0 Param_1st];
% second derivative
Param_2nd = diff(Param_1st)/stepsize;
Param_2nd = [0 Param_2nd];
%Plot parameter and derivatives
figure
ax1 = subplot(2,1,1); % top subplot
ax2 = subplot(2,1,2); % bottom subplot
plot(ax1,Z,Param),ylabel(ax1,'Blade parameter')
grid(ax1,'on')
plot(ax2,Z,Param_1st,Z,Param_2nd),legend('1st derivative','2nd derivative'),xlabel('z [m]'), ylabel('Derivatives')%,ylim([-0.5 0.5])

%Get Value
z = 1.5; % Set z value in [m]
Result = Param(1 + z/stepsize)



