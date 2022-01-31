% Shifts angles of rotation w.r.t. specified value. The function allows to
% partially address systematic errors resulting from imprecise alignment of
% reference antenna and AUT, as well as the ones resulting from the use of
% different starting angles of rotation in EM simulations (+-180) than in
% measurements (0 to 360)
% 
% Inputs:
%   ang       - angles of rotation
%   inResp    - input response
%   shift     - angular shift
% 
% Output:
%   shiftResp - shifter response
% 
% Copyright (c) 2021, Adrian Bekasiewicz
% All rights reserved.
% 
% This source code is licensed under the BSD-style license found in the
% LICENSE file in the root directory of this source tree. 

function shiftResp=shift_angle(ang,inResp,shift)

if max(ang)>180
    ang=ang-180;
end
ang=ang-shift;
[~,idx]=min(abs(ang+180));
if ang(idx)>-180
    [~,idx]=min(abs(ang-180));
end
if size(inResp,1)<size(inResp,2)
    shiftResp=[inResp(:,idx+1:end),inResp(:,1:idx)];
else
    shiftResp=[inResp(idx+1:end,:);inResp(1:idx,:)];
end


